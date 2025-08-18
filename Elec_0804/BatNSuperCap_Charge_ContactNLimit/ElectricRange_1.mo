within BatNSuperCap_Charge_ContactNLimit;

model ElectricRange_1 "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Batteries.Examples.Applications.ElectricCar SCap(
    enable_thermal_port=false,
    enable_control_bus=true,
    display_name=true,
    fixed_temperature=true,
    SOC_start=0.6,
    SoC_max=1.0,
    SoC_min=0.1,
    limitActionSoC=.Modelon.Types.FaultAction.Error,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionI = .Modelon.Types.FaultAction.Warning,ns = 100,np = 120,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsFixed controller1,redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2))
      annotation (Placement(transformation(extent={{-143.83,-15.95},{-175.83,16.05}},rotation = 0.0,origin = {0.0,0.0})));

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
        Placement(transformation(extent={{-11.8,-16.33},{20.2,15.67}},rotation = 0.0,origin = {0.0,0.0})));
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
    CrConstant=0.00845431,initialize_velocity = false,initialize_position = false)
    annotation (Placement(transformation(extent={{60,-16},{92,16}})));
  .Electrification.Machines.Control.Signals.tau_ref tau_ref(id=machine.id)
    annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=180,
        origin={4,50})));
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.avoid,init_start = true,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-152.75,-65.02},{-132.75,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.Driver driver(
    k=1,
    Ti=2,
    torque_output=false,
    redeclare .Electrification.Utilities.DriveCycles.WLTP driveCycle,
    repeat=true)
    annotation (Placement(transformation(extent={{86.16,40.0},{66.16,60.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.IdealBrake brakes(enable_mount=false) annotation (Placement(transformation(extent={{27.65,-11.65},{51.65,12.35}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(
    number_of_motors_front=0,
    number_of_motors_rear=1,
    tauMax=machine.core.limits.tau_max_mot,regen_torque = 100)
    annotation (Placement(transformation(extent={{50.0,39.61},{30.0,59.61}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,i_a_ref = -SCap.i_nom_1C,external_limits = true,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = true,iMaxInB = 500,external_i_a = true),common_mode = true,internal_ground = true) annotation(Placement(transformation(extent = {{-93.49,-10.43},{-113.49,9.57}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = -0.1,uHigh = 0,pre_y_start = false) annotation(Placement(transformation(extent = {{15.88,69.09},{-4.12,89.09}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{72.34,317.07},{92.34,337.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 2,nOut = 1) annotation(Placement(transformation(extent = {{-103.52,311.39},{-83.52,331.39}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SC(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-2.75,311.21},{17.25,331.21}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.2,enableTimer = false) annotation(Placement(transformation(extent = {{-59.97,311.38},{-39.97,331.38}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-53.62,138.46})));
    .Modelica.Blocks.Math.Gain convCrate(k = batty.np / ((batty.i_nom_1C))) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-53.48,178.83})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = false,uHigh = 0.5,uLow = 0) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-51.87,248.98000000000002})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-93.26,169.66})));
    .Electrification.Batteries.Control.Signals.i_cell i_cell(id = batty.id) annotation(Placement(transformation(extent = {{-4.0,-4.0},{4.0,4.0}},origin = {-48.46,86.1},rotation = -90.0)));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-16.42,-111.6},{3.58,-91.6}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-133.67,57.18},{-125.67,65.18}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(Electrification.Utilities.Types.ConverterMode.CurrentB),integerTrue = Integer(Electrification.Utilities.Types.ConverterMode.CurrentA)) annotation(Placement(transformation(extent = {{-181.47,51.85},{-161.47,71.85}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-204.1,82.1},rotation = -90.0)));
    .Electrification.Converters.Control.Signals.i_b_ref i_b_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-4.0,-4.0},{4.0,4.0}},origin = {-118.38,35.42},rotation = -90.0)));
    .Modelica.Blocks.Math.BooleanToReal OnSC(realTrue = -SCap.i_nom_1C) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-118.25,104.72},rotation = -90.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 60,ns = 100,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionSoC = .Modelon.Types.FaultAction.Error,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.ContactorControl controller1(contactors_closed = true,external_control = true),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical) annotation(Placement(transformation(extent = {{-84.14,-116.27},{-116.14,-84.27}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal Back2Batt(enableTimer = true,waitTime = 1) annotation(Placement(transformation(extent = {{-41.44,373.09},{-61.44,393.09}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.i_a_ref i_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-140.76,31.75},{-132.76,39.75}},origin = {0,0},rotation = 0)));
    .Electrification.Batteries.Control.Signals.i_cell i_cell_SC(id = SCap.id) annotation(Placement(transformation(extent = {{-4,-4},{4,4}},origin = {-243.92,281.08},rotation = -90)));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10,-10},{10,10}},rotation = 90,origin = {-244.15,311.09})));
    .Modelica.Blocks.Math.Gain convCrate2(k = SCap.np / ((batty.i_nom_1C))) annotation(Placement(transformation(extent = {{-235.22,350.14},{-215.22,370.14}},rotation = 0,origin = {0,0})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0,uHigh = 0.5,pre_y_start = false) annotation(Placement(transformation(extent = {{-194.31,370.35},{-174.31,350.35}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-159.02,349.64},{-139.02,369.64}},origin = {0,0},rotation = 0)));
equation
  connect(chassis.velocity, driver.speed_m)
    annotation (Line(points={{76,17.6},{76,39},{76.16,39}},   color={0,0,127}));
  connect(tau_ref.systemBus, machine.controlBus) annotation (Line(
      points={{0,50},{-8.6,50},{-8.6,15.67}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueArbitration.tau_brake_ref, brakes.u)
    annotation (Line(points={{29,43.61},{20,43.61},{20,26},{39.65,26},{39.65,13.55}}, color={0,0,127}));
  connect(torqueArbitration.veh_vel_x, chassis.velocity) annotation (
    Line(points={{40,37.61},{40,32},{76,32},{76,17.6}}, color={0,0,127}));
  connect(torqueArbitration.tau_ref_rear[1], tau_ref.u_r) annotation (Line(points={{29,49.61},{29,50},{10,50}}, color={0,0,127}));
  connect(machine.flange, chassis.flangeR) annotation (Line(points={{20.2,-0.33},{60,-0.33},{60,0}}, color={0,0,0}));
  connect(brakes.flange_a, chassis.flangeR) annotation (Line(points={{39.65,0.35},{39.65,0},{60,0}}, color={0,0,0}));
  connect(driver.acc_cmd, torqueArbitration.acc_cmd) annotation (Line(points={{65.16,56},{52,56},{52,55.61}}, color={0,0,127}));
  connect(driver.brk_cmd, torqueArbitration.brk_cmd) annotation (Line(points={{65.16,44},{52,44},{52,43.61}}, color={0,0,127}));
    connect(averageStepUpDownDCDC.plug_b,SCap.plug_a) annotation(Line(points = {{-113.49,-0.43},{-130.42,-0.43},{-130.42,0.05},{-143.83,0.05}},color = {255,128,0}));
    connect(machine.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-8.6,15.67},{-95.49,15.67},{-95.49,9.57}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{-11.8,-0.33},{-32.8,-0.33},{-32.8,-0.43},{-93.49,-0.43}},color = {255,128,0}));
    connect(vInitA.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-132.75,-55.02},{-119.83,-55.02},{-119.83,-0.43},{-113.49,-0.43}},color = {255,128,0}));
    connect(torqueArbitration.tau_ref_rear[1],hysteresis.u) annotation(Line(points = {{29,49.61},{29,79.09},{17.88,79.09}},color = {0,0,127}));
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-53.62,149.46},{-53.62,166.83},{-53.48,166.83}},color = {0,0,127}));
    connect(hysteresis2.y,HighCurrent.condition) annotation(Line(points = {{-51.87,259.98},{-51.87,284.47},{-49.97,284.47},{-49.97,309.38}},color = {255,0,255}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-53.48,189.83},{-53.48,227.9},{-51.87,227.9},{-51.87,236.98}},color = {0,0,127}));
    connect(i_cell.y_r,absI.u) annotation(Line(points = {{-48.46,91.1},{-48.46,109.39},{-53.62,109.39},{-53.62,126.46}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-93.52,310.39},{-93.52,212.14},{-93.26,212.14},{-93.26,182.04}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-83.02,321.39},{-69.43,321.39},{-69.43,321.38},{-53.97,321.38}},color = {0,0,0}));
    connect(HighCurrent.outPort,SC.inPort[1]) annotation(Line(points = {{-48.47,321.38},{-3.75,321.38},{-3.75,321.21}},color = {0,0,0}));
    connect(transition.outPort,Bat.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-104.52,321.07},{-104.52,321.39}},color = {0,0,0}));
    connect(and1.y,booleanToInteger.u) annotation(Line(points = {{-204.1,71.1},{-204.1,61.85},{-183.47,61.85}},color = {255,0,255}));
    connect(SC.active,and1.u2) annotation(Line(points = {{7.25,310.21},{7.25,231.51},{-212.1,231.51},{-212.1,94.1}},color = {255,0,255}));
    connect(hysteresis.y,and1.u1) annotation(Line(points = {{-5.12,79.09},{-10.69,79.09},{-10.69,129.22},{-204.1,129.22},{-204.1,94.1}},color = {255,0,255}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-160.47,61.85},{-135.67,61.85},{-135.67,61.18}},color = {255,127,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-125.67,61.18},{-95.49,61.18},{-95.49,9.57}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(i_b_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-118.38,31.42},{-118.38,23.39},{-95.49,23.39},{-95.49,9.57}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCap.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-147.03,16.05},{-147.03,20.36},{-95.49,20.36},{-95.49,9.57}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{3.58,-101.6},{-84.14,-101.6},{-84.14,-100.27}},color = {255,128,0}));
    connect(i_cell.systemBus,batty.controlBus) annotation(Line(points = {{-48.46,82.1},{-48.46,-1.08},{-87.34,-1.08},{-87.34,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-93.26,161.41},{-93.26,-84.27},{-87.34,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,batty.plug_a) annotation(Line(points = {{-11.8,-0.33},{-47.87,-0.33},{-47.87,-100.27},{-84.14,-100.27}},color = {255,128,0}));
    connect(Back2Batt.inPort,SC.outPort[1]) annotation(Line(points = {{-47.44,383.09},{23.44,383.09},{23.44,321.21},{17.75,321.21}},color = {0,0,0}));
    connect(Back2Batt.outPort,Bat.inPort[2]) annotation(Line(points = {{-52.94,383.09},{-110.23,383.09},{-110.23,321.39},{-104.52,321.39}},color = {0,0,0}));
    connect(OnSC.y,i_b_ref.u_r) annotation(Line(points = {{-118.25,93.72},{-118.25,72.51},{-118.38,72.51},{-118.38,41.42}},color = {0,0,127}));
    connect(hysteresis2.y,OnSC.u) annotation(Line(points = {{-51.87,259.98},{-51.87,264.88},{-118.25,264.88},{-118.25,116.72}},color = {255,0,255}));
    connect(OnSC.y,i_a_ref.u_r) annotation(Line(points = {{-118.25,93.72},{-118.25,88.72},{-148.76,88.72},{-148.76,35.75},{-142.76,35.75}},color = {0,0,127}));
    connect(i_a_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-132.76,35.75},{-95.49,35.75},{-95.49,9.57}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(i_cell_SC.systemBus,SCap.controlBus) annotation(Line(points = {{-243.92,277.08},{-243.92,75.83},{-147.03,75.83},{-147.03,16.05}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(absI2.u,i_cell_SC.y_r) annotation(Line(points = {{-244.15,299.09},{-244.15,292.4},{-243.92,292.4},{-243.92,286.08}},color = {0,0,127}));
    connect(convCrate2.u,absI2.y) annotation(Line(points = {{-237.22,360.14},{-244.15,360.14},{-244.15,322.09}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate2.y) annotation(Line(points = {{-196.31,360.35},{-205.265,360.35},{-205.265,360.14},{-214.22,360.14}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-173.31,360.35},{-167.16500000000002,360.35},{-167.16500000000002,359.64},{-161.02,359.64}},color = {255,0,255}));
    connect(not1.y,Back2Batt.condition) annotation(Line(points = {{-138.02,359.64},{-51.44,359.64},{-51.44,371.09}},color = {255,0,255}));

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
end ElectricRange_1;
