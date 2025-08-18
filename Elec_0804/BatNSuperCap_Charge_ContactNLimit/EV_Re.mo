within BatNSuperCap_Charge_ContactNLimit;

model EV_Re

  parameter Real c_rate_threshold = 0.99;
  parameter Real hysteresis = 0.001;

  .BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit battery(
    enable_thermal_port = false,
    SOC_start = 0.2,redeclare replaceable .BatNSuperCap_Charge_ContactNLimit.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(iMaxOut = battery.i_nom_1C * 0.499,iMaxIn = battery.i_nom_1C * 0.499)),
    display_name = true,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical)
    annotation(Placement(transformation(extent = {{148.0,-22.0},{168.0,-2.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Gain gain(k = 1 / battery.i_nom_1C)
    annotation(Placement(transformation(extent = {{-110.0,-16.0},{-90.0,4.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Electrical.DCSensor dCSensor
    annotation(Placement(transformation(extent = {{94.0,-22.0},{114.0,-2.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.5) annotation(Placement(transformation(extent = {{-36.0,-16.0},{-16.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.5) annotation(Placement(transformation(extent = {{-36.0,98.0},{-16.0,118.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-84.0,50.0},{-64.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.Transition transition(enableTimer = false,waitTime = 0.3) annotation(Placement(transformation(extent = {{-64.0,50.0},{-44.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepBattery(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{24.0,56.0},{44.0,76.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer = true,waitTime = 1) annotation(Placement(transformation(extent = {{-10.0,50.0},{10.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal transitionWithSignal2(enableTimer = true,waitTime = 0.3) annotation(Placement(transformation(extent = {{12.85,100.85},{-4.85,83.15}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{128.0,24.0},{148.0,44.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain2(k = 1 / battery.i_nom_1C) annotation(Placement(transformation(extent = {{-74.0,98.0},{-54.0,118.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.BatFromCar_ContactNLimit SuperCap(display_name = true,redeclare replaceable .BatNSuperCap_Charge_ContactNLimit.BatLimitsAndContactors controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed limits(external_enable = true,iMaxOut = 200,iMaxIn = 200),contactors(external_control = true)),SOC_start = 0.2,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,np = 60,fixed_temperature = true,limitActionSoC = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,id = 1,core(iCellMaxDch = 200,iCellMaxCh = 200)) annotation(Placement(transformation(extent = {{158.0,24.0},{178.0,44.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{0.95,114.95},{7.05,121.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal stepCap(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-34.0,50.0},{-14.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less annotation(Placement(transformation(extent = {{-36.0,132.0},{-16.0,152.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits(aggregate = false) annotation(Placement(transformation(extent = {{170.0,128.0},{150.0,168.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = battery.id) annotation(Placement(transformation(extent = {{48.0,0.0},{56.0,8.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs(generateEvent = true) annotation(Placement(transformation(extent = {{-110.0,116.0},{-90.0,136.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Abs abs2(generateEvent = true) annotation(Placement(transformation(extent = {{-140.0,-16.0},{-120.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold2(threshold = 0.1 - 0.01) annotation(Placement(transformation(extent = {{-36.0,18.0},{-16.0,38.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and2 annotation(Placement(transformation(extent = {{-3.05,14.95},{3.05,21.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less less2 annotation(Placement(transformation(extent = {{-6.0,-38.0},{14.0,-18.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits2(vMaxSignal = false,vMax = 400) annotation(Placement(transformation(extent = {{148.0,-82.0},{128.0,-42.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and3 annotation(Placement(transformation(extent = {{40.95,22.95},{47.05,29.05}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors2(id = SuperCap.id) annotation(Placement(transformation(extent = {{70.0,38.0},{78.0,46.0}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC CapDCDC(controller(external_limits = true,listen = true,id_listen = SuperCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_v_b = false,v_b_ref = 400)) annotation(Placement(transformation(extent = {{100.0,24.0},{120.0,44.0}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC batteryDCDC(controller(external_limits = true,listen = true,id_listen = battery.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,v_b_ref = 400,external_v_b = false,mode = .Electrification.Utilities.Types.ConverterMode.CurrentB,i_b_ref = -battery.i_nom_1C * 0.499,external_mode = true,external_i_b = false,iMaxInB = 100,iMaxInA = 100,external_v_a = false,v_a_ref = 400),electrical_b(C = 0.5)) annotation(Placement(transformation(extent = {{44.0,-48.0},{64.0,-28.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(causality = .Electrification.Utilities.Types.Causality.Input,id = batteryDCDC.id) annotation(Placement(transformation(extent = {{40.0,-68.0},{48.0,-60.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Less Voltage_Limi_Less annotation(Placement(transformation(extent = {{-18,-90},{2,-70}},origin = {0,0},rotation = 0)));
    .Modelica.StateGraph.StepWithSignal CV(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{72.0,56.0},{92.0,76.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal CVOn(waitTime = 0.3,enableTimer = true) annotation(Placement(transformation(extent = {{51.15,57.15},{68.85,74.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerTrue = 5,integerFalse = 3) annotation(Placement(transformation(extent = {{17.39,-68.61},{26.61,-59.39}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-3.67,-3.67},{3.67,3.67}},origin = {74.0,-74.0},rotation = 90.0)));
    .Modelica.Blocks.Math.Abs abs3(generateEvent = true) annotation(Placement(transformation(extent = {{-66.0,-118.0},{-46.0,-98.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Control.Signals.tau_ref tau_ref(id = machine.id) annotation(Placement(transformation(extent = {{4.07,4.0},{-4.07,-4.0}},rotation = -180.0,origin = {-101.4,-79.0})));
    .Electrification.Utilities.Blocks.Driver driver(repeat = true,redeclare .Electrification.Utilities.DriveCycles.WLTP driveCycle,torque_output = false,Ti = 2,k = 1) annotation(Placement(transformation(extent = {{-182.17,-88.0},{-161.83,-68.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.IdealBrake brakes(enable_mount = false) annotation(Placement(transformation(extent = {{-125.8,-141.0},{-150.2,-117.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(tauMax = 500,number_of_motors_rear = 1,number_of_motors_front = 0) annotation(Placement(transformation(extent = {{-148.17,-88.0},{-127.83,-68.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.SimpleChassis1D chassis(CrConstant = 0.00845431,rho = 1,Cd = 0.339628,A = 2.25,d = 0.73196,KX = 98300,Rl = 0.335901,lambda = 0.561118,ideal_wheel = false,R = 0.35155,m = 1800) annotation(Placement(transformation(extent = {{-158.33,-145.0},{-190.87,-113.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Examples.Applications.ElectricCar machine(redeclare replaceable .Electrification.Machines.Control.MachineWithInverter controller(inverterControl(machineControl(external_torque = true,publish_sensors = false))),display_name = true,fixed_temperature = true,enable_thermal_port = false,redeclare replaceable .Electrification.Machines.Core.Examples.ACMachineWithInverter core(inverter(vDCNom = 400))) annotation(Placement(transformation(extent = {{-85.73,-144.0},{-118.27,-112.0}},rotation = 0.0,origin = {0.0,0.0})));

equation
  connect(dCSensor.plug_b,battery.plug_a)
    annotation(Line(points = {{114,-12},{148,-12}},color = {255,128,0}));
 
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-63.5,60},{-58,60}},color = {0,0,0}));
    connect(transition.outPort,stepCap.inPort[1]) annotation(Line(points = {{-52.5,60},{-35,60}},color = {0,0,0}));
    connect(getComponentLimits.i_max_in,less.u2) annotation(Line(points = {{149,152},{143,152},{143,128},{-38,128},{-38,134}},color = {0,0,127}));
    connect(greaterEqualThreshold.u,gain2.y) annotation(Line(points = {{-38,108},{-53,108}},color = {0,0,127}));
    connect(dCSensor2.y[2],abs.u) annotation(Line(points = {{138,25},{-118,25},{-118,126},{-112,126}},color = {0,0,127}));
    connect(abs.y,gain2.u) annotation(Line(points = {{-89,126},{-82.5,126},{-82.5,108},{-76,108}},color = {0,0,127}));
    connect(abs.y,less.u1) annotation(Line(points = {{-89,126},{-63.5,126},{-63.5,142},{-38,142}},color = {0,0,127}));
    connect(less.y,and1.u1) annotation(Line(points = {{-15,142},{-7.33,142},{-7.33,118},{0.34,118}},color = {255,0,255}));
    connect(greaterEqualThreshold.y,and1.u2) annotation(Line(points = {{-15,108},{-7.33,108},{-7.33,115.56},{0.34,115.56}},color = {255,0,255}));
    connect(dCSensor.y[2],abs2.u) annotation(Line(points = {{104,-21},{104,-46},{-148,-46},{-148,-6},{-142,-6}},color = {0,0,127}));
    connect(abs2.y,gain.u) annotation(Line(points = {{-119,-6},{-112,-6}},color = {0,0,127}));
    connect(gain.y,lessThreshold.u) annotation(Line(points = {{-89,-6},{-38,-6}},color = {0,0,127}));
    connect(dCSensor2.y[2],lessThreshold2.u) annotation(Line(points = {{138,25},{138,-1},{-44,-1},{-44,28},{-38,28}},color = {0,0,127}));
    connect(lessThreshold2.y,and2.u1) annotation(Line(points = {{-15,28},{-10,28},{-10,18},{-3.66,18}},color = {255,0,255}));
    connect(lessThreshold.y,and2.u2) annotation(Line(points = {{-15,-6},{-3.66,-6},{-3.66,15.56}},color = {255,0,255}));
    connect(battery.controlBus,getComponentLimits2.componentBus) annotation(Line(points = {{150,-2},{150,4},{136,4},{136,-62},{148,-62}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits2.i_max_in,less2.u2) annotation(Line(points = {{127,-58},{-8,-58},{-8,-36}},color = {0,0,127}));
    connect(gain.y,less2.u1) annotation(Line(points = {{-89,-6},{-48.5,-6},{-48.5,-28},{-8,-28}},color = {0,0,127}));
    connect(less2.y,and3.u2) annotation(Line(points = {{15,-28},{21,-28},{21,23.56},{40.34,23.56}},color = {255,0,255}));
    connect(stepBattery.active,and3.u1) annotation(Line(points = {{34,55},{34,26},{40.34,26}},color = {255,0,255}));
    connect(and3.y,close_contactors.u_b) annotation(Line(points = {{47.36,26},{53.36,26},{53.36,15},{42,15},{42,4},{46,4}},color = {255,0,255}));
    connect(transitionWithSignal.outPort,stepBattery.inPort[1]) annotation(Line(points = {{1.5,60},{23,60},{23,66}},color = {0,0,0}));
    connect(stepCap.outPort[1],transitionWithSignal.inPort) annotation(Line(points = {{-13.5,60},{-4,60}},color = {0,0,0}));
    connect(and2.y,transitionWithSignal.condition) annotation(Line(points = {{3.35,18},{9.35,18},{9.35,42},{0,42},{0,48}},color = {255,0,255}));
    connect(transitionWithSignal2.outPort,stepCap.inPort[2]) annotation(Line(points = {{2.67,92},{-41,92},{-41,60},{-35,60}},color = {0,0,0}));
    connect(and1.y,transitionWithSignal2.condition) annotation(Line(points = {{7.36,118},{13.36,118},{13.36,106.85},{4,106.85},{4,102.62}},color = {255,0,255}));
    connect(close_contactors.systemBus,battery.controlBus) annotation(Line(points = {{56,4},{150,4},{150,-2}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors2.u_b,stepCap.active) annotation(Line(points = {{68,42},{-24,42},{-24,49}},color = {255,0,255}));
    connect(batteryDCDC.plug_b,dCSensor.plug_a) annotation(Line(points = {{64,-38},{64,-12},{94,-12}},color = {255,128,0}));
    connect(batteryDCDC.controlBus,battery.controlBus) annotation(Line(points = {{46,-28},{46,4},{150,4},{150,-2}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(mode_ref.systemBus,batteryDCDC.controlBus) annotation(Line(points = {{48,-64},{80,-64},{80,-6},{46,-6},{46,-28}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_a,CapDCDC.plug_b) annotation(Line(points = {{128,34},{120,34}},color = {255,128,0}));
    connect(transitionWithSignal2.inPort,CV.outPort[1]) annotation(Line(points = {{7.54,92},{98.5,92},{98.5,66},{92.5,66}},color = {0,0,0}));
    connect(stepBattery.outPort[1],CVOn.inPort) annotation(Line(points = {{44.5,66},{56.46,66}},color = {0,0,0}));
    connect(CVOn.outPort,CV.inPort[1]) annotation(Line(points = {{61.33,66},{71,66}},color = {0,0,0}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{27.07,-64},{38,-64}},color = {255,127,0}));
    connect(CV.active,booleanToInteger.u) annotation(Line(points = {{82,55},{82,-52},{10,-52},{10,-64},{16.47,-64}},color = {255,0,255}));
    connect(not1.y,CVOn.condition) annotation(Line(points = {{74,-69.96},{74,-9.81},{60,-9.81},{60,55.38}},color = {255,0,255}));
    connect(getComponentLimits.componentBus,SuperCap.controlBus) annotation(Line(points = {{170,148},{186,148},{186,44},{160,44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors2.systemBus,SuperCap.controlBus) annotation(Line(points = {{78,42},{84,42},{84,52},{160,52},{160,44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor2.plug_b,SuperCap.plug_a) annotation(Line(points = {{148,34},{158,34}},color = {255,128,0}));
    connect(SuperCap.controlBus,CapDCDC.controlBus) annotation(Line(points = {{160,44},{160,50},{102,50},{102,44}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.y[1],abs3.u) annotation(Line(points = {{104,-21},{104,-144},{-68,-144},{-68,-108}},color = {0,0,127}));
    connect(getComponentLimits2.v_max,Voltage_Limi_Less.u2) annotation(Line(points = {{127,-46},{127,-50},{121,-50},{121,-100},{-28,-100},{-28,-88},{-20,-88}},color = {0,0,127}));
    connect(not1.u,Voltage_Limi_Less.y) annotation(Line(points = {{74,-78.4},{8,-78.4},{8,-80},{3,-80}},color = {255,0,255}));
    connect(abs3.y,Voltage_Limi_Less.u1) annotation(Line(points = {{-45,-108},{-32.5,-108},{-32.5,-80},{-20,-80}},color = {0,0,127}));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{-174.6,-111.4},{-174.6,-89},{-172,-89}},color = {0,0,127}));
    connect(tau_ref.systemBus,machine.controlBus) annotation(Line(points = {{-97.33,-79},{-76.99,-79},{-76.99,-112},{-88.98,-112}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(torqueArbitration.tau_brake_ref,brakes.u) annotation(Line(points = {{-126.81,-84},{-117.66,-84},{-117.66,-103},{-138,-103},{-138,-115.8}},color = {0,0,127}));
    connect(torqueArbitration.veh_vel_x,chassis.velocity) annotation(Line(points = {{-138,-90},{-138,-97},{-174.6,-97},{-174.6,-111.4}},color = {0,0,127}));
    connect(torqueArbitration.tau_ref_rear[1],tau_ref.u_r) annotation(Line(points = {{-126.81,-78},{-107.5,-78},{-107.5,-79}},color = {0,0,127}));
    connect(machine.flange,chassis.flangeR) annotation(Line(points = {{-118.27,-128},{-118.27,-129},{-158.34,-129}},color = {0,0,0}));
    connect(brakes.flange_a,chassis.flangeR) annotation(Line(points = {{-138,-129},{-158.34,-129}},color = {0,0,0}));
    connect(driver.acc_cmd,torqueArbitration.acc_cmd) annotation(Line(points = {{-160.81,-72},{-150.2,-72}},color = {0,0,127}));
    connect(driver.brk_cmd,torqueArbitration.brk_cmd) annotation(Line(points = {{-160.81,-84},{-150.2,-84}},color = {0,0,127}));
    connect(batteryDCDC.plug_a,machine.plug_a) annotation(Line(points = {{44,-38},{-20.56,-38},{-20.56,-128},{-85.73,-128}},color = {255,128,0}));
    connect(CapDCDC.plug_a,machine.plug_a) annotation(Line(points = {{100,34},{7.44,34},{7.44,-128},{-85.73,-128}},color = {255,128,0}));

protected

annotation(
  uses(Modelica(version="4.0.0")),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
         Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")
       })
);
end EV_Re;
