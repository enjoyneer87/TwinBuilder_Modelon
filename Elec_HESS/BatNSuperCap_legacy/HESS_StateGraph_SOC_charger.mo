within BatNSuperCap_legacy;

model HESS_StateGraph_SOC_charger "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-171.49,-63.73},{-151.49,-43.73}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = Electrification.Utilities.Types.ConverterMode.PowerA,i_a_ref = 0,external_limits = true,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = false,iMaxInB = 200,external_i_a = false,i_b_ref = -SCap.i_nom_1C,iMaxInA = 200,pMaxInA = 1e16,pMaxInB = 1e16,external_pwr_b = true,external_pwr_a = false),common_mode = false,internal_ground = false,electrical_a(v_start_fixed = false),display_name = true,core(iL_start_fixed = false)) annotation(Placement(transformation(extent = {{-112.59,-18.11},{-132.59,1.89}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{96.31,397.19},{116.31,417.19}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-227.76,344.89},{-207.76,364.89}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-206.76,344.89},{-186.76,364.89}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-101.82,345.36},{-81.82,365.36}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.0,138.0})));
    .Modelica.Blocks.Math.Gain convCrate(k = batty.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-53.47,169.37})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = false,uHigh = 0.5,uLow = 0.35) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {18.93,221.3})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-91.59,165.87})));
    .Electrification.Batteries.Control.Signals.i_cell i_cell(id = batty.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-55.050000000000004,66.03},rotation = -90.0)));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-108.87,-157.81},{-88.87,-137.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 180,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionSoC = .Modelon.Types.FaultAction.Error,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(contactors(external_control = true,enable_core = true,contactors_closed = true,preChargeOverlap = 2),limits(external_enable = false,iMaxOut = 100,iMaxIn = 100,enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6)) annotation(Placement(transformation(extent = {{-74.85,-116.36},{-106.85,-84.36}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SCContactor(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{39.61,345.15},{59.61,365.15}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 0.5) annotation(Placement(transformation(extent = {{-84.09,390.26},{-64.09,410.26}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Control.Signals.i_cell i_cellSC(id = SCap.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-334.0,206.0},rotation = -90.0)));
    .Modelica.Blocks.Math.Gain convCrate3(k = 20 * SCap.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-330.3,333.97})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-334.49,260.05})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0.01,uHigh = 0.5,pre_y_start = false) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-330.3,365.97})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-311.27,380.0},{-291.27,400.0}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.SCCap SCap(initialize_with_OCV = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,controller(controller2(enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(limits(external_enable = false,iMaxOut = 200,iMaxIn = 200,enable_thermal = false),contactors(external_control = true,contactors_closed = false,enable_core = true))),display_name = true) annotation(Placement(transformation(extent = {{-156.28,-18.0},{-176.28,2.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc(id = SCap.id) annotation(Placement(transformation(extent = {{-238.75,38.57},{-230.75,46.57}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Feedback feedback annotation(Placement(transformation(extent = {{-372.26,-60.04},{-352.26,-80.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.Constant targetSOC(k = 0.98) annotation(Placement(transformation(extent = {{-398.26,-80.04},{-378.26,-60.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Nonlinear.Limiter limiter(strict = true,uMax = 200 * 1000,uMin = -200 * 1000) annotation(Placement(transformation(extent = {{-282.48,-86.46},{-262.48,-66.46}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Add add annotation(Placement(transformation(extent = {{-312.0,-86.0},{-292.0,-66.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Continuous.Filter filter(f_cut = 0.05) annotation(Placement(transformation(extent = {{-252.26,-86.04},{-232.26,-66.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain gain(k = 1e4) annotation(Placement(transformation(extent = {{-344.26,-80.04},{-324.26,-60.04}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.BatteryChargerFixedLimits_CC_1 batteryChargerFixedLimits_CC_(redeclare replaceable .Electrification.Loads.Electrical.CapacitorAndDiode electrical,iMax = 300,enable_control_bus = false,vMax = 1000,pMax = 350000000) annotation(Placement(transformation(extent = {{-48.63,-122.7},{-3.59,-77.66}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor annotation(Placement(transformation(extent = {{-1.78,-18.01},{18.22,1.99}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactorsSCcap(id = SCap.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {49.44,235.5})));
    .Modelica.StateGraph.TransitionWithSignal SOC_limit(enableTimer = true,waitTime = 1) annotation(Placement(transformation(extent = {{-68.11,344.99},{-48.11,364.99}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Step step(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-28.89,345.02},{-8.89,365.02}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.9) annotation(Placement(transformation(extent = {{-75.56,287.07},{-55.56,307.07}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 0.1) annotation(Placement(transformation(extent = {{-74.14,255.67},{-54.14,275.67}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-6.02,317.43},{-26.02,337.43}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-128.2,68.83},{-120.2,76.83}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger2(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.PowerB),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.Disabled)) annotation(Placement(transformation(extent = {{-167.81,63.53},{-147.81,83.53}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.pwr_b_ref pwr_b_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-216.93,-78.72},{-208.93,-70.72}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 1,enableTimer = true) annotation(Placement(transformation(extent = {{8.26,344.68},{28.26,364.68}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal DCDC_off(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-184.42,345.17},{-164.42,365.17}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal CheckDCDCoff(waitTime = 0.2,enableTimer = false) annotation(Placement(transformation(extent = {{-143.39,344.74},{-123.39,364.74}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI3(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-144.03,128.38})));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold2(threshold = 0.001) annotation(Placement(transformation(extent = {{-140.76,196.25},{-120.76,216.25}},origin = {0,0},rotation = 0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc_Batt(id = batty.id) annotation(Placement(transformation(extent = {{-170.78,-104.21},{-162.78,-96.21}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and2 annotation(Placement(transformation(extent = {{-366.22,136.13},{-386.22,156.13}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.LessThreshold lessThreshold3(threshold = 0.9) annotation(Placement(transformation(extent = {{-431.29,102.19},{-411.29,122.19}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold = 0.1) annotation(Placement(transformation(extent = {{-429.42,70.79},{-409.42,90.79}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and3 annotation(Placement(transformation(extent = {{-160.64,304.91},{-140.64,324.91}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal DCDC_off2(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-45.42,414.01},{-25.42,434.01}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SC_on(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-44.96,450.96},{-24.96,470.96}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SC_off(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-142.17,451.24},{-122.17,471.24}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal DCDC_on(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{4.66,487.62},{24.66,507.62}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal bat_on_SOCin(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-179.57,487.44},{-159.57,507.44}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal bat_off(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-109.23,486.69},{-89.23,506.69}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep2(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-245.27,487.45},{-225.27,507.45}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep3(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-246.22,451.65},{-226.22,471.65}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep4(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-246.32,417.31},{-226.32,437.31}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition2 annotation(Placement(transformation(extent = {{-212.95,487.47},{-192.95,507.47}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition3 annotation(Placement(transformation(extent = {{-214.43,451.7},{-194.43,471.7}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition4 annotation(Placement(transformation(extent = {{-215.64,419.8},{-195.64,439.8}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal CheckDCDCoff2(enableTimer = false,waitTime = 0.2) annotation(Placement(transformation(extent = {{-179.66,471.24},{-159.66,451.24}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal bat_off_SOCOut(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-58.34,487.31},{-38.34,507.31}},rotation = 0.0,origin = {0.0,0.0})));
equation
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-207.27,354.89},{-200.77,354.89}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-54,149},{-54,157.37},{-53.47,157.37}},color = {0,0,127}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-53.47,180.37},{-53.47,217.7},{18.93,217.7},{18.93,209.3}},color = {0,0,127}));
    connect(i_cell.y_r,absI.u) annotation(Line(points = {{-55.05,87.54},{-55.05,109.39},{-54,109.39},{-54,126}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-91.82,344.36},{-91.82,212.14},{-91.59,212.14},{-91.59,178.25}},color = {255,0,255}));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-88.87,-147.81},{-57.76,-147.81},{-57.76,-100.36},{-74.85,-100.36}},color = {255,128,0}));
    connect(i_cell.systemBus,batty.controlBus) annotation(Line(points = {{-55.05,48.82},{-55.05,-1.08},{-78.05,-1.08},{-78.05,-84.36}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(lowCurrentSCap.outPort,initialStep.inPort[1]) annotation(Line(points = {{-72.59,400.26},{-237.74,400.26},{-237.74,354.89},{-228.76,354.89}},color = {0,0,0}));
    connect(i_cellSC.y_r,absI2.u) annotation(Line(points = {{-334,227.51},{-334,237.98},{-334.49,237.98},{-334.49,248.05}},color = {0,0,127}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-330.3,321.97},{-330.3,278.97},{-334.49,278.97},{-334.49,271.05}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate3.y) annotation(Line(points = {{-330.3,353.97},{-330.3,344.97}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-330.3,376.97},{-330.3,390},{-313.27,390}},color = {255,0,255}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-290.27,390},{-74.09,390},{-74.09,388.26}},color = {255,0,255}));
    connect(vInitA.plug_a,SCap.plug_a) annotation(Line(points = {{-151.49,-53.73},{-145.28,-53.73},{-145.28,-8},{-156.28,-8}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-114.59,1.89},{-114.59,15.51},{-158.28,15.51},{-158.28,2}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCap.controlBus,i_cellSC.systemBus) annotation(Line(points = {{-158.28,2},{-158.28,17.31},{-334,17.31},{-334,188.79}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(targetSOC.y,feedback.u1) annotation(Line(points = {{-377.26,-70.04},{-370.26,-70.04}},color = {0,0,127}));
    connect(feedback.u2,soc.y_r) annotation(Line(points = {{-362.26,-62.04},{-362.26,42.57},{-239.75,42.57}},color = {0,0,127}));
    connect(add.y,limiter.u) annotation(Line(points = {{-291,-76},{-291,-76.46},{-284.48,-76.46}},color = {0,0,127}));
    connect(gain.y,add.u1) annotation(Line(points = {{-323.26,-70.04},{-314,-70.04},{-314,-70}},color = {0,0,127}));
    connect(gain.u,feedback.y) annotation(Line(points = {{-346.26,-70.04},{-353.26,-70.04}},color = {0,0,127}));
    connect(filter.u,limiter.y) annotation(Line(points = {{-254.26,-76.04},{-261.48,-76.04},{-261.48,-76.46}},color = {0,0,127}));
    connect(SCap.controlBus,soc.systemBus) annotation(Line(points = {{-158.28,2},{-208.26,2},{-208.26,42.57},{-230.75,42.57}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(batteryChargerFixedLimits_CC_.plug_a,dCSensor.plug_b) annotation(Line(points = {{-48.63,-100.18},{-48.63,-8.01},{18.22,-8.01}},color = {255,128,0}));
    connect(batteryChargerFixedLimits_CC_.plug_a,batty.plug_a) annotation(Line(points = {{-48.63,-100.18},{27.7,-100.18},{27.7,-100.36},{-74.85,-100.36}},color = {255,128,0}));
    connect(dCSensor.y[3],add.u2) annotation(Line(points = {{8.22,-17.01},{8.22,21.44},{-320.26,21.44},{-320.26,-82},{-314,-82}},color = {0,0,127}));
    connect(close_contactorsSCcap.systemBus,SCap.controlBus) annotation(Line(points = {{49.44,227.25},{49.44,34.19},{-158.28,34.19},{-158.28,2}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCContactor.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{60.11,355.15},{69.83,355.15},{69.83,400.26},{-78.09,400.26}},color = {0,0,0}));
    connect(close_contactorsSCcap.u_b,SCContactor.active) annotation(Line(points = {{49.44,247.88},{49.44,309.93},{49.61,309.93},{49.61,344.15}},color = {255,0,255}));
    connect(soc.y_r,lessThreshold.u) annotation(Line(points = {{-239.75,42.57},{-245.75,42.57},{-245.75,297.07},{-77.56,297.07}},color = {0,0,127}));
    connect(lessThreshold.y,and1.u1) annotation(Line(points = {{-54.56,297.07},{10.53,297.07},{10.53,327.43},{-4.02,327.43}},color = {255,0,255}));
    connect(greaterThreshold.y,and1.u2) annotation(Line(points = {{-53.14,265.67},{-4.02,265.67},{-4.02,319.43}},color = {255,0,255}));
    connect(and1.y,SOC_limit.condition) annotation(Line(points = {{-27.02,327.43},{-70.83,327.43},{-70.83,338.99},{-58.11,338.99},{-58.11,342.99}},color = {255,0,255}));
    connect(averageStepUpDownDCDC.plug_b,SCap.plug_a) annotation(Line(points = {{-132.59,-8.11},{-132.59,-8},{-156.28,-8}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.plug_a,dCSensor.plug_a) annotation(Line(points = {{-112.59,-8.11},{-1.78,-8.11},{-1.78,-8.01}},color = {255,128,0}));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-91.59,157.62},{-91.59,-84.36},{-78.05,-84.36}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-120.2,72.83},{-114.59,72.83},{-114.59,1.89}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(booleanToInteger2.y,mode_ref.u_i) annotation(Line(points = {{-146.81,73.53},{-130.2,73.53},{-130.2,72.83}},color = {255,127,0}));
    connect(filter.y,pwr_b_ref.u_r) annotation(Line(points = {{-231.26,-76.04},{-225.095,-76.04},{-225.095,-74.72},{-218.93,-74.72}},color = {0,0,127}));
    connect(pwr_b_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-208.93,-74.72},{-202.93,-74.72},{-202.93,7.67},{-114.59,7.67},{-114.59,1.89}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(hysteresis2.y,HighCurrent.condition) annotation(Line(points = {{18.93,232.3},{18.93,291.47},{18.26,291.47},{18.26,342.68}},color = {255,0,255}));
    connect(Bat.outPort[1],SOC_limit.inPort) annotation(Line(points = {{-81.32,355.36},{-74.61,355.36},{-74.61,354.99},{-62.11,354.99}},color = {0,0,0}));
    connect(SOC_limit.outPort,step.inPort[1]) annotation(Line(points = {{-56.61,354.99},{-43.25,354.99},{-43.25,355.02},{-29.89,355.02}},color = {0,0,0}));
    connect(step.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-8.39,355.02},{4.18,355.02},{4.18,354.68},{14.26,354.68}},color = {0,0,0}));
    connect(HighCurrent.outPort,SCContactor.inPort[1]) annotation(Line(points = {{19.76,354.68},{30.02,354.68},{30.02,355.15},{38.61,355.15}},color = {0,0,0}));
    connect(transition.outPort,DCDC_off.inPort[1]) annotation(Line(points = {{-195.26,354.89},{-190.67,354.89},{-190.67,355.17},{-185.42,355.17}},color = {0,0,0}));
    connect(DCDC_off.active,booleanToInteger2.u) annotation(Line(points = {{-174.42,344.17},{-174.42,73.53},{-169.81,73.53}},color = {255,0,255}));
    connect(DCDC_off.outPort[1],CheckDCDCoff.inPort) annotation(Line(points = {{-163.92,355.17},{-156.73,355.17},{-156.73,354.74},{-137.39,354.74}},color = {0,0,0}));
    connect(CheckDCDCoff.outPort,Bat.inPort[1]) annotation(Line(points = {{-131.89,354.74},{-122.55,354.74},{-122.55,355.36},{-102.82,355.36}},color = {0,0,0}));
    connect(greaterThreshold.u,soc.y_r) annotation(Line(points = {{-76.14,265.67},{-245.75,265.67},{-245.75,42.57},{-239.75,42.57}},color = {0,0,127}));
    connect(lessThreshold2.u,absI3.y) annotation(Line(points = {{-142.76,206.25},{-148.76,206.25},{-148.76,147.46},{-144.03,147.46},{-144.03,139.38}},color = {0,0,127}));
    connect(absI2.u,absI3.u) annotation(Line(points = {{-334.49,248.05},{-334.49,110.38},{-144.03,110.38},{-144.03,116.38}},color = {0,0,127}));
    connect(batty.controlBus,soc_Batt.systemBus) annotation(Line(points = {{-78.05,-84.36},{-78.05,-78.05},{-144.88,-78.05},{-144.88,-100.21},{-162.78,-100.21}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(lessThreshold3.y,and2.u1) annotation(Line(points = {{-410.29,112.19},{-344.75,112.19},{-344.75,146.13},{-364.22,146.13}},color = {255,0,255}));
    connect(greaterThreshold2.y,and2.u2) annotation(Line(points = {{-408.42,80.79},{-364.22,80.79},{-364.22,138.13}},color = {255,0,255}));
    connect(soc_Batt.y_r,greaterThreshold2.u) annotation(Line(points = {{-171.78,-100.21},{-437.42,-100.21},{-437.42,80.79},{-431.42,80.79}},color = {0,0,127}));
    connect(lessThreshold3.u,greaterThreshold2.u) annotation(Line(points = {{-433.29,112.19},{-438.84,112.19},{-438.84,80.79},{-431.42,80.79}},color = {0,0,127}));
    connect(lessThreshold2.y,and3.u2) annotation(Line(points = {{-119.76,206.25},{-113.76,206.25},{-113.76,300.91},{-162.64,300.91},{-162.64,306.91}},color = {255,0,255}));
    connect(and3.u1,and2.y) annotation(Line(points = {{-162.64,314.91},{-393.22,314.91},{-393.22,146.13},{-387.22,146.13}},color = {255,0,255}));
    connect(and3.y,CheckDCDCoff.condition) annotation(Line(points = {{-139.64,314.91},{-133.39,314.91},{-133.39,342.74}},color = {255,0,255}));
    connect(initialStep2.outPort[1],transition2.inPort) annotation(Line(points = {{-224.77,497.45},{-217.11,497.45},{-217.11,497.47},{-206.95,497.47}},color = {0,0,0}));
    connect(initialStep3.outPort[1],transition3.inPort) annotation(Line(points = {{-225.72,461.65},{-217.07,461.65},{-217.07,461.7},{-208.43,461.7}},color = {0,0,0}));
    connect(CheckDCDCoff2.outPort,SC_off.inPort[1]) annotation(Line(points = {{-168.16,461.24},{-143.17,461.24}},color = {0,0,0}));
    connect(transition2.outPort,bat_on_SOCin.inPort[1]) annotation(Line(points = {{-201.45,497.47},{-191.4,497.47},{-191.4,497.44},{-180.57,497.44}},color = {0,0,0}));
    connect(bat_on_SOCin.active,CheckDCDCoff2.condition) annotation(Line(points = {{-169.57,486.44},{-169.57,479.45},{-169.66,479.45},{-169.66,473.24}},color = {255,0,255}));

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
end HESS_StateGraph_SOC_charger;
