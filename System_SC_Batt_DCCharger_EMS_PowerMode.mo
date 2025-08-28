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
    annotation (Placement(transformation(extent={{22.89,149.26},{62.89,189.26}},rotation = 0.0,origin = {0.0,0.0})));

  // 슈퍼캡, 배터리
  HESS.paper_SCapPack scap(np=6) annotation(Placement(transformation(extent={{122.03,151.26},{157.17,186.4}},rotation = 0.0,origin = {0.0,0.0})));
  HESS.KETI_BatteryPack battery(
    SOC_start=0.9, display_name=true, enable_thermal_port=false,
    redeclare replaceable Electrification.Batteries.Control.TwoSubControllers controller(
      redeclare replaceable Electrification.Batteries.Control.CellSensors controller1,
      redeclare replaceable Electrification.Batteries.Control.LimitsFixed controller2))
    annotation (Placement(transformation(extent={{108.73,206.16},{139.59,237.02}},rotation = 0.0,origin = {0.0,0.0})));

  // DC 급속충전기(Load, Power mode)
  Electrification.Loads.Examples.Power charger(
    enable_thermal_port=false, display_name=true, fixed_temperature=true,
    redeclare Electrification.Loads.Control.PowerMode controller(
      external_mode=true, vMax=380))
    annotation (Placement(transformation(extent={{-25.12,149.39},{-65.12,189.39}},rotation = 0.0,origin = {0.0,0.0})));
  Electrification.Loads.Control.Signals.pwr_ref power_ref(id=charger.id)    
    annotation (Placement(transformation(extent={{15.94,50.25},{32.54,66.85}},rotation = 0.0,origin = {0.0,0.0})));

  // === EMS Unified (스케줄러 통합) ===
  HESS_EMS_Charger.EMS_Unified ems()
    annotation (Placement(transformation(extent={{-102.01,62.65},{-63.21,100.77}},rotation = 0.0,origin = {0.0,0.0})));

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
  Modelica.Blocks.Sources.RealExpression Pbatt_meas(y=battery.summary.power);

equation

  // ===== 센서 입력 (일반 등식) =====
  ems.SOC = battery.summary.soc;
  ems.T_max = battery.summary.T_max_cell;
  ems.v_pack = battery.summary.v;
  ems.v_sc = scap.summary.v;
  ems.v_bus_in = charger.summary.v;  // 충전기 전압이 버스 전압
  ems.P_charger_cap = chargerCap.y;
  ems.iMaxIn_opt = 1e9;  // 큰 값 (제한 없음)
  
  // 더미 주행 전력 요청 (충전 모드이므로 사용안됨)
  ems.P_dem_raw = 0;
  connect(charger.plug_a,dcdc.plug_a) 
  
  // ===== 배터리는 자연스러운 전력 흡수/공급 (EMS 직접 제어 없음) =====
  // 배터리는 충전기와 직접 병렬 연결되어 나머지 전력을 자동으로 처리

  annotation(
    experiment(StopTime=20, Interval=0.01),
    Documentation(info="
    <html>
      <p><b>System_SC_Batt_DCCharger_EMS with EMS_Unified (DC Bus-less)</b></p>
      <ul>
        <li>EMS_Unified: 통합 EMS (충전 스케줄러 내장)</li>
        <li>충전 모드: isCharging=true로 고정</li>
        <li>직결 구조: 충전기 - 배터리/DC컨버터 병렬 연결 (DC버스 없음)</li>
        <li>SC(DC/DC): EMS.P_cmd[1] → p_b_ref.u_r (Power Mode)</li>
        <li>Battery: 충전기와 직접 병렬, BMS 한계는 EMS에 의해 자동 반영</li>
        <li>Charger: EMS.P_load_cmd → power_ref.u_r (Power Mode)</li>
        <li>내장 스케줄러: SOC/온도/전압 기반 스마트 충전</li>
      </ul>
    </html>"));
    connect(charger.plug_a,dcdc.plug_a) annotation(Line(points = {{-25.12,169.39},{-1.1150000000000002,169.39},{-1.1150000000000002,169.26},{22.89,169.26}},color = {255,128,0}));
    connect(dcdc.plug_b,scap.plug_a) annotation(Line(points = {{62.89,169.26},{92.46000000000001,169.26},{92.46000000000001,168.83},{122.03,168.83}},color = {255,128,0}));
    connect(battery.plug_a,charger.plug_a) annotation(Line(points = {{123.4,220.33},{49.14,220.33},{49.14,169.39},{-25.12,169.39}},color = {255,128,0}));
    connect(battery.plug_a,charger.plug_a) annotation(Line(points = {{108.73,221.59},{41.805,221.59},{41.805,169.39},{-25.12,169.39}},color = {255,128,0}));
    connect(charger.controlBus,dcdc.controlBus) annotation(Line(points = {{-29.12,189.39},{-29.12,195.39},{26.89,195.39},{26.89,189.26}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(battery.controlBus,charger.controlBus) annotation(Line(points = {{111.82,237.02},{111.82,243.02},{-29.12,243.02},{-29.12,189.39}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(scap.controlBus,dcdc.controlBus) annotation(Line(points = {{125.54,186.4},{125.54,195.26},{26.89,195.26},{26.89,189.26}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(ems.controlBus,charger.controlBus) annotation(Line(points = {{-82.61,100.77},{-82.61,195.39},{-29.12,195.39},{-29.12,189.39}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dcdc.controlBus,ems.controlBus) annotation(Line(points = {{26.89,189.26},{26.89,195.26},{-82.61,195.26},{-82.61,100.77}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(battery.controlBus,ems.controlBus) annotation(Line(points = {{111.82,237.02},{111.82,243.02},{-82.61,243.02},{-82.61,100.77}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(p_b_ref.systemBus,dcdc.controlBus) annotation(Line(points = {{32.96,100.69},{68.89,100.69},{68.89,195.26},{26.89,195.26},{26.89,189.26}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(power_ref.systemBus,charger.controlBus) annotation(Line(points = {{32.54,58.55},{38.54,58.55},{38.54,195.39},{-29.12,195.39},{-29.12,189.39}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(chargingMode.y,ems.isCharging) annotation(Line(points = {{-117.7,179.41},{-111.7,179.41},{-111.7,106.77},{-116.01,106.77},{-116.01,98.15}},color = {255,0,255}));
    connect(ems.P_cmd[1],p_b_ref.u_r) annotation(Line(points = {{-56.66,97.33},{-56.66,103.33},{6.210000000000001,103.33},{6.210000000000001,100.69},{12.21,100.69}},color = {0,0,127}));
    connect(ems.P_load_cmd,power_ref.u_r) annotation(Line(points = {{-56.88,65.56},{-56.88,58.55},{11.79,58.55}},color = {0,0,127}));
end System_SC_Batt_DCCharger_EMS_PowerMode;