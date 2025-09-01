
model System_SC_Batt_DCCharger_EMS_PowerMode
  extends .Modelon.Icons.Experiment;

  // ===== 전력 경로 컴포넌트 =====
  // SC측 DC/DC (Power 모드)
  .HESS_EMS_Charger.AverageStepUpDown dcdc(
    controller(external_limits = false, listen = true),
    core(isolated = true, iL_start_fixed = false),
    id = 2)
    annotation (Placement(transformation(extent={{22.76,98.4},{62.76,138.4}},rotation = 0.0,origin = {0.0,0.0})));

  // 슈퍼캡, 배터리 (external_enable=false로 한계값 출력 비활성화)
  .HESS.paper_SCapPack scap(
    np = 6,
    accumulated_outputs = false,
    enable_thermal_port = false)
    annotation(Placement(transformation(extent={{122.28,100.29},{157.42,135.43}},rotation = 0.0,origin = {0.0,0.0})));
  .HESS.KETI_BatteryPack KETIBattery(
    SOC_start=0.9, display_name=true, enable_thermal_port=false,redeclare replaceable .Electrification.Batteries.Control.CellSensors controller,redeclare replaceable .Electrification.Batteries.Core.Examples.Nominal core,accumulated_outputs = false)
    annotation (Placement(transformation(extent={{126.21,206.18},{157.07,237.04}},rotation = 0.0,origin = {0.0,0.0})));

  // DC 급속충전기(Load, Power mode)
  .Electrification.Loads.Examples.Power charger(
    enable_thermal_port=false, display_name=true, fixed_temperature=true,
    redeclare replaceable .Electrification.Loads.Control.Power controller(
      external_power = true,
      external_limits = false,
      listen = true,
      typeListen = .Electrification.Utilities.Types.ControllerType.Controller,
      id_listen = ems.id
    ),
    id = 3)
    annotation (Placement(transformation(extent={{-84.15,98.84},{-124.15,138.84}},rotation = 0.0,origin = {0.0,0.0})));

  // === 편의 표현식 ===
  .Modelica.Blocks.Sources.RealExpression Vbus(y=charger.summary.v);  // 충전기 전압이 버스 전압
  .Modelica.Blocks.Sources.RealExpression Psc_meas(y=dcdc.summary.p_out_b);
  .Modelica.Blocks.Sources.RealExpression Pbatt_meas(y=KETIBattery.summary.p_out);
    .HESS_EMS_allocator.EMS ems(
      battery_id = KETIBattery.id,
      DCDC_id = dcdc.id,
      load_id = charger.id,
      // 둘 다 연결된 시스템: 기본 true 유지
      enable_battery = true,
      enable_sc_dcdc = true
    ) annotation(Placement(transformation(extent = {{-61.9,44.22},{-25.62,80.5}},origin = {0.0,0.0},rotation = 0.0)));

equation
 
  // 더미 주행 전력 요청 (충전 모드이므로 사용안됨)
    connect(charger.plug_a,dcdc.plug_a) annotation(Line(points = {{-84.15,118.84},{-1.12,118.84},{-1.12,118.4},{22.76,118.4}},color = {255,128,0}));
    connect(dcdc.plug_b,scap.plug_a) annotation(Line(points = {{62.76,118.4},{62.76,117.86},{122.28,117.86}},color = {255,128,0}));
    connect(KETIBattery.plug_a,charger.plug_a) annotation(Line(points = {{126.21,221.61},{49.14,221.61},{49.14,184.1},{-84.15,184.1},{-84.15,118.84}},color = {255,128,0}));
  // ControlBus는 EMS를 허브로 단일 연결
  connect(charger.controlBus, ems.controlBus) annotation(Line(points = {{-88.15,138.84},{-88.15,144.84},{-43.76,144.84},{-43.76,80.11}},color = {240,170,40},pattern = LinePattern.Dot));
  connect(dcdc.controlBus, ems.controlBus) annotation(Line(points = {{26.76,138.4},{26.76,130.82},{-43.76,130.82},{-43.76,80.11}},color = {240,170,40},pattern = LinePattern.Dot));
  connect(KETIBattery.controlBus, ems.controlBus) annotation(Line(points = {{129.3,237.04},{129.3,243.04},{-43.76,243.04},{-43.76,80.11}},color = {240,170,40},pattern = LinePattern.Dot));
  connect(scap.controlBus, ems.controlBus) annotation(Line(points = {{125.79,135.43},{125.79,195.26},{-43.76,195.26},{-43.76,80.11}},color = {240,170,40},pattern = LinePattern.Dot));
end System_SC_Batt_DCCharger_EMS_PowerMode;
