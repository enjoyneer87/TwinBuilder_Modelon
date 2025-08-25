within YourPackage;

/**
 * LocalEMS_Hierarchical_Sources_Full
 * - N개 소스(예: 1=SC, 2=Battery)에 대해 GenerousStack(방전/충전)으로 분배
 * - GetComponentLimits/VIP를 사용해 실시간 한계/실측 연동
 * - 부하 한계를 SetComponentLimits로 내려주고 alpha(0..1)로 디레이트
 * - Summary 레코드에 내부 가용/분배/음전력합산 신호 매핑
 */
model EMS_Allocator_GStack
  extends Electrification.Control.Interfaces.BaseController;

  import SI = Modelica.Units.SI;
  import MC = Modelica.Constants;

  parameter .Electrification.Control.PowerAllocation.Records.AllocationRecord
    allocation[:]={
      .Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=1, 
        controllerType=Electrification.Utilities.Types.ControllerType.Converter, // SuperCap - DC/DC 컨버터 통해 연결
        generous=true, 
        p_rat_out=0.7, 
        p_rat_in=0.7,
        p_max_out=MC.inf,
        p_max_in=MC.inf,
        i_max_out=MC.inf,
        i_max_in=MC.inf),
      .Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=2,
        controllerType=Electrification.Utilities.Types.ControllerType.Battery, // Battery - 직접 연결 또는 BMS 통해 연결
        generous=true,
        p_rat_out=1.0,
        p_rat_in=1.0,
        p_max_out=MC.inf,
        p_max_in=MC.inf,
        i_max_out=MC.inf,
        i_max_in=MC.inf)}
    "Power allocation table" // allocation[i]: 각 소스의 비율/절대한계/관대 옵션;

//record AllocationRecord "Record used for parametrizing power allocated to a component"
/// Electrification.Utilities.Types.ControllerType controllerType=
//    Electrification.Utilities.Types.ControllerType.Load "Controller type";
//  Integer id = 1 "Controller identifier";
//  Boolean generous = false "True to pass un-used power to others";
//  Real p_rat_in(min=0.0,max=1.0) = 1.0 "Ratio of maximum available input power";
//  Real p_rat_out(min=0.0,max=1.0) = 1.0 "Ratio of maximum available output power";
//  Modelica.Units.SI.Power p_max_in(min=0.0) = Modelica.Constants.inf "Maximum input power limit (constant)";
//  Modelica.Units.SI.Power p_max_out(min=0.0) = Modelica.Constants.inf "Maximum output power limit (constant)";
//  Modelica.Units.SI.Current i_max_in(min=0.0) = Modelica.Constants.inf "Maximum input current limit (constant)";
//  Modelica.Units.SI.Current i_max_out(min=0.0) = Modelica.Constants.inf "Maximum output current limit (constant)";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>"));
//end AllocationRecord"

  // ====== 구성/튜닝 파라미터 ======
  final parameter Integer N(min=1) = size(allocation,1) "Number of sources (derived from allocation)";
  parameter SI.Time T_available  = 0.10       "Negative feedback filter in GenerousStack";
  parameter Boolean allocate_negative = true  "Use negative usage as available power";
  parameter Real eta[N] = {0.985,0.97}        "Per-source efficiency for caps/i_ref";
  // Slew(전력 지령의 변화율 제한)
  parameter Real dP_rise[N] = {3e6, 1e6} "Max rising slope of P_cmd [W/s]";
  parameter Real dP_fall[N] = {3e6, 1e6} "Max falling slope of P_cmd [W/s]";
  parameter SI.Time T_slew[N] = {0.03, 0.08}  "Slew shaper time constant [s]";
  // 부하 디레이트 필터
  parameter SI.Time T_alpha = 0.03 "alpha low-pass time constant";
  parameter Real alpha_min = 0.0   "minimum alpha";

  // ====== 외부 신호 ======
  // 부하의 "원하는 전력" (부호 포함: +방전/-충전). 없으면 외부 스케줄러가 연결해줌
  Modelica.Blocks.Interfaces.RealInput P_dem "Load power request (+discharge/-charge) [W]";

  // ====== 컨트롤 버스: 부하/소스 연결 ======
  // 부하(충전기/모터 등)
  Electrification.Control.Signals.BusSelector busLoad(
    category=Electrification.Utilities.Types.ControllerType.Machine, id=1)
    annotation (Placement(transformation(origin={20,70}, extent={{6,-6},{-6,6}})));

  // 부하 측 측정/제한 인터페이스
  Electrification.Control.Limits.GetComponentVIP vipLoad
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  Electrification.Control.Limits.SetComponentLimits setLoad(
    i_max_in=Modelica.Constants.inf,
    i_max_out=Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{44,-16},{76,48}})));

  // 소스(예: 1=SC, 2=Batt) 버스/한계/VIP
  Electrification.Control.Signals.BusSelector busSrc[N](
    id=allocation.id,
    category=allocation.controllerType)
    annotation (Placement(transformation(origin={-20,70}, extent={{-6,-6},{6,6}})));

  Electrification.Control.Limits.GetComponentLimits srcLimits[N](
    vMaxSignal=true, vMinSignal=true,
    iMaxInSignal=true, iMaxOutSignal=true,
    pMaxInSignal=true, pMaxOutSignal=true)
    annotation (Placement(transformation(extent={{-84,-20},{-52,44}})));

  Electrification.Control.Limits.GetComponentVIP vipSrc[N]
    annotation (Placement(transformation(extent={{-84,-60},{-52,4}})));

  // ====== 분배기: GenerousStack(방전/충전) ======
Electrification.Control.PowerAllocation.Components.GenerousStack pOutAlloc(
  N=N, 
  generous=allocation.generous,        // ✅ 배열 속성 접근
  k_ratio=allocation.p_rat_out,        // ✅ 배열 속성 접근
  k_absolute=allocation.p_max_out,     // ✅ 배열 속성 접근
  T_available=T_available, 
  negative_available=allocate_negative);
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

    Electrification.Control.PowerAllocation.Components.GenerousStack pInAlloc(
    N=N, 
    generous=allocation.generous,        // ✅ 배열 속성 접근
    k_ratio=allocation.p_rat_in,         // ✅ 배열 속성 접근
    k_absolute=allocation.p_max_in,      // ✅ 배열 속성 접근
    T_available=T_available, 
    negative_available=allocate_negative);
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  // ====== Summary 레코드(내부 신호 매핑) ======
  replaceable input Electrification.Control.PowerAllocation.Records.Summary summary(
    p_avail_out = pOutAlloc.pAvailableTotal.y, // 전체 전력 - 음전력 포함 - 방전을 양전력으로 기록
    p_avail_in  = pInAlloc.pAvailableTotal.y,  // 전체 전력 - 음전력 포함 - 충전을 양전력으로 기록
    p_alloc_out = pOutAlloc.p_allocated,  // GenerousStack 내부 출력 N vector pOutAlloc.p_allocated[i]
    p_alloc_in  = pInAlloc.p_allocated,    // GenerousStack 내부 출력 N vector pInAlloc.p_allocated[i]
    // GenerousStack 내부 음전력 합산은 부호 복원해서 기록
    p_used_out  = -pInAlloc.sumNegative.y, // 음전력 합산 (부호 복원)
    p_used_in   = -pOutAlloc.sumNegative.y, // 음전력 합산 (부호 복원)
    p_in        = demandPassthrough.y, // 부하 요구전력 (부호 포함) - 블록을 통해 전달
    final N     = N)
    annotation (Dialog(tab="Records"), choicesAllMatching=true);

  // ====== EMS 출력 ======
  
  Modelica.Blocks.Interfaces.RealOutput P_cmd[N] "Per-source power cmd [W] (signed)"; // 각 소스에 보낼 전력 지령
  Modelica.Blocks.Interfaces.RealOutput i_ref[N] "Per-source current ref [A] (signed)"; // 각 소스에 보낼 전류 지령
  Modelica.Blocks.Interfaces.RealOutput alpha_load "Load derate factor (0..1)"; // 부하 디레이트 계수
  Modelica.Blocks.Interfaces.RealOutput p_max_out_load "Sum discharge cap to load [W]"; // 부하에 내려주는 방전 허용치
  Modelica.Blocks.Interfaces.RealOutput p_max_in_load  "Sum charge cap to load [W]"; // 부하에 내려주는 충전 허용치
  Modelica.Blocks.Interfaces.RealOutput P_unserved "Unserved demand [W]"; // 부족 전력량

protected
  parameter SI.Voltage Veps=1e-3;
  SI.Voltage V_bus = max(Veps, vipLoad.v);  // 부하 VIP에서 버스 전압 가져오기

  // 동적 캡(소스별)
  SI.Power cap_out[N], cap_in[N], cap_sign[N];

  // Slew 상태
  SI.Power P_state[N](each start=0);

  // 신호 블록에서 가져오는 값들
  Real sgn = if P_dem >= 0 then 1.0 else -1.0;
  SI.Power P_dem_mag = abs(P_dem);

  // alpha 필터
  Modelica.Blocks.Continuous.FirstOrder alphaFilt(k=1, T=T_alpha)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  // ====== 사용 전력 피드백을 위한 신호 블록 ======
  // (제거됨 - 직접 연결)

  // ====== P_dem 신호 처리 블록 (단순화) ======
  Modelica.Blocks.Sources.RealExpression demandPassthrough(y=P_dem) "Pass P_dem to summary"
    annotation (Placement(transformation(extent={{-60,50},{-50,60}})));

  // ====== 동적 제한 및 Slew 처리 블록 ======
  Modelica.Blocks.Nonlinear.VariableLimiter powerLimiter[N] "Dynamic power limits"
    annotation (Placement(transformation(extent={{40,20},{50,30}})));

equation
  // ====== 컨트롤 버스 연결 ======
  connect(busLoad.systemBus, controlBus) annotation (Line(
      points={{14,70},{0,70},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(setLoad.componentBus, busLoad.componentBus) annotation (Line(
      points={{76,16},{90,16},{90,70},{26,70}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(vipLoad.componentBus, busLoad.componentBus) annotation (Line(
      points={{80,-80},{90,-80},{90,70},{26,70}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));

  for i in 1:N loop
    connect(busSrc[i].systemBus, controlBus) annotation (Line(
        points={{-14,70},{0,70},{0,100}},
        color={240,170,40},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(srcLimits[i].componentBus, busSrc[i].componentBus) annotation (Line(
        points={{-52,12},{-40,12},{-40,70},{-26,70}},
        color={240,170,40},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(vipSrc[i].componentBus, busSrc[i].componentBus) annotation (Line(
        points={{-64,-50},{-40,-50},{-40,70},{-26,70}},
        color={240,170,40},
        pattern=LinePattern.Dot,
        thickness=0.5));
  end for;


  // ====== 신호 처리 - 간단한 수식 사용 ======

  // 1. GenerousStack 입력 - 수식으로 간단히
  pOutAlloc.p_available = max(P_dem, 0);  // 방전: 양의 P_dem만
  pInAlloc.p_available = max(-P_dem, 0);  // 충전: 음의 P_dem을 양수로

  // 3. 사용 전력 피드백 (부호 유지) - 명시적 연결
  for i in 1:N loop
    connect(vipSrc[i].p, pOutAlloc.p_used[i]);  // 부호 유지 - 음전력 피드백 활성화
    connect(vipSrc[i].p, pInAlloc.p_used[i]);   // 부호 유지 - 음전력 피드백 활성화
  end for;

  // ====== 소스별 동적 한계 ======
  for i in 1:N loop
    cap_out[i] = min( max(0, srcLimits[i].p_max_out),
                      eta[i]*V_bus*max(0, srcLimits[i].i_max_out) );
    cap_in[i]  = min( max(0, srcLimits[i].p_max_in),
                      eta[i]*V_bus*max(0, srcLimits[i].i_max_in)  );
    cap_sign[i] = if sgn>=0 then cap_out[i] else cap_in[i];
  end for;

  // ====== 분배 → 제한 → Slew → P_cmd/i_ref ======
  for i in 1:N loop
    // 분배 결과
    SI.Power P_alloc = if sgn>=0 then +pOutAlloc.p_allocated[i] else -pInAlloc.p_allocated[i];
    
    // 동적 제한 적용
    SI.Power P_limited = min(cap_sign[i], max(-cap_sign[i], P_alloc));
    
    // Slew 제한 (미분 방정식)
    der(P_state[i]) = noEvent(
      if (P_limited - P_state[i]) >= 0 then
        min(dP_rise[i], (P_limited - P_state[i]) / max(1e-6, T_slew[i]))
      else
        max(-dP_fall[i], (P_limited - P_state[i]) / max(1e-6, T_slew[i])) );

    P_cmd[i] = P_state[i];
    i_ref[i] = P_cmd[i] / (eta[i]*max(Veps, V_bus));
  end for;

  // ====== 분배 → 제한 → Slew → P_cmd/i_ref ======
  for i in 1:N loop
    // 분배 결과
    SI.Power P_alloc = if sgn>=0 then +pOutAlloc.p_allocated[i] else -pInAlloc.p_allocated[i];
    
    // 동적 제한 적용
    SI.Power P_limited = min(cap_sign[i], max(-cap_sign[i], P_alloc));
    
    // Slew 제한 (미분 방정식)
    der(P_state[i]) = noEvent(
      if (P_limited - P_state[i]) >= 0 then
        min(dP_rise[i], (P_limited - P_state[i]) / max(1e-6, T_slew[i]))
      else
        max(-dP_fall[i], (P_limited - P_state[i]) / max(1e-6, T_slew[i])) );

    P_cmd[i] = P_state[i];
    i_ref[i] = P_cmd[i] / (eta[i]*max(Veps, V_bus));
  end for;

  // ====== 부하 허용치(합) 및 SetComponentLimits로 전달 ======
  p_max_out_load = sum(cap_out[i] for i in 1:N);
  p_max_in_load  = sum(cap_in[i]  for i in 1:N);

  connect(setLoad.p_max_out, p_max_out_load);
  connect(setLoad.p_max_in,  p_max_in_load);

  // ====== 부하 디레이트(alpha) & 미서빙 전력 ======
  alphaFilt.u = max(alpha_min,
                    min(1.0,
                        (if sgn>=0 then p_max_out_load else p_max_in_load)
                        / max(1e-6, P_dem_mag)));
  alpha_load = alphaFilt.y;
 // 부족 전력량 (부호 없음), p_dem_mag - p_allow (= p_max_out_load or p_max_in_load)
  P_unserved = max(0, P_dem_mag - (if sgn>=0 then p_max_out_load else p_max_in_load));


  annotation (Documentation(info="
  <html>
    <p><b>EMS_Allocator_GStack</b></p>
    <ul>
      <li>GenerousStack(방전/충전)으로 계층형·관대 분배</li>
      <li>GetComponentLimits/VIP로 소스 실시간 한계/실측 연동 → min(pMax, η·V·iMax)</li>
      <li>부하 한계를 SetComponentLimits로 내려주고, alpha로 요청 디레이트</li>
      <li>Summary 레코드에 내부 신호(p_avail_*, p_alloc_*, p_used_*, p_in, N) 매핑</li>
    </ul>
  </html>"));
end EMS_Allocator_GStack;
