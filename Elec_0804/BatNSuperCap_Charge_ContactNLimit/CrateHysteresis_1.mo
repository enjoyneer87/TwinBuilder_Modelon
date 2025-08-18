within BatNSuperCap_Charge_ContactNLimit;

model CrateHysteresis_1
  // Threshold와 히스테리시스 폭 설정
  parameter Real c_rate_threshold = 0.5;
  parameter Real hysteresis = 0.01;
  .Modelica.Blocks.Math.Abs abs(generateEvent = true)
    annotation(Placement(transformation(extent = {{-80.0,30.0},{-60.0,50.0}}, origin={0.0,0.0}, rotation=0.0)));
  .Modelica.Blocks.Logical.Hysteresis hysteresisSwitch(
    uLow = c_rate_threshold - hysteresis,
    uHigh = c_rate_threshold + hysteresis,pre_y_start = true)
    annotation(Placement(transformation(extent = {{-40.0,30.0},{-20.0,50.0}}, origin={0.0,0.0}, rotation=0.0)));

  .BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,
    controller(contactors(maxVoltageDiff = 10,contactors_closed = false),redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(external_enable = false,iMaxIn = battery.i_nom_1C,iMaxOut = battery.i_nom_1C)),display_name = true,fixed_temperature = true)
    annotation(Placement(transformation(extent = {{110.0,-4.0},{130.0,16.0}}, origin={0.0,0.0}, rotation=0.0)));
  
  .BatNSuperCap_Charge_ContactNLimit.BatFromCar_SuperCapContactNLimit battery2(
    controller(hide_bus_signals = true, contactors(hide_bus_signals = true,contactors_closed = false)),
    id = 2,
    enable_thermal_port = false,
    np = 60,
    SOC_start = 0.2,fixed_temperature = true)
    annotation(Placement(transformation(extent = {{104.0,22.0},{124.0,42.0}}, origin={0.0,0.0}, rotation=0.0)));
  
  .Electrification.Batteries.Control.Signals.close_contactors close_contactors(
    id = battery.id)
    annotation(Placement(transformation(extent = {{58.0,-2.0},{66.0,6.0}}, origin={0.0,0.0}, rotation=0.0)));

  .Electrification.Batteries.Control.Signals.close_contactors close_contactors2(
    id = battery2.id)
    annotation(Placement(transformation(extent = {{50.0,36.0},{58.0,44.0}}, origin={0.0,0.0}, rotation=0.0)));
    .Modelica.Blocks.Logical.Not notGate annotation(Placement(transformation(extent = {{11.77,-8.0},{36.23,12.0}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.BatteryChargerFixedLimits_CC batteryChargerFixedLimits_CC annotation(Placement(transformation(extent = {{-38.0,-88.0},{-18.0,-68.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C) annotation(Placement(transformation(extent = {{-132,30},{-112,50}},origin = {0,0},rotation = 0)));
    .Electrification.Electrical.DCSensor dCSensor annotation(Placement(transformation(extent = {{82.0,-16.0},{102.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCInit vInitB(v_start = battery.summary.ocv,init_start = true) annotation(Placement(transformation(extent = {{90.0,-36.0},{102.0,-24.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCInit vInitB2(init_start = true,v_start = battery2.summary.ocv) annotation(Placement(transformation(extent = {{70.0,60.0},{82.0,72.0}},rotation = 0.0,origin = {0.0,0.0})));

equation

  // 절대값 출력 → 히스테리시스 입력
  connect(abs.y, hysteresisSwitch.u) annotation(Line(points = {{-59,40},{-42,40}}, color={0,0,127}));
    connect(hysteresisSwitch.y,close_contactors2.u_b) annotation(Line(points = {{-19,40},{48,40}},color = {255,0,255}));
    connect(close_contactors.u_b,notGate.y) annotation(Line(points = {{56,2},{37.45,2}},color = {255,0,255}));
    connect(notGate.u,hysteresisSwitch.y) annotation(Line(points = {{9.32,2},{-4.84,2},{-4.84,40},{-19,40}},color = {255,0,255}));
    connect(close_contactors2.systemBus,battery2.controlBus) annotation(Line(points = {{58,40},{64,40},{64,48},{106,48},{106,42}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors.systemBus,battery.controlBus) annotation(Line(points = {{66,2},{72,2},{72,22},{112,22},{112,16}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(battery2.plug_a,batteryChargerFixedLimits_CC.plug_a) annotation(Line(points = {{104,32},{-52,32},{-52,-78},{-38,-78}},color = {255,128,0}));
    connect(gain.y,abs.u) annotation(Line(points = {{-111,40},{-82,40}},color = {0,0,127}));
    connect(dCSensor.plug_b,battery.plug_a) annotation(Line(points = {{102,-6},{110,-6},{110,6}},color = {255,128,0}));
    connect(dCSensor.y[2],gain.u) annotation(Line(points = {{92,-15},{92,-21},{-140,-21},{-140,40},{-134,40}},color = {0,0,127}));
    connect(batteryChargerFixedLimits_CC.plug_a,dCSensor.plug_a) annotation(Line(points = {{-38,-78},{-44,-78},{-44,-46},{82,-46},{82,-6}},color = {255,128,0}));
    connect(vInitB.plug_a,dCSensor.plug_b) annotation(Line(points = {{102,-30},{108,-30},{108,-6},{102,-6}},color = {255,128,0}));
    connect(vInitB2.plug_a,battery2.plug_a) annotation(Line(points = {{82,66},{93,66},{93,32},{104,32}},color = {255,128,0}));

annotation(
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end CrateHysteresis_1;
