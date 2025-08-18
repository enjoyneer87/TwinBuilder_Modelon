within BatNSuperCap_legacy;

model ElectricRange_SOC "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = SCap.OCV_start,common_mode = false) annotation (
    Placement(transformation(extent={{-152.44,-65.02},{-132.44,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{41.91,309.9},{61.91,329.9}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 0) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-29.85,309.92},{-9.85,329.92}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.3,enableTimer = false) annotation(Placement(transformation(extent = {{22.41,346.19},{2.41,366.19}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-49.84,152.63})));
    .Modelica.Blocks.Math.Gain convCrate(k = 1 / ((batty.i_nom_1C))) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-50.34,191.93})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-92.98,77.75})));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = 400,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-108.86,-159.21},{-88.86,-139.21}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-128.63,74.82},{-120.63,82.82}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentB),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerB)) annotation(Placement(transformation(extent = {{-176.1,68.21},{-156.1,88.21}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-200.5,97.41},rotation = -90.0)));
    .Modelica.Blocks.Math.BooleanToReal OnSC(realFalse = SCap.i_nom_1C * 200,realTrue = 0) annotation(Placement(transformation(extent = {{-214.73,18.54},{-194.73,38.54}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 100,limitActionI = .Modelon.Types.FaultAction.Terminate,limitActionV = .Modelon.Types.FaultAction.Terminate,limitActionSoC = .Modelon.Types.FaultAction.Error,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(limits(iMaxOut = batty.i_nom_1C * 0.5,enable_thermal = false,iMaxIn = batty.i_nom_1C * 0.5),contactors(external_control = true,contactors_closed = false,maxVoltageDiff = 10,preChargeOverlap = 0.1,enable_core = true),enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6),common_mode = false) annotation(Placement(transformation(extent = {{-84.65,-116.58},{-116.65,-84.58}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-107.41,309.55},{-87.41,329.55}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 1) annotation(Placement(transformation(extent = {{-75.74,309.82},{-55.74,329.82}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain convCrate3(k = 1 / (((batty.i_nom_1C)))) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-276.38,232.29})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-277.45,188.86})));
    .BatNSuperCap_0804.SCCap SCap(id = 2,SoC_min = 0,redeclare replaceable .Electrification.Batteries.Core.Examples.NCA.TabularTransient core(vCellMin = 0,vCellMax = 1000,redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic1stTabular impedance(interpolation_degree = 3,interpolation_method = .Modelon.Blocks.Interpolation.Types.Method.Polynomial,C1_table = [0.2,6.830667e+03;0.3,5.654858e+03;0.4,7.071634e+03;0.5,1.620276e+04;0.6,1.085817e+04;0.7,1.452638e+04;0.8,2.401400e+04;0.9,1.250130e+04;1.0,4.580168e+03],R1_table = [0.2,3.728732e-03;0.3,4.537486e-03;0.4,2.206103e-03;0.5,1.545534e-03;0.6,1.749724e-03;0.7,1.753031e-03;0.8,1.678829e-03;0.9,3.100650e-03;1.0,6.274575e-03],R0_table = [0.2,0.3170192;0.3,0.3102788;0.4,0.3128846;0.5,0.2990385;0.6,0.2941587;0.7,0.2926683;0.8,0.2949038;0.9,0.2922837;1.0,0.3994471]),redeclare replaceable .Electrification.Batteries.Core.OCV.Table voltage(interpolation_degree = 3,interpolation_method = .Modelon.Blocks.Interpolation.Types.Method.Polynomial,ref_SoC_0 = 0,cellOCV_table = [0.2,0.788471;0.3,1.078110;0.4,1.355740;0.5,1.620590;0.6,1.876870;0.7,2.127530;0.8,2.376170;0.9,2.630110;1.0,2.908830],limitStart = 2),capacity(Q_cap_cell_nom = 13200)),ns = 86,SoC_max = 0.95,limitActionV = .Modelon.Types.FaultAction.Terminate,limitActionSoC = .Modelon.Types.FaultAction.Terminate,display_name = true,controller(controller2(enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.LimitsTabular controller1),redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIdeal electrical,initialize_with_OCV = false,common_mode = false,limitActionI = .Modelon.Types.FaultAction.Terminate) annotation(Placement(transformation(extent = {{-240.91,-53.12},{-260.91,-33.12}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.i_b_ref i_b_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-149.41,24.559999999999995},{-141.41,32.56}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.5) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-50.6,237.55},rotation = 90.0)));
    .Electrification.Electrical.DCSensor dCSensor(common_mode = false) annotation(Placement(transformation(extent = {{-200.56,-50.59},{-220.56,-30.59}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uHigh = 0.5,uLow = 0.1,pre_y_start = true) annotation(Placement(transformation(extent = {{-260.08,262.31},{-240.08,282.31}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-202.24,263.02},{-182.24,283.02}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Control.Signals.pwr_sns pwr_sns(id = machine.id) annotation(Placement(transformation(extent = {{-198.28,-19.16},{-190.28,-11.16}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{-61.36,-61.68},{-41.36,-41.68}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,external_limits = true,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = false,iMaxInB = 1000,external_i_a = false,pMaxInA = SCap.controller.controller1.pMaxIn * 100,pMaxInB = 1e16,external_pwr_b = true,external_pwr_a(fixed = false) = false,i_b_ref = -SCap.i_nom_1C,v_a_ref = 0,external_v_a = false,iMaxInA = SCap.controller.controller1.iMaxIn * 100,i_a_ref = SCap.controller.controller1.iMaxIn,pwr_a_ref = 0,k_v = 10,aggregate_limits = false),common_mode = false,internal_ground = false,redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_b,redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_a(v_start = 0,v_start_fixed = false),redeclare replaceable .Electrification.Converters.Core.AverageStepUpDown core) annotation(Placement(transformation(extent = {{-109.5,-8.77},{-89.5,11.23}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.pwr_a_ref pwr_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-208.9,2.96},{-200.9,10.96}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc(id = batty.id) annotation(Placement(transformation(extent = {{-329.57,56.85},{-321.57,64.85}},origin = {0,0},rotation = 0)));
    .Modelica.Blocks.Math.Feedback feedback annotation(Placement(transformation(extent = {{-479.83,46.81},{-459.83,26.81}},rotation = 0,origin = {0,0})));
    .Modelica.Blocks.Sources.Constant targetSOC(k = 0.8) annotation(Placement(transformation(extent = {{-505.57000000000005,26.85},{-485.56999999999994,46.85}},rotation = 0,origin = {0,0})));
    .Modelica.Blocks.Nonlinear.Limiter limiter(uMin = -machine.core.limits.P_max_mot,uMax = machine.core.limits.P_max_mot,strict = true) annotation(Placement(transformation(extent = {{-389.51,21.13},{-369.51,41.129999999999995}},origin = {0,0},rotation = 0)));
    .Modelica.Blocks.Math.Add add annotation(Placement(transformation(extent = {{-419.83,20.81},{-399.83,40.81}},rotation = 0,origin = {0,0})));
    .Modelica.Blocks.Continuous.Filter filter(f_cut = 0.05) annotation(Placement(transformation(extent = {{-359.83,20.54},{-339.83,40.54}},rotation = 0,origin = {0,0})));
    .Modelica.Blocks.Math.Gain gain2(k = 1e4) annotation(Placement(transformation(extent = {{-451.83,26.81},{-431.83,46.81}},rotation = 0,origin = {0,0})));
    .Electrification.Machines.Examples.Machine machine(redeclare replaceable .Electrification.Machines.Control.MultiMode controller(external_torque = true),redeclare replaceable .Electrification.Machines.Mechanical.Gearbox mechanical(d_viscous = 0,ratio = 10),core(redeclare replaceable .Electrification.Machines.Core.Limits.Scalar limits(tau_max_mot = 1000),redeclare .Electrification.Machines.Core.Losses.Efficiency lossesMachine,redeclare .Electrification.Machines.Core.Losses.Efficiency lossesConverter),display_name = true,fixed_temperature = true,enable_thermal_port = false) annotation(Placement(transformation(extent = {{54.89,-133.78},{86.89,-101.78}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.SimpleChassis1D chassis(m = 2000) annotation(Placement(transformation(extent = {{98.57,-133.46},{130.57,-101.46}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Control.Signals.tau_ref torqueReference(id = machine.id) annotation(Placement(transformation(extent = {{-4.0,4.0},{4.0,-4.0}},rotation = 180.0,origin = {76.89,-67.14})));
    .Electrification.Utilities.Blocks.Driver driver(tauMax = machine.core.limits.tau_max_mot,repeat = true,redeclare .Electrification.Utilities.DriveCycles.WLTP driveCycle) annotation(Placement(transformation(extent = {{126.89,-79.14},{102.89,-55.14}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.pwr_b_ref pwr_b_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-209.75,-7.89},{-201.75,0.11}},origin = {0,0},rotation = 0)));
    .Modelica.Blocks.MathInteger.MultiSwitch multiSwitch annotation(Placement(transformation(extent = {{-160.24,123.27},{-120.24,143.27}},origin = {0,0},rotation = 0)));
equation
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-49.84,163.63},{-49.84,179.93},{-50.34,179.93}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-19.85,308.92},{-19.85,103.95},{-92.98,103.95},{-92.98,90.13}},color = {255,0,255}));
    connect(and1.y,booleanToInteger.u) annotation(Line(points = {{-200.5,86.41},{-200.5,78.21},{-178.1,78.21}},color = {255,0,255}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-155.1,78.21},{-130.63,78.21},{-130.63,78.82}},color = {255,127,0}));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-88.86,-149.21},{-48.33,-149.21},{-48.33,-100.58},{-84.65,-100.58}},color = {255,128,0}));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-92.98,69.5},{-92.98,-84.58},{-87.85,-84.58}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCon.active,and1.u2) annotation(Line(points = {{-97.41,308.55},{-97.41,295.64},{-218,295.64},{-218,109.41},{-208.5,109.41}},color = {255,0,255}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-276.38,220.29},{-276.38,207.36},{-277.45,207.36},{-277.45,199.86}},color = {0,0,127}));
    connect(Bat.active,OnSC.u) annotation(Line(points = {{-19.85,308.92},{-19.85,302.21},{-228.88,302.21},{-228.88,28.54},{-216.73,28.54}},color = {255,0,255}));
    connect(SCon.active,and1.u1) annotation(Line(points = {{-97.41,308.55},{-97.41,209.8},{-200.5,209.8},{-200.5,109.41}},color = {255,0,255}));
    connect(OnSC.y,i_b_ref.u_r) annotation(Line(points = {{-193.73,28.54},{-163.09,28.54},{-163.09,28.56},{-151.41,28.56}},color = {0,0,127}));
    connect(greaterEqualThreshold.u,convCrate.y) annotation(Line(points = {{-50.6,225.55},{-50.6,214.15},{-50.34,214.15},{-50.34,202.93}},color = {0,0,127}));
    connect(greaterEqualThreshold.y,HighCurrent.condition) annotation(Line(points = {{-50.6,248.55},{-50.6,298.63},{12.41,298.63},{12.41,344.19}},color = {255,0,255}));
    connect(dCSensor.plug_b,SCap.plug_a) annotation(Line(points = {{-220.56,-40.59},{-230.62,-40.59},{-230.62,-43.12},{-240.91,-43.12}},color = {255,128,0}));
    connect(dCSensor.y[2],absI2.u) annotation(Line(points = {{-210.56,-49.59},{-210.56,-56.04},{-277.45,-56.04},{-277.45,176.86}},color = {0,0,127}));
    connect(convCrate3.y,hysteresis.u) annotation(Line(points = {{-276.38,243.29},{-276.38,272.31},{-262.08,272.31}},color = {0,0,127}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-181.24,273.02},{-65.74,273.02},{-65.74,307.82}},color = {255,0,255}));
    connect(hysteresis.y,not1.u) annotation(Line(points = {{-239.08,272.31},{-221.45,272.31},{-221.45,273.02},{-204.24,273.02}},color = {255,0,255}));
    connect(transition.outPort,SCon.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-116.53,321.07},{-116.53,319.55},{-108.41,319.55}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{-86.91,319.55},{-78.81,319.55},{-78.81,319.82},{-69.74,319.82}},color = {0,0,0}));
    connect(lowCurrentSCap.outPort,Bat.inPort[1]) annotation(Line(points = {{-64.24,319.82},{-49.37,319.82},{-49.37,319.92},{-30.85,319.92}},color = {0,0,0}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-9.35,319.92},{22.41,319.92},{22.41,356.19},{16.41,356.19}},color = {0,0,0}));
    connect(HighCurrent.outPort,SCon.inPort[2]) annotation(Line(points = {{10.91,356.19},{-114.41,356.19},{-114.41,319.55},{-108.41,319.55}},color = {0,0,0}));
    connect(batty.plug_a,dCSensor2.plug_a) annotation(Line(points = {{-84.65,-100.58},{-73.43,-100.58},{-73.43,-51.68},{-61.36,-51.68}},color = {255,128,0}));
    connect(dCSensor2.y[2],absI.u) annotation(Line(points = {{-51.36,-60.68},{-51.36,-66.41},{-35.36,-66.41},{-35.36,-34.41},{-49.84,-34.41},{-49.84,140.63}},color = {0,0,127}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-120.63,78.82},{-107.5,78.82},{-107.5,11.23}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-107.5,11.23},{-107.5,17.16},{-242.91,17.16},{-242.91,-33.12}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(i_b_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-141.41,28.56},{-107.5,28.56},{-107.5,11.23}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.plug_a,dCSensor.plug_a) annotation(Line(points = {{-109.5,1.23},{-155.63,1.23},{-155.63,-40.59},{-200.56,-40.59}},color = {255,128,0}));
    connect(vInitA.plug_a,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{-132.44,-55.02},{-122.61,-55.02},{-122.61,1.23},{-109.5,1.23}},color = {255,128,0}));
    connect(pwr_a_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-200.9,6.96},{-129.06,6.96},{-129.06,17.45},{-107.5,17.45},{-107.5,11.23}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(targetSOC.y,feedback.u1) annotation(Line(points = {{-484.57,36.85},{-484.57,36.81},{-477.83,36.81}},color = {0,0,127}));
    connect(feedback.u2,soc.y_r) annotation(Line(points = {{-469.83,44.81},{-469.83,60.85},{-330.57,60.85}},color = {0,0,127}));
    connect(add.y,limiter.u) annotation(Line(points = {{-398.83,30.81},{-398.83,31.13},{-391.51,31.13}},color = {0,0,127}));
    connect(gain2.y,add.u1) annotation(Line(points = {{-430.83,36.81},{-421.83,36.81}},color = {0,0,127}));
    connect(gain2.u,feedback.y) annotation(Line(points = {{-453.83,36.81},{-460.83,36.81}},color = {0,0,127}));
    connect(filter.u,limiter.y) annotation(Line(points = {{-361.83,30.54},{-368.51,30.54},{-368.51,31.13}},color = {0,0,127}));
    connect(pwr_sns.y_r,add.u2) annotation(Line(points = {{-199.28,-15.16},{-427.83,-15.16},{-427.83,24.81},{-421.83,24.81}},color = {0,0,127}));
    connect(filter.y,pwr_a_ref.u_r) annotation(Line(points = {{-338.83,30.54},{-241.83,30.54},{-241.83,6.96},{-210.9,6.96}},color = {0,0,127}));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{114.57,-99.86},{114.89,-99.86},{114.89,-80.35}},color = {0,0,127}));
    connect(driver.tau_ref,torqueReference.u_r) annotation(Line(points = {{101.69,-67.15},{82.89,-67.15}},color = {0,0,127}));
    connect(machine.flange,chassis.flangeR) annotation(Line(points = {{86.89,-117.78},{86.89,-117.46},{98.57,-117.46}},color = {0,0,0}));
    connect(torqueReference.systemBus,machine.controlBus) annotation(Line(points = {{72.89,-67.15},{58.09,-67.15},{58.09,-101.78}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,dCSensor2.plug_b) annotation(Line(points = {{54.89,-117.78},{6.77,-117.78},{6.77,-51.68},{-41.36,-51.68}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.plug_b,machine.plug_a) annotation(Line(points = {{-89.5,1.23},{31.14,1.23},{31.14,-117.78},{54.89,-117.78}},color = {255,128,0}));
    connect(pwr_sns.systemBus,machine.controlBus) annotation(Line(points = {{-190.28,-15.16},{58.09,-15.16},{58.09,-101.78}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(filter.y,pwr_b_ref.u_r) annotation(Line(points = {{-338.83,30.54},{-275.28999999999996,30.54},{-275.28999999999996,-3.89},{-211.75,-3.89}},color = {0,0,127}));
    connect(pwr_b_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-201.75,-3.89},{-195.75,-3.89},{-195.75,17.45},{-107.5,17.45},{-107.5,11.23}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(batty.controlBus,soc.systemBus) annotation(Line(points = {{-87.85,-84.58},{-87.85,60.85},{-321.57,60.85}},color = {240,170,40},pattern = LinePattern.Dot));

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
end ElectricRange_SOC;
