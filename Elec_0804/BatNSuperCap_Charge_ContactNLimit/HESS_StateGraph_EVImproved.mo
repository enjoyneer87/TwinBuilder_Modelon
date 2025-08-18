within BatNSuperCap_Charge_ContactNLimit;

model HESS_StateGraph_EVImproved "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-153.51,-65.02},{-133.51,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,i_a_ref = -SCap.i_nom_1C,external_limits = true,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = false,iMaxInB = 500,external_i_a = true,i_b_ref = -SCap.i_nom_1C,iMaxInA = 200,pMaxInA = 1e16,pMaxInB = 1e16,external_pwr_b = false,external_pwr_a = true),common_mode = false,internal_ground = false) annotation(Placement(transformation(extent = {{-94.23,-10.0},{-114.23,10.0}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{96.31,397.19},{116.31,417.19}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-103.52,311.39},{-83.52,331.39}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.1,enableTimer = true) annotation(Placement(transformation(extent = {{-60.0,311.28},{-40.0,331.28}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.0,138.0})));
    .Modelica.Blocks.Math.Gain convCrate(k = batty.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.31999999999999,179.57})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = false,uHigh = 0.5,uLow = 0.35) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-49.64,251.87})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-92.97,169.66})));
    .Electrification.Batteries.Control.Signals.i_cell i_cell(id = batty.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-54.65,66.03},rotation = -90.0)));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-108.87,-157.41},{-88.87,-137.41}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-131.59,58.66},{-123.59,66.66}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentA),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerA)) annotation(Placement(transformation(extent = {{-180.0,54.0},{-160.0,74.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToReal OnSC(realTrue = -200 * SCap.i_nom_1C,realFalse = 0) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-119.84,105.2},rotation = -90.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 180,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionSoC = .Modelon.Types.FaultAction.Terminate,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.ContactorControl controller1(contactors_closed = true,external_control = true,enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6)) annotation(Placement(transformation(extent = {{-83.92,-116.27},{-115.92,-84.27}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-19.13,311.51},{0.87,331.51}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 5) annotation(Placement(transformation(extent = {{-86.07,362.1},{-66.07,382.1}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Control.Signals.i_cell i_cellSC(id = SCap.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-334.0,206.0},rotation = -90.0)));
    .Modelica.Blocks.Math.Gain convCrate3(k = 20 * SCap.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-332.0,300.0})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-334.49,260.05})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0.01,uHigh = 0.5,pre_y_start = false) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-332.0,332.0})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-312.97,346.03},{-292.97,366.03}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.SCCap SCap(initialize_with_OCV = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIsolated electrical,controller(controller2(enable_thermal = false),controller1(iMaxOut = 200,iMaxIn = 200,enable_thermal = false)),limitActionSoC = .Modelon.Types.FaultAction.Terminate) annotation(Placement(transformation(extent = {{-146.87,-10.0},{-166.87,10.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc(id = SCap.id) annotation(Placement(transformation(extent = {{-222.0,-50.0},{-214.0,-42.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.pwr_a_ref pwr_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{4.0,4.0},{-4.0,-4.0}},rotation = 180.0,origin = {-218.0,-76.0})));
    .Modelica.Blocks.Math.Feedback feedback annotation(Placement(transformation(extent = {{-372.26,-60.04},{-352.26,-80.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.Constant targetSOC(k = 0.91) annotation(Placement(transformation(extent = {{-398.26,-80.04},{-378.26,-60.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Nonlinear.Limiter limiter(strict = true,uMax = 200 * 1000,uMin = -200 * 1000) annotation(Placement(transformation(extent = {{-282.48,-85.99},{-262.48,-65.99}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Add add annotation(Placement(transformation(extent = {{-312.0,-86.0},{-292.0,-66.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Continuous.Filter filter(f_cut = 0.05) annotation(Placement(transformation(extent = {{-252.56,-85.74},{-232.56,-65.74}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain(k = 1e4) annotation(Placement(transformation(extent = {{-344.26,-80.04},{-324.26,-60.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.i_a_ref i_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-114.0,32.0},{-106.0,40.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor annotation(Placement(transformation(extent = {{-2.0,-9.94},{18.0,10.06}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Examples.Applications.ElectricCar machine(initialize_angle = true,initialize_speed = true,redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(torqueControl(external_torque = true),typeListen = .Electrification.Utilities.Types.ControllerType.Converter,id_listen = averageStepUpDownDCDC.id,listen = true,external_limits = true),display_name = true,fixed_temperature = true,enable_thermal_port = false) annotation(Placement(transformation(extent = {{46.85,-15.88},{78.85,16.12}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.SimpleChassis1D chassis(initialize_position = true,initialize_velocity = true,CrConstant = 0.00845431,rho = 1,Cd = 0.339628,A = 2.25,d = 0.73196,KX = 98300,Rl = 0.335901,lambda = 0.561118,ideal_wheel = false,R = 0.35155,m = 1800) annotation(Placement(transformation(extent = {{134.05,-15.08},{166.05,16.92}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Control.Signals.tau_ref tau_ref(id = machine.id) annotation(Placement(transformation(extent = {{-4.0,4.0},{4.0,-4.0}},rotation = 180.0,origin = {77.79,50.62})));
    .Electrification.Utilities.Blocks.Driver driver(repeat = true,redeclare replaceable .Electrification.Utilities.DriveCycles.AccelerateDecelerate driveCycle,torque_output = false,Ti = 2,k = 1) annotation(Placement(transformation(extent = {{159.67,40.92},{139.67,60.92}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.IdealBrake brakes(enable_mount = false) annotation(Placement(transformation(extent = {{101.61,-10.86},{125.61,13.14}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(v_max = 270.777,regen_torque = 300,tauMax = machine.core.limits.tau_max_mot,number_of_motors_rear = 1,number_of_motors_front = 0) annotation(Placement(transformation(extent = {{123.79,40.91},{103.79,60.91}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep2(nOut = 1) annotation(Placement(transformation(extent = {{-159.57,403.8},{-139.57,423.8}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.Transition transition2 annotation(Placement(transformation(extent = {{-136.15,403.89},{-116.15,423.89}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelon.Blocks.Routing.ConstantOverrideInteger mDCDC(k = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentA)) annotation(Placement(transformation(extent = {{-97.16,507.04},{-85.16,519.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelon.Blocks.Routing.ConstantOverrideInteger mDCDC2(k = Integer(.Electrification.Utilities.Types.ConverterMode.Disabled)) annotation(Placement(transformation(extent = {{-141.16,507.04},{-129.16,519.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.IntegerConstant mDCDC3(k = Integer(.Electrification.Utilities.Types.ConverterMode.VoltageB)) annotation(Placement(transformation(extent = {{-229.16,519.04},{-217.16,507.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelon.Blocks.Routing.ConstantOverrideInteger mGen(k = Integer(.Electrification.Utilities.Types.MachineControlMode.Speed)) annotation(Placement(transformation(extent = {{-185.16,527.04},{-173.16,539.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.IntegerConstant mGen2(k = Integer(.Electrification.Utilities.Types.MachineControlMode.Disabled)) annotation(Placement(transformation(extent = {{-229.16,539.04},{-217.16,527.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelon.Blocks.Routing.ConstantOverrideInteger mGen3(k = Integer(.Electrification.Utilities.Types.MachineControlMode.Voltage)) annotation(Placement(transformation(extent = {{-141.16,527.04},{-129.16,539.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref input_dcdc_mode(id = dcdc.id) annotation(Placement(transformation(extent = {{-43.16,509.04},{-35.16,517.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Control.Signals.mode_ref input_gen_mode(id = starterGenerator.id) annotation(Placement(transformation(extent = {{-43.16,529.04},{-35.16,537.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelon.Blocks.Routing.ConstantOverrideInteger mGen4(k = Integer(.Electrification.Utilities.Types.MachineControlMode.Voltage)) annotation(Placement(transformation(extent = {{-97.16,527.04},{-85.16,539.04}},rotation = 0.0,origin = {0.0,0.0})));
equation
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-54,149},{-54,167.57},{-54.32,167.57}},color = {0,0,127}));
    connect(hysteresis2.y,HighCurrent.condition) annotation(Line(points = {{-49.64,262.87},{-49.64,291.47},{-50,291.47},{-50,309.28}},color = {255,0,255}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-54.32,190.57},{-54.32,227.9},{-49.64,227.9},{-49.64,239.87}},color = {0,0,127}));
    connect(i_cell.y_r,absI.u) annotation(Line(points = {{-54.65,87.54},{-54.65,109.39},{-54,109.39},{-54,126}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-93.52,310.39},{-93.52,212.14},{-92.97,212.14},{-92.97,182.04}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-83.02,321.39},{-69.43,321.39},{-69.43,321.28},{-54,321.28}},color = {0,0,0}));
    connect(transition.outPort,Bat.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-104.52,321.07},{-104.52,321.39}},color = {0,0,0}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-159,64},{-133.59,64},{-133.59,62.66}},color = {255,127,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-123.59,62.66},{-96.23,62.66},{-96.23,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-88.87,-147.41},{-57.76,-147.41},{-57.76,-100.27},{-83.92,-100.27}},color = {255,128,0}));
    connect(i_cell.systemBus,batty.controlBus) annotation(Line(points = {{-54.65,48.82},{-54.65,-1.08},{-90.2,-1.08},{-90.2,-84.27},{-87.12,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-92.97,161.41},{-92.97,-84.27},{-87.12,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(hysteresis2.y,OnSC.u) annotation(Line(points = {{-49.64,262.87},{-49.64,273.06},{-119.84,273.06},{-119.84,117.2}},color = {255,0,255}));
    connect(HighCurrent.outPort,SCon.inPort[1]) annotation(Line(points = {{-48.5,321.28},{-32.4,321.28},{-32.4,321.51},{-20.13,321.51}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{1.37,321.51},{14.82,321.51},{14.82,372.1},{-80.07,372.1}},color = {0,0,0}));
    connect(lowCurrentSCap.outPort,initialStep.inPort[1]) annotation(Line(points = {{-74.57,372.1},{-162.66,372.1},{-162.66,321.07},{-157.66,321.07}},color = {0,0,0}));
    connect(i_cellSC.y_r,absI2.u) annotation(Line(points = {{-334,227.51},{-334,237.98},{-334.49,237.98},{-334.49,248.05}},color = {0,0,127}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-332,288},{-332,278.97},{-334.49,278.97},{-334.49,271.05}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate3.y) annotation(Line(points = {{-332,320},{-332,311}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-332,343},{-332,356.03},{-314.97,356.03}},color = {255,0,255}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-291.97,356.03},{-76.07,356.03},{-76.07,360.1}},color = {255,0,255}));
    connect(SCap.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-146.87,0},{-114.23,0}},color = {255,128,0}));
    connect(vInitA.plug_a,SCap.plug_a) annotation(Line(points = {{-133.51,-55.02},{-127.24,-55.02},{-127.24,0},{-146.87,0}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-96.23,10},{-96.23,16},{-148.87,16},{-148.87,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCap.controlBus,i_cellSC.systemBus) annotation(Line(points = {{-148.87,10},{-148.87,17.31},{-334,17.31},{-334,188.79}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(targetSOC.y,feedback.u1) annotation(Line(points = {{-377.26,-70.04},{-370.26,-70.04}},color = {0,0,127}));
    connect(feedback.u2,soc.y_r) annotation(Line(points = {{-362.26,-62.04},{-362.26,-46},{-223,-46}},color = {0,0,127}));
    connect(add.y,limiter.u) annotation(Line(points = {{-291,-76},{-291,-75.99},{-284.48,-75.99}},color = {0,0,127}));
    connect(gain.y,add.u1) annotation(Line(points = {{-323.26,-70.04},{-314,-70.04},{-314,-70}},color = {0,0,127}));
    connect(gain.u,feedback.y) annotation(Line(points = {{-346.26,-70.04},{-353.26,-70.04}},color = {0,0,127}));
    connect(filter.y,pwr_a_ref.u_r) annotation(Line(points = {{-231.56,-75.74},{-224,-75.74},{-224,-76}},color = {0,0,127}));
    connect(filter.u,limiter.y) annotation(Line(points = {{-254.56,-75.74},{-261.48,-75.74},{-261.48,-75.99}},color = {0,0,127}));
    connect(SCap.controlBus,soc.systemBus) annotation(Line(points = {{-148.87,10},{-148.87,16},{-208.26,16},{-208.26,-46},{-214,-46}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.controlBus,pwr_a_ref.systemBus) annotation(Line(points = {{-96.23,10},{-96.23,16},{-208,16},{-208,-76},{-214,-76}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(OnSC.y,i_a_ref.u_r) annotation(Line(points = {{-119.84,94.2},{-119.84,89.2},{-154,89.2},{-154,36},{-116,36}},color = {0,0,127}));
    connect(i_a_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-106,36},{-96.23,36},{-96.23,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.plug_b,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{18,0.06},{-18,0.06},{-18,0},{-94.23,0}},color = {255,128,0}));
    connect(dCSensor.y[3],add.u2) annotation(Line(points = {{8,-8.94},{8,-126},{-320.26,-126},{-320.26,-82},{-314,-82}},color = {0,0,127}));
    connect(SCon.active,booleanToInteger.u) annotation(Line(points = {{-9.13,310.51},{-9.13,305.51},{-188,305.51},{-188,64},{-182,64}},color = {255,0,255}));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{150.05,18.52},{150.05,39.92},{149.67,39.92}},color = {0,0,127}));
    connect(tau_ref.systemBus,machine.controlBus) annotation(Line(points = {{73.79,50.62},{50.05,50.62},{50.05,16.12}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(torqueArbitration.tau_brake_ref,brakes.u) annotation(Line(points = {{102.79,44.91},{93.79,44.91},{93.79,26.62},{113.61,26.62},{113.61,14.34}},color = {0,0,127}));
    connect(torqueArbitration.veh_vel_x,chassis.velocity) annotation(Line(points = {{113.79,38.91},{113.79,32.62},{150.05,32.62},{150.05,18.52}},color = {0,0,127}));
    connect(torqueArbitration.tau_ref_rear[1],tau_ref.u_r) annotation(Line(points = {{102.79,50.91},{102.79,50.62},{83.79,50.62}},color = {0,0,127}));
    connect(machine.flange,chassis.flangeR) annotation(Line(points = {{78.85,0.12},{78.85,0.92},{134.05,0.92}},color = {0,0,0}));
    connect(brakes.flange_a,chassis.flangeR) annotation(Line(points = {{113.61,1.14},{113.61,0.92},{134.05,0.92}},color = {0,0,0}));
    connect(driver.acc_cmd,torqueArbitration.acc_cmd) annotation(Line(points = {{138.67,56.92},{125.79,56.92},{125.79,56.91}},color = {0,0,127}));
    connect(driver.brk_cmd,torqueArbitration.brk_cmd) annotation(Line(points = {{138.67,44.92},{125.79,44.92},{125.79,44.91}},color = {0,0,127}));
    connect(machine.plug_a,dCSensor.plug_b) annotation(Line(points = {{46.85,0.12},{32.43,0.12},{32.43,0.06},{18,0.06}},color = {255,128,0}));
    connect(machine.plug_a,batty.plug_a) annotation(Line(points = {{46.85,0.12},{46.85,-100.27},{-83.92,-100.27}},color = {255,128,0}));
    connect(machine.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{50.05,16.12},{50.05,22.63},{-96.23,22.63},{-96.23,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(initialStep2.outPort[1],transition2.inPort) annotation(Line(points = {{-139.07,413.8},{-134.61,413.8},{-134.61,413.89},{-130.15,413.89}},color = {0,0,0}));
    connect(mDCDC.u,mDCDC2.y) annotation(Line(points = {{-98.36,513.04},{-127.96,513.04}},color = {255,127,0}));
    connect(mDCDC.y,input_dcdc_mode.u_i) annotation(Line(points = {{-83.96,513.04},{-45.16,513.04}},color = {255,127,0}));
    connect(mGen.u,mGen2.y) annotation(Line(points = {{-186.36,533.04},{-216.56,533.04}},color = {255,127,0}));
    connect(mGen3.u,mGen.y) annotation(Line(points = {{-142.36,533.04},{-171.96,533.04}},color = {255,127,0}));
    connect(mGen3.y,mGen4.u) annotation(Line(points = {{-127.96,533.04},{-98.36,533.04}},color = {255,127,0}));
    connect(input_gen_mode.u_i,mGen4.y) annotation(Line(points = {{-45.16,533.04},{-83.96,533.04}},color = {255,127,0}));
    connect(mDCDC2.override,mGen3.repeat) annotation(Line(points = {{-135.16,520.24},{-135.16,525.84}},color = {255,0,255}));
    connect(mDCDC.override,mGen4.repeat) annotation(Line(points = {{-91.16,520.24},{-91.16,525.84}},color = {255,0,255}));
    connect(mDCDC3.y,mDCDC2.u) annotation(Line(points = {{-216.56,513.04},{-142.36,513.04}},color = {255,127,0}));

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
end HESS_StateGraph_EVImproved;
