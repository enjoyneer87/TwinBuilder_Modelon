within BatNSuperCap_Charge_ContactNLimit;

model ElectricRange_wDCDC "Range of battery electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Batteries.Examples.Applications.ElectricCar battery(
    enable_thermal_port=false,
    enable_control_bus=true,
    display_name=true,
    fixed_temperature=true,
    SOC_start=0.6,
    SoC_max=1.0,
    SoC_min=0.1,
    limitActionSoC=Modelon.Types.FaultAction.Error,limitActionV = Modelon.Types.FaultAction.Warning,limitActionI = Modelon.Types.FaultAction.Warning,ns = 100,np = 120)
      annotation (Placement(transformation(extent={{-89.74,-16.49},{-121.74,15.51}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Machines.Examples.Applications.ElectricCar machine(
    enable_thermal_port=false,
    fixed_temperature=true,
    display_name=true,
    redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(
      external_limits=true,
      listen=true,
      id_listen=averageStepUpDownDCDC.id,
      typeListen=Electrification.Utilities.Types.ControllerType.Converter,
      torqueControl(external_torque=true))) annotation (
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
    CrConstant=0.00845431)
    annotation (Placement(transformation(extent={{60,-16},{92,16}})));
  .Electrification.Machines.Control.Signals.tau_ref tau_ref(id=machine.id)
    annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=180,
        origin={4,50})));
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.avoid,init_start = true,v_start = battery.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-69.97,-59.84},{-49.97,-39.84}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.Driver driver(
    k=1,
    Ti=2,
    torque_output=false,
    redeclare .Electrification.Utilities.DriveCycles.WLTP driveCycle,
    repeat=false)
    annotation (Placement(transformation(extent={{86.16,40.0},{66.16,60.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.IdealBrake brakes(enable_mount=false) annotation (Placement(transformation(extent={{28.0,-12.0},{52.0,12.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(
    number_of_motors_front=0,
    number_of_motors_rear=1,
    tauMax=machine.core.limits.tau_max_mot,regen_torque = 300)
    annotation (Placement(transformation(extent={{50.0,40.0},{30.0,60.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = Electrification.Utilities.Types.ConverterMode.CurrentA,i_a_ref = -battery.i_nom_1C,external_limits = true,listen = true,id_listen = battery.id,typeListen = Electrification.Utilities.Types.ControllerType.Battery,i_b_ref = -battery.i_nom_1C)) annotation(Placement(transformation(extent = {{-39.45,-10.36},{-59.45,9.64}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-61.14,35.43},{-53.14,43.43}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerTrue = Integer(Electrification.Utilities.Types.ConverterMode.CurrentB),integerFalse = Integer(Electrification.Utilities.Types.ConverterMode.CurrentA)) annotation(Placement(transformation(extent = {{-100.06,30.0},{-80.06,50.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = -0.1,uHigh = 0) annotation(Placement(transformation(extent = {{-101.37,65.47},{-121.37,85.47}},origin = {0.0,0.0},rotation = 0.0)));
equation
  connect(chassis.velocity, driver.speed_m)
    annotation (Line(points={{76,17.6},{76,39},{76.16,39}},   color={0,0,127}));
  connect(tau_ref.systemBus, machine.controlBus) annotation (Line(
      points={{0,50},{-21.12,50},{-21.12,20.78},{-8.6,20.78},{-8.6,15.67}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueArbitration.tau_brake_ref, brakes.u)
    annotation (Line(points={{29,44},{20,44},{20,26},{40,26},{40,13.2}}, color={0,0,127}));
  connect(torqueArbitration.veh_vel_x, chassis.velocity) annotation (
    Line(points={{40,38},{40,32},{76,32},{76,17.6}}, color={0,0,127}));
  connect(torqueArbitration.tau_ref_rear[1], tau_ref.u_r) annotation (Line(points={{29,50},{10,50}}, color={0,0,127}));
  connect(machine.flange, chassis.flangeR) annotation (Line(points={{20.2,-0.33},{20.2,0},{60,0}}, color={0,0,0}));
  connect(brakes.flange_a, chassis.flangeR) annotation (Line(points={{40,0},{60,0}}, color={0,0,0}));
  connect(driver.acc_cmd, torqueArbitration.acc_cmd) annotation (Line(points={{65.16,56},{52,56}}, color={0,0,127}));
  connect(driver.brk_cmd, torqueArbitration.brk_cmd) annotation (Line(points={{65.16,44},{52,44}}, color={0,0,127}));
    connect(averageStepUpDownDCDC.plug_b,battery.plug_a) annotation(Line(points = {{-59.45,-0.36},{-76.62,-0.36},{-76.62,-0.49},{-89.74,-0.49}},color = {255,128,0}));
    connect(machine.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-8.6,15.67},{-41.45,15.67},{-41.45,9.64}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{-11.8,-0.33},{-32.8,-0.33},{-32.8,-0.36},{-39.45,-0.36}},color = {255,128,0}));
    connect(vInitA.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-49.97,-49.84},{-44,-49.84},{-44,-24.84},{-65.13,-24.84},{-65.13,-0.36},{-59.45,-0.36}},color = {255,128,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-53.14,39.43},{-41.45,39.43},{-41.45,9.64}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-79.06,40},{-72.67,40},{-72.67,39.43},{-63.14,39.43}},color = {255,127,0}));
    connect(torqueArbitration.tau_ref_rear[1],hysteresis.u) annotation(Line(points = {{29,50},{29,59.02},{-36.99,59.02},{-36.99,75.47},{-99.37,75.47}},color = {0,0,127}));
    connect(hysteresis.y,booleanToInteger.u) annotation(Line(points = {{-122.37,75.47},{-128.21,75.47},{-128.21,40},{-102.06,40}},color = {255,0,255}));
    connect(averageStepUpDownDCDC.controlBus,battery.controlBus) annotation(Line(points = {{-41.45,9.64},{-41.45,22.17},{-92.94,22.17},{-92.94,15.51}},color = {240,170,40},pattern = LinePattern.Dot));

annotation (
    experiment(StopTime=22000),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This example demonstrates an experiment for predicting the range of an electric vehicle. The powertrain for the vehicle consists of a battery pack, an electric machine, and an electric load that represents additional consumers in the vehicle. The mechanics of the vehicle are captured by a simple 1D chassis model. A model of the friction brakes are also included, as well as control for blending the friction braking with electric regeneration. The driver controls the vehicle speed to follow a repeated sequence of the <a href=\"modelica://Electrification.Utilities.DriveCycles.WLTP\">WLTP</a> cycle (class 3).</p>

<h4>Electric range</h4>
<p>The range of the vehicle is here defined as the distance that the vehicle travels, when driven according to a repeated sequence of a specific drive cycle. The simulation starts with a fully charged battery, at 90 &percnt; SoC. And a monitor in the battery has been configured to stop the simulation when the battery is depleated to 10 &percnt; SoC (configured in the Limits tab of the battery model).</p>
<p>Note that the SoC here defines the full capacity of the battery. This assumes that the capacity of the battery has been parametrized in this way, and that we only allow using a limited window of this capacity. If we instead have parametrized the usable capacity of tha battery, we would initialize the battery at 100 &percnt; SoC and stop the simulation at 0 &percnt; SoC.</p>

<h4>Drive cycle</h4>
<p>A <a href=\"modelica://Electrification.Utilities.Blocks.Driver\">driver model</a> (speed feedback controller) is used to control the vehicle speed according to follow the speed profile determined by the WLTP cycle. The plot below shows the reference speed for the first cycle, and the actual measured speed of the vehicle. The measured speed follows the reference more or less.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_Speed.png\"/></p>

<h4>Torque arbitrarion and brake blending</h4>
<p>The driver provides acceleration and braking commands to the powertrain. These commands are translated into a torque &quot;request&quot; to the electric machine and the friction brakes, via the <em>torqueArbitraton</em> control block. This includese a brake blending strategy, to complement the friction brakes with the electric machine to regenerate energy back into the battery.</p>

<p>Note: The friction brake model use a normalized diameter, such that the input signal corresponds to torque.</p>

<p>A reference torque is provided to the machine as a signal via the system control bus, using a <a href=\"modelica://Electrification.Machines.Control.Signals.tau_ref\">signal adapter</a> (more about this in the <a href=\"modelica://Electrification.Information.UsersGuide.BasicConcepts.ControllersAndSignals\">User&apos;s Guide</a>). Note that the machine id is specified in the adapter to address the machine on the system control bus.</p>

<p>The plot below shows the acceleration and braking command from the driver, along with the torque from the electric machine and the friction brakes.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_TorqueArbitration.png\"/></p>

<h4>Range (distance)</h4>
<p>The plot below shows the position of the vehicle versus the SoC of the battery. We can see that the vehicle has traveled 272 km when the battery is depleted.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_Position.png\"/></p>

<h4>Energy losses</h4>
<p>The plot below shows the energy lost to heat in the battery, the machine, the brakes, as well as the energy lost to the additional loads. For comparison, the total energy output from the battery is also shown.</p>
<p>Note that the <b>loads</b> component has been parametrized with a loss factor of 100 &percnt; (<code>k_loss=1</code>) such that all of the consumed energy is reported as losses (dissipated as heat).</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_Losses.png\"/></p>
</html>"));
end ElectricRange_wDCDC;
