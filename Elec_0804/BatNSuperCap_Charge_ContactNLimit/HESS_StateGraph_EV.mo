within BatNSuperCap_Charge_ContactNLimit;

model HESS_StateGraph_EV "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Electrical.DCInit vInitA(init_steady=true, stateSelect=StateSelect.default,init_start = false,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-153.51,-65.02},{-133.51,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,i_a_ref = -SCap.i_nom_1C,external_limits = true,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = false,iMaxInB = 500,external_i_a = true,i_b_ref = -SCap.i_nom_1C,iMaxInA = 200,pMaxInA = 1e16,pMaxInB = 1e16,external_pwr_b = false,external_pwr_a = false,pwr_a_ref = torqueArbitration.number_of_motors_rear),common_mode = false,internal_ground = false) annotation(Placement(transformation(extent = {{-91.05,-8.65},{-111.05,11.35}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{96.31,397.19},{116.31,417.19}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-103.52,312.24},{-83.52,332.24}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.1,enableTimer = true) annotation(Placement(transformation(extent = {{-60.0,311.28},{-40.0,331.28}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.0,138.0})));
    .Modelica.Blocks.Math.Gain convCrate(k = batty.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.760000000000005,179.57})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = true,uHigh = 0.5,uLow = 0.35) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-49.64,253.75})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-92.97,169.66})));
    .Electrification.Batteries.Control.Signals.i_cell i_cell(id = batty.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-54.0,66.43},rotation = -90.0)));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-65.08,-169.76},{-45.08,-149.76}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-131.95,58.66},{-123.95,66.66}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentA),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerA)) annotation(Placement(transformation(extent = {{-180.0,54.53},{-160.0,74.53}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToReal OnSC(realTrue = -200 * SCap.i_nom_1C,realFalse = 0) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-120.24000000000001,105.44},rotation = -90.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 180,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionSoC = Modelon.Types.FaultAction.Terminate,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(contactors(external_control = true,contactors_closed = false)),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6)) annotation(Placement(transformation(extent = {{-40.21,-128.35},{-72.21,-96.35}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-19.13,311.97},{0.87,331.97}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 5) annotation(Placement(transformation(extent = {{-86.07,362.1},{-66.07,382.1}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Control.Signals.i_cell i_cellSC(id = SCap.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-334.0,206.0},rotation = -90.0)));
    .Modelica.Blocks.Math.Gain convCrate3(k = 20 * SCap.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-332.0,300.0})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-334.49,260.05})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0.01,uHigh = 0.5,pre_y_start = false) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-332.0,332.0})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-312.97,346.03},{-292.97,366.03}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.SCCap SCap(initialize_with_OCV = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIsolated electrical,controller(controller2(enable_thermal = false),controller1(iMaxOut = 200,iMaxIn = 200,enable_thermal = false)),limitActionSoC = Modelon.Types.FaultAction.Terminate) annotation(Placement(transformation(extent = {{-146.39,-9.61},{-166.39,10.39}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.i_a_ref i_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-114.0,32.0},{-106.0,40.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor annotation(Placement(transformation(extent = {{-2.79,-9.15},{17.21,10.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Examples.Applications.ElectricCar machine(initialize_angle = true,initialize_speed = true,redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(torqueControl(external_torque = true),typeListen = Electrification.Utilities.Types.ControllerType.Battery,id_listen = batty.id,listen = true,external_limits = true),display_name = true,fixed_temperature = true,enable_thermal_port = false,core(controller_limits = true)) annotation(Placement(transformation(extent = {{46.99,-15.19},{78.99,16.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.SimpleChassis1D chassis(initialize_position = false,initialize_velocity = false,CrConstant = 0.00845431,rho = 1,Cd = 0.339628,A = 2.25,d = 0.73196,KX = 98300,Rl = 0.335901,lambda = 0.561118,ideal_wheel = false,R = 0.35155,m = 1800) annotation(Placement(transformation(extent = {{134.05,-15.82},{166.05,16.18}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Control.Signals.tau_ref tau_ref(id = machine.id) annotation(Placement(transformation(extent = {{-4.0,4.0},{4.0,-4.0}},rotation = 180.0,origin = {71.63,51.96})));
    .Electrification.Utilities.Blocks.Driver driver(repeat = true,redeclare replaceable .Electrification.Utilities.DriveCycles.AccelerateDecelerate driveCycle,torque_output = false,Ti = 2,k = 1) annotation(Placement(transformation(extent = {{159.97,40.92},{139.97,60.92}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.IdealBrake brakes(enable_mount = false) annotation(Placement(transformation(extent = {{101.61,-10.86},{125.61,13.14}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(v_max = 270.777,regen_torque = 300,tauMax = machine.core.limits.tau_max_mot,number_of_motors_rear = 1,number_of_motors_front = 0) annotation(Placement(transformation(extent = {{124.0,42.23},{104.0,62.23}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Control.Signals.SoC_cell soc_SC(id = SCap.id) annotation(Placement(transformation(extent = {{89.13,168.27},{97.13,176.27}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis soc_low(uLow = 0.08,uHigh = 0.15) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {66.68,227.9},rotation = 90.0)));
    .Modelica.Blocks.Logical.And soc_ok_SC annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {81.07,307.69},rotation = 90.0)));
    .Modelica.Blocks.Logical.Not not_soc_high annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {106.14,269.7},rotation = 90.0)));
    .Modelica.Blocks.Logical.Hysteresis soc_high(uHigh = 0.9,uLow = 0.85) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {105.69,228.75},rotation = 90.0)));
    .Modelica.Blocks.Logical.And Check_SC_soc_Crate annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-13.649999999999999,281.41},rotation = 90.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc_Batt(id = batty.id) annotation(Placement(transformation(extent = {{-4.0,-4.0},{4.0,4.0}},origin = {-102.43,431.64},rotation = -180.0)));
    .Modelica.Blocks.Logical.And Check_Bat_soc_Crate annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},origin = {-197.67,461.84},rotation = -90.0)));
    .Modelica.Blocks.Logical.And soc_ok_bat annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-80.49,563.8},rotation = 90.0)));
    .Modelica.Blocks.Logical.Hysteresis soc_low2(uHigh = 0.15,uLow = 0.08) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-95.46,483.36},rotation = 90.0)));
    .Modelica.Blocks.Logical.Hysteresis soc_high2(uLow = 0.9,uHigh = 0.92) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-54.61,484.86},rotation = 90.0)));
    .Modelica.Blocks.Logical.Not not_soc_high2 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-54.89,525.81},rotation = 90.0)));
equation
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-54,149},{-54,167.57},{-54.76,167.57}},color = {0,0,127}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-54.76,190.57},{-54.76,227.9},{-49.64,227.9},{-49.64,241.75}},color = {0,0,127}));
    connect(i_cell.y_r,absI.u) annotation(Line(points = {{-54,87.95},{-54,126}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-93.52,311.24},{-93.52,212.14},{-92.97,212.14},{-92.97,182.04}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-83.02,322.24},{-69.43,322.24},{-69.43,321.28},{-54,321.28}},color = {0,0,0}));
    connect(transition.outPort,Bat.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-104.52,321.07},{-104.52,322.24}},color = {0,0,0}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-159,64.53},{-133.95,64.53},{-133.95,62.66}},color = {255,127,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-123.95,62.66},{-93.05,62.66},{-93.05,11.35}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-45.08,-159.76},{-13.97,-159.76},{-13.97,-112.35},{-40.21,-112.35}},color = {255,128,0}));
    connect(i_cell.systemBus,batty.controlBus) annotation(Line(points = {{-54,49.22},{-54,-1.08},{-43.41,-1.08},{-43.41,-96.35}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-92.97,161.41},{-76.7,161.41},{-76.7,-96.35},{-43.41,-96.35}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(hysteresis2.y,OnSC.u) annotation(Line(points = {{-49.64,264.75},{-49.64,273.06},{-120.24,273.06},{-120.24,117.44}},color = {255,0,255}));
    connect(HighCurrent.outPort,SCon.inPort[1]) annotation(Line(points = {{-48.5,321.28},{-32.4,321.28},{-32.4,321.97},{-20.13,321.97}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{1.37,321.97},{13.11,321.97},{13.11,372.1},{-80.07,372.1}},color = {0,0,0}));
    connect(lowCurrentSCap.outPort,initialStep.inPort[1]) annotation(Line(points = {{-74.57,372.1},{-162.66,372.1},{-162.66,321.07},{-157.66,321.07}},color = {0,0,0}));
    connect(i_cellSC.y_r,absI2.u) annotation(Line(points = {{-334,227.51},{-334,237.98},{-334.49,237.98},{-334.49,248.05}},color = {0,0,127}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-332,288},{-332,278.97},{-334.49,278.97},{-334.49,271.05}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate3.y) annotation(Line(points = {{-332,320},{-332,311}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-332,343},{-332,356.03},{-314.97,356.03}},color = {255,0,255}));
    connect(SCap.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-146.39,0.39},{-146.39,1.35},{-111.05,1.35}},color = {255,128,0}));
    connect(vInitA.plug_a,SCap.plug_a) annotation(Line(points = {{-133.51,-55.02},{-127.24,-55.02},{-127.24,0.39},{-146.39,0.39}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-93.05,11.35},{-93.05,16},{-148.39,16},{-148.39,10.39}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCap.controlBus,i_cellSC.systemBus) annotation(Line(points = {{-148.39,10.39},{-148.39,18.13},{-334,18.13},{-334,188.79}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(OnSC.y,i_a_ref.u_r) annotation(Line(points = {{-120.24,94.44},{-120.24,87.49},{-154.86,87.49},{-154.86,36},{-116,36}},color = {0,0,127}));
    connect(i_a_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-106,36},{-93.05,36},{-93.05,11.35}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(dCSensor.plug_b,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{17.21,0.85},{-18,0.85},{-18,1.35},{-91.05,1.35}},color = {255,128,0}));
    connect(SCon.active,booleanToInteger.u) annotation(Line(points = {{-9.13,310.97},{-9.13,305.51},{-188,305.51},{-188,64.53},{-182,64.53}},color = {255,0,255}));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{150.05,17.78},{150.05,39.92},{149.97,39.92}},color = {0,0,127}));
    connect(tau_ref.systemBus,machine.controlBus) annotation(Line(points = {{67.63,51.96},{50.19,51.96},{50.19,16.81}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(torqueArbitration.tau_brake_ref,brakes.u) annotation(Line(points = {{103,46.23},{93.79,46.23},{93.79,26.62},{113.61,26.62},{113.61,14.34}},color = {0,0,127}));
    connect(torqueArbitration.veh_vel_x,chassis.velocity) annotation(Line(points = {{114,40.23},{114,32.62},{150.05,32.62},{150.05,17.78}},color = {0,0,127}));
    connect(torqueArbitration.tau_ref_rear[1],tau_ref.u_r) annotation(Line(points = {{103,52.23},{103,51.96},{77.63,51.96}},color = {0,0,127}));
    connect(machine.flange,chassis.flangeR) annotation(Line(points = {{78.99,0.81},{78.99,0.18},{134.05,0.18}},color = {0,0,0}));
    connect(brakes.flange_a,chassis.flangeR) annotation(Line(points = {{113.61,1.14},{113.61,0.18},{134.05,0.18}},color = {0,0,0}));
    connect(driver.acc_cmd,torqueArbitration.acc_cmd) annotation(Line(points = {{138.97,56.92},{126,56.92},{126,58.23}},color = {0,0,127}));
    connect(driver.brk_cmd,torqueArbitration.brk_cmd) annotation(Line(points = {{138.97,44.92},{126,44.92},{126,46.23}},color = {0,0,127}));
    connect(machine.plug_a,dCSensor.plug_b) annotation(Line(points = {{46.99,0.81},{32.43,0.81},{32.43,0.85},{17.21,0.85}},color = {255,128,0}));
    connect(machine.plug_a,batty.plug_a) annotation(Line(points = {{46.99,0.81},{46.99,-112.35},{-40.21,-112.35}},color = {255,128,0}));
    connect(not_soc_high.u,soc_high.y) annotation(Line(points = {{106.14,257.7},{106.14,248.73},{105.69,248.73},{105.69,239.75}},color = {255,0,255}));
    connect(not_soc_high.y,soc_ok_SC.u2) annotation(Line(points = {{106.14,280.7},{106.14,295.69},{89.07,295.69}},color = {255,0,255}));
    connect(soc_low.y,soc_ok_SC.u1) annotation(Line(points = {{66.68,238.9},{66.68,266.97},{81.07,266.97},{81.07,295.69}},color = {255,0,255}));
    connect(soc_SC.y_r,soc_low.u) annotation(Line(points = {{88.13,172.27},{66.68,172.27},{66.68,215.9}},color = {0,0,127}));
    connect(soc_SC.y_r,soc_high.u) annotation(Line(points = {{88.13,172.27},{82.13,172.27},{82.13,212.75},{105.69,212.75},{105.69,216.75}},color = {0,0,127}));
    connect(SCap.controlBus,soc_SC.systemBus) annotation(Line(points = {{-148.39,10.39},{-148.39,16.39},{101.53,16.39},{101.53,172.27},{97.13,172.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(soc_ok_SC.y,Check_SC_soc_Crate.u2) annotation(Line(points = {{81.07,318.69},{81.07,285.82},{0.35,285.82},{0.35,269.41},{-5.65,269.41}},color = {255,0,255}));
    connect(hysteresis2.y,Check_SC_soc_Crate.u1) annotation(Line(points = {{-49.64,264.75},{-49.64,269.73},{-31.64,269.73},{-31.64,265.41},{-13.65,265.41},{-13.65,269.41}},color = {255,0,255}));
    connect(Check_SC_soc_Crate.y,HighCurrent.condition) annotation(Line(points = {{-13.65,292.41},{-13.65,300.845},{-50,300.845},{-50,309.28}},color = {255,0,255}));
    connect(soc_Batt.y_r,soc_low2.u) annotation(Line(points = {{-97.43,431.64},{-91.43,431.64},{-91.43,465.36},{-95.46,465.36},{-95.46,471.36}},color = {0,0,127}));
    connect(soc_Batt.y_r,soc_high2.u) annotation(Line(points = {{-97.43,431.64},{-54.61,431.64},{-54.61,472.86}},color = {0,0,127}));
    connect(soc_ok_bat.y,Check_Bat_soc_Crate.u2) annotation(Line(points = {{-80.49,574.8},{-80.49,604.64},{-189.67,604.64},{-189.67,473.84}},color = {255,0,255}));
    connect(not_soc_high2.u,soc_high2.y) annotation(Line(points = {{-54.89,513.81},{-54.89,504.84},{-54.61,504.84},{-54.61,495.86}},color = {255,0,255}));
    connect(not_soc_high2.y,soc_ok_bat.u2) annotation(Line(points = {{-54.89,536.81},{-54.89,551.8},{-72.49,551.8}},color = {255,0,255}));
    connect(soc_low2.y,soc_ok_bat.u1) annotation(Line(points = {{-95.46,494.36},{-95.46,523.08},{-80.49,523.08},{-80.49,551.8}},color = {255,0,255}));
    connect(not1.y,Check_Bat_soc_Crate.u1) annotation(Line(points = {{-291.97,356.03},{-285.97,356.03},{-285.97,479.84},{-197.67,479.84},{-197.67,473.84}},color = {255,0,255}));
    connect(Check_Bat_soc_Crate.y,lowCurrentSCap.condition) annotation(Line(points = {{-197.67,450.84},{-197.67,354.1},{-76.07,354.1},{-76.07,360.1}},color = {255,0,255}));
    connect(soc_Batt.systemBus,batty.controlBus) annotation(Line(points = {{-106.43,431.64},{-234.7,431.64},{-234.7,-90.35},{-43.41,-90.35},{-43.41,-96.35}},color = {240,170,40},pattern = LinePattern.Dot));

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
end HESS_StateGraph_EV;
