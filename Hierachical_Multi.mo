
model Hierarchical_Multi "Hierarchical power allocation controller"

  replaceable input .Electrification.Control.PowerAllocation.Records.Summary summary(
    p_avail_out=pMaxOutAllocation.pAvailableTotal.y,
    p_avail_in=pMaxInAllocation.pAvailableTotal.y,
    p_alloc_out=pMaxOutAllocation.p_allocated,
    p_alloc_in=pMaxInAllocation.p_allocated,
    final N=N,
    p_in=loadPower.p,
    p_used_out=-pMaxInAllocation.sumNegative.y,
    p_used_in=-pMaxOutAllocation.sumNegative.y) annotation (
      Dialog(tab="Records"),
      Placement(transformation(extent={{82,82},{98,98}})), choicesAllMatching=true);

  extends .Electrification.Control.Interfaces.BaseController;
  //parameter Integer battery_id=1 "Identifier of the battery controller" annotation(Dialog(group="ControlBus"));
  //final parameter Integer N(min=1) = size(allocation,1) "Number of \"loads\"";
  // === 설정: 소스(슈퍼캡, 배터리)용 Allocation 테이블 ===
  // allocation[i]: 각 소스의 비율/절대한계/관대 옵션
    parameter Integer N(min=1)=2 "Number of sources (e.g., 1:SC, 2:Batt)";
  parameter .Electrification.Control.PowerAllocation.Records.AllocationRecord
    allocation[:]={
      .Electrification.Control.PowerAllocation.Records.AllocationRecord()}
    "Power allocation table";

  // 회생/충전에서 음전력의 자가-가용화(원치 않으면 false)

  parameter Boolean allocate_negative=false
    "Allocate negative power usage to available power";
  parameter .Modelica.Units.SI.Time T_available=0.01 "Time constant of available power calculation" annotation (Dialog(enable=allocate_negative));

  // === 버스/신호: 부하 1개, 소스 N개 ===
  // (필요 시 실제 프로젝트의 버스/ID 체계에 맞추세요)
  // 부하의 요구전력/전압/한계 취득
    
 .Electrification.Control.Signals.BusSelector busLoad(
      category=.Electrification.Utilities.Types.ControllerType.Machine, id=1)
    annotation (Placement(transformation(origin={20,70}, extent={{6,-6},{-6,6}})));
  .Electrification.Control.Limits.GetComponentVIP loadMeas
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));

    
  // 소스 측(슈퍼캡/배터리) 버스/한계
  .Electrification.Control.Signals.BusSelector busSrc[N](
      id=allocation.id, category=allocation.controllerType)
    annotation (Placement(transformation(origin={-20,70}, extent={{-6,-6},{6,6}})));

  .Electrification.Control.Limits.GetComponentLimits srcLimits[N](
    vMaxSignal=true, 
    vMinSignal=true, 
    iMaxInSignal=true, 
    iMaxOutSignal=true,
    pMaxInSignal=true,
    pMaxOutSignal=true)
    annotation (Placement(transformation(extent={{-83.56,-19.54},{-51.56,44.46}},rotation = 0.0,origin = {0.0,0.0})));

   
    
  .Electrification.Control.Limits.SetComponentLimits loadLimits(
    i_max_in  = Modelica.Constants.inf,
    i_max_out = Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{44.0,-16.18},{76.0,47.82}},rotation = 0.0,origin = {0.0,0.0})));
    
    
    

  // === 분배기: 방전/충전 별 GenerousStack ===
  .Electrification.Control.PowerAllocation.Components.GenerousStack pOutAlloc(
    N=N,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_out,     // 방전 비율
    k_absolute=allocation.p_max_out,  // 방전 절대한계
    T_available=T_available,
    negative_available=allocate_negative)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  .Electrification.Control.PowerAllocation.Components.GenerousStack pInAlloc(
    N=N,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_in,      // 충전 비율
    k_absolute=allocation.p_max_in,   // 충전 절대한계
    T_available=T_available,
    negative_available=allocate_negative)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
    
      // 소스별 실제 사용전력(절댓값) 입력
  // (DC/DC에서 측정한 P, 부호 제거해서 magnitude만 입력)
  Modelica.Blocks.Interfaces.RealInput p_used_abs[N] "abs(power used by sources)";

  // 출력: 소스별 전력/전류 지령 (부호 복원 후 후단 컨버터로)
  Modelica.Blocks.Interfaces.RealOutput P_cmd[N] "signed power command to sources";
  Modelica.Blocks.Interfaces.RealOutput i_ref[N] "signed current reference to sources";
    
 protected
  Real sgn = noEvent(if loadMeas.p >= 0 then 1.0 else -1.0);
  parameter Real Veps = 1e-3;
  Real Vbus;  // 필요시 버스 전압을 loadMeas 또는 별도 측정에서 취함
  parameter Real eta[N] = {0.985, 0.97};   
    
  .Modelica.Blocks.Math.Gain p_neg[N](each k=-1) annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=0,
        origin={44,-74})));
    
equation
    // 버스 연결 (프로젝트 버스 규약에 맞게 조정)
  connect(busLoad.systemBus,controlBus) annotation(Line(points = {{14,70},{7,70},{7,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));
  connect(busLoad.componentBus,loadLimits.componentBus) annotation(Line(points = {{26,70},{82,70},{82,15.82},{76,15.82}},color = {240,170,40},pattern = LinePattern.Dot));

  for i in 1:N loop
    connect(busSrc[i].systemBus, controlBus) annotation(Line(points = {{-14,70},{-7,70},{-7,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(srcLimits[i].componentBus, busSrc[i].componentBus) annotation(Line(points = {{-26,70},{-89.56,70},{-89.56,12.46},{-83.56,12.46}},color = {240,170,40},pattern = LinePattern.Dot));
  end for;



  // 부하 요구전력 측정
  connect(loadMeas.componentBus, busLoad.componentBus);
  Vbus = max(Veps, /* 필요시 버스전압 측정 블록 사용 */ srcLimits[1].v_max); // 예시

  // === p_available: 부하 요구 크기 ===
  // 방전용: loadMeas.p >= 0 → pOutAlloc에 abs(p) 공급
  // 충전용: loadMeas.p < 0  → pInAlloc에 abs(p) 공급
  pOutAlloc.p_available = if loadMeas.p >= 0 then abs(loadMeas.p) else 0;
  pInAlloc.p_available  = if loadMeas.p <  0 then abs(loadMeas.p) else 0;

  // === p_used: 소스가 실제 낸/받은 전력의 절댓값 ===
  pOutAlloc.p_used = p_used_abs; // magnitude
  pInAlloc.p_used  = p_used_abs; // magnitude

  // === 부호 복원 후 전력/전류 지령 ===
  for i in 1:N loop
    P_cmd[i] = if loadMeas.p >= 0 then +pOutAlloc.p_allocated[i]
                                 else -pInAlloc.p_allocated[i];
    i_ref[i]  = P_cmd[i] / Vbus; // 필요시 효율/내부저항 보정: / (eta[i]*Vbus)
  end for;

annotation (Documentation(info="<html>
<p>One-load to multi-sources allocator using two <b>GenerousStack</b> blocks (discharge/charge). It feeds |P_load| as available power, uses abs(P_used_src) for feedback, and restores the sign for final per-source commands.</p>
</html>"));  
  
end Hierarchical_Multi;
