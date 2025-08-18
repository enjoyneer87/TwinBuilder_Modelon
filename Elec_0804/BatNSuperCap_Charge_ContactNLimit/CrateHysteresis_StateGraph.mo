within BatNSuperCap_Charge_ContactNLimit;
model CrateHysteresis_StateGraph
  import Modelica.StateGraph;
  import Electrification.Batteries.Control.Signals.close_contactors;
  import BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit;
  import BatNSuperCap_Charge_ContactNLimit.BatFromCar_SuperCapContactNLimit;

  parameter Real c_rate_threshold = 0.5;
  parameter Real hysteresis = 0.01;

  BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,redeclare replaceable .BatNSuperCap_Charge_ContactNLimit.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(iMaxOut = battery.i_nom_1C * 0.499,iMaxIn = battery.i_nom_1C * 0.499)),
    display_name = true,fixed_temperature = true,limitActionSoC = Modelon.Types.FaultAction.Warning,limitActionV = Modelon.Types.FaultAction.Warning,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical)
    annotation(Placement(transformation(extent = {{148.0,-22.0},{168.0,-2.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-132.0,30.0},{-112.0,50.0}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Logical.Pre preBatt()                   annotation(Placement(
      transformation(extent={{100.0,54.0},{108.0,62.0}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Logical.Pre preSuper() annotation(Placement(
      transformation(extent={{62.0,0.0},{70.0,8.0}},rotation = 0.0,origin = {0.0,0.0})));
  Electrification.Electrical.DCSensor dCSensor
    annotation(Placement(transformation(extent = {{86.0,-22.0},{106.0,-2.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.49) annotation(Placement(transformation(extent = {{-36.0,-16.0},{-16.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.51) annotation(Placement(transformation(extent = {{-36.0,98.0},{-16.0,118.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-84.0,50.0},{-64.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepBattery(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{22.0,54.0},{42.0,74.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer = true,waitTime = 1) annotation(Placement(transformation(extent = {{-10.0,50.0},{10.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal2(enableTimer = true,waitTime = 0.2) annotation(Placement(transformation(extent = {{12.85,100.85},{-4.85,83.15}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{68.0,16.0},{88.0,36.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain2(k = 1 / battery.i_nom_1C) annotation(Placement(transformation(extent = {{-104.0,98.0},{-84.0,118.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.BatteryChargerFixedLimits_CC_1 batteryChargerFixedLimits_CC_(pMax = 350000000,vMax = battery.controller.limits.vMax,enable_control_bus = false,iMax = 300) annotation(Placement(transformation(extent = {{-44.0,-72.0},{-24.0,-52.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs(generateEvent = true) annotation(Placement(transformation(extent = {{-72.0,98.0},{-52.0,118.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs2(generateEvent = true) annotation(Placement(transformation(extent = {{-92.0,-16.0},{-72.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit battery2(display_name = true,redeclare replaceable .BatNSuperCap_Charge_ContactNLimit.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(external_enable = true,iMaxOut = 200,iMaxIn = 200),contactors(external_control = true,contactors_closed = false)),SOC_start = 0.2,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,np = 60,fixed_temperature = true,limitActionSoC = Modelon.Types.FaultAction.Warning,limitActionV = Modelon.Types.FaultAction.Warning,id = 1,core(iCellMaxDch = 200,iCellMaxCh = 200)) annotation(Placement(transformation(extent = {{134.0,26.0},{154.0,46.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold2(threshold = 0.51) annotation(Placement(transformation(extent = {{-36.0,18.0},{-16.0,38.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Or or1 annotation(Placement(transformation(extent = {{68.59,48.59},{75.41,55.41}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{56.95,28.95},{63.05,35.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and2 annotation(Placement(transformation(extent = {{16.02,16.02},{23.98,23.98}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepCap(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-34.0,50.0},{-14.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{36.38,28.38},{43.62,35.62}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less annotation(Placement(transformation(extent = {{98.0,94.0},{118.0,114.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and3 annotation(Placement(transformation(extent = {{132.95,100.95},{139.05,107.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors2(id = battery2.id) annotation(Placement(transformation(extent = {{102.0,38.0},{110.0,46.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits annotation(Placement(transformation(extent = {{146.0,50.0},{126.0,90.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and4 annotation(Placement(transformation(extent = {{86.95,54.95},{93.05,61.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = battery.id) annotation(Placement(transformation(extent = {{80.0,0.0},{88.0,8.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs3(generateEvent = true) annotation(Placement(transformation(extent = {{66.0,116.0},{86.0,136.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and5 annotation(Placement(transformation(extent = {{38.95,-7.05},{45.05,-0.95}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits2(iMaxIn = 200,iMaxInSignal = false,iMaxOutSignal = false) annotation(Placement(transformation(extent = {{102.0,-146.0},{82.0,-106.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs4(generateEvent = true) annotation(Placement(transformation(extent = {{12.8,-88.4},{32.8,-68.4}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less2 annotation(Placement(transformation(extent = {{52.0,-78.0},{72.0,-58.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCInit vInitB(init_start = true,v_start = battery.summary.ocv) annotation(Placement(transformation(extent = {{116.0,-34.0},{128.0,-22.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCInit vInitB2(v_start = battery2.summary.ocv,init_start = true) annotation(Placement(transformation(extent = {{108.0,14.0},{120.0,26.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCInit vInitB3(v_start = battery.summary.ocv,init_start = true) annotation(Placement(transformation(extent = {{-68.0,-70.0},{-56.0,-58.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition(enableTimer = true,waitTime = 0.1) annotation(Placement(transformation(extent = {{-64,50},{-44,70}},origin = {0,0},rotation = 0)));

equation
  connect(dCSensor.plug_b,battery.plug_a)
    annotation(Line(points = {{106,-12},{148,-12}},color = {255,128,0}));
  connect(dCSensor.y[2],gain.u)
    annotation(Line(points = {{96,-21},{-140,-21},{-140,40},{-134,40}},color = {0,0,127}));
    connect(transitionWithSignal.outPort,stepBattery.inPort[1]) annotation(Line(points = {{1.5,60},{21,60},{21,64}},color = {0,0,0}));
    connect(stepBattery.outPort[1],transitionWithSignal2.inPort) annotation(Line(points = {{42.5,64},{46,64},{46,92},{7.54,92}},color = {0,0,0}));
    connect(lessThreshold.y,transitionWithSignal.condition) annotation(Line(points = {{-15,-6},{0,-6},{0,48}},color = {255,0,255}));
    connect(batteryChargerFixedLimits_CC_.plug_a,dCSensor.plug_a) annotation(Line(points = {{-44,-62},{-50,-62},{-50,-40},{86,-40},{86,-12}},color = {255,128,0}));
    connect(dCSensor2.plug_a,batteryChargerFixedLimits_CC_.plug_a) annotation(Line(points = {{68,26},{-50,26},{-50,-62},{-44,-62}},color = {255,128,0}));
    connect(gain2.y,abs.u) annotation(Line(points = {{-83,108},{-74,108}},color = {0,0,127}));
    connect(abs.y,greaterEqualThreshold.u) annotation(Line(points = {{-51,108},{-38,108}},color = {0,0,127}));
    connect(gain.y,abs2.u) annotation(Line(points = {{-111,40},{-102.5,40},{-102.5,-6},{-94,-6}},color = {0,0,127}));
    connect(abs2.y,lessThreshold.u) annotation(Line(points = {{-71,-6},{-38,-6}},color = {0,0,127}));
    connect(battery2.plug_a,dCSensor2.plug_b) annotation(Line(points = {{134,36},{95,36},{95,26},{88,26}},color = {255,128,0}));
    connect(dCSensor2.y[2],gain2.u) annotation(Line(points = {{78,17},{78,12},{-112,12},{-112,108},{-106,108}},color = {0,0,127}));
    connect(abs2.y,greaterEqualThreshold2.u) annotation(Line(points = {{-71,-6},{-60,-6},{-60,28},{-38,28}},color = {0,0,127}));
    connect(and1.u1,greaterEqualThreshold.y) annotation(Line(points = {{56.34,32},{56.34,42},{50,42},{50,116},{-15,116},{-15,108}},color = {255,0,255}));
    connect(and1.y,or1.u1) annotation(Line(points = {{63.36,32},{63.36,52},{67.91,52}},color = {255,0,255}));
    connect(greaterEqualThreshold2.y,and2.u2) annotation(Line(points = {{-15,28},{-10,28},{-10,16.82},{15.22,16.82}},color = {255,0,255}));
    connect(and2.y,or1.u2) annotation(Line(points = {{24.38,20},{67.91,20},{67.91,49.27}},color = {255,0,255}));
    connect(stepCap.outPort[1],transitionWithSignal.inPort) annotation(Line(points = {{-13.5,60},{-4,60}},color = {0,0,0}));
    connect(stepBattery.active,and2.u1) annotation(Line(points = {{32,53},{32,44},{12,44},{12,20},{15.22,20}},color = {255,0,255}));
    connect(and1.u2,not1.y) annotation(Line(points = {{56.34,29.56},{56.34,22.95},{50.16,22.95},{50.16,42},{43.98,42},{43.98,32}},color = {255,0,255}));
    connect(stepBattery.active,not1.u) annotation(Line(points = {{32,53},{32,40.5},{35.66,40.5},{35.66,32}},color = {255,0,255}));
    connect(less.y,and3.u1) annotation(Line(points = {{119,104},{132.34,104}},color = {255,0,255}));
    connect(or1.y,and3.u2) annotation(Line(points = {{75.75,52},{75.75,101.56},{132.34,101.56}},color = {255,0,255}));
    connect(and3.y,transitionWithSignal2.condition) annotation(Line(points = {{139.36,104},{139.36,109.05},{4,109.05},{4,102.62}},color = {255,0,255}));
    connect(getComponentLimits.componentBus,battery2.controlBus) annotation(Line(points = {{146,70},{136,70},{136,46}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits.i_max_in,less.u2) annotation(Line(points = {{125,74},{84,74},{84,96},{96,96}},color = {0,0,127}));
    connect(less.y,and4.u1) annotation(Line(points = {{119,104},{125,104},{125,81},{80.95,81},{80.95,58},{86.34,58}},color = {255,0,255}));
    connect(stepCap.active,and4.u2) annotation(Line(points = {{-24,49},{-24,43},{86.34,43},{86.34,55.56}},color = {255,0,255}));
    connect(close_contactors2.systemBus,battery2.controlBus) annotation(Line(points = {{110,42},{136,42},{136,46}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors.systemBus,battery.controlBus) annotation(Line(points = {{88,4},{150,4},{150,-2}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(abs3.y,less.u1) annotation(Line(points = {{87,126},{91.5,126},{91.5,104},{96,104}},color = {0,0,127}));
    connect(abs3.u,dCSensor2.y[2]) annotation(Line(points = {{64,126},{58,126},{58,11},{78,11},{78,17}},color = {0,0,127}));
    connect(less2.y,and5.u1) annotation(Line(points = {{73,-68},{80,-68},{80,-123.4},{30,-123.4},{30,-4},{38.34,-4}},color = {255,0,255}));
    connect(getComponentLimits2.i_max_in,less2.u2) annotation(Line(points = {{81,-122},{44,-122},{44,-76},{50,-76}},color = {0,0,127}));
    connect(abs4.y,less2.u1) annotation(Line(points = {{33.8,-78.4},{38.3,-78.4},{38.3,-68},{50,-68}},color = {0,0,127}));
    connect(battery.controlBus,getComponentLimits2.componentBus) annotation(Line(points = {{150,-2},{150,4},{130,4},{130,-126},{102,-126}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.y[2],abs4.u) annotation(Line(points = {{96,-21},{96,-28},{4.800000000000001,-28},{4.800000000000001,-78.4},{10.8,-78.4}},color = {0,0,127}));
    connect(and5.u2,or1.y) annotation(Line(points = {{38.34,-6.44},{32.95,-6.44},{32.95,22.78},{81.75,22.78},{81.75,52},{75.75,52}},color = {255,0,255}));
    connect(vInitB.plug_a,battery.plug_a) annotation(Line(points = {{128,-28},{138,-28},{138,-12},{148,-12}},color = {255,128,0}));
    connect(vInitB2.plug_a,battery2.plug_a) annotation(Line(points = {{120,20},{127,20},{127,36},{134,36}},color = {255,128,0}));
    connect(vInitB3.plug_a,batteryChargerFixedLimits_CC_.plug_a) annotation(Line(points = {{-56,-64},{-50,-64},{-50,-62},{-44,-62}},color = {255,128,0}));
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-63.5,60},{-58,60}},color = {0,0,0}));
    connect(transition.outPort,stepCap.inPort[1]) annotation(Line(points = {{-52.5,60},{-35,60}},color = {0,0,0}));
    connect(transitionWithSignal2.outPort,stepCap.inPort[2]) annotation(Line(points = {{2.67,92},{-41,92},{-41,60},{-35,60}},color = {0,0,0}));
    connect(and4.y,           preBatt.u);
    connect(preBatt.y,        close_contactors2.u_b) annotation(Line(points = {{108.4,58},{114.4,58},{114.4,50},{94,50},{94,42},{100,42}}));
    connect(and5.y,           preSuper.u) annotation(Line(points = {{45.36,-4},{51.36,-4},{51.36,4},{61.2,4}}));
    connect(preSuper.y,       close_contactors.u_b);
    connect(and5.y,preSuper.u) annotation(Line(points = {{45.36,-4},{51.36,-4},{51.36,-13.05},{32.95,-13.05},{32.95,6},{45.2,6}},color = {255,0,255}));
    connect(preSuper.y,close_contactors.u_b) annotation(Line(points = {{70.4,4},{78,4}},color = {255,0,255}));
    connect(and4.y,preBatt.u) annotation(Line(points = {{93.35,58},{99.2,58}},color = {255,0,255}));
    connect(preBatt.y,close_contactors2.u_b) annotation(Line(points = {{108.4,58},{114.4,58},{114.4,68},{94,68},{94,42},{100,42}},color = {255,0,255}));

protected

annotation(
  uses(Modelica(version="4.0.0")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end CrateHysteresis_StateGraph;