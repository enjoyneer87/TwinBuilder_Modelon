within BatNSuperCap_Charge_ContactNLimit;

model CrateHysteresis_Test
  // Threshold와 히스테리시스 폭 설정
  parameter Real c_rate_threshold = 0.5;
  parameter Real hysteresis = 0.05;

  // 블록 선언
  .Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-132,30},{-112,50}}, origin={0,0}, rotation=0)));
  .Modelica.Blocks.Math.Abs abs(generateEvent = true)
    annotation(Placement(transformation(extent = {{-80.0,30.0},{-60.0,50.0}}, origin={0.0,0.0}, rotation=0.0)));
  .Modelica.Blocks.Logical.Hysteresis hysteresisSwitch(
    uLow = c_rate_threshold - hysteresis,
    uHigh = c_rate_threshold + hysteresis,pre_y_start = true)
    annotation(Placement(transformation(extent = {{-56.0,30.0},{-36.0,50.0}}, origin={0.0,0.0}, rotation=0.0)));
  .Modelica.Blocks.Logical.Not notGate
    annotation(Placement(transformation(extent = {{14.0,-10.0},{34.0,10.0}}, origin={0.0,0.0}, rotation=0.0)));

  .BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,
    controller(contactors(maxVoltageDiff = 10,contactors_closed = true,external_control = false)),display_name = true)
    annotation(Placement(transformation(extent = {{110.0,-4.0},{130.0,16.0}}, origin={0.0,0.0}, rotation=0.0)));
  
  .BatNSuperCap_Charge_ContactNLimit.BatFromCar_SuperCapContactNLimit battery2(
    controller(hide_bus_signals = true, contactors(hide_bus_signals = true,external_control = false)),
    id = 2,
    enable_thermal_port = false,
    np = 60,
    SOC_start = 0.2)
    annotation(Placement(transformation(extent = {{100.0,30.0},{120.0,50.0}}, origin={0.0,0.0}, rotation=0.0)));

  .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(
    integerTrue = battery2.id,     // c_rate >= 0.5일 때 battery2 선택
    integerFalse = battery.id)     // c_rate < 0.5일 때 battery1 선택
    annotation(Placement(transformation(extent = {{4.0,-42.0},{24.0,-22.0}}, origin={0.0,0.0}, rotation=0.0)));

  .Electrification.Loads.Control.Signals.i i(
    id = batteryCharger.id)
    annotation(Placement(transformation(extent = {{-132,-18},{-124,-10}}, origin={0,0}, rotation=0)));

  .Electrification.Control.Signals.mode_ref mode_ref
    annotation(Placement(transformation(extent = {{42.0,-36.0},{50.0,-28.0}}, origin={0.0,0.0}, rotation=0.0)));

  .Electrification.Loads.Examples.BatteryCharger batteryCharger(
    redeclare replaceable .Electrification.Loads.Control.BatteryCharger controller(
      id_battery(start=1,fixed = false) = mode_ref.mode,
      hide_bus_signals = true,
      external_limits = true,
      iMaxOut = 1000,
      pMaxOut = 350e5,
      vMax = 800,k_pMax = 2),
    hide_bus_signals = false,
    display_name = true)
    annotation(Placement(transformation(extent = {{-100.0,-90.0},{-80.0,-70.0}}, origin={0.0,0.0}, rotation=0.0)));
    .Electrification.Electrical.DCSwitch dcSwitch(external_input = true,Ron = 1e-6) annotation(Placement(transformation(extent = {{128.0,60.0},{148.0,80.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSwitch dcSwitch2(external_input = true,Ron = 1e-6) annotation(Placement(transformation(extent = {{84.0,-12.0},{104.0,-32.0}},origin = {0.0,0.0},rotation = 0.0)));

equation
  // 전류 입력 → gain → 절대값
  connect(i.y_r, gain.u) annotation(Line(points = {{-133,-14},{-140,-14},{-140,40},{-134,40}}, color={0,0,127}));
  connect(gain.y, abs.u) annotation(Line(points = {{-111,40},{-82,40}}, color={0,0,127}));

  // 절대값 출력 → 히스테리시스 입력
  connect(abs.y, hysteresisSwitch.u) annotation(Line(points = {{-59,40},{-58,40}}, color={0,0,127}));

  // 히스테리시스 출력 → NOT 블록 입력
  connect(hysteresisSwitch.y, notGate.u) annotation(Line(points = {{-35,40},{2,40},{2,0},{12,0}}, color={255,0,255}));

  // booleanToInteger 입력 → 히스테리시스 출력 (충전기 모드 설정)
  connect(booleanToInteger.u, hysteresisSwitch.y) annotation(Line(points = {{2,-32},{-8,-32},{-8,40},{-35,40}}, color={255,0,255}));

  // booleanToInteger 출력 → mode_ref 입력 (충전기 배터리 모드 설정)
  connect(booleanToInteger.y, mode_ref.u_i) annotation(Line(points = {{25,-32},{40,-32}}, color={255,127,0}));

  // 배터리 컨트롤 버스 → 배터리 충전기 컨트롤 버스
  connect(battery.controlBus, batteryCharger.controlBus) annotation(Line(points = {{112,16},{-98,16},{-98,-70}}, color={240,170,40}, pattern=LinePattern.Dot));
  connect(battery2.controlBus, batteryCharger.controlBus) annotation(Line(points = {{102,50},{102,56},{-98,56},{-98,-70}}, color={240,170,40}, pattern=LinePattern.Dot));

  // 충전기 제어 버스 → 전류 센서 연결
  connect(batteryCharger.controlBus, i.systemBus) annotation(Line(points = {{-98,-70},{-98,-22},{-124,-22},{-124,-14}}, color={240,170,40}, pattern=LinePattern.Dot));

  // mode_ref → 충전기 제어 버스
  connect(mode_ref.systemBus, batteryCharger.controlBus) annotation(Line(points = {{50,-32},{56,-32},{56,-70},{-98,-70}}, color={240,170,40}, pattern=LinePattern.Dot));
    connect(batteryCharger.plug_a,dcSwitch.plug_a) annotation(Line(points = {{-100,-80},{-22,-80},{-22,70},{128,70}},color = {255,128,0}));
    connect(dcSwitch.plug_b,battery2.plug_a) annotation(Line(points = {{148,70},{182,70},{182,30},{94,30},{94,40},{100,40}},color = {255,128,0}));
    connect(batteryCharger.plug_a,dcSwitch2.plug_a) annotation(Line(points = {{-100,-80},{-106,-80},{-106,-22},{84,-22}},color = {255,128,0}));
    connect(dcSwitch2.plug_b,battery.plug_a) annotation(Line(points = {{104,-22},{104,6},{110,6}},color = {255,128,0}));
    connect(dcSwitch.switch_close,hysteresisSwitch.y) annotation(Line(points = {{138,58},{138,54},{2,54},{2,40},{-35,40}},color = {255,0,255}));
    connect(notGate.y,dcSwitch2.switch_close) annotation(Line(points = {{35,0},{94,0},{94,-10}},color = {255,0,255}));

annotation(
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end CrateHysteresis_Test;
