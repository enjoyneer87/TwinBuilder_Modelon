within BatNSuperCap_legacy;

model HESS_StateGraph_EV_1 "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Electrical.DCInit vInitA(init_steady=true, stateSelect=StateSelect.default,init_start = false,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-153.51,-65.02},{-133.51,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.PowerA,external_limits = false,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = false,iMaxInB = 500,external_i_a = false,iMaxInA = 200,pMaxInA = 1e16,pMaxInB = 1e16,external_pwr_b = false,external_pwr_a = false,pwr_a_ref = machine.controller.limits.pMaxIn,aggregate_limits = false),common_mode = false,internal_ground = false) annotation(Placement(transformation(extent = {{-109.68,-14.24},{-89.68,5.76}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{96.31,397.19},{116.31,417.19}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-103.52,312.24},{-83.52,332.24}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.1,enableTimer = true) annotation(Placement(transformation(extent = {{-58.05,312.4},{-38.05,332.4}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.0,138.0})));
    .Modelica.Blocks.Math.Gain convCrate(k = 1 / ((batty.i_nom_1C))) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.760000000000005,179.57})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = true,uHigh = 0.5,uLow = 0.35) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-53.97,237.14})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-92.97,169.66})));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-88.27,-180.43},{-68.27,-160.43}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-131.95,59.06},{-123.95,67.06}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.Disabled),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerA)) annotation(Placement(transformation(extent = {{-180.46,54.53},{-160.46,74.53}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 180,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionSoC = .Modelon.Types.FaultAction.Terminate,SoC_min = 0,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller(contactors(contactors_closed = false,external_control = true,enable_pre_charge = true)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6)) annotation(Placement(transformation(extent = {{-117.64,-151.01},{-149.64,-119.01}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-19.13,311.97},{0.87,331.97}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 5) annotation(Placement(transformation(extent = {{-86.07,362.1},{-66.07,382.1}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain convCrate3(k = 20 * SCap.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-332.0,300.0})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-334.49,260.05})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0.01,uHigh = 0.5,pre_y_start = false) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-332.0,332.0})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-312.97,346.03},{-292.97,366.03}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.SCCap SCap(initialize_with_OCV = false,redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIsolated electrical,redeclare replaceable .Electrification.Batteries.Control.LimitsTabular controller(external_enable = false),limitActionSoC = .Modelon.Types.FaultAction.Terminate) annotation(Placement(transformation(extent = {{-206.32,-13.34},{-226.32,6.66}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor annotation(Placement(transformation(extent = {{-5.71,-14.02},{14.29,5.98}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Examples.Applications.ElectricCar machine(initialize_angle = true,initialize_speed = true,redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(torqueControl(external_torque = true),typeListen = .Electrification.Utilities.Types.ControllerType.Battery,id_listen = batty.id,listen = true,external_limits = false),display_name = true,fixed_temperature = true,enable_thermal_port = false,core(controller_limits = true)) annotation(Placement(transformation(extent = {{47.25,-20.93},{79.25,11.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.SimpleChassis1D chassis(initialize_position = false,initialize_velocity = false,CrConstant = 0.00845431,rho = 1,Cd = 0.339628,A = 2.25,d = 0.73196,KX = 98300,Rl = 0.335901,lambda = 0.561118,ideal_wheel = false,R = 0.35155,m = 1800) annotation(Placement(transformation(extent = {{166.1,-15.82},{198.1,16.18}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Control.Signals.tau_ref tau_ref(id = machine.id) annotation(Placement(transformation(extent = {{-4.0,4.0},{4.0,-4.0}},rotation = 180.0,origin = {71.63,62.7})));
    .Electrification.Utilities.Blocks.Driver driver(repeat = true,redeclare replaceable .Electrification.Utilities.DriveCycles.AccelerateDecelerate driveCycle,torque_output = false,Ti = 2,k = 1) annotation(Placement(transformation(extent = {{164.24,56.09},{144.24,76.09}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.IdealBrake brakes(enable_mount = false) annotation(Placement(transformation(extent = {{109.16,-10.82},{133.16,13.18}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(v_max = 270.777,regen_torque = 300,tauMax = machine.core.limits.tau_max_mot,number_of_motors_rear = 1,number_of_motors_front = 0) annotation(Placement(transformation(extent = {{114.94,43.91},{94.94,63.91}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{7.51,-120.73},{24.05,-104.19}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor3 annotation(Placement(transformation(extent = {{-176.99,-12.82},{-156.99,7.18}},origin = {0.0,0.0},rotation = 0.0)));
equation
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-54,149},{-54,167.57},{-54.76,167.57}},color = {0,0,127}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-54.76,190.57},{-53.97,225.14}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-93.52,311.24},{-93.52,212.14},{-92.97,212.14},{-92.97,182.04}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-83.02,322.24},{-69.43,322.24},{-69.43,322.4},{-52.05,322.4}},color = {0,0,0}));
    connect(transition.outPort,Bat.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-104.52,321.07},{-104.52,322.24}},color = {0,0,0}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-159.46,64.53},{-133.95,64.53},{-133.95,63.06}},color = {255,127,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-123.95,63.06},{-107.68,63.06},{-107.68,5.76}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-68.27,-170.43},{-13.97,-170.43},{-13.97,-135.01},{-117.64,-135.01}},color = {255,128,0}));
    connect(HighCurrent.outPort,SCon.inPort[1]) annotation(Line(points = {{-46.55,322.4},{-32.4,322.4},{-32.4,321.97},{-20.13,321.97}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{1.37,321.97},{13.11,321.97},{13.11,372.1},{-80.07,372.1}},color = {0,0,0}));
    connect(lowCurrentSCap.outPort,initialStep.inPort[1]) annotation(Line(points = {{-74.57,372.1},{-162.66,372.1},{-162.66,321.07},{-157.66,321.07}},color = {0,0,0}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-332,288},{-332,278.97},{-334.49,278.97},{-334.49,271.05}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate3.y) annotation(Line(points = {{-332,320},{-332,311}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-332,343},{-332,356.03},{-314.97,356.03}},color = {255,0,255}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-107.68,5.76},{-107.68,16.79},{-208.32,16.79},{-208.32,6.66}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCon.active,booleanToInteger.u) annotation(Line(points = {{-9.13,310.97},{-9.13,303.61},{-188,303.61},{-188,64.53},{-182.46,64.53}},color = {255,0,255}));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{182.1,17.78},{182.1,23.15},{154.24,23.15},{154.24,55.09}},color = {0,0,127}));
    connect(tau_ref.systemBus,machine.controlBus) annotation(Line(points = {{67.63,62.7},{50.45,62.7},{50.45,11.07}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(torqueArbitration.tau_brake_ref,brakes.u) annotation(Line(points = {{93.94,47.91},{93.94,26.62},{121.16,26.62},{121.16,14.38}},color = {0,0,127}));
    connect(torqueArbitration.veh_vel_x,chassis.velocity) annotation(Line(points = {{104.94,41.91},{104.94,32.62},{182.1,32.62},{182.1,17.78}},color = {0,0,127}));
    connect(torqueArbitration.tau_ref_rear[1],tau_ref.u_r) annotation(Line(points = {{93.94,53.91},{93.94,62.7},{77.63,62.7}},color = {0,0,127}));
    connect(driver.acc_cmd,torqueArbitration.acc_cmd) annotation(Line(points = {{143.24,72.09},{124.49,72.09},{124.49,59.91},{116.94,59.91}},color = {0,0,127}));
    connect(driver.brk_cmd,torqueArbitration.brk_cmd) annotation(Line(points = {{143.24,60.09},{125.16,60.09},{125.16,47.91},{116.94,47.91}},color = {0,0,127}));
    connect(machine.plug_a,dCSensor.plug_b) annotation(Line(points = {{47.25,-4.93},{32.43,-4.93},{32.43,-4.02},{14.29,-4.02}},color = {255,128,0}));
    connect(chassis.flangeR,brakes.flange_a) annotation(Line(points = {{166.1,0.18},{166.1,1.18},{121.16,1.18}},color = {0,0,0}));
    connect(machine.flange,brakes.flange_a) annotation(Line(points = {{79.25,-4.93},{121.16,-4.93},{121.16,1.18}},color = {0,0,0}));
    connect(dCSensor.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-5.71,-4.02},{-46.87,-4.02},{-46.87,-4.24},{-89.68,-4.24}},color = {255,128,0}));
    connect(dCSensor2.y[2],absI.u) annotation(Line(points = {{15.78,-119.9},{15.78,-125.9},{-54,-125.9},{-54,126}},color = {0,0,127}));
    connect(machine.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{50.45,11.07},{50.45,17.07},{-107.68,17.07},{-107.68,5.76}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,dCSensor2.plug_b) annotation(Line(points = {{47.25,-4.93},{35.81,-4.93},{35.81,-112.46},{24.05,-112.46}},color = {255,128,0}));
    connect(dCSensor2.plug_a,batty.plug_a) annotation(Line(points = {{7.51,-112.46},{-55.06,-112.46},{-55.06,-135.01},{-117.64,-135.01}},color = {255,128,0}));
    connect(batty.controlBus,close_contactors.systemBus) annotation(Line(points = {{-120.84,-119.01},{-79.03,-119.01},{-79.03,21.2},{-92.97,21.2},{-92.97,161.41}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.controlBus,batty.controlBus) annotation(Line(points = {{50.45,11.07},{50.45,17.07},{-120.84,17.07},{-120.84,-119.01}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-291.97,356.03},{-286.97,356.03},{-286.97,354.1},{-76.07,354.1},{-76.07,360.1}},color = {255,0,255}));
    connect(averageStepUpDownDCDC.plug_a,dCSensor3.plug_a) annotation(Line(points = {{-109.68,-4.24},{-140.23,-4.24},{-140.23,-2.82},{-176.99,-2.82}},color = {255,128,0}));
    connect(dCSensor3.plug_a,SCap.plug_a) annotation(Line(points = {{-176.99,-2.82},{-191.65,-2.82},{-191.65,-3.34},{-206.32,-3.34}},color = {255,128,0}));
    connect(vInitA.plug_a,SCap.plug_a) annotation(Line(points = {{-133.51,-55.02},{-127.51,-55.02},{-127.51,-3.34},{-206.32,-3.34}},color = {255,128,0}));
    connect(dCSensor3.y[2],absI2.u) annotation(Line(points = {{-166.99,-11.82},{-166.99,-17.82},{-334.49,-17.82},{-334.49,248.05}},color = {0,0,127}));
    connect(hysteresis2.y,HighCurrent.condition) annotation(Line(points = {{-53.97,248.14},{-53.97,279.27},{-48.05,279.27},{-48.05,310.4}},color = {255,0,255}));

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
end HESS_StateGraph_EV_1;
