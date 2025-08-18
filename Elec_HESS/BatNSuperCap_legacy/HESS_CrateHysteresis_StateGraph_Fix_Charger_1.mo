within BatNSuperCap_legacy;

model HESS_CrateHysteresis_StateGraph_Fix_Charger_1
  parameter Real hysteresis = 0.001;

  .BatNSuperCap_legacy.BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,redeclare replaceable .BatNSuperCap_legacy.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(iMaxOut = 100,iMaxIn = 100),contactors(preChargeOverlap = 0.1)),
    display_name = true,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,core(iCellMaxDch = 50))
    annotation(Placement(transformation(extent = {{379.03,-108.44},{399.03,-88.44}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-125.29,-102.76},{-105.29,-82.76}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Electrical.DCSensor dCSensor
    annotation(Placement(transformation(extent = {{347.48,-109.4},{367.48,-89.4}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.5 - hysteresis) annotation(Placement(transformation(extent = {{-51.29,-102.76},{-31.29,-82.76}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.5 + hysteresis) annotation(Placement(transformation(extent = {{-33.96,122.54},{-13.96,142.54}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-84.0,50.0},{-64.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.Transition transition(enableTimer = false,waitTime = 0.3) annotation(Placement(transformation(extent = {{-64.0,50.0},{-44.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepBattery(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{28.0,48.0},{48.0,68.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer = true,waitTime = 10) annotation(Placement(transformation(extent = {{-10.0,49.59},{10.0,69.59}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal2(enableTimer = true,waitTime = 0.1) annotation(Placement(transformation(extent = {{19.16,101.32},{1.46,83.62}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{347.46,-63.4},{367.46,-43.4}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain2(k = 1 / battery.i_nom_1C) annotation(Placement(transformation(extent = {{-71.66,122.54},{-51.66,142.54}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.BatteryChargerFixedLimits_CC_1 batteryChargerFixedLimits_CC_(pMax = 350000000,vMax = 1000,enable_control_bus = false,iMax = 300,redeclare replaceable .Electrification.Loads.Electrical.CapacitorAndDiode electrical,display_name = true) annotation(Placement(transformation(extent = {{-240.93,-86.41},{-260.93,-66.41}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.BatFromCar_ContactNLimit SuperCap(display_name = true,redeclare replaceable .BatNSuperCap_legacy.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(external_enable = true,iMaxOut = 200,iMaxIn = 200),contactors(external_control = true,preChargeOverlap = 2)),SOC_start = 0.2,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,np = 60,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,id = 1,core(iCellMaxDch = 200,iCellMaxCh = 200)) annotation(Placement(transformation(extent = {{377.46,-63.4},{397.46,-43.4}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{3.29,139.49},{9.39,145.59}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepCap(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-33.78,50.0},{-13.78,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less annotation(Placement(transformation(extent = {{-33.66,156.73},{-13.66,176.73}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits(aggregate = false) annotation(Placement(transformation(extent = {{54.16,130.88},{34.16,170.88}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = battery.id) annotation(Placement(transformation(extent = {{156.76,-163.51},{164.76,-155.51}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs(generateEvent = true) annotation(Placement(transformation(extent = {{-107.66,140.54},{-87.66,160.54}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs2(generateEvent = true) annotation(Placement(transformation(extent = {{-154.95,-102.76},{-134.95,-82.76}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold_SuperCap(threshold = 0.1 - hysteresis) annotation(Placement(transformation(extent = {{-52.0,-68.0},{-32.0,-48.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and2 annotation(Placement(transformation(extent = {{-18.34,-71.81},{-12.24,-65.71}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less2 annotation(Placement(transformation(extent = {{-18.81,-152.03},{1.19,-132.03}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits4Battery(vMaxSignal = false,vMax = 400) annotation(Placement(transformation(extent = {{113.76,-256.77},{133.76,-216.77}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and3 annotation(Placement(transformation(extent = {{12.55,-147.58},{18.65,-141.48}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors4SuperCap(id = SuperCap.id) annotation(Placement(transformation(extent = {{147.01,-39.41},{155.01,-31.41}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC CapDCDC(controller(external_limits = true,listen = true,id_listen = SuperCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_v_b = false,v_b_ref = Bat_VoltageLimit,Ti_v = 0.1),display_name = true,core(L = 1e-4),enable_thermal_port = false) annotation(Placement(transformation(extent = {{302.35,-63.63},{322.35,-43.63}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC batteryDCDC(controller(external_limits = true,listen = true,id_listen = battery.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_v_b = false,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,external_mode = true,external_i_b = false,iMaxInB = 100,i_a_ref = -battery.i_nom_1C * (0.5 - hysteresis),v_a_ref = Bat_VoltageLimit,i_b_ref = 100,iMaxInA = 100,pMaxInA = 400 * 100,pMaxInB = 400 * 100,external_v_a = true),display_name = true,enable_thermal_port = false,electrical_a(v_start_fixed = false)) annotation(Placement(transformation(extent = {{322.23,-108.62},{302.23,-88.62}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(causality = .Electrification.Utilities.Types.Causality.Input,id = batteryDCDC.id) annotation(Placement(transformation(extent = {{44.26,-174.12},{52.26,-166.12}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal CV(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{73.0,48.41},{93.0,68.41}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal CVOn(waitTime = 0,enableTimer = true) annotation(Placement(transformation(extent = {{52.15,49.15},{69.85,66.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerTrue = 4,integerFalse = 2) annotation(Placement(transformation(extent = {{2.81,-175.39},{12.03,-166.17}},origin = {0.0,0.0},rotation = 0.0)));
    parameter Real Bat_VoltageLimit = 400;
    .Electrification.Converters.Control.Signals.v_a_ref v_a_ref annotation(Placement(transformation(extent = {{271.96,-116.94},{279.96,-108.94}},origin = {0,0},rotation = 0)));
    .Electrification.Electrical.DCInit vInitB(v_start = battery.summary.ocv,init_start = true) annotation(Placement(transformation(extent = {{319.77,-159.0},{331.77,-147.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.Greater greater annotation(Placement(transformation(extent = {{195.15,-271.66},{215.15,-251.66}},origin = {0.0,0.0},rotation = 0.0)));

equation
  connect(dCSensor.plug_b,battery.plug_a)
    annotation(Line(points = {{367.48,-99.4},{379.03,-99.4},{379.03,-98.44}},color = {255,128,0}));
 
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-63.5,60},{-58,60}},color = {0,0,0}));
    connect(transition.outPort,stepCap.inPort[1]) annotation(Line(points = {{-52.5,60},{-34.78,60}},color = {0,0,0}));
    connect(getComponentLimits.componentBus,SuperCap.controlBus) annotation(Line(points = {{54.16,150.88},{186,150.88},{186,-43.4},{379.46,-43.4}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits.i_max_in,less.u2) annotation(Line(points = {{33.16,154.88},{-42.44,154.88},{-42.44,158.73},{-35.66,158.73}},color = {0,0,127}));
    connect(greaterEqualThreshold.u,gain2.y) annotation(Line(points = {{-35.96,132.54},{-50.66,132.54}},color = {0,0,127}));
    connect(dCSensor2.y[2],abs.u) annotation(Line(points = {{357.46,-62.4},{357.46,-68},{-118,-68},{-118,150.54},{-109.66,150.54}},color = {0,0,127}));
    connect(abs.y,gain2.u) annotation(Line(points = {{-86.66,150.54},{-80.16,150.54},{-80.16,132.54},{-73.66,132.54}},color = {0,0,127}));
    connect(abs.y,less.u1) annotation(Line(points = {{-86.66,150.54},{-61.16,150.54},{-61.16,166.73},{-35.66,166.73}},color = {0,0,127}));
    connect(less.y,and1.u1) annotation(Line(points = {{-12.66,166.73},{-4.99,166.73},{-4.99,142.54},{2.68,142.54}},color = {255,0,255}));
    connect(greaterEqualThreshold.y,and1.u2) annotation(Line(points = {{-12.96,132.54},{-4.99,132.54},{-4.99,140.1},{2.68,140.1}},color = {255,0,255}));
    connect(dCSensor.y[2],abs2.u) annotation(Line(points = {{357.48,-108.4},{357.48,-132.45},{-163.29,-132.45},{-163.29,-92.76},{-156.95,-92.76}},color = {0,0,127}));
    connect(abs2.y,gain.u) annotation(Line(points = {{-133.95,-92.76},{-127.29,-92.76}},color = {0,0,127}));
    connect(gain.y,lessThreshold.u) annotation(Line(points = {{-104.29,-92.76},{-53.29,-92.76}},color = {0,0,127}));
    connect(dCSensor2.y[2],lessThreshold_SuperCap.u) annotation(Line(points = {{357.46,-62.4},{357.46,-78.85},{-59.29,-78.85},{-59.29,-58},{-54,-58}},color = {0,0,127}));
    connect(lessThreshold_SuperCap.y,and2.u1) annotation(Line(points = {{-31,-58},{-25.29,-58},{-25.29,-68.76},{-18.95,-68.76}},color = {255,0,255}));
    connect(lessThreshold.y,and2.u2) annotation(Line(points = {{-30.29,-92.76},{-18.95,-92.76},{-18.95,-71.2}},color = {255,0,255}));
    connect(battery.controlBus,getComponentLimits4Battery.componentBus) annotation(Line(points = {{381.03,-88.44},{381.03,-82.44},{156.2,-82.44},{156.2,-236.77},{113.76,-236.77}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits4Battery.i_max_in,less2.u2) annotation(Line(points = {{134.76,-232.77},{189.2,-232.77},{189.2,-156.03},{-20.81,-156.03},{-20.81,-150.03}},color = {0,0,127}));
    connect(gain.y,less2.u1) annotation(Line(points = {{-104.29,-92.76},{-63.79,-92.76},{-63.79,-142.03},{-20.81,-142.03}},color = {0,0,127}));
    connect(less2.y,and3.u2) annotation(Line(points = {{2.19,-142.03},{11.94,-142.03},{11.94,-146.97}},color = {255,0,255}));
    connect(stepBattery.active,and3.u1) annotation(Line(points = {{38,47},{38,-144.53},{11.94,-144.53}},color = {255,0,255}));
    connect(and3.y,close_contactors.u_b) annotation(Line(points = {{18.96,-144.53},{38.07,-144.53},{38.07,-134.62},{42.5,-134.62},{42.5,-159.51},{154.76,-159.51}},color = {255,0,255}));
    connect(close_contactors4SuperCap.systemBus,SuperCap.controlBus) annotation(Line(points = {{155.01,-35.41},{379.46,-35.41},{379.46,-43.4}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(transitionWithSignal.outPort,stepBattery.inPort[1]) annotation(Line(points = {{1.5,59.59},{27,59.59},{27,58}},color = {0,0,0}));
    connect(stepCap.outPort[1],transitionWithSignal.inPort) annotation(Line(points = {{-13.28,60},{-4,60},{-4,59.59}},color = {0,0,0}));
    connect(and2.y,transitionWithSignal.condition) annotation(Line(points = {{-11.93,-68.76},{0,-68.76},{0,47.59}},color = {255,0,255}));
    connect(transitionWithSignal2.outPort,stepCap.inPort[2]) annotation(Line(points = {{8.98,92.47},{-41,92.47},{-41,60},{-34.78,60}},color = {0,0,0}));
    connect(and1.y,transitionWithSignal2.condition) annotation(Line(points = {{9.7,142.54},{18.27,142.54},{18.27,103.09},{10.31,103.09}},color = {255,0,255}));
    connect(close_contactors.systemBus,battery.controlBus) annotation(Line(points = {{164.76,-159.51},{192.32,-159.51},{192.32,-88.44},{381.03,-88.44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_b,SuperCap.plug_a) annotation(Line(points = {{367.46,-53.4},{377.46,-53.4}},color = {255,128,0}));
    connect(close_contactors4SuperCap.u_b,stepCap.active) annotation(Line(points = {{145.01,-35.41},{-23.78,-35.41},{-23.78,49}},color = {255,0,255}));
    connect(batteryDCDC.controlBus,battery.controlBus) annotation(Line(points = {{320.23,-88.62},{320.23,-70.96},{381.03,-70.96},{381.03,-88.44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(mode_ref.systemBus,batteryDCDC.controlBus) annotation(Line(points = {{52.26,-170.12},{52.26,-82.67},{320.23,-82.67},{320.23,-88.62}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_a,CapDCDC.plug_b) annotation(Line(points = {{347.46,-53.4},{347.46,-53.63},{322.35,-53.63}},color = {255,128,0}));
    connect(CapDCDC.plug_a,batteryChargerFixedLimits_CC_.plug_a) annotation(Line(points = {{302.35,-53.63},{-69.55,-53.63},{-69.55,-76.41},{-240.93,-76.41}},color = {255,128,0}));
    connect(SuperCap.controlBus,CapDCDC.controlBus) annotation(Line(points = {{379.46,-43.4},{379.46,-37.81},{304.35,-37.81},{304.35,-43.63}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(transitionWithSignal2.inPort,CV.outPort[1]) annotation(Line(points = {{13.85,92.47},{98.5,92.47},{98.5,58.41},{93.5,58.41}},color = {0,0,0}));
    connect(stepBattery.outPort[1],CVOn.inPort) annotation(Line(points = {{48.5,58},{57.46,58}},color = {0,0,0}));
    connect(CVOn.outPort,CV.inPort[1]) annotation(Line(points = {{62.33,58},{72,58},{72,58.41}},color = {0,0,0}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{12.49,-170.78},{42.26,-170.78},{42.26,-170.12}},color = {255,127,0}));
    connect(CV.active,booleanToInteger.u) annotation(Line(points = {{83,47.41},{83,-112.92},{-8.3,-112.92},{-8.3,-170.78},{1.89,-170.78}},color = {255,0,255}));
    connect(batteryDCDC.plug_a,dCSensor.plug_a) annotation(Line(points = {{322.23,-98.62},{347.48,-98.62},{347.48,-99.4}},color = {255,128,0}));
    connect(batteryChargerFixedLimits_CC_.plug_a,batteryDCDC.plug_b) annotation(Line(points = {{-240.93,-76.41},{30.91,-76.41},{30.91,-98.62},{302.23,-98.62}},color = {255,128,0}));
    connect(v_a_ref.systemBus,batteryDCDC.controlBus) annotation(Line(points = {{279.96,-112.94},{285.96,-112.94},{285.96,-82.76},{320.23,-82.76},{320.23,-88.62}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.y[1],v_a_ref.u_r) annotation(Line(points = {{357.48,-108.4},{357.48,-122.94},{263.96,-122.94},{263.96,-112.94},{269.96,-112.94}},color = {0,0,127}));
    connect(vInitB.plug_a,batteryDCDC.plug_a) annotation(Line(points = {{331.77,-153},{337.77,-153},{337.77,-98.62},{322.23,-98.62}},color = {255,128,0}));
    connect(dCSensor.y[1],greater.u1) annotation(Line(points = {{357.48,-108.4},{357.48,-245.54},{170.83,-245.54},{170.83,-261.66},{193.15,-261.66}},color = {0,0,127}));
    connect(getComponentLimits4Battery.v_max,greater.u2) annotation(Line(points = {{134.76,-220.77},{165.16,-220.77},{165.16,-269.66},{193.15,-269.66}},color = {0,0,127}));
    connect(greater.y,CVOn.condition) annotation(Line(points = {{216.15,-261.66},{222.15,-261.66},{222.15,41.38},{61,41.38},{61,47.38}},color = {255,0,255}));

protected

annotation(
  uses(Modelica(version="4.0.0")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end HESS_CrateHysteresis_StateGraph_Fix_Charger_1;
