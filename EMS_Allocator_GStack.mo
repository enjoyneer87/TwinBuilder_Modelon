model EMS_Allocator_GStack
  extends Electrification.Control.Interfaces.BaseController;

  import SI = Modelica.Units.SI;
  import MC = Modelica.Constants;

  // ===== Allocation 테이블 =====
  parameter Electrification.Control.PowerAllocation.Records.AllocationRecord
    allocation[:] = {
      Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=1,
        controllerType=Electrification.Utilities.Types.ControllerType.Converter, // SC(DC/DC)
        generous=true, p_rat_out=0.7, p_rat_in=0.7,
        p_max_out=MC.inf, p_max_in=MC.inf, i_max_out=MC.inf, i_max_in=MC.inf),
      Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=2,
        controllerType=Electrification.Utilities.Types.ControllerType.Battery,  // Battery
        generous=true, p_rat_out=1.0, p_rat_in=1.0,
        p_max_out=MC.inf, p_max_in=MC.inf, i_max_out=MC.inf, i_max_in=MC.inf)
    };

  final parameter Integer N(min=1) = size(allocation,1) "Number of sources";

  // ===== 튜닝 =====
  parameter SI.Time T_available  = 0.10 "Negative feedback filter in GenerousStack";
  parameter Boolean allocate_negative = true "Use negative usage as available power";
  parameter Real eta[N] = {0.985,0.97} "Per-source efficiency";

  parameter Real dP_rise[N] = {3e6, 1e6} "Max rising slope [W/s]";
  parameter Real dP_fall[N] = {3e6, 1e6} "Max falling slope [W/s]";
  parameter SI.Time T_slew[N] = {0.03, 0.08} "Slew shaper time [s]";

  parameter SI.Time T_alpha = 0.03 "alpha LPF time";
  parameter Real alpha_min = 0.0;
  parameter Boolean visualConnections = true "Enable visual connection annotations";
  // 소스(배터리/SC)의 한계를 외부에서 덮어쓰지 않도록 기본적으로 비활성화
  parameter Boolean drive_source_limits = false "Publish per-source limits to sources via SetComponentLimits (may conflict with internal limits)";

  // ===== 외부 입력 =====
  Modelica.Blocks.Interfaces.RealInput P_dem "Load request (+discharge/-charge) [W]";

  // ===== 부하 버스/한계/VIP =====
  Electrification.Control.Signals.BusSelector busLoad(
    category=Electrification.Utilities.Types.ControllerType.Machine, id=1)
    annotation (Placement(transformation(origin={20,80}, extent={{6,-6},{-6,6}})));
  Electrification.Control.Limits.GetComponentVIP vipLoad
    annotation (Placement(transformation(extent={{80,-100},{60,-80}})));
  Electrification.Control.Limits.SetComponentLimits setLoad(
    i_max_in=Modelica.Constants.inf, i_max_out=Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{60,20},{92,52}})));

  // ===== 소스 버스/한계/VIP =====
  Electrification.Control.Signals.BusSelector busSrc[N](
    id=allocation.id, category=allocation.controllerType)
    annotation (Placement(transformation(origin={-20,80}, extent={{-6,-6},{6,6}})));
  Electrification.Control.Limits.GetComponentLimits srcLimits[N](
    vMaxSignal=true, vMinSignal=true,
    iMaxInSignal=true, iMaxOutSignal=true,
    pMaxInSignal=true, pMaxOutSignal=true)
    annotation (Placement(transformation(extent={{-100,20},{-68,52}})));  
  Electrification.Control.Limits.GetComponentVIP vipSrc[N]
    annotation (Placement(transformation(extent={{-100,-40},{-68,-8}})));
  
  // ===== 소스별 지령 전달 (옵션) =====
  Electrification.Control.Limits.SetComponentLimits setSrc[N](
    each i_max_in=Modelica.Constants.inf, each i_max_out=Modelica.Constants.inf) if drive_source_limits
    annotation (Placement(transformation(extent={{-68,-80},{-36,-48}})));

  // ===== GenerousStack (방전/충전) =====
  Electrification.Control.PowerAllocation.Components.GenerousStack pOutAlloc(
    N=N,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_out,
    k_absolute=allocation.p_max_out,
    T_available=T_available,
    negative_available=allocate_negative)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Electrification.Control.PowerAllocation.Components.GenerousStack pInAlloc(
    N=N,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_in,
    k_absolute=allocation.p_max_in,
    T_available=T_available,
    negative_available=allocate_negative)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  // ===== Summary =====
  replaceable input Electrification.Control.PowerAllocation.Records.Summary summary(
    p_avail_out = pOutAlloc.pAvailableTotal.y,
    p_avail_in  = pInAlloc.pAvailableTotal.y,
    p_alloc_out = pOutAlloc.p_allocated,
    p_alloc_in  = pInAlloc.p_allocated,
    p_used_out  = -pInAlloc.sumNegative.y,
    p_used_in   = -pOutAlloc.sumNegative.y,
    p_in        = demandPassthrough.y,
    final N     = N)
    annotation (Dialog(tab="Records"), choicesAllMatching=true);

  // ===== 출력 =====
  Modelica.Blocks.Interfaces.RealOutput P_cmd[N] "Per-source power cmd [W]";
  Modelica.Blocks.Interfaces.RealOutput i_ref[N] "Per-source current ref [A]";
  Modelica.Blocks.Interfaces.RealOutput alpha_load "Load derate (0..1)";
  Modelica.Blocks.Interfaces.RealOutput p_max_out_load "Sum discharge cap [W]";
  Modelica.Blocks.Interfaces.RealOutput p_max_in_load  "Sum charge cap [W]";
  Modelica.Blocks.Interfaces.RealOutput P_unserved "Unserved demand [W]";

protected
  parameter SI.Voltage Veps=1e-3;
  SI.Voltage V_bus;

  // 동적 한계
  SI.Power cap_out[N], cap_in[N], cap_sign[N];

  // Slew 상태
  SI.Power P_state[N](each start=0);
  
  // 분배 및 제한 관련 변수
  SI.Power P_alloc[N];
  SI.Power P_tgt[N];

  // 편의
  Real sgn;
  SI.Power P_dem_mag;

  // alpha LPF
  Modelica.Blocks.Continuous.FirstOrder alphaFilt(k=1, T=T_alpha)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

  // RealExpression 블록(다이어그램 가시화용)
  Modelica.Blocks.Sources.RealExpression demandPassthrough(y=P_dem)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Sources.RealExpression dischargeAvailable(y=max(P_dem, 0))
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.RealExpression chargeAvailable(y=max(-P_dem, 0))
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

equation
  // === 버스 연결
  connect(busLoad.systemBus, controlBus)
    annotation (Line(points={{14,80},{0,80},{0,100}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
  connect(setLoad.componentBus, busLoad.componentBus)
    annotation (Line(points={{92,36},{100,36},{100,80},{26,80}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
  connect(vipLoad.componentBus, busLoad.componentBus)
    annotation (Line(points={{80,-90},{100,-90},{100,80},{26,80}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));

  for i in 1:N loop
    connect(busSrc[i].systemBus, controlBus)
      annotation (Line(points={{-14,80},{0,80},{0,100}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
    connect(srcLimits[i].componentBus, busSrc[i].componentBus)
      annotation (Line(points={{-68,36},{-50,36},{-50,80},{-26,80}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
    connect(vipSrc[i].componentBus, busSrc[i].componentBus)
      annotation (Line(points={{-84,-24},{-50,-24},{-50,80},{-26,80}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
    // 소스별 지령 전달 (옵션)
    if drive_source_limits then
      connect(setSrc[i].componentBus, busSrc[i].componentBus)
        annotation (Line(points={{-36,-64},{-30,-64},{-30,80},{-26,80}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
    end if;
  end for;


  // === 버스 전압 (소스 전압 기준)
  // 배터리-DC/DC컨버터-부하 시스템에서는 소스 전압 제약이 중요
  V_bus = max(Veps, min(vipSrc[i].v for i in 1:N));

  // === p_available (RealExpression으로 명시 연결)
  connect(dischargeAvailable.y, pOutAlloc.p_available)
    annotation (Line(points={{-19,50},{50,50},{50,-40}}, color={0,0,127}));
  connect(chargeAvailable.y, pInAlloc.p_available)
    annotation (Line(points={{-19,10},{-70,10},{-70,-40}}, color={0,0,127}));

  // === p_used: 부호 있는 실제 전력(음전력 가용화에 필요)
  if not visualConnections then
    // 일반적인 for 루프 (N 확장 가능)
    for i in 1:N loop
      connect(vipSrc[i].p, pOutAlloc.p_used[i]);
      connect(vipSrc[i].p, pInAlloc.p_used[i]);
    end for;
  else
    // 시각적 연결 (N=2 고정, annotation 포함)
    connect(vipSrc[1].p, pOutAlloc.p_used[1])
      annotation(Line(points={{-84,-16},{50,-16},{50,-45}}, color={0,0,127}));
    connect(vipSrc[1].p, pInAlloc.p_used[1])
      annotation(Line(points={{-84,-16},{-70,-16},{-70,-45}}, color={0,0,127}));
    connect(vipSrc[2].p, pOutAlloc.p_used[2])
      annotation(Line(points={{-84,-32},{50,-32},{50,-55}}, color={0,0,127}));
    connect(vipSrc[2].p, pInAlloc.p_used[2])
      annotation(Line(points={{-84,-32},{-70,-32},{-70,-55}}, color={0,0,127}));
  end if;


  // === 편의 변수
  sgn      = if P_dem >= 0 then 1.0 else -1.0;
  P_dem_mag = abs(P_dem);

  // === 소스별 동적 한계 (min(pMax, η·V·iMax))
  for i in 1:N loop
    cap_out[i] = min( max(0, srcLimits[i].p_max_out),
                      eta[i]*V_bus*max(0, srcLimits[i].i_max_out) );
    cap_in[i]  = min( max(0, srcLimits[i].p_max_in),
                      eta[i]*V_bus*max(0, srcLimits[i].i_max_in)  );
    cap_sign[i] = if sgn>=0 then cap_out[i] else cap_in[i];
  end for;

  // === 분배 → 제한 → Slew → P_cmd/i_ref
  for i in 1:N loop
    // 분배 결과(부호 복원)
    P_alloc[i] = if sgn>=0 then +pOutAlloc.p_allocated[i]
                           else -pInAlloc.p_allocated[i];

    // 동적 제한
    P_tgt[i] = min(cap_sign[i], max(-cap_sign[i], P_alloc[i]));

    // Slew: 미분-클램핑
    der(P_state[i]) = noEvent(
      if (P_tgt[i] - P_state[i]) >= 0 then
        min(dP_rise[i], (P_tgt[i] - P_state[i]) / max(1e-6, T_slew[i]))
      else
        max(-dP_fall[i], (P_tgt[i] - P_state[i]) / max(1e-6, T_slew[i])) );

    P_cmd[i] = P_state[i];
    i_ref[i] = P_cmd[i] / (eta[i]*max(Veps, V_bus));
  end for;

  // === 부하 허용합 + SetComponentLimits로 전달
  p_max_out_load = sum(cap_out[i] for i in 1:N);
  p_max_in_load  = sum(cap_in[i]  for i in 1:N);

  connect(setLoad.p_max_out, p_max_out_load);
  connect(setLoad.p_max_in,  p_max_in_load);

  // === 소스별 지령 전달 (P_cmd, i_ref -> 컴포넌트) (옵션)
  if drive_source_limits then
    for i in 1:N loop
      connect(setSrc[i].p_max_out, max(0, P_cmd[i]));   // 방전 지령
      connect(setSrc[i].p_max_in,  max(0, -P_cmd[i]));  // 충전 지령
      connect(setSrc[i].i_max_out, max(0, i_ref[i]));   // 방전 전류 지령
      connect(setSrc[i].i_max_in,  max(0, -i_ref[i]));  // 충전 전류 지령
    end for;
  end if;

  // === alpha 및 미서빙 전력
  alphaFilt.u = max(alpha_min,
                    min(1.0,
                        (if sgn>=0 then p_max_out_load else p_max_in_load)
                        / max(1e-6, P_dem_mag)));
  alpha_load = alphaFilt.y;
  P_unserved = max(0, P_dem_mag - (if sgn>=0 then p_max_out_load else p_max_in_load));






  annotation (Documentation(info="
  <html>
    <p><b>EMS_Allocator_GStack</b> (refined):</p>
    <ul>
      <li>GenerousStack(방전/충전) + RealExpression p_available</li>
      <li>signed p_used, dynamic caps(min(pMax, η·V·iMax)), slew</li>
      <li>SetComponentLimits로 부하 허용치, alpha로 디레이트</li>
      <li>Summary 매핑 포함</li>
    </ul>
  </html>"));
end EMS_Allocator_GStack;
