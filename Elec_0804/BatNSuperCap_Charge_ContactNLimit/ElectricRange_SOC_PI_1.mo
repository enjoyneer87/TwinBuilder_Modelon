within BatNSuperCap_Charge_ContactNLimit;

model ElectricRange_SOC_PI_1 "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;

  .Electrification.Machines.Examples.Applications.ElectricCar machine(
    enable_thermal_port=false,
    fixed_temperature=true,
    display_name=true,
    redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(
      external_limits=true,
      listen=true,
      id_listen=averageStepUpDownDCDC.id,
      typeListen=.Electrification.Utilities.Types.ControllerType.Converter,
      torqueControl(external_torque=true)),initialize_speed = true,initialize_angle = true) annotation (
        Placement(transformation(extent={{41.35,-16.41},{73.35,15.59}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.SimpleChassis1D chassis(
    m=1800,
    R=0.35155,
    ideal_wheel=false,
    lambda=0.561118,
    Rl=0.335901,
    KX=98300,
    d=0.73196,
    A=2.25,
    Cd=0.339628,
    rho=1,
    CrConstant=0.00845431,initialize_velocity = true,initialize_position = true)
    annotation (Placement(transformation(extent={{128.16,-16.42},{160.16,15.58}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Machines.Control.Signals.tau_ref tau_ref(id=machine.id)
    annotation (Placement(transformation(
        extent={{-4.0,4.0},{4.0,-4.0}},
        rotation=180.0,
        origin={72.28,49.58})));
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-153.24,-65.02},{-133.24,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.Driver driver(
    k=1,
    Ti=2,
    torque_output=false,redeclare replaceable .Electrification.Utilities.DriveCycles.AccelerateDecelerate driveCycle,
    repeat=true)
    annotation (Placement(transformation(extent={{154.46,39.58},{134.46,59.58}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.IdealBrake brakes(enable_mount=false) annotation (Placement(transformation(extent={{96.1,-11.73},{120.1,12.27}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(
    number_of_motors_front=0,
    number_of_motors_rear=1,
    tauMax=machine.core.limits.tau_max_mot,regen_torque = 300,v_max = 270.777)
    annotation (Placement(transformation(extent={{118.28,39.58},{98.28,59.58}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,i_a_ref = -SCap.i_nom_1C,external_limits = false,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = false,iMaxInB = 500,external_i_a = true,i_b_ref = -SCap.i_nom_1C,iMaxInA = 300,pMaxInA = 1e16,pMaxInB = 1e16,external_pwr_b = false,external_pwr_a = true),common_mode = false,internal_ground = false) annotation(Placement(transformation(extent = {{-93.6,-10.0},{-113.6,10.0}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{41.91,309.9},{61.91,329.9}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-103.52,311.39},{-83.52,331.39}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.1,enableTimer = true) annotation(Placement(transformation(extent = {{-59.42,311.49},{-39.42,331.49}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-49.84,152.99})));
    .Modelica.Blocks.Math.Gain convCrate(k = batty.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-49.68,194.32})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = false,uHigh = 0.5,uLow = 0.35) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-49.46,251.77999999999997})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-93.39,182.98})));
    .Electrification.Batteries.Control.Signals.i_cell i_cell(id = batty.id) annotation(Placement(transformation(extent = {{-10.27,-10.27},{10.27,10.27}},origin = {-49.82,80.85},rotation = -90.0)));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-108.43,-159.48},{-88.43,-139.48}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-128.63,74.82},{-120.63,82.82}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentA),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerA)) annotation(Placement(transformation(extent = {{-175.84,68.99},{-155.84,88.99}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-199.94,97.09},rotation = -90.0)));
    .Modelica.Blocks.Math.BooleanToReal OnSC(realTrue = -200 * SCap.i_nom_1C,realFalse = 0) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-149.62,144.67},rotation = -90.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 180,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionSoC = .Modelon.Types.FaultAction.Error,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.ContactorControl controller1(contactors_closed = true,external_control = true,enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6)) annotation(Placement(transformation(extent = {{-84.14,-116.27},{-116.14,-84.27}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = -0.1,uHigh = 0,pre_y_start = false) annotation(Placement(transformation(extent = {{79.86,69.58},{59.86,89.58}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-19.13,311.51},{0.87,331.51}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 5) annotation(Placement(transformation(extent = {{-86.07,362.1},{-66.07,382.1}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Control.Signals.i_cell i_cellSC(id = SCap.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-277.38,134.39},rotation = -90.0)));
    .Modelica.Blocks.Math.Gain convCrate3(k = 20 * SCap.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-274.96,228.39})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-277.45,188.44})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0.01,uHigh = 0.5,pre_y_start = false) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-274.96,260.39})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-255.93,274.42},{-235.93,294.42}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.SCCap SCap(initialize_with_OCV = true,redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIsolated electrical,OCV_start = 600) annotation(Placement(transformation(extent = {{-137.64,-18.36},{-174.36,18.36}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc(id = SCap.id) annotation(Placement(transformation(extent = {{-343.57,42.85},{-335.57,50.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.pwr_a_ref pwr_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{4.0,4.0},{-4.0,-4.0}},rotation = 180.0,origin = {-339.57,16.85})));
    .Modelica.Blocks.Math.Feedback feedback annotation(Placement(transformation(extent = {{-493.83,32.81},{-473.83,12.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.Constant targetSOC(k = 0.8) annotation(Placement(transformation(extent = {{-519.57,12.85},{-499.57,32.85}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Nonlinear.Limiter limiter(strict = true,uMax = machine.core.limits.P_max_mot,uMin = -machine.core.limits.P_max_mot) annotation(Placement(transformation(extent = {{-403.51,7.13},{-383.51,27.13}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Control.Signals.pwr_sns pwr_sns(id = machine.id) annotation(Placement(transformation(extent = {{4.0,4.0},{-4.0,-4.0}},origin = {-339.83,-13.190000000000001},rotation = 180.0)));
    .Modelica.Blocks.Math.Add add annotation(Placement(transformation(extent = {{-433.83,6.81},{-413.83,26.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Continuous.Filter filter(f_cut = 0.05) annotation(Placement(transformation(extent = {{-373.83,6.81},{-353.83,26.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain(k = 1e4) annotation(Placement(transformation(extent = {{-465.83,12.81},{-445.83,32.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.i_a_ref i_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-120.46,46.11},{-112.46,54.11}},origin = {0.0,0.0},rotation = 0.0)));
equation
  connect(chassis.velocity, driver.speed_m)
    annotation (Line(points={{144.16,17.18},{144.16,38.58},{144.46,38.58}},   color={0,0,127}));
  connect(tau_ref.systemBus, machine.controlBus) annotation (Line(
      points={{68.28,49.58},{44.55,49.58},{44.55,15.59}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueArbitration.tau_brake_ref, brakes.u)
    annotation (Line(points={{97.28,43.58},{88.28,43.58},{88.28,25.58},{108.1,25.58},{108.1,13.47}}, color={0,0,127}));
  connect(torqueArbitration.veh_vel_x, chassis.velocity) annotation (
    Line(points={{108.28,37.58},{108.28,31.58},{144.16,31.58},{144.16,17.18}}, color={0,0,127}));
  connect(torqueArbitration.tau_ref_rear[1], tau_ref.u_r) annotation (Line(points={{97.28,49.58},{78.28,49.58}}, color={0,0,127}));
  connect(machine.flange, chassis.flangeR) annotation (Line(points={{73.35,-0.41},{73.35,-0.42},{128.16,-0.42}}, color={0,0,0}));
  connect(brakes.flange_a, chassis.flangeR) annotation (Line(points={{108.1,0.27},{108.1,-0.42},{128.16,-0.42}}, color={0,0,0}));
  connect(driver.acc_cmd, torqueArbitration.acc_cmd) annotation (Line(points={{133.46,55.58},{120.28,55.58}}, color={0,0,127}));
  connect(driver.brk_cmd, torqueArbitration.brk_cmd) annotation (Line(points={{133.46,43.58},{120.28,43.58}}, color={0,0,127}));
    connect(machine.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{44.55,15.59},{-95.6,15.59},{-95.6,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{41.35,-0.41},{-93.6,-0.41},{-93.6,0}},color = {255,128,0}));
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-49.84,163.99},{-49.84,182.32},{-49.68,182.32}},color = {0,0,127}));
    connect(hysteresis2.y,HighCurrent.condition) annotation(Line(points = {{-49.46,262.78},{-49.46,291.47},{-49.42,291.47},{-49.42,309.49}},color = {255,0,255}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-49.68,205.32},{-49.68,227.9},{-49.46,227.9},{-49.46,239.78}},color = {0,0,127}));
    connect(i_cell.y_r,absI.u) annotation(Line(points = {{-49.82,93.69},{-49.82,124.38},{-49.84,124.38},{-49.84,140.99}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-93.52,310.39},{-93.52,212.14},{-93.39,212.14},{-93.39,195.36}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-83.02,321.39},{-69.43,321.39},{-69.43,321.49},{-53.42,321.49}},color = {0,0,0}));
    connect(transition.outPort,Bat.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-104.52,321.07},{-104.52,321.39}},color = {0,0,0}));
    connect(and1.y,booleanToInteger.u) annotation(Line(points = {{-199.94,86.09},{-199.94,78.99},{-177.84,78.99}},color = {255,0,255}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-154.84,78.99},{-130.63,78.99},{-130.63,78.82}},color = {255,127,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-120.63,78.82},{-95.6,78.82},{-95.6,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-88.43,-149.48},{-48.33,-149.48},{-48.33,-100.27},{-84.14,-100.27}},color = {255,128,0}));
    connect(i_cell.systemBus,batty.controlBus) annotation(Line(points = {{-49.82,70.58},{-49.82,-1.08},{-87.34,-1.08},{-87.34,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-93.39,174.73},{-93.39,-84.27},{-87.34,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,batty.plug_a) annotation(Line(points = {{41.35,-0.41},{41.35,-22.57},{-49.15,-22.57},{-49.15,-100.27},{-84.14,-100.27}},color = {255,128,0}));
    connect(hysteresis2.y,OnSC.u) annotation(Line(points = {{-49.46,262.78},{-49.46,273.06},{-149.62,273.06},{-149.62,156.67}},color = {255,0,255}));
    connect(hysteresis.y,and1.u1) annotation(Line(points = {{58.86,79.58},{-31.43,79.58},{-31.43,121.65},{-199.94,121.65},{-199.94,109.09}},color = {255,0,255}));
    connect(torqueArbitration.tau_ref_rear[1],hysteresis.u) annotation(Line(points = {{97.28,49.58},{89.73,49.58},{89.73,79.58},{81.86,79.58}},color = {0,0,127}));
    connect(SCon.active,and1.u2) annotation(Line(points = {{-9.13,310.51},{-9.13,295.64},{-218,295.64},{-218,109.09},{-207.94,109.09}},color = {255,0,255}));
    connect(HighCurrent.outPort,SCon.inPort[1]) annotation(Line(points = {{-47.92,321.49},{-32.4,321.49},{-32.4,321.51},{-20.13,321.51}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{1.37,321.51},{14.82,321.51},{14.82,372.1},{-80.07,372.1}},color = {0,0,0}));
    connect(lowCurrentSCap.outPort,initialStep.inPort[1]) annotation(Line(points = {{-74.57,372.1},{-162.66,372.1},{-162.66,321.07},{-157.66,321.07}},color = {0,0,0}));
    connect(i_cellSC.y_r,absI2.u) annotation(Line(points = {{-277.38,155.9},{-277.38,166.37},{-277.45,166.37},{-277.45,176.44}},color = {0,0,127}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-274.96,216.39},{-274.96,207.36},{-277.45,207.36},{-277.45,199.44}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate3.y) annotation(Line(points = {{-274.96,248.39},{-274.96,239.39}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-274.96,271.39},{-274.96,284.42},{-257.93,284.42}},color = {255,0,255}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-234.93,284.42},{-76.07,284.42},{-76.07,360.1}},color = {255,0,255}));
    connect(SCap.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-137.64,0},{-113.6,0}},color = {255,128,0}));
    connect(vInitA.plug_a,SCap.plug_a) annotation(Line(points = {{-133.24,-55.02},{-127.24,-55.02},{-127.24,0},{-137.64,0}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-95.6,10},{-95.6,18.36},{-141.31,18.36}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCap.controlBus,i_cellSC.systemBus) annotation(Line(points = {{-141.31,18.36},{-141.31,4},{-277.38,4},{-277.38,117.18}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(targetSOC.y,feedback.u1) annotation(Line(points = {{-498.57,22.85},{-498.57,22.81},{-491.83,22.81}},color = {0,0,127}));
    connect(feedback.u2,soc.y_r) annotation(Line(points = {{-483.83,30.81},{-483.83,46.85},{-344.57,46.85}},color = {0,0,127}));
    connect(add.y,limiter.u) annotation(Line(points = {{-412.83,16.81},{-412.83,17.13},{-405.51,17.13}},color = {0,0,127}));
    connect(gain.y,add.u1) annotation(Line(points = {{-444.83,22.81},{-435.83,22.81}},color = {0,0,127}));
    connect(gain.u,feedback.y) annotation(Line(points = {{-467.83,22.81},{-474.83,22.81}},color = {0,0,127}));
    connect(filter.y,pwr_a_ref.u_r) annotation(Line(points = {{-352.83,16.81},{-345.57,16.81},{-345.57,16.85}},color = {0,0,127}));
    connect(filter.u,limiter.y) annotation(Line(points = {{-375.83,16.81},{-382.51,16.81},{-382.51,17.13}},color = {0,0,127}));
    connect(add.u2,pwr_sns.y_r) annotation(Line(points = {{-435.83,10.81},{-443.83,10.81},{-443.83,-13.19},{-344.83,-13.19}},color = {0,0,127}));
    connect(SCap.controlBus,soc.systemBus) annotation(Line(points = {{-141.31,18.36},{-208.26,18.36},{-208.26,46.85},{-335.57,46.85}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.controlBus,pwr_a_ref.systemBus) annotation(Line(points = {{-95.6,10},{-95.6,16.85},{-335.57,16.85}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.controlBus,pwr_sns.systemBus) annotation(Line(points = {{-95.6,10},{-95.6,16},{-208.26,16},{-208.26,-13.19},{-335.83,-13.19}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.controlBus,pwr_sns.systemBus) annotation(Line(points = {{44.55,15.59},{44.55,123.59},{-208.26,123.59},{-208.26,-13.19},{-335.83,-13.19}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(OnSC.y,i_a_ref.u_r) annotation(Line(points = {{-149.62,133.67},{-149.62,50.11},{-122.46,50.11}},color = {0,0,127}));
    connect(i_a_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-112.46,50.11},{-95.6,50.11},{-95.6,10}},color = {240,170,40},pattern = LinePattern.Dot));

annotation (
    experiment(StopTime=22000),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This example demonstrates an experiment for predicting the range of an electric vehicle. The powertrain for the vehicle consists of a SCap pack, an electric machine, and an electric load that represents additional consumers in the vehicle. The mechanics of the vehicle are captured by a simple 1D chassis model. A model of the friction brakes are also included, as well as control for blending the friction braking with electric regeneration. The driver controls the vehicle speed to follow a repeated sequence of the <a href=\"modelica://Electrification.Utilities.DriveCycles.WLTP\">WLTP</a> cycle (class 3).</p>

<h4>Electric range</h4>
<p>The range of the vehicle is here defined as the distance that the vehicle travels, when driven according to a repeated sequence of a specific drive cycle. The simulation starts with a fully charged SCap, at 90 &percnt; SoC. And a monitor in the SCap has been configured to stop the simulation when the SCap is depleated to 10 &percnt; SoC (configured in the Limits tab of the SCap model).</p>
<p>Note that the SoC here defines the full capacity of the SCap. This assumes that the capacity of the SCap has been parametrized in this way, and that we only allow using a limited window of this capacity. If we instead have parametrized the usable capacity of tha SCap, we would initialize the SCap at 100 &percnt; SoC and stop the simulation at 0 &percnt; SoC.</p>

<h4>Drive cycle</h4>
<p>A <a href=\"modelica://Electrification.Utilities.Blocks.Driver\">driver model</a> (speed feedback controller) is used to control the vehicle speed according to follow the speed profile determined by the WLTP cycle. The plot below shows the reference speed for the first cycle, and the actual measured speed of the vehicle. The measured speed follows the reference more or less.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_Speed.png\"/></p>

<h4>Torque arbitrarion and brake blending</h4>
<p>The driver provides acceleration and braking commands to the powertrain. These commands are translated into a torque &quot;request&quot; to the electric machine and the friction brakes, via the <em>torqueArbitraton</em> control block. This includese a brake blending strategy, to complement the friction brakes with the electric machine to regenerate energy back into the SCap.</p>

<p>Note: The friction brake model use a normalized diameter, such that the input signal corresponds to torque.</p>

<p>A reference torque is provided to the machine as a signal via the system control bus, using a <a href=\"modelica://Electrification.Machines.Control.Signals.tau_ref\">signal adapter</a> (more about this in the <a href=\"modelica://Electrification.Information.UsersGuide.BasicConcepts.ControllersAndSignals\">User&apos;s Guide</a>). Note that the machine id is specified in the adapter to address the machine on the system control bus.</p>

<p>The plot below shows the acceleration and braking command from the driver, along with the torque from the electric machine and the friction brakes.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_TorqueArbitration.png\"/></p>

<h4>Range (distance)</h4>
<p>The plot below shows the position of the vehicle versus the SoC of the SCap. We can see that the vehicle has traveled 272 km when the SCap is depleted.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_Position.png\"/></p>

<h4>Energy losses</h4>
<p>The plot below shows the energy lost to heat in the SCap, the machine, the brakes, as well as the energy lost to the additional loads. For comparison, the total energy output from the SCap is also shown.</p>
<p>Note that the <b>loads</b> component has been parametrized with a loss factor of 100 &percnt; (<code>k_loss=1</code>) such that all of the consumed energy is reported as losses (dissipated as heat).</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_Losses.png\"/></p>
</html>"));
end ElectricRange_SOC_PI_1;
