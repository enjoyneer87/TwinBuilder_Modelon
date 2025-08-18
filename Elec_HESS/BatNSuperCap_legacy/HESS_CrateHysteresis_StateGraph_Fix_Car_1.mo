within BatNSuperCap_legacy;

model HESS_CrateHysteresis_StateGraph_Fix_Car_1
  parameter Real hysteresis = 0.001;

  .BatNSuperCap_legacy.BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,redeclare replaceable .BatNSuperCap_legacy.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(iMaxOut = 100,iMaxIn = 100,theoretical_limit = true,enable_thermal = false),contactors(preChargeOverlap = 0.1)),
    display_name = true,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Terminate,limitActionV = .Modelon.Types.FaultAction.Warning,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,core(iCellMaxDch = 50),SoC_max = 0.9)
    annotation(Placement(transformation(extent = {{380.0,-108.0},{400.0,-88.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-125.29,-102.76},{-105.29,-82.76}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Electrical.DCSensor dCSensor
    annotation(Placement(transformation(extent = {{347.48,-108.35},{367.48,-88.35}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.5 - hysteresis) annotation(Placement(transformation(extent = {{-51.29,-102.76},{-31.29,-82.76}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.5 + hysteresis) annotation(Placement(transformation(extent = {{-36.3,98.0},{-16.3,118.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-84.0,50.0},{-64.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.Transition transition(enableTimer = false,waitTime = 0.3) annotation(Placement(transformation(extent = {{-64.0,50.0},{-44.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepBattery(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{28.0,48.0},{48.0,68.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer = true,waitTime = 10) annotation(Placement(transformation(extent = {{-10.0,49.59},{10.0,69.59}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal2(enableTimer = true,waitTime = 0.1) annotation(Placement(transformation(extent = {{12.85,100.85},{-4.85,83.15}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{347.46,-63.4},{367.46,-43.4}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain2(k = 1 / battery.i_nom_1C) annotation(Placement(transformation(extent = {{-74.0,98.0},{-54.0,118.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.BatFromCar_ContactNLimit SuperCap(display_name = true,redeclare replaceable .BatNSuperCap_legacy.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(external_enable = true,iMaxOut = 200,iMaxIn = 200,theoretical_limit = true,enable_thermal = false),contactors(external_control = true,preChargeOverlap = 2)),SOC_start = 0.2,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,np = 60,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Terminate,limitActionV = .Modelon.Types.FaultAction.Warning,id = 1,core(iCellMaxDch = 200,iCellMaxCh = 200),SoC_max = 0.9) annotation(Placement(transformation(extent = {{382.0,-64.0},{402.0,-44.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{0.95,114.95},{7.05,121.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepCap(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-34.0,50.0},{-14.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less annotation(Placement(transformation(extent = {{-36.0,132.0},{-16.0,152.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits(aggregate = false) annotation(Placement(transformation(extent = {{178.0,104.0},{158.0,144.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = battery.id) annotation(Placement(transformation(extent = {{152.34,-156.33},{160.34,-148.33}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs(generateEvent = true) annotation(Placement(transformation(extent = {{-110.0,116.0},{-90.0,136.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs2(generateEvent = true) annotation(Placement(transformation(extent = {{-155.29,-102.76},{-135.29,-82.76}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold_SuperCap(threshold = 0.1 - hysteresis) annotation(Placement(transformation(extent = {{-50.0,-68.0},{-30.0,-48.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and2 annotation(Placement(transformation(extent = {{-18.34,-71.81},{-12.24,-65.71}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less2 annotation(Placement(transformation(extent = {{-21.29,-125.11},{-1.29,-105.11}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits4Battery(vMaxSignal = false,vMax = 400) annotation(Placement(transformation(extent = {{166.0,-208.0},{146.0,-168.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and3 annotation(Placement(transformation(extent = {{25.66,-63.81},{31.76,-57.71}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors4SuperCap(id = SuperCap.id) annotation(Placement(transformation(extent = {{147.01,-39.41},{155.01,-31.41}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC CapDCDC(controller(external_limits = true,listen = true,id_listen = SuperCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_v_b = false,v_b_ref = Bat_VoltageLimit,Ti_v = 0.1,mode = Electrification.Utilities.Types.ConverterMode.PowerA,external_pwr_b = false,pwr_b_ref = 50 * 1000,pwr_a_ref = 50 * 1000),display_name = true,core(L = 1e-4),enable_thermal_port = false) annotation(Placement(transformation(extent = {{301.83,-64.0},{321.83,-44.0}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC batteryDCDC(controller(external_limits = true,listen = true,id_listen = battery.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_v_b = false,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,external_mode = true,external_i_b = false,iMaxInB = 100,i_a_ref = -battery.i_nom_1C * (0.5 - hysteresis),v_a_ref = Bat_VoltageLimit,i_b_ref = 100,iMaxInA = 100,pMaxInA = 400 * 100,pMaxInB = 400 * 100,external_v_a = true),display_name = true,enable_thermal_port = false,electrical_a(v_start_fixed = false)) annotation(Placement(transformation(extent = {{322.2,-108.0},{302.2,-88.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(causality = .Electrification.Utilities.Types.Causality.Input,id = batteryDCDC.id) annotation(Placement(transformation(extent = {{21.01,-178.12},{29.01,-170.12}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less_4Voltage annotation(Placement(transformation(extent = {{-38.77,-196.83},{-18.77,-176.83}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal CV(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{72.68,47.36},{92.68,67.36}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal CVOn(waitTime = 0,enableTimer = true) annotation(Placement(transformation(extent = {{52.15,49.15},{69.85,66.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerTrue = 4,integerFalse = 2) annotation(Placement(transformation(extent = {{-1.74,-178.73},{7.48,-169.51}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-3.67,-3.67},{3.67,3.67}},origin = {54.870000000000005,-184.12},rotation = 90.0)));
    parameter Real Bat_VoltageLimit = 400;
    .Electrification.Converters.Control.Signals.v_a_ref v_a_ref annotation(Placement(transformation(extent = {{271.96,-116.94},{279.96,-108.94}},origin = {0,0},rotation = 0)));
    .Electrification.Electrical.DCInit vInitB(v_start = battery.OCV_start,init_start = true) annotation(Placement(transformation(extent = {{320.3,-159.0},{332.3,-147.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Examples.Applications.ElectricCar machine(enable_thermal_port = false,fixed_temperature = true,display_name = true,redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(torqueControl(external_torque = true),typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_limits = true,id_listen = battery.id,listen = true),initialize_speed = true,initialize_angle = true) annotation(Placement(transformation(extent = {{-281.3,-94.0},{-318.7,-62.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.SimpleChassis1D chassis(m = 1800,R = 0.35155,ideal_wheel = false,lambda = 0.561118,Rl = 0.335901,KX = 98300,d = 0.73196,A = 2.25,Cd = 0.339628,rho = 1,CrConstant = 0.00845431,initialize_velocity = true,initialize_position = true) annotation(Placement(transformation(extent = {{-383.41,-93.46},{-420.81,-61.46}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Control.Signals.tau_ref tau_ref(id = machine.id) annotation(Placement(transformation(extent = {{4.68,4.0},{-4.68,-4.0}},rotation = -180.0,origin = {-317.65,-27.76})));
    .Electrification.Utilities.Blocks.Driver driver(k = 1,Ti = 2,torque_output = false,redeclare replaceable .Electrification.Utilities.DriveCycles.NEDC driveCycle,repeat = true) annotation(Placement(transformation(extent = {{-413.35,-37.46},{-389.97,-17.46}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.IdealBrake brakes(enable_mount = false) annotation(Placement(transformation(extent = {{-345.48,-89.24},{-373.54,-65.24}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(number_of_motors_front = 0,number_of_motors_rear = 1,tauMax = machine.core.limits.tau_max_mot,regen_torque = 300,v_max = 270.777) annotation(Placement(transformation(extent = {{-371.41,-37.76},{-348.03,-17.76}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCInit vInitB2(init_start = true,v_start = SuperCap.OCV_start) annotation(Placement(transformation(extent = {{319.3,-14.46},{331.3,-2.46}},rotation = 0.0,origin = {0.0,0.0})));

equation
  connect(dCSensor.plug_b,battery.plug_a)
    annotation(Line(points = {{367.48,-98.35},{380,-98.35},{380,-98}},color = {255,128,0}));
 
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-63.5,60},{-58,60}},color = {0,0,0}));
    connect(transition.outPort,stepCap.inPort[1]) annotation(Line(points = {{-52.5,60},{-35,60}},color = {0,0,0}));
    connect(getComponentLimits.componentBus,SuperCap.controlBus) annotation(Line(points = {{178,124},{186,124},{186,-44},{384,-44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits.i_max_in,less.u2) annotation(Line(points = {{157,128},{-38,128},{-38,134}},color = {0,0,127}));
    connect(greaterEqualThreshold.u,gain2.y) annotation(Line(points = {{-38.3,108},{-53,108}},color = {0,0,127}));
    connect(dCSensor2.y[2],abs.u) annotation(Line(points = {{357.46,-62.4},{357.46,-68},{-118,-68},{-118,126},{-112,126}},color = {0,0,127}));
    connect(abs.y,gain2.u) annotation(Line(points = {{-89,126},{-82.5,126},{-82.5,108},{-76,108}},color = {0,0,127}));
    connect(abs.y,less.u1) annotation(Line(points = {{-89,126},{-63.5,126},{-63.5,142},{-38,142}},color = {0,0,127}));
    connect(less.y,and1.u1) annotation(Line(points = {{-15,142},{-7.33,142},{-7.33,118},{0.34,118}},color = {255,0,255}));
    connect(greaterEqualThreshold.y,and1.u2) annotation(Line(points = {{-15.3,108},{-7.33,108},{-7.33,115.56},{0.34,115.56}},color = {255,0,255}));
    connect(dCSensor.y[2],abs2.u) annotation(Line(points = {{357.48,-107.35},{357.48,-133.01},{-163.29,-133.01},{-163.29,-92.76},{-157.29,-92.76}},color = {0,0,127}));
    connect(abs2.y,gain.u) annotation(Line(points = {{-134.29,-92.76},{-127.29,-92.76}},color = {0,0,127}));
    connect(gain.y,lessThreshold.u) annotation(Line(points = {{-104.29,-92.76},{-53.29,-92.76}},color = {0,0,127}));
    connect(dCSensor2.y[2],lessThreshold_SuperCap.u) annotation(Line(points = {{357.46,-62.4},{357.46,-87.76},{-59.29,-87.76},{-59.29,-58},{-52,-58}},color = {0,0,127}));
    connect(lessThreshold_SuperCap.y,and2.u1) annotation(Line(points = {{-29,-58},{-25.29,-58},{-25.29,-68.76},{-18.95,-68.76}},color = {255,0,255}));
    connect(lessThreshold.y,and2.u2) annotation(Line(points = {{-30.29,-92.76},{-18.95,-92.76},{-18.95,-71.2}},color = {255,0,255}));
    connect(battery.controlBus,getComponentLimits4Battery.componentBus) annotation(Line(points = {{382,-88},{382,-82.76},{228.62,-82.76},{228.62,-188},{166,-188}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits4Battery.i_max_in,less2.u2) annotation(Line(points = {{145,-184},{88.74,-184},{88.74,-164.1},{-38.53,-164.1},{-38.53,-123.11},{-23.29,-123.11}},color = {0,0,127}));
    connect(gain.y,less2.u1) annotation(Line(points = {{-104.29,-92.76},{-63.79,-92.76},{-63.79,-115.11},{-23.29,-115.11}},color = {0,0,127}));
    connect(less2.y,and3.u2) annotation(Line(points = {{-0.29,-115.11},{5.71,-115.11},{5.71,-63.2},{25.05,-63.2}},color = {255,0,255}));
    connect(stepBattery.active,and3.u1) annotation(Line(points = {{38,47},{38,-60.76},{25.05,-60.76}},color = {255,0,255}));
    connect(and3.y,close_contactors.u_b) annotation(Line(points = {{32.07,-60.76},{38.07,-60.76},{38.07,-71.76},{26.71,-71.76},{26.71,-152.33},{150.34,-152.33}},color = {255,0,255}));
    connect(close_contactors4SuperCap.systemBus,SuperCap.controlBus) annotation(Line(points = {{155.01,-35.41},{384,-35.41},{384,-44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(transitionWithSignal.outPort,stepBattery.inPort[1]) annotation(Line(points = {{1.5,59.59},{27,59.59},{27,58}},color = {0,0,0}));
    connect(stepCap.outPort[1],transitionWithSignal.inPort) annotation(Line(points = {{-13.5,60},{-4,60},{-4,59.59}},color = {0,0,0}));
    connect(and2.y,transitionWithSignal.condition) annotation(Line(points = {{-11.93,-68.76},{0,-68.76},{0,47.59}},color = {255,0,255}));
    connect(transitionWithSignal2.outPort,stepCap.inPort[2]) annotation(Line(points = {{2.67,92},{-41,92},{-41,60},{-35,60}},color = {0,0,0}));
    connect(and1.y,transitionWithSignal2.condition) annotation(Line(points = {{7.36,118},{13.36,118},{13.36,106.85},{4,106.85},{4,102.62}},color = {255,0,255}));
    connect(close_contactors.systemBus,battery.controlBus) annotation(Line(points = {{160.34,-152.33},{192.32,-152.33},{192.32,-88},{382,-88}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_b,SuperCap.plug_a) annotation(Line(points = {{367.46,-53.4},{382,-53.4},{382,-54}},color = {255,128,0}));
    connect(close_contactors4SuperCap.u_b,stepCap.active) annotation(Line(points = {{145.01,-35.41},{-24,-35.41},{-24,49}},color = {255,0,255}));
    connect(batteryDCDC.controlBus,battery.controlBus) annotation(Line(points = {{320.2,-88},{320.2,-70.96},{382,-70.96},{382,-88}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(mode_ref.systemBus,batteryDCDC.controlBus) annotation(Line(points = {{29.01,-174.12},{34.87,-174.12},{34.87,-266},{320.2,-266},{320.2,-88}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_a,CapDCDC.plug_b) annotation(Line(points = {{347.46,-53.4},{347.46,-54},{321.83,-54}},color = {255,128,0}));
    connect(SuperCap.controlBus,CapDCDC.controlBus) annotation(Line(points = {{384,-44},{384,-37.81},{303.83,-37.81},{303.83,-44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.y[1],less_4Voltage.u1) annotation(Line(points = {{357.48,-107.35},{357.48,-202},{-47.29,-202},{-47.29,-186.83},{-40.77,-186.83}},color = {0,0,127}));
    connect(getComponentLimits4Battery.v_max,less_4Voltage.u2) annotation(Line(points = {{145,-172},{101.87,-172},{101.87,-210.12},{-47.13,-210.12},{-47.13,-194.83},{-40.77,-194.83}},color = {0,0,127}));
    connect(transitionWithSignal2.inPort,CV.outPort[1]) annotation(Line(points = {{7.54,92},{98.5,92},{98.5,57.36},{93.18,57.36}},color = {0,0,0}));
    connect(stepBattery.outPort[1],CVOn.inPort) annotation(Line(points = {{48.5,58},{57.46,58}},color = {0,0,0}));
    connect(CVOn.outPort,CV.inPort[1]) annotation(Line(points = {{62.33,58},{71.68,58},{71.68,57.36}},color = {0,0,0}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{7.94,-174.12},{19.01,-174.12}},color = {255,127,0}));
    connect(CV.active,booleanToInteger.u) annotation(Line(points = {{82.68,46.36},{82.68,-52.18},{-8.3,-52.18},{-8.3,-174.12},{-2.67,-174.12}},color = {255,0,255}));
    connect(not1.u,less_4Voltage.y) annotation(Line(points = {{54.87,-188.52},{-11.13,-188.52},{-11.13,-186.83},{-17.77,-186.83}},color = {255,0,255}));
    connect(not1.y,CVOn.condition) annotation(Line(points = {{54.87,-180.09},{54.87,-9.81},{61,-9.81},{61,47.38}},color = {255,0,255}));
    connect(batteryDCDC.plug_a,dCSensor.plug_a) annotation(Line(points = {{322.2,-98},{347.48,-98},{347.48,-98.35}},color = {255,128,0}));
    connect(v_a_ref.systemBus,batteryDCDC.controlBus) annotation(Line(points = {{279.96,-112.94},{285.96,-112.94},{285.96,-82.76},{320.2,-82.76},{320.2,-88}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.y[1],v_a_ref.u_r) annotation(Line(points = {{357.48,-107.35},{357.48,-122.94},{263.96,-122.94},{263.96,-112.94},{269.96,-112.94}},color = {0,0,127}));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{-402.11,-59.86},{-402.11,-38.46},{-401.67,-38.46}},color = {0,0,127}));
    connect(tau_ref.systemBus,machine.controlBus) annotation(Line(points = {{-312.97,-27.76},{-285.04,-27.76},{-285.04,-62}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(torqueArbitration.tau_brake_ref,brakes.u) annotation(Line(points = {{-346.87,-33.76},{-336.35,-33.76},{-336.35,-51.76},{-359.52,-51.76},{-359.52,-64.04}},color = {0,0,127}));
    connect(torqueArbitration.veh_vel_x,chassis.velocity) annotation(Line(points = {{-359.73,-39.76},{-359.73,-45.76},{-402.11,-45.76},{-402.11,-59.86}},color = {0,0,127}));
    connect(torqueArbitration.tau_ref_rear[1],tau_ref.u_r) annotation(Line(points = {{-346.87,-27.76},{-324.66,-27.76}},color = {0,0,127}));
    connect(machine.flange,chassis.flangeR) annotation(Line(points = {{-318.7,-78},{-318.7,-77.46},{-383.41,-77.46}},color = {0,0,0}));
    connect(brakes.flange_a,chassis.flangeR) annotation(Line(points = {{-359.52,-77.24},{-359.52,-77.46},{-383.41,-77.46}},color = {0,0,0}));
    connect(driver.acc_cmd,torqueArbitration.acc_cmd) annotation(Line(points = {{-388.81,-21.46},{-373.75,-21.46},{-373.75,-21.76}},color = {0,0,127}));
    connect(driver.brk_cmd,torqueArbitration.brk_cmd) annotation(Line(points = {{-388.81,-33.46},{-373.75,-33.46},{-373.75,-33.76}},color = {0,0,127}));
    connect(CapDCDC.plug_a,machine.plug_a) annotation(Line(points = {{301.83,-54},{10.44,-54},{10.44,-78},{-281.3,-78}},color = {255,128,0}));
    connect(batteryDCDC.plug_b,machine.plug_a) annotation(Line(points = {{302.2,-98},{10.38,-98},{10.38,-78},{-281.3,-78}},color = {255,128,0}));
    connect(battery.controlBus,machine.controlBus) annotation(Line(points = {{382,-88},{382,-56},{-285.04,-56},{-285.04,-62}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitB2.plug_a,SuperCap.plug_a) annotation(Line(points = {{331.3,-8.46},{368.39,-8.46},{368.39,-54},{382,-54}},color = {255,128,0}));
    connect(battery.plug_a,vInitB.plug_a) annotation(Line(points = {{380,-98},{356.15,-98},{356.15,-153},{332.3,-153}},color = {255,128,0}));

protected

annotation(
  uses(Modelica(version="4.0.0")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end HESS_CrateHysteresis_StateGraph_Fix_Car_1;
