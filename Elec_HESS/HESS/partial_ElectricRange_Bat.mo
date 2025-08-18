within HESS;

partial model partial_ElectricRange_Bat "Range of battery electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Batteries.Examples.Applications.ElectricCar battery(
    enable_thermal_port=false,
    enable_control_bus=true,
    display_name=true,
    fixed_temperature=true,
    SOC_start=0.9,
    SoC_max=1.0,
    SoC_min=0.1,
    limitActionSoC=.Modelon.Types.FaultAction.Terminate)
      annotation (Placement(transformation(extent={{-50.16,-16.0},{-82.16,16.0}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Machines.Examples.Applications.ElectricCar machine(
    enable_thermal_port=false,
    fixed_temperature=true,
    display_name=true,
    redeclare replaceable .Electrification.Machines.Control.LimitedTorque controller(
      external_limits=true,
      listen=true,
      id_listen=battery.id,
      typeListen=.Electrification.Utilities.Types.ControllerType.Battery,
      torqueControl(external_torque=true))) annotation (
        Placement(transformation(extent={{-12.0,-16.0},{20.0,16.0}})));
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
  .Electrification.Electrical.DCInit vInitA(init_steady=true, stateSelect=StateSelect.avoid) annotation (
    Placement(transformation(extent={{-70,-60},{-50,-40}})));
  .Electrification.Utilities.Blocks.Driver driver(
    k=1,
    Ti=2,
    torque_output=false,
    redeclare .Electrification.Utilities.DriveCycles.WLTP driveCycle,
    repeat=true)
    annotation (Placement(transformation(extent={{86,40},{66,60}})));
  .Electrification.Mechanical.IdealBrake brakes(enable_mount=false) annotation (Placement(transformation(extent={{28,-12},{52,12}})));
  .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(
    number_of_motors_front=0,
    number_of_motors_rear=1,
    tauMax=machine.core.limits.tau_max_mot)
    annotation (Placement(transformation(extent={{50,40},{30,60}})));
equation
  connect(chassis.velocity, driver.speed_m)
    annotation (Line(points={{76,17.6},{76,39}},   color={0,0,127}));
  connect(vInitA.plug_a, battery.plug_a) annotation (Line(
      points={{-50,-50},{-30,-50},{-30,0},{-50.16,0}},
      color={255,128,0},
      thickness=0.5));
  connect(machine.plug_a, battery.plug_a) annotation (Line(
      points={{-12,0},{-50.16,0}},
      color={255,128,0},
      thickness=0.5));
  connect(tau_ref.systemBus, machine.controlBus) annotation (Line(
      points={{0,50},{-20,50},{-20,16},{-8.8,16}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueArbitration.tau_brake_ref, brakes.u)
    annotation (Line(points={{29,44},{20,44},{20,26},{40,26},{40,13.2}}, color={0,0,127}));
  connect(torqueArbitration.veh_vel_x, chassis.velocity) annotation (
    Line(points={{40,38},{40,32},{76,32},{76,17.6}}, color={0,0,127}));
  connect(battery.controlBus, machine.controlBus) annotation (Line(
      points={{-53.36,16},{-8.8,16}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueArbitration.tau_ref_rear[1], tau_ref.u_r) annotation (Line(points={{29,50},{10,50}}, color={0,0,127}));
  connect(machine.flange, chassis.flangeR) annotation (Line(points={{20,0},{60,0}}, color={0,0,0}));
  connect(brakes.flange_a, chassis.flangeR) annotation (Line(points={{40,0},{60,0}}, color={0,0,0}));
  connect(driver.acc_cmd, torqueArbitration.acc_cmd) annotation (Line(points={{65,56},{52,56}}, color={0,0,127}));
  connect(driver.brk_cmd, torqueArbitration.brk_cmd) annotation (Line(points={{65,44},{52,44}}, color={0,0,127}));

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
end partial_ElectricRange_Bat;
