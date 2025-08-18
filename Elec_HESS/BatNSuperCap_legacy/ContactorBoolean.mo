within BatNSuperCap_legacy;
model ContactorBoolean
    extends .Electrification.Batteries.Electrical.Pack.Interfaces.Base;
    .Modelica.Electrical.Analog.Ideal.IdealClosingSwitch positiveSwitch(useHeatPort = true,Ron = contactorResistance,Goff = 1 / isolationResistance) annotation(Placement(transformation(extent = {{8.0,-8.0},{-8.0,8.0}},rotation = 180.0,origin = {-29.0,38.0})));
    .Electrification.Electrical.Components.Resistor packResistor(enable_heatport = true,R = packResistance) annotation(Placement(transformation(extent = {{8.0,-8.0},{-8.0,8.0}},rotation = 180.0,origin = {1.0,38.0})));
    .Electrification.Electrical.Components.Resistor preChargeResistor(R = preChargeResistance,enable_heatport = true) annotation(Placement(transformation(extent = {{8.0,-8.0},{-8.0,8.0}},rotation = 180.0,origin = {1.0,58.0})));
    .Modelica.Electrical.Analog.Ideal.IdealClosingSwitch preChargeSwitch(useHeatPort = true,Ron = contactorResistance,Goff = 1 / isolationResistance) annotation(Placement(transformation(extent = {{8.0,8.0},{-8.0,-8.0}},rotation = 180.0,origin = {-29.0,58.0})));
    .Electrification.Electrical.Components.Resistor resistor_n(enable_heatport = true,R = isolationResistance) annotation(Placement(transformation(extent = {{-8.0,-8.0},{8.0,8.0}},rotation = -90.0,origin = {58.0,-24.0})));
    .Electrification.Electrical.Components.Resistor resistor_p(enable_heatport = true,R = isolationResistance) annotation(Placement(transformation(extent = {{8.0,8.0},{-8.0,-8.0}},rotation = 90.0,origin = {58.0,16.0})));
    .Modelica.Electrical.Analog.Ideal.IdealClosingSwitch negativeSwitch(useHeatPort = true,Ron = contactorResistance,Goff = 1 / isolationResistance) annotation(Placement(transformation(extent = {{-8.0,8.0},{8.0,-8.0}},rotation = 180.0,origin = {-32.0,-40.0})));
equation
    connect(positiveSwitch.n,packResistor.p) annotation(Line(points = {{-21,38},{-7,38}},color = {0,0,255}));
    connect(preChargeSwitch.n,preChargeResistor.p) annotation(Line(points = {{-21,58},{-7,58}},color = {0,0,255}));
    connect(pin_p,packResistor.n) annotation(Line(points = {{100,40},{9,40},{9,38}},color = {0,0,255}));
    connect(preChargeResistor.n,pin_p) annotation(Line(points = {{9,58},{58,58},{58,40},{100,40}},color = {0,0,255}));
    connect(resistor_p.p,pin_p) annotation(Line(points = {{58,24},{58,40},{100,40}},color = {0,0,255}));
    connect(resistor_p.n,resistor_n.p) annotation(Line(points = {{58,8},{58,-16}},color = {0,0,255}));
    connect(resistor_n.n,pin_n) annotation(Line(points = {{58,-32},{58,-40},{100,-40}},color = {0,0,255}));
    connect(negativeSwitch.p,pin_n) annotation(Line(points = {{-24,-40},{100,-40}},color = {0,0,255}));
    connect(splitter.n,negativeSwitch.n) annotation(Line(points = {{-72,-4},{-72,-40},{-40,-40}},color = {0,0,255}));
    connect(positiveSwitch.p,splitter.p) annotation(Line(points = {{-37,38},{-72,38},{-72,4}},color = {0,0,255}));
    connect(preChargeSwitch.p,splitter.p) annotation(Line(points = {{-37,58},{-72,58},{-72,4}},color = {0,0,255}));
    connect(ground,resistor_n.p) annotation(Line(points = {{-100,-100},{12,-100},{12,-10},{58,-10},{58,-16}},color = {0,0,255}));
end ContactorBoolean;
