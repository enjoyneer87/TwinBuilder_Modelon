model System_SC_Batt_DCCharger_EMS_PowerMode
  extends Modelon.Icons.Experiment;
  import SI = Modelica.Units.SI;
  import MC = Modelica.Constants;

  // ===== 전력 경로 컴포넌트 =====
  // SC측 DC/DC (Power 모드)
  Electrification.Converters.Examples.AverageStepUpDown dcdc(
    enable_thermal_port=false, display_name=true, fixed_temperature=true,
    core(n=400/200, iL_start=410),
    redeclare replaceable Electrification.Converters.Electrical.Capacitor electrical_a(
      C=0.001, v_start=428.4, v_start_fixed=true),
    redeclare replaceable Electrification.Converters.Electrical.Ideal electrical_b,
    redeclare replaceable Electrification.Converters.Control.Power controller(
      mode=Electrification.Utilities.Types.ConverterModePower.PowerB,external_pwr_b = true))
    annotation (Placement(transformation(extent={{27.24,134.87},{67.24,174.87}},rotation = 0.0,origin = {0.0,0.0})));

  // 슈퍼캡, 배터리 (external_enable=false로 한계값 출력 비활성화)
  HESS.paper_SCapPack scap(np=6,redeclare replaceable .Electrification.Batteries.Control.CellSensors controller)
    annotation(Placement(transformation(extent={{122.03,151.26},{157.17,186.4}},rotation = 0.0,origin = {0.0,0.0})));
  HESS.KETI_BatteryPack battery(
    SOC_start=0.9, display_name=true, enable_thermal_port=false,redeclare replaceable .Electrification.Batteries.Control.CellSensors controller)
    annotation (Placement(transformation(extent={{108.73,206.57},{139.59,237.43}},rotation = 0.0,origin = {0.0,0.0})));

  // DC 급속충전기(Load, Power mode)
  Electrification.Loads.Examples.Power charger(
    enable_thermal_port=false, display_name=true, fixed_temperature=true,redeclare replaceable .Electrification.Loads.Control.Power controller(external_power = true,external_limits = true,listen = false,typeListen = Electrification.Utilities.Types.ControllerType.Controller,id_listen = ems.id))
    annotation (Placement(transformation(extent={{-26.27,149.72},{-66.27,189.72}},rotation = 0.0,origin = {0.0,0.0})));
  Electrification.Loads.Control.Signals.pwr_ref power_ref(id=charger.id)    
    annotation (Placement(transformation(extent={{15.53,50.25},{32.13,66.85}},rotation = 0.0,origin = {0.0,0.0})));

  // === EMS Unified (스케줄러 통합) ===
  HESS_EMS_Charger.EMS_Unified ems(
    load_id = charger.id,dcdc_id = dcdc.id,battery_id = battery.id,id = 1)
    annotation (Placement(transformation(extent={{-102.42,63.47},{-63.62,101.59}},rotation = 0.0,origin = {0.0,0.0})));

  // === 컨버터 제어 신호 ===
  Electrification.Converters.Control.Signals.pwr_b_ref p_b_ref(id=dcdc.id)
    annotation (Placement(transformation(extent={{16.36,92.39},{32.96,108.99}},rotation = 0.0,origin = {0.0,0.0})));

  // === 충전기 용량 제한 ===
  Modelica.Blocks.Sources.Constant chargerCap(k=300e3)
    annotation (Placement(transformation(extent={{-145.82,227.68},{-117.82,255.68}},rotation = 0.0,origin = {0.0,0.0})));

  // === 모드 전환 신호 ===
  Modelica.Blocks.Sources.BooleanConstant chargingMode(k=true)
    annotation (Placement(transformation(extent={{-144.81,166.5},{-118.99,192.32}},rotation = 0.0,origin = {0.0,0.0})));

  // === 편의 표현식 ===
  Modelica.Blocks.Sources.RealExpression Vbus(y=charger.summary.v);  // 충전기 전압이 버스 전압
  Modelica.Blocks.Sources.RealExpression Psc_meas(y=dcdc.summary.p_out_b);
  Modelica.Blocks.Sources.RealExpression Pbatt_meas(y=battery.summary.p_out);

equation

  // ===== 센서 입력 (일반 등식) =====
  ems.SOC = battery.summary.SoC;
  ems.T_max = battery.summary.T_cell_max;
  ems.v_pack = battery.summary.v;
  ems.v_sc = scap.summary.v;
  ems.v_bus_in = charger.summary.v;  // 충전기 전압이 버스 전압
  ems.P_charger_cap = chargerCap.y;
  ems.iMaxIn_opt = 1e9;  // 큰 값 (제한 없음)
  
  // 더미 주행 전력 요청 (충전 모드이므로 사용안됨)
  ems.P_dem_raw = 0;
    connect(charger.plug_a,dcdc.plug_a) annotation(Line(points = {{-26.27,169.72},{-1.12,169.72},{-1.12,169.26},{22.89,169.26}},color = {255,128,0}));
    connect(dcdc.plug_b,scap.plug_a) annotation(Line(points = {{67.24,154.87},{92.46,154.87},{92.46,168.83},{122.03,168.83}},color = {255,128,0}));
    connect(battery.plug_a,charger.plug_a) annotation(Line(points = {{108.73,222},{49.14,222},{49.14,184.1},{-26.27,184.1},{-26.27,169.72}},color = {255,128,0}));
    connect(battery.plug_a,charger.plug_a) annotation(Line(points = {{108.73,221.59},{41.805,221.59},{41.805,169.39},{-25.12,169.39}},color = {255,128,0}));
    connect(charger.controlBus,dcdc.controlBus) annotation(Line(points = {{-30.27,189.72},{-30.27,195.39},{7.16,195.39},{7.16,174.87},{31.24,174.87}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(battery.controlBus,charger.controlBus) annotation(Line(points = {{111.82,237.43},{111.82,243.02},{-30.27,243.02},{-30.27,189.72}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(scap.controlBus,dcdc.controlBus) annotation(Line(points = {{125.54,186.4},{125.54,195.26},{31.24,195.26},{31.24,174.87}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(ems.controlBus,charger.controlBus) annotation(Line(points = {{-83.02,101.59},{-83.02,195.39},{-30.27,195.39},{-30.27,189.72}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dcdc.controlBus,ems.controlBus) annotation(Line(points = {{31.24,174.87},{31.24,195.26},{-83.02,195.26},{-83.02,101.59}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(battery.controlBus,ems.controlBus) annotation(Line(points = {{111.82,237.43},{111.82,243.02},{-83.02,243.02},{-83.02,101.59}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(p_b_ref.systemBus,dcdc.controlBus) annotation(Line(points = {{32.96,100.69},{70.12,100.69},{70.12,195.26},{31.24,195.26},{31.24,174.87}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(power_ref.systemBus,charger.controlBus) annotation(Line(points = {{32.13,58.55},{38.54,58.55},{38.54,195.39},{-30.27,195.39},{-30.27,189.72}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(chargingMode.y,ems.isCharging) annotation(Line(points = {{-117.7,179.41},{-111.7,179.41},{-111.7,106.77},{-116.42,106.77},{-116.42,98.98}},color = {255,0,255}));
    connect(ems.P_cmd[1],p_b_ref.u_r) annotation(Line(points = {{-57.07,98.15},{-57.07,100.69},{12.21,100.69}},color = {0,0,127}));
    connect(ems.P_load_cmd,power_ref.u_r) annotation(Line(points = {{-57.29,66.38},{-57.29,58.55},{11.38,58.55}},color = {0,0,127}));
    connect(charger.plug_a,dcdc.plug_a) annotation(Line(points = {{-25.86,169.72},{0.6899999999999995,169.72},{0.6899999999999995,154.87},{27.24,154.87}},color = {255,128,0}));
end System_SC_Batt_DCCharger_EMS_PowerMode;