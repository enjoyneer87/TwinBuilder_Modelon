within HESS;

model HESS_Fix_Charger
  parameter Real hysteresis = 0.001;

  .HESS.KETI_BatteryPack battery(redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller(contactors(external_control = true,contactors_closed = false)),limitActionSoC = Modelon.Types.FaultAction.Error,limitActionV = Modelon.Types.FaultAction.Error,display_name = true)
    annotation(Placement(transformation(extent = {{378.57,-108.44},{398.57,-88.44}},rotation = 0.0,origin = {0.0,0.0})));

  .HESS.KETI_SCapPack SuperCap(redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller(contactors(external_control = true,contactors_closed = false),redeclare replaceable .HESS.LimitsFixed_SCap limits),limitActionSoC = Modelon.Types.FaultAction.Warning,limitActionV = Modelon.Types.FaultAction.Warning,SOC_start = 0.2,display_name = true)
    annotation(Placement(transformation(extent = {{378.07,-62.94},{398.07,-42.94}},rotation = 0.0,origin = {0.0,0.0})));

    
  .Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-125.29,-102.76},{-105.29,-82.76}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Electrical.DCSensor dCSensor
    annotation(Placement(transformation(extent = {{336.3,-102.17},{356.3,-82.17}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.5 - hysteresis) annotation(Placement(transformation(extent = {{-51.29,-102.76},{-31.29,-82.76}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.5 + hysteresis) annotation(Placement(transformation(extent = {{-36.3,98.0},{-16.3,118.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-84.0,50.0},{-64.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.Transition transition(enableTimer = false,waitTime = 0.3) annotation(Placement(transformation(extent = {{-64.0,50.0},{-44.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepBattery(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{28.0,48.0},{48.0,68.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer = true,waitTime = 10) annotation(Placement(transformation(extent = {{-6.0,50.0},{14.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal2(enableTimer = true,waitTime = 0.1) annotation(Placement(transformation(extent = {{12.85,100.85},{-4.85,83.15}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{347.46,-63.4},{367.46,-43.4}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain2(k = 1 / battery.i_nom_1C) annotation(Placement(transformation(extent = {{-74.0,98.0},{-54.0,118.0}},rotation = 0.0,origin = {0.0,0.0})));
   // Charger
    .BatNSuperCap_legacy.BatteryChargerFixedLimits_CC_1 batteryChargerFixedLimits_CC_(pMax = 350000000,vMax = 1000,enable_control_bus = false,iMax = 300,redeclare replaceable .Electrification.Loads.Electrical.CapacitorAndDiode electrical,display_name = true) annotation(Placement(transformation(extent = {{-240.93,-85.9},{-260.93,-65.9}},origin = {0.0,0.0},rotation = 0.0)));
    
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{0.95,114.95},{7.05,121.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepCap(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-34.0,50.0},{-14.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less annotation(Placement(transformation(extent = {{-36.0,132.19},{-16.0,152.19}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits(aggregate = false) annotation(Placement(transformation(extent = {{178.0,104.0},{158.0,144.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = battery.id) annotation(Placement(transformation(extent = {{156.76,-163.51},{164.76,-155.51}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs(generateEvent = true) annotation(Placement(transformation(extent = {{-110.0,116.0},{-90.0,136.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold_SuperCap(threshold = 0.1 - hysteresis) annotation(Placement(transformation(extent = {{-52.0,-68.0},{-32.0,-48.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and2 annotation(Placement(transformation(extent = {{-18.34,-71.81},{-12.24,-65.71}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less2 annotation(Placement(transformation(extent = {{-18.81,-152.03},{1.19,-132.03}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits4Battery(vMaxSignal = false,vMax = 400) annotation(Placement(transformation(extent = {{182.2,-257.11},{162.2,-217.11}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and3 annotation(Placement(transformation(extent = {{22.75,-130.94},{28.85,-124.84}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors4SuperCap(id = SuperCap.id) annotation(Placement(transformation(extent = {{147.01,-39.41},{155.01,-31.41}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC CapDCDC(controller(external_limits = true,listen = true,id_listen = SuperCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_v_b = false,Ti_v = 0.1,v_b_ref = SuperCap.controller.limits.vMax),display_name = true,core(L = 1e-4),enable_thermal_port = false) annotation(Placement(transformation(extent = {{302.41,-63.59},{322.41,-43.59}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less_4Voltage annotation(Placement(transformation(extent = {{82.65,-273.5},{62.65,-253.5}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-3.67,-3.67},{3.67,3.67}},origin = {50.86,-229.31},rotation = 90.0)));
    parameter Real Bat_VoltageLimit = 200;
    .Electrification.Electrical.DCInit vInitB(v_start = battery.OCV_start,init_start = true) annotation(Placement(transformation(extent = {{320.19,-159.0},{332.19,-147.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCInit vInitB2(init_start = true,v_start = SuperCap.OCV_start) annotation(Placement(transformation(extent = {{340.0,-20.0},{352.0,-8.0}},rotation = 0.0,origin = {0.0,0.0})));

equation
  connect(dCSensor.plug_b,battery.plug_a)
    annotation(Line(points = {{356.3,-92.17},{378.57,-92.17},{378.57,-98.44}},color = {255,128,0}));
 
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-63.5,60},{-58,60}},color = {0,0,0}));
    connect(transition.outPort,stepCap.inPort[1]) annotation(Line(points = {{-52.5,60},{-35,60}},color = {0,0,0}));
    connect(getComponentLimits.componentBus,SuperCap.controlBus) annotation(Line(points = {{178,124},{186,124},{186,-42.94},{380.07,-42.94}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits.i_max_in,less.u2) annotation(Line(points = {{157,128},{-38,128},{-38,134.19}},color = {0,0,127}));
    connect(greaterEqualThreshold.u,gain2.y) annotation(Line(points = {{-38.3,108},{-53,108}},color = {0,0,127}));
    connect(abs.y,gain2.u) annotation(Line(points = {{-89,126},{-82.5,126},{-82.5,108},{-76,108}},color = {0,0,127}));
    connect(abs.y,less.u1) annotation(Line(points = {{-89,126},{-63.5,126},{-63.5,142.19},{-38,142.19}},color = {0,0,127}));
    connect(less.y,and1.u1) annotation(Line(points = {{-15,142.19},{-7.33,142.19},{-7.33,118},{0.34,118}},color = {255,0,255}));
    connect(greaterEqualThreshold.y,and1.u2) annotation(Line(points = {{-15.3,108},{-7.33,108},{-7.33,115.56},{0.34,115.56}},color = {255,0,255}));
    connect(gain.y,lessThreshold.u) annotation(Line(points = {{-104.29,-92.76},{-53.29,-92.76}},color = {0,0,127}));
    connect(dCSensor2.y[2],lessThreshold_SuperCap.u) annotation(Line(points = {{357.46,-62.4},{357.46,-78.85},{-59.29,-78.85},{-59.29,-58},{-54,-58}},color = {0,0,127}));
    connect(lessThreshold_SuperCap.y,and2.u1) annotation(Line(points = {{-31,-58},{-25.29,-58},{-25.29,-68.76},{-18.95,-68.76}},color = {255,0,255}));
    connect(lessThreshold.y,and2.u2) annotation(Line(points = {{-30.29,-92.76},{-18.95,-92.76},{-18.95,-71.2}},color = {255,0,255}));
    connect(battery.controlBus,getComponentLimits4Battery.componentBus) annotation(Line(points = {{380.57,-88.44},{380.57,-82.76},{228.62,-82.76},{228.62,-237.11},{182.2,-237.11}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits4Battery.i_max_in,less2.u2) annotation(Line(points = {{161.2,-233.11},{130.65,-233.11},{130.65,-164.1},{-38.53,-164.1},{-38.53,-150.03},{-20.81,-150.03}},color = {0,0,127}));
    connect(gain.y,less2.u1) annotation(Line(points = {{-104.29,-92.76},{-63.79,-92.76},{-63.79,-142.03},{-20.81,-142.03}},color = {0,0,127}));
    connect(less2.y,and3.u2) annotation(Line(points = {{2.19,-142.03},{22.14,-142.03},{22.14,-130.33}},color = {255,0,255}));
    connect(stepBattery.active,and3.u1) annotation(Line(points = {{38,47},{38,-127.89},{22.14,-127.89}},color = {255,0,255}));
    connect(and3.y,close_contactors.u_b) annotation(Line(points = {{29.16,-127.89},{38.07,-127.89},{38.07,-134.62},{42.5,-134.62},{42.5,-159.51},{154.76,-159.51}},color = {255,0,255}));
    connect(close_contactors4SuperCap.systemBus,SuperCap.controlBus) annotation(Line(points = {{155.01,-35.41},{380.07,-35.41},{380.07,-42.94}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(transitionWithSignal.outPort,stepBattery.inPort[1]) annotation(Line(points = {{5.5,60},{27,60},{27,58}},color = {0,0,0}));
    connect(stepCap.outPort[1],transitionWithSignal.inPort) annotation(Line(points = {{-13.5,60},{0,60}},color = {0,0,0}));
    connect(and2.y,transitionWithSignal.condition) annotation(Line(points = {{-11.93,-68.76},{4,-68.76},{4,48}},color = {255,0,255}));
    connect(transitionWithSignal2.outPort,stepCap.inPort[2]) annotation(Line(points = {{2.67,92},{-41,92},{-41,60},{-35,60}},color = {0,0,0}));
    connect(and1.y,transitionWithSignal2.condition) annotation(Line(points = {{7.36,118},{13.36,118},{13.36,106.85},{4,106.85},{4,102.62}},color = {255,0,255}));
    connect(close_contactors.systemBus,battery.controlBus) annotation(Line(points = {{164.76,-159.51},{192.32,-159.51},{192.32,-88.44},{380.57,-88.44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_b,SuperCap.plug_a) annotation(Line(points = {{367.46,-53.4},{378.07,-53.4},{378.07,-52.94}},color = {255,128,0}));
    connect(close_contactors4SuperCap.u_b,stepCap.active) annotation(Line(points = {{145.01,-35.41},{-24,-35.41},{-24,49}},color = {255,0,255}));
    connect(dCSensor2.plug_a,CapDCDC.plug_b) annotation(Line(points = {{347.46,-53.4},{322.41,-53.4},{322.41,-53.59}},color = {255,128,0}));
    connect(CapDCDC.plug_a,batteryChargerFixedLimits_CC_.plug_a) annotation(Line(points = {{302.41,-53.59},{-69.55,-53.59},{-69.55,-75.9},{-240.93,-75.9}},color = {255,128,0}));
    connect(SuperCap.controlBus,CapDCDC.controlBus) annotation(Line(points = {{380.07,-42.94},{380.07,-37.81},{304.41,-37.81},{304.41,-43.59}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.y[1],less_4Voltage.u1) annotation(Line(points = {{346.3,-101.17},{346.3,-263.5},{84.65,-263.5}},color = {0,0,127}));
    connect(getComponentLimits4Battery.v_max,less_4Voltage.u2) annotation(Line(points = {{161.2,-221.11},{99.06,-221.11},{99.06,-271.5},{84.65,-271.5}},color = {0,0,127}));
    connect(not1.u,less_4Voltage.y) annotation(Line(points = {{50.86,-233.72},{50.86,-263.5},{61.65,-263.5}},color = {255,0,255}));
    connect(vInitB2.plug_a,SuperCap.plug_a) annotation(Line(points = {{352,-14},{372.52,-14},{372.52,-52.94},{378.07,-52.94}},color = {255,128,0}));
    connect(dCSensor.y[2],abs.u) annotation(Line(points = {{346.3,-101.17},{346.3,-168.52},{-161.11,-168.52},{-161.11,126},{-112,126}},color = {0,0,127}));
    connect(dCSensor2.y[2],gain.u) annotation(Line(points = {{357.46,-62.4},{330.66,-62.4},{330.66,-142.32},{-133.29,-142.32},{-133.29,-92.76},{-127.29,-92.76}},color = {0,0,127}));
    connect(batteryChargerFixedLimits_CC_.plug_a,dCSensor.plug_a) annotation(Line(points = {{-240.93,-75.9},{53.28,-75.9},{53.28,-92.17},{336.3,-92.17}},color = {255,128,0}));
    connect(vInitB.plug_a,battery.plug_a) annotation(Line(points = {{332.19,-153},{355.3,-153},{355.3,-98.44},{378.57,-98.44}},color = {255,128,0}));
    connect(stepBattery.outPort[1],transitionWithSignal2.inPort) annotation(Line(points = {{48.5,58},{54.5,58},{54.5,92},{7.54,92}},color = {0,0,0}));

protected

annotation(
  uses(Modelica(version="4.0.0")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end HESS_Fix_Charger;
