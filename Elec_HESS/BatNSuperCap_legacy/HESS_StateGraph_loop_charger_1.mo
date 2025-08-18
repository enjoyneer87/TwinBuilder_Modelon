within BatNSuperCap_legacy;

model HESS_StateGraph_loop_charger_1 "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-171.82,-63.73},{-151.82,-43.73}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.PowerB,i_a_ref = 0,external_limits = true,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = false,iMaxInB = 200,external_i_a = false,i_b_ref = -SCap.i_nom_1C,iMaxInA = 200,pMaxInA = 1e16,pMaxInB = 1e16,external_pwr_b = false,external_pwr_a = false,pwr_a_ref = 20 * 400),common_mode = false,internal_ground = false,electrical_a(v_start_fixed = false),display_name = true,core(iL_start_fixed = false)) annotation(Placement(transformation(extent = {{-112.0,-16.0},{-132.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{96.31,397.19},{116.31,417.19}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-356.98,149.42})));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-108.87,-157.34},{-88.87,-137.34}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 180,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Terminate,limitActionSoC = .Modelon.Types.FaultAction.Terminate,SoC_min = 0.1,SoC_max = 0.95,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(contactors(external_control = true,enable_core = true,contactors_closed = false,preChargeOverlap = 0.1),limits(external_enable = false,iMaxOut = 50,iMaxIn = 50,enable_thermal = false),enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6)) annotation(Placement(transformation(extent = {{-199.48,-123.0},{-231.48,-91.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.SCCap SCap(initialize_with_OCV = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,controller(controller2(enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(limits(external_enable = false,iMaxOut = 40,iMaxIn = 40,enable_thermal = false),contactors(external_control = true,contactors_closed = false,enable_core = true),enable_thermal = false)),display_name = true,limitActionSoC = .Modelon.Types.FaultAction.Terminate,limitActionV = .Modelon.Types.FaultAction.Terminate,SoC_max = 0.95) annotation(Placement(transformation(extent = {{-156.79,-17.9},{-176.79,2.1}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc_SC(id = SCap.id) annotation(Placement(transformation(extent = {{-222.81,242.01},{-214.81,250.01}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor annotation(Placement(transformation(extent = {{-1.78,-18.01},{18.22,1.99}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactorsSCcap(id = SCap.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-30.5,258.6})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-128.2,68.83},{-120.2,76.83}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger2(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.Disabled),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerA)) annotation(Placement(transformation(extent = {{-167.81,63.99},{-147.81,83.99}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.SoC_cell soc_Batt(id = batty.id) annotation(Placement(transformation(extent = {{-4.0,-4.0},{4.0,4.0}},origin = {1.0199999999999998,509.69000000000005},rotation = -180.0)));
    .Modelica.Blocks.Logical.And soc_ok_bat annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {22.96,642.7},rotation = 90.0)));
    .Modelica.StateGraph.StepWithSignal Use_Battery(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-47.67,446.85},{-27.67,466.85}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-188.98,448.07},{-168.98,468.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition toBat annotation(Placement(transformation(extent = {{-157.84,448.12},{-147.84,468.12}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal toSC(enableTimer = false,waitTime = 5) annotation(Placement(transformation(extent = {{-45.12,485.47},{-65.12,505.47}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.StateGraph.StepWithSignal Use_Supercap(nOut = 1,nIn = 2) annotation(Placement(transformation(extent = {{-131.05,450.24},{-111.05,470.24}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal BackToBat(enableTimer = true,waitTime = 10) annotation(Placement(transformation(extent = {{-97.76,467.77},{-77.76,447.77}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = 20,uHigh = 100) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-86.54,369.37},rotation = 90.0)));
    .Modelica.Blocks.Logical.Not not2 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-16.31,639.7},rotation = 90.0)));
    .Modelica.Blocks.Logical.Hysteresis soc_low(uLow = 0.08,uHigh = 0.15) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {7.989999999999999,562.26},rotation = 90.0)));
    .Modelica.Blocks.Logical.Hysteresis soc_high(uHigh = 0.92,uLow = 0.9) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {48.84,564.13},rotation = 90.0)));
    .Modelica.Blocks.Logical.Not not_soc_high annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {48.56,604.71},rotation = 90.0)));
    .Modelica.Blocks.Logical.And Check_Bat_soc_Crate annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},origin = {-94.22,540.74},rotation = -90.0)));
    .Modelica.Blocks.Math.Abs absI4(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = -90.0,origin = {8.0,-47.53})));
    .Modelica.Blocks.Logical.Hysteresis soc_low2(uHigh = 0.15,uLow = 0.08) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-245.26,301.64},rotation = 90.0)));
    .Modelica.Blocks.Logical.And soc_ok_SC annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-230.87,381.43},rotation = 90.0)));
    .Modelica.Blocks.Logical.Not not_soc_high2 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-205.8,343.44},rotation = 90.0)));
    .Modelica.Blocks.Logical.Hysteresis soc_high2(uLow = 0.85,uHigh = 0.9) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-206.25,302.49},rotation = 90.0)));
    .Modelica.Blocks.Logical.And Check_SC_soc_Crate annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-88.47,421.97},rotation = 90.0)));
    .Electrification.Loads.Examples.BatteryCharger batteryCharger(controller(external_limits = true,vMax = 1000,listen_to_battery = true,id_battery = limitsFixed.id)) annotation(Placement(transformation(extent = {{78.05,-17.98},{98.05,2.02}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Switch switch annotation(Placement(transformation(extent = {{-50.0,72.0},{-30.0,92.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.v_cell v_cell_bat(id = batty.id) annotation(Placement(transformation(extent = {{-4.0,-4.0},{4.0,4.0}},origin = {-65.3,33.93},rotation = 180.0)));
    .Modelica.Blocks.Math.Gain gain(k = batty.ns) annotation(Placement(transformation(extent = {{-45.6,18.1},{-25.6,38.1}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Control.Signals.v_cell v_cell_SC(id = SCap.id) annotation(Placement(transformation(extent = {{-4.0,-4.0},{4.0,4.0}},origin = {-144.83,124.99000000000001},rotation = 180.0)));
    .Modelica.Blocks.Math.Gain gain2(k = SCap.ns) annotation(Placement(transformation(extent = {{-125.46,108.83},{-105.46,128.83}},origin = {0.0,0.0},rotation = 0.0)));
equation
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-88.87,-147.34},{-57.76,-147.34},{-57.76,-107},{-199.48,-107}},color = {255,128,0}));
    connect(vInitA.plug_a,SCap.plug_a) annotation(Line(points = {{-151.82,-53.73},{-145.28,-53.73},{-145.28,-7.9},{-156.79,-7.9}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-114,4},{-114,20.35},{-158.79,20.35},{-158.79,2.1}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactorsSCcap.systemBus,SCap.controlBus) annotation(Line(points = {{-30.5,250.35},{-30.5,39.3},{-158.79,39.3},{-158.79,2.1}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.plug_b,SCap.plug_a) annotation(Line(points = {{-132,-6},{-132,-7.9},{-156.79,-7.9}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.plug_a,dCSensor.plug_a) annotation(Line(points = {{-112,-6},{-1.78,-6},{-1.78,-8.01}},color = {255,128,0}));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-356.98,141.17},{-356.98,-91},{-202.68,-91}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-120.2,72.83},{-114,72.83},{-114,4}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(booleanToInteger2.y,mode_ref.u_i) annotation(Line(points = {{-146.81,73.99},{-130.2,73.99},{-130.2,72.83}},color = {255,127,0}));
    connect(initialStep.outPort[1],toBat.inPort) annotation(Line(points = {{-168.48,458.07},{-162.42,458.07},{-162.42,458.12},{-154.84,458.12}},color = {0,0,0}));
    connect(hysteresis.y,not2.u) annotation(Line(points = {{-86.54,380.37},{-86.54,390.26},{-16.31,390.26},{-16.31,627.7}},color = {255,0,255}));
    connect(soc_Batt.y_r,soc_low.u) annotation(Line(points = {{6.02,509.69},{12.02,509.69},{12.02,544.26},{7.99,544.26},{7.99,550.26}},color = {0,0,127}));
    connect(soc_Batt.y_r,soc_high.u) annotation(Line(points = {{6.02,509.69},{48.84,509.69},{48.84,552.13}},color = {0,0,127}));
    connect(not_soc_high.u,soc_high.y) annotation(Line(points = {{48.56,592.71},{48.56,583.74},{48.84,583.74},{48.84,575.13}},color = {255,0,255}));
    connect(not_soc_high.y,soc_ok_bat.u2) annotation(Line(points = {{48.56,615.71},{48.56,630.7},{30.96,630.7}},color = {255,0,255}));
    connect(soc_low.y,soc_ok_bat.u1) annotation(Line(points = {{7.99,573.26},{7.99,601.98},{22.96,601.98},{22.96,630.7}},color = {255,0,255}));
    connect(soc_ok_bat.y,Check_Bat_soc_Crate.u2) annotation(Line(points = {{22.96,653.7},{22.96,683.54},{-86.22,683.54},{-86.22,552.74}},color = {255,0,255}));
    connect(not2.y,Check_Bat_soc_Crate.u1) annotation(Line(points = {{-16.31,650.7},{-16.31,659.23},{-94.22,659.23},{-94.22,552.74}},color = {255,0,255}));
    connect(Check_Bat_soc_Crate.y,BackToBat.condition) annotation(Line(points = {{-94.22,529.74},{-94.22,519.25},{-87.76,519.25},{-87.76,469.77}},color = {255,0,255}));
    connect(batty.plug_a,dCSensor.plug_a) annotation(Line(points = {{-199.48,-107},{-42.61,-107},{-42.61,-8.01},{-1.78,-8.01}},color = {255,128,0}));
    connect(Use_Battery.active,close_contactors.u_b) annotation(Line(points = {{-37.67,445.85},{-37.67,426.29},{-356.98,426.29},{-356.98,161.79}},color = {255,0,255}));
    connect(dCSensor.y[2],absI4.u) annotation(Line(points = {{8.22,-17.01},{8.22,-25.27},{8,-25.27},{8,-35.53}},color = {0,0,127}));
    connect(hysteresis.u,absI4.y) annotation(Line(points = {{-86.54,357.37},{-86.54,-62.54},{8,-62.54},{8,-58.53}},color = {0,0,127}));
    connect(not_soc_high2.u,soc_high2.y) annotation(Line(points = {{-205.8,331.44},{-205.8,322.47},{-206.25,322.47},{-206.25,313.49}},color = {255,0,255}));
    connect(not_soc_high2.y,soc_ok_SC.u2) annotation(Line(points = {{-205.8,354.44},{-205.8,369.43},{-222.87,369.43}},color = {255,0,255}));
    connect(soc_low2.y,soc_ok_SC.u1) annotation(Line(points = {{-245.26,312.64},{-245.26,340.71},{-230.87,340.71},{-230.87,369.43}},color = {255,0,255}));
    connect(SCap.controlBus,soc_SC.systemBus) annotation(Line(points = {{-158.79,2.1},{-208.26,2.1},{-208.26,246.01},{-214.81,246.01}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(soc_SC.y_r,soc_low2.u) annotation(Line(points = {{-223.81,246.01},{-245.26,246.01},{-245.26,289.64}},color = {0,0,127}));
    connect(soc_SC.y_r,soc_high2.u) annotation(Line(points = {{-223.81,246.01},{-229.81,246.01},{-229.81,286.49},{-206.25,286.49},{-206.25,290.49}},color = {0,0,127}));
    connect(Check_SC_soc_Crate.u2,hysteresis.y) annotation(Line(points = {{-80.47,409.97},{-80.47,384.87},{-86.54,384.87},{-86.54,380.37}},color = {255,0,255}));
    connect(Check_SC_soc_Crate.u1,soc_ok_SC.y) annotation(Line(points = {{-88.47,409.97},{-88.47,401.43},{-230.87,401.43},{-230.87,392.43}},color = {255,0,255}));
    connect(Use_Supercap.active,close_contactorsSCcap.u_b) annotation(Line(points = {{-121.05,449.24},{-121.05,438.74},{-30.5,438.74},{-30.5,270.97}},color = {255,0,255}));
    connect(Use_Supercap.active,booleanToInteger2.u) annotation(Line(points = {{-121.05,449.24},{-121.05,346.55},{-175.81,346.55},{-175.81,73.99},{-169.81,73.99}},color = {255,0,255}));
    connect(soc_Batt.systemBus,batty.controlBus) annotation(Line(points = {{-2.98,509.69},{-324.97,509.69},{-324.97,-91},{-202.68,-91}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(Check_SC_soc_Crate.y,toSC.condition) annotation(Line(points = {{-88.47,432.97},{-88.47,444.94},{-55.12,444.94},{-55.12,483.47}},color = {255,0,255}));
    connect(toBat.outPort,Use_Supercap.inPort[1]) annotation(Line(points = {{-152.09,458.12},{-142.61,458.12},{-142.61,460.24},{-132.05,460.24}},color = {0,0,0}));
    connect(Use_Supercap.outPort[1],BackToBat.inPort) annotation(Line(points = {{-110.55,460.24},{-103.4,460.24},{-103.4,457.77},{-91.76,457.77}},color = {0,0,0}));
    connect(BackToBat.outPort,Use_Battery.inPort[1]) annotation(Line(points = {{-86.26,457.77},{-67.18,457.77},{-67.18,456.85},{-48.67,456.85}},color = {0,0,0}));
    connect(Use_Battery.outPort[1],toSC.inPort) annotation(Line(points = {{-27.17,456.85},{-21.17,456.85},{-21.17,495.47},{-51.12,495.47}},color = {0,0,0}));
    connect(toSC.outPort,Use_Supercap.inPort[2]) annotation(Line(points = {{-56.62,495.47},{-142.53,495.47},{-142.53,460.24},{-132.05,460.24}},color = {0,0,0}));
    connect(batteryCharger.plug_a,dCSensor.plug_b) annotation(Line(points = {{78.05,-7.98},{44.35,-7.98},{44.35,-8.01},{18.22,-8.01}},color = {255,128,0}));
    connect(batty.controlBus,v_cell_bat.systemBus) annotation(Line(points = {{-202.68,-91},{-202.68,33.93},{-69.3,33.93}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(v_cell_bat.y_r,gain.u) annotation(Line(points = {{-60.3,33.93},{-54.11,33.93},{-54.11,28.1},{-47.6,28.1}},color = {0,0,127}));
    connect(gain.y,switch.u3) annotation(Line(points = {{-24.6,28.1},{-18.93,28.1},{-18.93,56.47},{-52,56.47},{-52,74}},color = {0,0,127}));
    connect(gain2.y,switch.u1) annotation(Line(points = {{-104.46,118.83},{-52,118.83},{-52,90}},color = {0,0,127}));
    connect(v_cell_SC.y_r,gain2.u) annotation(Line(points = {{-139.83,124.99},{-133.65,124.99},{-133.65,118.83},{-127.46,118.83}},color = {0,0,127}));
    connect(v_cell_SC.systemBus,SCap.controlBus) annotation(Line(points = {{-148.83,124.99},{-158.79,124.99},{-158.79,2.1}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(Use_Supercap.active,switch.u2) annotation(Line(points = {{-121.05,449.24},{-121.05,82},{-52,82}},color = {255,0,255}));

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
end HESS_StateGraph_loop_charger_1;
