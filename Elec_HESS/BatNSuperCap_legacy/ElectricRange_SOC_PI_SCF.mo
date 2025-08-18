within BatNSuperCap_legacy;

model ElectricRange_SOC_PI_SCF "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;

  .Electrification.Machines.Examples.Applications.ElectricCar machine(
    enable_thermal_port=false,
    fixed_temperature=true,
    display_name=true,redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(torqueControl(external_torque = true),external_limits = true,listen = true,typeListen (fixed = false)= Electrification.Utilities.Types.ControllerType.Battery,id_listen = batty.id,iMaxIn = batty.i_nom_1C * 0.5,iMaxOut = batty.i_nom_1C * 0.5,pMaxIn = 250 * 1000,pMaxOut = 250 * 1000),initialize_speed = true,initialize_angle = true,common_mode = false,core(limits(tau_max_mot = 1000),controller_limits = false)) annotation (
        Placement(transformation(extent={{42.67,-16.04},{74.67,15.96}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.SimpleChassis1D chassis(
    m=1800 * 1.5,
    R=0.35155,
    ideal_wheel=false,
    lambda=0.561118,
    Rl=0.335901,
    KX=98300,
    d=0.73196,
    A=2.25,
    Cd=0.339628,
    rho=1,
    CrConstant=0.00845431,initialize_velocity = true,initialize_position = true,useInclinationInput = false,inclinationConstant = 5)
    annotation (Placement(transformation(extent={{128.16,-16.74},{160.16,15.26}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Machines.Control.Signals.tau_ref tau_ref(id=machine.id)
    annotation (Placement(transformation(
        extent={{-4.0,4.0},{4.0,-4.0}},
        rotation=180.0,
        origin={72.28,49.58})));
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = 200,common_mode (fixed = false)= false) annotation (
    Placement(transformation(extent={{-152.92,-65.4},{-132.92,-45.4}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.Driver driver(
    k=1,
    Ti=2,
    torque_output=false,redeclare replaceable .Electrification.Utilities.DriveCycles.NEDC driveCycle,
    repeat=false)
    annotation (Placement(transformation(extent={{154.46,39.58},{134.46,59.58}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.IdealBrake brakes(enable_mount=false) annotation (Placement(transformation(extent={{96.1,-11.73},{120.1,12.27}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(
    number_of_motors_front=0,
    number_of_motors_rear=1,
    tauMax=machine.core.limits.tau_max_mot,regen_torque = 100,v_max = 270.777)
    annotation (Placement(transformation(extent={{117.96,39.58},{97.96,59.58}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,external_limits = true,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = true,iMaxInB = 5000,external_i_a = false,pMaxInA = 1e16,pMaxInB = 1e16,external_pwr_b = false,external_pwr_a = true,v_b_ref = SCap.controller.controller1.limits.vMax,i_b_ref = -SCap.i_nom_1C,aggregate_limits = false),common_mode = false,internal_ground = false,redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_a(v_start = 200,v_start_fixed = false),electrical_b(v_start = 400,v_start_fixed = false)) annotation(Placement(transformation(extent = {{-111.57,-8.26},{-91.57,11.74}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{93.89,310.26},{113.89,330.26}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 0) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-22.51,311.75},{-2.51,331.75}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 5,enableTimer = false) annotation(Placement(transformation(extent = {{41.59,348.41},{21.59,368.41}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-49.84,152.99})));
    .Modelica.Blocks.Math.Gain convCrate(k = 1 / ((batty.i_nom_1C))) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-49.68,194.32})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = true,uHigh = 0.5,uLow = 0.45) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-49.15,251.77999999999997})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-93.39,182.98})));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = 400,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-108.83,-159.48},{-88.83,-139.48}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-128.63,74.82},{-120.63,82.82}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentB),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerA)) annotation(Placement(transformation(extent = {{-175.84,68.6},{-155.84,88.6}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-200.5,97.09},rotation = -90.0)));
    .Modelica.Blocks.Math.BooleanToReal OnSC(realTrue = 0,realFalse = 0) annotation(Placement(transformation(extent = {{-195.23,37.24},{-175.23,57.24}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 40,ns = 100,limitActionI = .Modelon.Types.FaultAction.Terminate,limitActionV = .Modelon.Types.FaultAction.Terminate,limitActionSoC = .Modelon.Types.FaultAction.Error,SoC_min = 0,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(contactors(external_control = true,contactors_closed = false)),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical(preChargeResistance = 0.1),initialize_with_OCV = false,core(capacityNom = 3.6,vCellMax = 1000,vCellMin = 0),common_mode = false) annotation(Placement(transformation(extent = {{-84.18,-115.71},{-116.18,-83.71}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = -0.1,uHigh = 0,pre_y_start = false) annotation(Placement(transformation(extent = {{79.86,69.26},{59.86,89.26}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-104.41,311.87},{-84.41,331.87}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 5) annotation(Placement(transformation(extent = {{-73.08,311.76},{-53.08,331.76}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain convCrate3(k = SCap.np / ((batty.i_nom_1C))) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-274.96,227.95})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-277.89,188.44})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0.1,uHigh = 0.5,pre_y_start = true) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-275.27,260.39})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-256.7,274.42},{-236.7,294.42}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc(id = SCap.id) annotation(Placement(transformation(extent = {{-343.57,42.85},{-335.57,50.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Feedback feedback annotation(Placement(transformation(extent = {{-493.83,32.81},{-473.83,12.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.Constant targetSOC(k = 0.8) annotation(Placement(transformation(extent = {{-519.57,12.85},{-499.57,32.85}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Nonlinear.Limiter limiter(strict = true,uMax = machine.core.limits.P_max_mot,uMin = -machine.core.limits.P_max_mot) annotation(Placement(transformation(extent = {{-403.51,7.13},{-383.51,27.13}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Control.Signals.pwr_sns pwr_sns(id = machine.id) annotation(Placement(transformation(extent = {{4.0,4.0},{-4.0,-4.0}},origin = {-339.83,-13.46},rotation = 180.0)));
    .Modelica.Blocks.Math.Add add annotation(Placement(transformation(extent = {{-433.83,6.81},{-413.83,26.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Continuous.Filter filter(f_cut = 0.05) annotation(Placement(transformation(extent = {{-373.83,6.54},{-353.83,26.54}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain(k = 1e4) annotation(Placement(transformation(extent = {{-465.83,12.81},{-445.83,32.81}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_0804.SCCap SCap(id = 2,SoC_min = 0,redeclare replaceable .Electrification.Batteries.Core.Examples.NCA.TabularTransient core(vCellMin = 0,vCellMax = 1000,redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic1stTabular impedance(interpolation_degree = 3,interpolation_method = .Modelon.Blocks.Interpolation.Types.Method.Polynomial,C1_table = [0.2,6.830667e+03;0.3,5.654858e+03;0.4,7.071634e+03;0.5,1.620276e+04;0.6,1.085817e+04;0.7,1.452638e+04;0.8,2.401400e+04;0.9,1.250130e+04;1.0,4.580168e+03],R1_table = [0.2,3.728732e-03;0.3,4.537486e-03;0.4,2.206103e-03;0.5,1.545534e-03;0.6,1.749724e-03;0.7,1.753031e-03;0.8,1.678829e-03;0.9,3.100650e-03;1.0,6.274575e-03],R0_table = [0.2,0.3170192;0.3,0.3102788;0.4,0.3128846;0.5,0.2990385;0.6,0.2941587;0.7,0.2926683;0.8,0.2949038;0.9,0.2922837;1.0,0.3994471]),redeclare replaceable .Electrification.Batteries.Core.OCV.Table voltage(interpolation_degree = 3,interpolation_method = .Modelon.Blocks.Interpolation.Types.Method.Polynomial,ref_SoC_0 = 0,cellOCV_table = [0.2,0.788471;0.3,1.078110;0.4,1.355740;0.5,1.620590;0.6,1.876870;0.7,2.127530;0.8,2.376170;0.9,2.630110;1.0,2.908830],limitStart = 2),capacity(Q_cap_cell_nom = 13200)),ns = 86,SoC_max = 0.95,limitActionV = .Modelon.Types.FaultAction.Terminate,limitActionSoC = .Modelon.Types.FaultAction.Terminate,display_name = true,controller(controller2(enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(contactors(external_control = true,contactors_closed = false,maxVoltageDiff = 20),limits(enable_thermal = false),enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical(preChargeResistance = 2),initialize_with_OCV = false,common_mode = false,internal_ground = false) annotation(Placement(transformation(extent = {{-240.53,-53.69},{-260.53,-33.69}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.pwr_a_ref pwr_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{4.0,4.0},{-4.0,-4.0}},rotation = 180.0,origin = {-339.57,16.85})));
    .Electrification.Converters.Control.Signals.i_b_ref i_b_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-150.14,31.35},{-142.14,39.35}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors2(id = SCap.id) annotation(Placement(transformation(extent = {{-262.28,-5.4},{-254.28,2.6}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor(common_mode = false) annotation(Placement(transformation(extent = {{-188.33,-50.83},{-208.33,-30.83}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2(common_mode = false) annotation(Placement(transformation(extent = {{-17.08,-32.31},{-37.08,-12.31}},origin = {0.0,0.0},rotation = 0.0)));
equation
  connect(chassis.velocity, driver.speed_m)
    annotation (Line(points={{144.16,16.86},{144.16,38.58},{144.46,38.58}},   color={0,0,127}));
  connect(tau_ref.systemBus, machine.controlBus) annotation (Line(
      points={{68.28,49.58},{45.87,49.58},{45.87,15.96}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueArbitration.tau_brake_ref, brakes.u)
    annotation (Line(points={{96.96,43.58},{88.28,43.58},{88.28,25.58},{108.1,25.58},{108.1,13.47}}, color={0,0,127}));
  connect(torqueArbitration.veh_vel_x, chassis.velocity) annotation (
    Line(points={{107.96,37.58},{107.96,31.58},{144.16,31.58},{144.16,16.86}}, color={0,0,127}));
  connect(torqueArbitration.tau_ref_rear[1], tau_ref.u_r) annotation (Line(points={{96.96,49.58},{78.28,49.58}}, color={0,0,127}));
  connect(machine.flange, chassis.flangeR) annotation (Line(points={{74.67,-0.04},{74.67,-0.74},{128.16,-0.74}}, color={0,0,0}));
  connect(brakes.flange_a, chassis.flangeR) annotation (Line(points={{108.1,0.27},{108.1,-0.74},{128.16,-0.74}}, color={0,0,0}));
  connect(driver.acc_cmd, torqueArbitration.acc_cmd) annotation (Line(points={{133.46,55.58},{119.96,55.58}}, color={0,0,127}));
  connect(driver.brk_cmd, torqueArbitration.brk_cmd) annotation (Line(points={{133.46,43.58},{119.96,43.58}}, color={0,0,127}));
    connect(machine.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{45.87,15.96},{45.87,21.59},{-109.57,21.59},{-109.57,11.74}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-49.84,163.99},{-49.84,182.32},{-49.68,182.32}},color = {0,0,127}));
    connect(hysteresis2.y,HighCurrent.condition) annotation(Line(points = {{-49.15,262.78},{-49.15,279.35},{31.59,279.35},{31.59,346.41}},color = {255,0,255}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-49.68,205.32},{-49.68,227.9},{-49.15,227.9},{-49.15,239.78}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-12.51,310.75},{-12.51,212.14},{-93.39,212.14},{-93.39,195.36}},color = {255,0,255}));
    connect(and1.y,booleanToInteger.u) annotation(Line(points = {{-200.5,86.09},{-200.5,78.6},{-177.84,78.6}},color = {255,0,255}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-154.84,78.6},{-130.63,78.6},{-130.63,78.82}},color = {255,127,0}));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-88.83,-149.48},{-48.33,-149.48},{-48.33,-99.71},{-84.18,-99.71}},color = {255,128,0}));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-93.39,174.73},{-93.39,-83.71},{-87.38,-83.71}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(torqueArbitration.tau_ref_rear[1],hysteresis.u) annotation(Line(points = {{96.96,49.58},{89.73,49.58},{89.73,79.26},{81.86,79.26}},color = {0,0,127}));
    connect(SCon.active,and1.u2) annotation(Line(points = {{-94.41,310.87},{-94.41,295.64},{-218,295.64},{-218,109.09},{-208.5,109.09}},color = {255,0,255}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-274.96,215.95},{-274.96,207.36},{-277.89,207.36},{-277.89,199.44}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate3.y) annotation(Line(points = {{-275.27,248.39},{-274.96,248.39},{-274.96,238.95}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-275.27,271.39},{-275.27,284.42},{-258.7,284.42}},color = {255,0,255}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-235.7,284.42},{-63.08,284.42},{-63.08,309.76}},color = {255,0,255}));
    connect(targetSOC.y,feedback.u1) annotation(Line(points = {{-498.57,22.85},{-498.57,22.81},{-491.83,22.81}},color = {0,0,127}));
    connect(feedback.u2,soc.y_r) annotation(Line(points = {{-483.83,30.81},{-483.83,46.85},{-344.57,46.85}},color = {0,0,127}));
    connect(add.y,limiter.u) annotation(Line(points = {{-412.83,16.81},{-412.83,17.13},{-405.51,17.13}},color = {0,0,127}));
    connect(gain.y,add.u1) annotation(Line(points = {{-444.83,22.81},{-435.83,22.81}},color = {0,0,127}));
    connect(gain.u,feedback.y) annotation(Line(points = {{-467.83,22.81},{-474.83,22.81}},color = {0,0,127}));
    connect(filter.u,limiter.y) annotation(Line(points = {{-375.83,16.54},{-382.51,16.54},{-382.51,17.13}},color = {0,0,127}));
    connect(add.u2,pwr_sns.y_r) annotation(Line(points = {{-435.83,10.81},{-443.83,10.81},{-443.83,-13.46},{-344.83,-13.46}},color = {0,0,127}));
    connect(averageStepUpDownDCDC.controlBus,pwr_sns.systemBus) annotation(Line(points = {{-109.57,11.74},{-109.57,29.56},{-303.17,29.56},{-303.17,-13.46},{-335.83,-13.46}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.controlBus,pwr_sns.systemBus) annotation(Line(points = {{45.87,15.96},{45.87,124.1},{-208.26,124.1},{-208.26,-13.46},{-335.83,-13.46}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCap.controlBus,soc.systemBus) annotation(Line(points = {{-242.53,-33.69},{-242.53,46.85},{-335.57,46.85}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(hysteresis.y,and1.u1) annotation(Line(points = {{58.86,79.26},{52.86,79.26},{52.86,115.09},{-200.5,115.09},{-200.5,109.09}},color = {255,0,255}));
    connect(vInitA.plug_a,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{-132.92,-55.4},{-122.97,-55.4},{-122.97,1.74},{-111.57,1.74}},color = {255,128,0}));
    connect(machine.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{42.67,-0.04},{-25.31,-0.04},{-25.31,1.74},{-91.57,1.74}},color = {255,128,0}));
    connect(filter.y,pwr_a_ref.u_r) annotation(Line(points = {{-352.83,16.54},{-345.57,16.54},{-345.57,16.85}},color = {0,0,127}));
    connect(averageStepUpDownDCDC.controlBus,pwr_a_ref.systemBus) annotation(Line(points = {{-109.57,11.74},{-109.57,27.13},{-329.57,27.13},{-329.57,16.85},{-335.57,16.85}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(Bat.active,OnSC.u) annotation(Line(points = {{-12.51,310.75},{-12.51,305.39},{-229.48,305.39},{-229.48,47.24},{-197.23,47.24}},color = {255,0,255}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-120.63,78.82},{-109.57,78.82},{-109.57,11.74}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(OnSC.y,i_b_ref.u_r) annotation(Line(points = {{-174.23,47.24},{-162.91,47.24},{-162.91,35.35},{-152.14,35.35}},color = {0,0,127}));
    connect(i_b_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-142.14,35.35},{-109.57,35.35},{-109.57,11.74}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCon.active,close_contactors2.u_b) annotation(Line(points = {{-94.41,310.87},{-94.41,305.51},{-269.8,305.51},{-269.8,-1.4},{-264.28,-1.4}},color = {255,0,255}));
    connect(close_contactors2.systemBus,SCap.controlBus) annotation(Line(points = {{-254.28,-1.4},{-242.53,-1.4},{-242.53,-33.69}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.plug_a,dCSensor.plug_a) annotation(Line(points = {{-111.57,1.74},{-147.77,1.74},{-147.77,-40.83},{-188.33,-40.83}},color = {255,128,0}));
    connect(dCSensor.plug_b,SCap.plug_a) annotation(Line(points = {{-208.33,-40.83},{-222.13,-40.83},{-222.13,-43.69},{-240.53,-43.69}},color = {255,128,0}));
    connect(dCSensor.y[2],absI2.u) annotation(Line(points = {{-198.33,-49.83},{-198.33,-55.55},{-277.89,-55.55},{-277.89,176.44}},color = {0,0,127}));
    connect(transition.outPort,SCon.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-114.785,321.07},{-114.785,321.87},{-105.41,321.87}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{-83.91,321.87},{-75.495,321.87},{-75.495,321.76},{-67.08,321.76}},color = {0,0,0}));
    connect(lowCurrentSCap.outPort,Bat.inPort[1]) annotation(Line(points = {{-61.58,321.76},{-44.69,321.76},{-44.69,321.75},{-23.51,321.75}},color = {0,0,0}));
    connect(HighCurrent.outPort,SCon.inPort[2]) annotation(Line(points = {{30.09,358.41},{-111.41,358.41},{-111.41,321.87},{-105.41,321.87}},color = {0,0,0}));
    connect(machine.plug_a,dCSensor2.plug_a) annotation(Line(points = {{42.67,-0.04},{11.69,-0.04},{11.69,-22.31},{-17.08,-22.31}},color = {255,128,0}));
    connect(dCSensor2.plug_b,batty.plug_a) annotation(Line(points = {{-37.08,-22.31},{-60.63,-22.31},{-60.63,-99.71},{-84.18,-99.71}},color = {255,128,0}));
    connect(dCSensor2.y[2],absI.u) annotation(Line(points = {{-27.08,-31.31},{-27.08,-37.31},{-49.84,-37.31},{-49.84,140.99}},color = {0,0,127}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-109.57,11.74},{-109.57,-23.76},{-242.53,-23.76},{-242.53,-33.69}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.controlBus,batty.controlBus) annotation(Line(points = {{45.87,15.96},{45.87,21.96},{-87.38,21.96},{-87.38,-83.71}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-2.01,321.75},{41.59,321.75},{41.59,358.41},{35.59,358.41}},color = {0,0,0}));

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
end ElectricRange_SOC_PI_SCF;
