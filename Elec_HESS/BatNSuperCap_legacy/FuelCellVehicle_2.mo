within BatNSuperCap_legacy;

model FuelCellVehicle_2 "Fuel cell electric vehicle control and range simulation"
  extends .Modelon.Icons.Experiment;

  .Electrification.Machines.Examples.Machine machine(
    enable_thermal_port=false,
    fixed_temperature=true,
    display_name=true,
    core(
      redeclare replaceable .Electrification.Machines.Core.Limits.Scalar limits(
        I_dc_max_mot=200,
        enable_P_max=true,
        P_max_mot=130000,
        enable_tau_max=true,
        tau_max_mot=300),
      redeclare .Electrification.Machines.Core.Losses.Efficiency lossesMachine(
        enable_table_losses=false, constant_eta=0.97),
      redeclare .Electrification.Machines.Core.Losses.Efficiency
        lossesConverter(enable_table_losses=false, constant_eta=0.97)),
    redeclare replaceable .Electrification.Machines.Mechanical.Gearbox
      mechanical(ratio=10,d_viscous = 0),
    redeclare replaceable .Electrification.Machines.Control.MultiMode controller(
      external_torque=true,mode = Electrification.Utilities.Types.MachineControlMode.Torque)) annotation (
        Placement(transformation(extent={{8,-16},{40,16}})));
  .Electrification.Mechanical.SimpleChassis1D chassis
    annotation (Placement(transformation(extent={{52,-16},{84,16}})));
  .Electrification.Machines.Control.Signals.tau_ref torqueReference(id=machine.id)
    annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=180,
        origin={30,50})));
  .Electrification.Loads.Examples.ConstantPower loads(
    pRef=2000,
    iMax=200,
    display_name=true,
    fixed_temperature=true)
    annotation (Placement(transformation(extent={{48,-66},{80,-34}})));
  .Electrification.Utilities.Blocks.Driver driver(
    redeclare .Electrification.Utilities.DriveCycles.WLTP driveCycle,
    repeat=true,
    tauMax=machine.core.limits.tau_max_mot)
    annotation (Placement(transformation(extent={{80,38},{56,62}})));
  .Electrification.Converters.Examples.AverageStepUpDown converter(
    enable_thermal_port=false,
    display_name=true,
    fixed_temperature = true,
    redeclare replaceable .Electrification.Converters.Control.MultiMode controller(
      mode=.Electrification.Utilities.Types.ConverterMode.PowerA,
      external_pwr_a=true,
      pMaxInA = fuelCell.pRated,
      pMaxOutA = 0,
      iMaxInA = 200,
      iMaxOutA = 0))
    annotation (Placement(transformation(extent={{-20.01,-66.81},{11.99,-34.81}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Electrical.DCInit vInitB(init_start=true, v_start=battery.summary.ocv)
    annotation (Placement(transformation(extent={{0,-80},{12,-68}})));
  .Modelon.Visualizers.RealValue gasConsumption_show(number=fuelCell.calculator.y,
      precision=1)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  .Modelon.Visualizers.RealValue distance_show(number=chassis.s/1000, precision=1)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  .Electrification.Examples.Components.FuelCellController controller(
    pMax=fuelCell.pRated,
    id_Battery=battery.id,
    id_Machine=machine.id,
    id_Converter=converter.id) annotation (Placement(transformation(
        extent={{-90,26},{-70,46}})));
    .Electrification.Batteries.Examples.Applications.FuelCellVehicle battery(enable_thermal_port = false,
    display_name=true) annotation (
      Placement(transformation(extent={{-40.16,-15.68},{-72.16,16.32}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Electrical.DCInit vInitA(init_steady=true)
    annotation (Placement(transformation(extent={{-60,-80},{-48,-68}})));
  .Electrification.Examples.Components.FuelCellDummy fuelCell(display_name=true, emptyAction=.Modelon.Types.FaultAction.Terminate)
    annotation (Placement(transformation(extent={{-48,-66},{-80,-34}})));
equation
  connect(converter.controlBus, controller.controlBus) annotation (Line(
      points={{-16.81,-34.81},{-30,-34.81},{-30,36},{-70,36}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(controller.controlBus, battery.controlBus) annotation (Line(
      points={{-70,36},{-43.36,36},{-43.36,16.32}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(controller.controlBus, machine.controlBus) annotation (Line(
      points={{-70,36},{11.2,36},{11.2,16}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(chassis.velocity, driver.speed_m) annotation (
    Line(points={{68,17.6},{68,36.8}}, color={0,0,127}));
  connect(driver.tau_ref, torqueReference.u_r) annotation (
    Line(points={{54.8,50},{36,50}}, color={0,0,127}));
  connect(machine.flange, chassis.flangeR) annotation (
    Line(points={{40,0},{52,0}},    color={0,0,0}));
  connect(vInitB.plug_a, loads.plug_a) annotation (Line(
      points={{12,-74},{20,-74},{20,-50},{48,-50}},
      color={255,128,0},
      thickness=0.5));
  connect(fuelCell.plug_a, converter.plug_a) annotation (Line(
      points={{-48,-50},{-20.01,-50},{-20.01,-50.81}},
      color={255,128,0},
      thickness=0.5));
  connect(vInitA.plug_a, converter.plug_a) annotation (Line(
      points={{-48,-74},{-40,-74},{-40,-50.81},{-20.01,-50.81}},
      color={255,128,0},
      thickness=0.5));
  connect(battery.plug_a, machine.plug_a) annotation (Line(
      points={{-40.16,0.32},{-40.16,0},{8,0}},
      color={255,128,0},
      thickness=0.5));
  connect(converter.plug_b, loads.plug_a) annotation (Line(
      points={{11.99,-50.81},{11.99,-50},{48,-50}},
      color={255,128,0},
      thickness=0.5));
  connect(machine.plug_a, converter.plug_b) annotation (Line(
      points={{8,0},{-20,0},{-20,-24},{30,-24},{30,-50.81},{11.99,-50.81}},
      color={255,128,0},
      thickness=0.5));
  connect(torqueReference.systemBus, machine.controlBus) annotation (Line(
      points={{26,50},{11.2,50},{11.2,16}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  annotation (
    experiment(StopTime=36000),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-96,96},{-4,88}},
          textColor={0,0,0},
          textString="Hydrogen consumption (L)"), Text(
          extent={{4,96},{96,88}},
          textColor={0,0,0},
          textString="Distance (km)")}),
    Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This example demonstrates a fuel cell providing energy to an electric vehicle via a DC/DC converter in combination with a battery. The experiment is set up to simulate the range of the vehicle, for a certain drive cycle and amount of hydrogen in the fuel cell tank.

<h4>Power supply strategy</h4>
<p>The <em>fuelCell</em> component is the primary supply to the system, while the <em>battery</em> acts as a buffer to filter transient load changes that are too fast for the fuel cell to react to. The battery also stores and provides energy that is regenerated when the vehicle is braking (the fuel cell is unable to receive electric energy). Since the battery is directly connected to the electric <em>machine</em> and auxilary <em>loads</em>, it will always supply any additional power that is consumed that the fuel cell does not provide, and store any excess energy that is not consumed. The power from the fuel cell is actuated by the DC/DC <em>converter</em>, and primarily controlled to maintain a suitable level of energy in the battery for both providing and storing transient power.</p>
<p>The first plot below shows the power consumption of the machine together with the power output from the battery and fuel cell. The second plot shows the state of charge in the battery for the whole simulation. Note that these are zoomed in to a limited part of the simulation.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/FuelCellVehicle_power_and_soc.png\"/></p>

<h4>DC/DC converter control</h4>
<p>The DC/DC converter has been configured to operate in power control mode, based on a reference signal provided from the system <em>controller</em> (<a href=\"modelica://Electrification.Examples.Components.FuelCellController\">FuelCellController</a>) via the control signal bus. The system controller provides the <a href=\"modelica://Electrification.Converters.Control.Signals.pwr_a_ref\">pwr_ref_a</a> signal to the converter, based a target state of charge and feedback from the battery (the <a href=\"modelica://Electrification.Batteries.Control.Signals.SoC_cell\">SoC_cell</a> signal). Additionally, some feed-forward of the machine power (the <a href=\"modelica://Electrification.Machines.Control.Signals.pwr_sns\">pwr_sns</a> signal) is also included.</p>
<p>The controller inside the converter has been configured (in the <em>Limits</em> tab) to only allow power out from the fuel cell, with a maximum corresponding to the rated power. Additionally, a maximum current limit has been configured to prevent unrealistic transients.</p>

<h4>Fuel cell model</h4>
<p>The fuel cell is represented by a simple Thevenin equivalent circuit model (<a href=\"modelica://Electrification.Examples.Components.FuelCellDummy\">FuelCellDummy</a>), that represent the most important electrical dynamics as a boundary condition to the DC/DC converter. A more detailed model of a fuel cell can be integrated in the same way. This &quot;dummy fuel cell&quot; model has been parametrized to roughly match the more detailed model from the <em>Fuel Cell Library</em> by <me>Modelon</em> (<code>FuelCell.Examples.PEMFC.System.FuelCellHybridVehicle</code>).</p>

<h4>Battery</h4>
<p>A small battery pack is represented with a nominal battery model (<a href=\"modelica://Electrification.Batteries.Examples.Applications.FuelCellVehicle\">Batteries.Examples.Applications.FuelCellVehicle</a>) that describes variations in state of charge, and voltage variations depending on the power output.</p>

<h4>Vehicle range</h4>
<p>The fuel cell has been configured to terminate the simulation when the hydrogen tank is empty. This means that the simulation should end before the specified experiment stop time. In this case, the tank has been parametrized to start at 50 % of its full capacity.</p>
<p>The plot below shows the position of the vehicle versus the hydrogen consumption. We can see that the vehicle has traveled almost 300 km after using 70 liters of hydrogen.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/FuelCellVehicle_distance_vs_consumption.png\"/></p>

<h4>Drive cycle</h4>
<p>The range of the vehicle is defined as the accumulated distance traveled, when driven according to a repeated sequence of a specific drive cycle (<a href=\"modelica://Electrification.Utilities.DriveCycles.WLTP\">WLTP</a>, class 3). A 1D chassis model represents the mechanical dynamics (inertia and losses) of the vehicle.</p>
A <a href=\"modelica://Electrification.Utilities.Blocks.Driver\">driver model</a> (speed feedback controller) is used to control the vehicle speed according to follow the speed profile determined by the drive cycle. The plot below shows the reference speed for the first cycle, and the actual measured speed of the vehicle. The measured speed follows the reference more or less. If we look closely, we can see that the speed becomes negative for a short moment before the vehicle reach regions of standstill. This is because braking of the vehicle is only applied via the electric machine (no friction brakes), and the driver is not configured to avoid these &quot;undershoots&quot;.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_ElectricRange_Speed.png\"/></p>
<p>The driver provides a reference torque for the machine connected to the wheels of the vehicle chassis. The torque reference is provided to the machine as a signal via the system control bus, using a <a href=\"modelica://Electrification.Machines.Control.Signals.tau_ref\">signal adapter</a> (more about this in the <a href=\"modelica://Electrification.Information.UsersGuide.BasicConcepts.ControllersAndSignals\">User&apos;s Guide</a>). Note that the machine id is specified in the adapter to address the machine on the system control bus.</p>

<h4>Voltage initialization</h4>
<p>The machine and converter components both contain link capacitors that act as additional energy buffers. 
The voltage of these capacitors need to be initialized to avoid excessive transient in-rush currents at the start of the simulation. 
This is done using the two <a href=\"modelica://Electrification.Electrical.DCInit\">DCInit</a> components (<em>vInitA/B</em>).</p>

</html>"));
end FuelCellVehicle_2;
