model System_SC_Batt_DCCharger_EMS
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
      external_p_b=true,
      mode=Electrification.Utilities.Types.ConverterModePower.PowerB))
    annotation (Placement(transformation(extent={{40,120},{80,160}})));

  // 버스, 접지
  Electrification.Electrical.DCSplitter  dcBus annotation(Placement(transformation(extent={{10,130},{-10,150}})));
  Modelica.Electrical.Analog.Basic.Ground gnd annotation(Placement(transformation(extent={{-10,110},{10,120}})));

  // 슈퍼캡, 배터리
  HESS.paper_SCapPack scap(np=6) annotation(Placement(transformation(extent={{100,130},{120,150}})));
  HESS.KETI_BatteryPack battery(
    SOC_start=0.9, display_name=true, enable_thermal_port=false,
    redeclare replaceable Electrification.Batteries.Control.TwoSubControllers controller(
      redeclare replaceable Electrification.Batteries.Control.CellSensors controller1,
      redeclare replaceable Electrification.Batteries.Control.LimitsFixed controller2))
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));

  // DC 급속충전기(Load, Power mode)
  Electrification.Loads.Examples.Power charger(
    enable_thermal_port=false, display_name=true, fixed_temperature=true,
    redeclare Electrification.Loads.Control.PowerMode controller(
      external_mode=true, vMax=380))
    annotation (Placement(transformation(extent={{-120,190},{-160,230}})));
  Electrification.Loads.Control.Signals.power_ref power_ref(id=charger.id);

  // === EMS Unified (스케줄러 통합) ===
  EMS_Unified ems()
    annotation (Placement(transformation(extent={{-30,60},{30,100}})));

  // === 컨버터 제어 신호 ===
  Electrification.Converters.Control.Signals.p_b_ref p_b_ref(id=dcdc.id)
    annotation (Placement(transformation(extent={{90,80},{110,100}})));

  // === 배터리 제어 신호 ===
  Electrification.Batteries.Control.Signals.power_ref battPowerRef(id=battery.id)
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));

  // === 충전기 용량 제한 ===
  Modelica.Blocks.Sources.Constant chargerCap(k=300e3)
    annotation (Placement(transformation(extent={{-60,22},{-50,32}})));

  // === 모드 전환 신호 ===
  Modelica.Blocks.Sources.BooleanConstant chargingMode(k=true)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  // === 충전 전력 절댓값 변환 ===
  Modelica.Blocks.Math.Abs absChargePower
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  // === 모니터링 신호들 ===
  Modelica.Blocks.Interfaces.RealOutput alpha_load_out "Load derate factor";
  Modelica.Blocks.Interfaces.RealOutput P_unserved_out "Unserved power [W]";
  Modelica.Blocks.Interfaces.RealOutput p_max_out_total "Total discharge capacity [W]";
  Modelica.Blocks.Interfaces.RealOutput p_max_in_total "Total charge capacity [W]";

  // === 편의 표현식 ===
  Modelica.Blocks.Sources.RealExpression Vbus(y=dcdc.summary.v_b);
  Modelica.Blocks.Sources.RealExpression Psc_meas(y=dcdc.summary.p_out_b);
  Modelica.Blocks.Sources.RealExpression Pbatt_meas(y=battery.summary.p);

equation
  // ===== 전기 배선 =====
  // DC/DC 연결: A측=버스, B측=SC
  connect(dcdc.plug_b,  scap.plug_a);
  // 배터리 직접 연결 (EMS 제어)
  connect(battery.plug_a, dcdc.plug_a);
  // 충전기 부하
  connect(charger.plug_a, dcdc.plug_a);

  // ===== ControlBus 네트워크 =====
  connect(ems.controlBus, dcdc.controlBus);
  connect(ems.controlBus, charger.controlBus);
  connect(ems.controlBus, battery.controlBus);

  // ===== EMS Unified 입력 (모드 + 센서값) =====
  connect(chargingMode.y, ems.isCharging);
  
  // 센서 입력들
  ems.SOC = battery.summary.SOC;
  ems.T_max = battery.summary.T_max;
  ems.v_pack = battery.summary.v;
  ems.v_sc = scap.summary.v;
  ems.v_bus_in = dcdc.summary.v_b;
  ems.P_charger_cap = chargerCap.y;
  ems.iMaxIn_opt = 1e9;  // 큰 값 (제한 없음)
  
  // 더미 주행 전력 요청 (충전 모드이므로 사용안됨)
  ems.P_dem_raw = 0;

  // ===== 충전기 전력 지령 =====
  connect(power_ref.systemBus, charger.controlBus);
  connect(ems.P_load_cmd, absChargePower.u);
  connect(absChargePower.y, power_ref.u_r);

  // ===== 컨버터 전력 지령 =====
  connect(p_b_ref.systemBus, dcdc.controlBus);
  connect(ems.P_cmd[1], p_b_ref.u_r);

  // ===== 배터리 전력 지령 =====
  connect(battPowerRef.systemBus, battery.controlBus);
  connect(ems.P_cmd[2], battPowerRef.u_r);

  // ===== 모니터링 출력 연결 =====
  connect(ems.alpha_load, alpha_load_out);
  connect(ems.P_unserved, P_unserved_out);
  connect(ems.p_max_out_load, p_max_out_total);
  connect(ems.p_max_in_load, p_max_in_total);

  annotation(
    experiment(StopTime=20, Interval=0.01),
    Documentation(info="
    <html>
      <p><b>System_SC_Batt_DCCharger_EMS with EMS_Unified</b></p>
      <ul>
        <li>EMS_Unified: 통합 EMS (충전 스케줄러 내장)</li>
        <li>충전 모드: isCharging=true로 고정</li>
        <li>SC(DC/DC): EMS.P_cmd[1] → p_b_ref.u_r (Power Mode)</li>
        <li>Battery: 직접 연결, EMS.P_cmd[2]로 제어</li>
        <li>내장 스케줄러: SOC/온도/전압 기반 스마트 충전</li>
        <li>충전기: EMS 내부 스케줄러가 직접 전력 분배 처리</li>
      </ul>
    </html>"));
end System_SC_Batt_DCCharger_EMS;
