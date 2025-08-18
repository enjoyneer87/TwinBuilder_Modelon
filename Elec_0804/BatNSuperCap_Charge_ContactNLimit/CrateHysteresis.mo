within BatNSuperCap_Charge_ContactNLimit;
model CrateHysteresis
  // Threshold와 히스테리시스 폭 설정
  parameter Real c_rate_threshold = 0.5;
  parameter Real hysteresis = 0.05;

  // 블록 선언
  Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-132,30},{-112,50}}, origin={0,0}, rotation=0)));
  Modelica.Blocks.Math.Abs abs(generateEvent = true)
    annotation(Placement(transformation(extent = {{-80.0,30.0},{-60.0,50.0}}, origin={0.0,0.0}, rotation=0.0)));
  Modelica.Blocks.Logical.Hysteresis hysteresisSwitch(
    uLow = c_rate_threshold - hysteresis,
    uHigh = c_rate_threshold + hysteresis)
    annotation(Placement(transformation(extent = {{-40,30},{-20,50}}, origin={0,0}, rotation=0)));
  Modelica.Blocks.Logical.Not notGate
    annotation(Placement(transformation(extent = {{12.0,-8.0},{32.0,12.0}}, origin={0.0,0.0}, rotation=0.0)));

  BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,
    controller(contactors(maxVoltageDiff = 100)))
    annotation(Placement(transformation(extent = {{110,-4},{130,16}}, origin={0,0}, rotation=0)));
  
  BatNSuperCap_Charge_ContactNLimit.BatFromCar_SuperCapContactNLimit battery2(
    controller(hide_bus_signals = true, contactors(hide_bus_signals = true)),
    id = 2,
    enable_thermal_port = false,
    np = 60,
    SOC_start = 0.2)
    annotation(Placement(transformation(extent = {{92,30},{112,50}}, origin={0,0}, rotation=0)));
  
  Electrification.Batteries.Control.Signals.close_contactors close_contactors(
    id = battery.id)
    annotation(Placement(transformation(extent = {{58.0,-2.0},{66.0,6.0}}, origin={0.0,0.0}, rotation=0.0)));

  Electrification.Batteries.Control.Signals.close_contactors close_contactors2(
    id = battery2.id)
    annotation(Placement(transformation(extent = {{58.0,36.0},{66.0,44.0}}, origin={0.0,0.0}, rotation=0.0)));

  Modelica.Blocks.Math.BooleanToInteger booleanToInteger(
    integerTrue = battery2.id,     // c_rate >= 0.5일 때 battery2 선택
    integerFalse = battery.id)     // c_rate < 0.5일 때 battery1 선택
    annotation(Placement(transformation(extent = {{4,-42},{24,-22}}, origin={0,0}, rotation=0)));

  Electrification.Loads.Control.Signals.i i(
    id = batteryCharger.id)
    annotation(Placement(transformation(extent = {{-132,-18},{-124,-10}}, origin={0,0}, rotation=0)));

  Electrification.Control.Signals.mode_ref mode_ref
    annotation(Placement(transformation(extent = {{42.0,-36.0},{50.0,-28.0}}, origin={0.0,0.0}, rotation=0.0)));

  Electrification.Loads.Examples.BatteryCharger batteryCharger(
    redeclare replaceable Electrification.Loads.Control.BatteryCharger controller(
      id_battery(start=1) = mode_ref.mode,
      hide_bus_signals = true,
      external_limits = true,
      iMaxOut = 1000,
      pMaxOut = 350e3,
      vMax = 800),
    hide_bus_signals = false,
    display_name = true)
    annotation(Placement(transformation(extent = {{-100,-90},{-80,-70}}, origin={0,0}, rotation=0)));

equation
  // 전류 입력 → gain → 절대값
  connect(i.y_r, gain.u) annotation(Line(points = {{-133,-14},{-140,-14},{-140,40},{-134,40}}, color={0,0,127}));
  connect(gain.y, abs.u) annotation(Line(points = {{-111,40},{-82,40}}, color={0,0,127}));

  // 절대값 출력 → 히스테리시스 입력
  connect(abs.y, hysteresisSwitch.u) annotation(Line(points = {{-59,40},{-40,40}}, color={0,0,127}));

  // 히스테리시스 출력 → NOT 블록 입력
  connect(hysteresisSwitch.y, notGate.u) annotation(Line(points = {{-17,40},{2,40},{2,2},{10,2}}, color={255,0,255}));

  // 히스테리시스 출력 → battery2 컨택터 제어 신호
  connect(hysteresisSwitch.y, close_contactors2.u_b) annotation(Line(points = {{0,40},{10,40}}, color={255,0,255}));

  // NOT 출력 → battery1 컨택터 제어 신호
  connect(notGate.y, close_contactors.u_b) annotation(Line(points = {{33,2},{56,2}}, color={255,0,255}));

  // 각 배터리의 컨트롤 버스 → 배터리 충전기 컨트롤 버스 연결
  connect(close_contactors.systemBus, battery.controlBus) annotation(Line(points = {{66,2},{74,2},{74,16},{112,16}}, color={240,170,40}, pattern=LinePattern.Dot));
  connect(close_contactors2.systemBus, battery2.controlBus) annotation(Line(points = {{66,40},{76,40},{76,56},{94,56},{94,50}}, color={240,170,40}, pattern=LinePattern.Dot));

  // booleanToInteger 입력 → 히스테리시스 출력 (충전기 모드 설정)
  connect(booleanToInteger.u, hysteresisSwitch.y) annotation(Line(points = {{2,-32},{-12,-32},{-12,40},{-19,40}}, color={255,0,255}));

  // booleanToInteger 출력 → mode_ref 입력 (충전기 배터리 모드 설정)
  connect(booleanToInteger.y, mode_ref.u_i) annotation(Line(points = {{25,-32},{40,-32}}, color={255,127,0}));

  // 배터리 컨트롤 버스 → 배터리 충전기 컨트롤 버스
  connect(battery.controlBus, batteryCharger.controlBus) annotation(Line(points = {{112,16},{-98,16},{-98,-70}}, color={240,170,40}, pattern=LinePattern.Dot));
  connect(battery2.controlBus, batteryCharger.controlBus) annotation(Line(points = {{94,50},{94,56},{-98,56},{-98,-70}}, color={240,170,40}, pattern=LinePattern.Dot));

  // 배터리 충전기와 배터리 전원 플러그 연결
  connect(batteryCharger.plug_a, battery.plug_a) annotation(Line(points = {{-100,-80},{90,-80},{90,6},{110,6}}, color={255,128,0}));
  connect(batteryCharger.plug_a, battery2.plug_a) annotation(Line(points = {{-100,-80},{-100,-58},{202,-58},{202,26},{92,26},{92,40}}, color={255,128,0}));

  // 충전기 제어 버스 → 전류 센서 연결
  connect(batteryCharger.controlBus, i.systemBus) annotation(Line(points = {{-98,-70},{-98,-22},{-124,-22},{-124,-14}}, color={240,170,40}, pattern=LinePattern.Dot));

  // mode_ref → 충전기 제어 버스
  connect(mode_ref.systemBus, batteryCharger.controlBus) annotation(Line(points = {{50,-32},{56,-32},{56,-70},{-98,-70}}, color={240,170,40}, pattern=LinePattern.Dot));

annotation(
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end CrateHysteresis;