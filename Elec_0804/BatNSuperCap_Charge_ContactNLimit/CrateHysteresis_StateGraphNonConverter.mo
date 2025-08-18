within BatNSuperCap_Charge_ContactNLimit;

model CrateHysteresis_StateGraphNonConverter

  parameter Real c_rate_threshold = 0.5;
  parameter Real hysteresis = 0.001;

  .BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,redeclare replaceable .BatNSuperCap_Charge_ContactNLimit.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(iMaxOut = battery.i_nom_1C * 0.499,iMaxIn = battery.i_nom_1C * 0.499,external_enable = false),contactors(contactors_closed = false)),
    display_name = true,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical)
    annotation(Placement(transformation(extent = {{148.0,-22.0},{168.0,-2.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-110.0,-16.0},{-90.0,4.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Electrical.DCSensor dCSensor
    annotation(Placement(transformation(extent = {{94.0,-22.0},{114.0,-2.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.5 - 0.01) annotation(Placement(transformation(extent = {{-34.0,-18.0},{-14.0,2.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.5 + 0.01) annotation(Placement(transformation(extent = {{-36.0,98.0},{-16.0,118.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-84.0,50.0},{-64.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.Transition transition(enableTimer = false,waitTime = 0.3) annotation(Placement(transformation(extent = {{-64.0,50.0},{-44.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepBattery(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{26.0,48.0},{46.0,68.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer = true,waitTime = 0.3) annotation(Placement(transformation(extent = {{-14.0,50.0},{6.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal2(enableTimer = true,waitTime = 0.1) annotation(Placement(transformation(extent = {{12.85,100.85},{-4.85,83.15}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{128.0,24.0},{148.0,44.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain2(k = 1 / battery.i_nom_1C) annotation(Placement(transformation(extent = {{-74.0,98.0},{-54.0,118.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.BatteryChargerFixedLimits_CC_1 batteryChargerFixedLimits_CC_(pMax = 350000000,vMax = battery.controller.limits.vMax,enable_control_bus = false,iMax = 300) annotation(Placement(transformation(extent = {{-44.0,-72.0},{-24.0,-52.0}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit battery2(display_name = true,redeclare replaceable .BatNSuperCap_Charge_ContactNLimit.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(external_enable = true,iMaxOut = 200,iMaxIn = 200),contactors(external_control = true)),SOC_start = 0.2,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,np = 60,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,id = 1,core(iCellMaxDch = 200,iCellMaxCh = 200)) annotation(Placement(transformation(extent = {{158.0,24.0},{178.0,44.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{0.95,114.95},{7.05,121.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepCap(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-34.0,50.0},{-14.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less annotation(Placement(transformation(extent = {{-36.0,132.0},{-16.0,152.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits(aggregate = false,vMinSignal = false,iMaxInSignal = false,iMaxOutSignal = false,pMaxInSignal = false,pMaxOutSignal = false) annotation(Placement(transformation(extent = {{170.0,128.0},{150.0,168.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = battery.id) annotation(Placement(transformation(extent = {{48.0,0.0},{56.0,8.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs(generateEvent = true) annotation(Placement(transformation(extent = {{-110.0,116.0},{-90.0,136.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs2(generateEvent = true) annotation(Placement(transformation(extent = {{-140.0,-16.0},{-120.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold2(threshold = 0.1) annotation(Placement(transformation(extent = {{-36.0,18.0},{-16.0,38.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and2 annotation(Placement(transformation(extent = {{-9.05,22.95},{-2.95,29.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less2 annotation(Placement(transformation(extent = {{-6.0,-38.0},{14.0,-18.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits2(vMaxSignal = false,vMax = 400,iMaxOutSignal = false,iMaxInSignal = false,vMinSignal = false) annotation(Placement(transformation(extent = {{248.0,-72.0},{228.0,-32.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and3 annotation(Placement(transformation(extent = {{40.95,22.95},{47.05,29.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors2(id = battery2.id) annotation(Placement(transformation(extent = {{70.0,38.0},{78.0,46.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less3 annotation(Placement(transformation(extent = {{-18,-90},{2,-70}},origin = {0,0},rotation = 0)));
    .Modelica.StateGraph.StepWithSignal CV(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{82.0,54.0},{102.0,74.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal CVOn(waitTime = 1,enableTimer = true) annotation(Placement(transformation(extent = {{51.15,57.15},{68.85,74.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-3.67,-3.67},{3.67,3.67}},origin = {74.0,-74.0},rotation = 90.0)));
    .Electrification.Electrical.DCInit vInitB(init_start = true,v_start = battery.summary.ocv) annotation(Placement(transformation(extent = {{114.0,-40.0},{126.0,-28.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCInit vInitB2(v_start = battery2.summary.ocv,init_start = true) annotation(Placement(transformation(extent = {{122.0,62.0},{134.0,74.0}},rotation = 0.0,origin = {0.0,0.0})));

equation
  connect(dCSensor.plug_b,battery.plug_a)
    annotation(Line(points = {{114,-12},{148,-12}},color = {255,128,0}));
 
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-63.5,60},{-58,60}},color = {0,0,0}));
    connect(transition.outPort,stepCap.inPort[1]) annotation(Line(points = {{-52.5,60},{-35,60}},color = {0,0,0}));
    connect(getComponentLimits.componentBus,battery2.controlBus) annotation(Line(points = {{170,148},{186,148},{186,44},{160,44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits.i_max_in,less.u2) annotation(Line(points = {{149,152},{143,152},{143,128},{-38,128},{-38,134}},color = {0,0,127}));
    connect(greaterEqualThreshold.u,gain2.y) annotation(Line(points = {{-38,108},{-53,108}},color = {0,0,127}));
    connect(dCSensor2.y[2],abs.u) annotation(Line(points = {{138,25},{138,14},{-118,14},{-118,126},{-112,126}},color = {0,0,127}));
    connect(abs.y,gain2.u) annotation(Line(points = {{-89,126},{-82.5,126},{-82.5,108},{-76,108}},color = {0,0,127}));
    connect(abs.y,less.u1) annotation(Line(points = {{-89,126},{-63.5,126},{-63.5,142},{-38,142}},color = {0,0,127}));
    connect(less.y,and1.u1) annotation(Line(points = {{-15,142},{-7.33,142},{-7.33,118},{0.34,118}},color = {255,0,255}));
    connect(greaterEqualThreshold.y,and1.u2) annotation(Line(points = {{-15,108},{-7.33,108},{-7.33,115.56},{0.34,115.56}},color = {255,0,255}));
    connect(dCSensor.y[2],abs2.u) annotation(Line(points = {{104,-21},{104,-42},{-148,-42},{-148,-6},{-142,-6}},color = {0,0,127}));
    connect(abs2.y,gain.u) annotation(Line(points = {{-119,-6},{-112,-6}},color = {0,0,127}));
    connect(gain.y,lessThreshold.u) annotation(Line(points = {{-89,-6},{-36,-6},{-36,-8}},color = {0,0,127}));
    connect(dCSensor2.y[2],lessThreshold2.u) annotation(Line(points = {{138,25},{138,-1},{-44,-1},{-44,28},{-38,28}},color = {0,0,127}));
    connect(lessThreshold2.y,and2.u1) annotation(Line(points = {{-15,28},{-9.66,28},{-9.66,26}},color = {255,0,255}));
    connect(lessThreshold.y,and2.u2) annotation(Line(points = {{-13,-8},{-9.66,-8},{-9.66,23.56}},color = {255,0,255}));
    connect(battery.controlBus,getComponentLimits2.componentBus) annotation(Line(points = {{150,-2},{150,4},{136,4},{136,-86},{248,-86},{248,-52}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits2.i_max_in,less2.u2) annotation(Line(points = {{227,-48},{227,-54},{-20,-54},{-20,-36},{-8,-36}},color = {0,0,127}));
    connect(gain.y,less2.u1) annotation(Line(points = {{-89,-6},{-48.5,-6},{-48.5,-28},{-8,-28}},color = {0,0,127}));
    connect(less2.y,and3.u2) annotation(Line(points = {{15,-28},{22,-28},{22,23.56},{40.34,23.56}},color = {255,0,255}));
    connect(stepBattery.active,and3.u1) annotation(Line(points = {{36,47},{36,26},{40.34,26}},color = {255,0,255}));
    connect(and3.y,close_contactors.u_b) annotation(Line(points = {{47.36,26},{53.36,26},{53.36,15},{42,15},{42,4},{46,4}},color = {255,0,255}));
    connect(close_contactors2.systemBus,battery2.controlBus) annotation(Line(points = {{78,42},{84,42},{84,52},{160,52},{160,44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(transitionWithSignal.outPort,stepBattery.inPort[1]) annotation(Line(points = {{-2.5,60},{25,60},{25,58}},color = {0,0,0}));
    connect(stepCap.outPort[1],transitionWithSignal.inPort) annotation(Line(points = {{-13.5,60},{-8,60}},color = {0,0,0}));
    connect(and2.y,transitionWithSignal.condition) annotation(Line(points = {{-2.64,26},{-2.64,42},{-4,42},{-4,48}},color = {255,0,255}));
    connect(transitionWithSignal2.outPort,stepCap.inPort[2]) annotation(Line(points = {{2.67,92},{-41,92},{-41,60},{-35,60}},color = {0,0,0}));
    connect(and1.y,transitionWithSignal2.condition) annotation(Line(points = {{7.36,118},{13.36,118},{13.36,106.85},{4,106.85},{4,102.62}},color = {255,0,255}));
    connect(close_contactors.systemBus,battery.controlBus) annotation(Line(points = {{56,4},{150,4},{150,-2}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_b,battery2.plug_a) annotation(Line(points = {{148,34},{158,34}},color = {255,128,0}));
    connect(close_contactors2.u_b,stepCap.active) annotation(Line(points = {{68,42},{-24,42},{-24,49}},color = {255,0,255}));
    connect(dCSensor.y[1],less3.u1) annotation(Line(points = {{104,-21},{104,-114},{-32,-114},{-32,-80},{-20,-80}},color = {0,0,127}));
    connect(getComponentLimits2.v_max,less3.u2) annotation(Line(points = {{227,-36},{227,-44},{121,-44},{121,-100},{-28,-100},{-28,-88},{-20,-88}},color = {0,0,127}));
    connect(transitionWithSignal2.inPort,CV.outPort[1]) annotation(Line(points = {{7.54,92},{102.5,92},{102.5,64}},color = {0,0,0}));
    connect(stepBattery.outPort[1],CVOn.inPort) annotation(Line(points = {{46.5,58},{46.5,66},{56.46,66}},color = {0,0,0}));
    connect(CVOn.outPort,CV.inPort[1]) annotation(Line(points = {{61.33,66},{81,66},{81,64}},color = {0,0,0}));
    connect(not1.u,less3.y) annotation(Line(points = {{74,-78.4},{8,-78.4},{8,-80},{3,-80}},color = {255,0,255}));
    connect(not1.y,CVOn.condition) annotation(Line(points = {{74,-69.96},{74,-9.81},{60,-9.81},{60,55.38}},color = {255,0,255}));
    connect(dCSensor2.plug_a,batteryChargerFixedLimits_CC_.plug_a) annotation(Line(points = {{128,34},{-50,34},{-50,-62},{-44,-62}},color = {255,128,0}));
    connect(dCSensor.plug_a,batteryChargerFixedLimits_CC_.plug_a) annotation(Line(points = {{94,-12},{-50,-12},{-50,-62},{-44,-62}},color = {255,128,0}));
    connect(vInitB.plug_a,battery.plug_a) annotation(Line(points = {{126,-34},{137,-34},{137,-12},{148,-12}},color = {255,128,0}));
    connect(vInitB2.plug_a,dCSensor2.plug_b) annotation(Line(points = {{134,68},{148,68},{148,34}},color = {255,128,0}));

protected

annotation(
  uses(Modelica(version="4.0.0")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end CrateHysteresis_StateGraphNonConverter;
