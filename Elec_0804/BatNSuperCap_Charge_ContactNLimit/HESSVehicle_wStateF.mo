within BatNSuperCap_Charge_ContactNLimit;
model HESSVehicle_wStateF
  "Battery-SuperCap HESS electric vehicle (no fuel cell)"


  extends .Modelon.Icons.Experiment;
  /* ───────── 추가 ①: 파생 함수가 필요 없는 래퍼 ───────── */
/*────────────────────────── 래퍼 함수 ──────────────────────────*/

  /*──────────────────────────────────────────────
   * 1. HESS Controller
   *──────────────────────────────────────────────*/
  BatNSuperCap_Charge_ContactNLimit.HESSControllerOuter hESSControllerOuter(
    id_Battery=battery.id,
    id_Machine=machine.id,
    id_Converter=dcdcSC.id) annotation (
      Placement(transformation(extent={{-209.06,85.72},{-185.06,109.72}},rotation = 0.0,origin = {0.0,0.0})));

  /*──────────────────────────────────────────────
   * 2. Drive
   *──────────────────────────────────────────────*/
  .Electrification.Machines.Examples.Machine machine(
    enable_thermal_port=false,
    fixed_temperature=true,
    display_name=true,
    core(
      redeclare replaceable .Electrification.Machines.Core.Limits.Scalar limits(
        I_dc_max_mot=200,
        enable_P_max=true,
        P_max_mot=130e3,
        enable_tau_max=true,
        tau_max_mot=300),
      redeclare .Electrification.Machines.Core.Losses.Efficiency lossesMachine(
        enable_table_losses=false,
        constant_eta=0.97),
      redeclare .Electrification.Machines.Core.Losses.Efficiency lossesConverter(
        enable_table_losses=false,
        constant_eta=0.97)),
    redeclare replaceable .Electrification.Machines.Mechanical.Gearbox
      mechanical(ratio=10, d_viscous=0),
    redeclare replaceable .Electrification.Machines.Control.MultiMode
      controller(external_torque=true)) annotation (Placement(transformation(
          extent={{34.0,-12.0},{66.0,20.0}})));

  /*──────────────────────────────────────────────
   * 3. HV Battery 
   *──────────────────────────────────────────────*/
  .Electrification.Batteries.Examples.Applications.FuelCellVehicle battery(
    enable_thermal_port=false,
    display_name=true,
    np=5,
    redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(
      redeclare replaceable .Electrification.Batteries.Control.ContactorControl controller1(
        external_control=true,
        contactors_closed=false,enable_thermal = false),
      redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2),
    limit_voltage=true) annotation (Placement(transformation(extent={{-104.0,-12.0},{-136.0,20.0}},rotation = 0.0,origin = {0.0,0.0})));

  /*──────────────────────────────────────────────
   * 4. SuperCap as LV
   *──────────────────────────────────────────────*/
  .Electrification.Batteries.Examples.Applications.Car12V batterySC(
    np=110,
    id=2,
    enable_thermal_port=false) annotation (Placement(transformation(extent={{-54.0,-48.0},{-74.0,-28.0}},rotation = 0.0,origin = {0.0,0.0})));

  /*──────────────────────────────���───────────────
   * 5. Bidirectional DCDC
   *──────────────────────────────────────────────*/
  .Electrification.Converters.Examples.AverageStepUpDown dcdcSC(
    enable_thermal_port=false,
    display_name=true,
    fixed_temperature=true,
    redeclare replaceable .Electrification.Converters.Control.MultiMode controller(
      mode=.Electrification.Utilities.Types.ConverterMode.CurrentA,
      external_i_a=false,
      external_mode=false,
      external_pwr_a=true)) annotation (Placement(transformation(extent={{-8.71,-54.11},{23.29,-22.11}},rotation = 0.0,origin = {0.0,0.0})));

  /*──────────────────────────────────────────────
   * 6. Initialization & Sensor
   *──────────────────────────────────────────────*/
  .Electrification.Electrical.DCInit vInitSC(
    init_start=true,
    v_start=batterySC.summary.ocv) annotation (Placement(
        transformation(extent={{-56.0,-78.0},{-44.0,-66.0}})));
  .Electrification.Electrical.DCInit vInitHV(
    v_start=battery.summary.ocv,
    init_start=true) annotation (Placement(transformation(extent={{-104.0,36.0},{-92.0,48.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Electrical.DCSensor dCSensor annotation (Placement(
        transformation(extent={{-44.92,16.14},{-24.92,-3.86}},rotation = 0.0,origin = {0.0,0.0})));

  /*──────────────────────────────────────────────
   * 7. State Machine
   *──────────────────────────────────────────────*/
  inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation (
      Placement(transformation(extent={{84.9,247.46},{104.9,267.46}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.InitialStep initialStep(nOut=1) annotation (Placement(
        transformation(extent={{-144.1,241.46},{-124.1,261.46}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.Transition transition annotation (Placement(
        transformation(extent={{-123.1,241.46},{-103.1,261.46}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.StepWithSignal Bat(nOut=1, nIn=2) annotation (Placement(
        transformation(extent={{-83.1,241.46},{-63.1,261.46}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.StepWithSignal SC(nIn=1, nOut=1) annotation (Placement(
        transformation(extent={{14.9,241.46},{34.9,261.46}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.TransitionWithSignal HighCurrent(enableTimer=true,
      waitTime=0.5) annotation (Placement(transformation(extent={{-45.1,241.46},{-25.1,261.46}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.TransitionWithSignal Back2Batt(enableTimer=true,
      waitTime=1) annotation (Placement(transformation(extent={{-23.1,301.81},{-43.1,321.81}},rotation = 0.0,origin = {0.0,0.0})));

  /*──────────────────────────────────────────────
   * 8. Signal Processing 
   *──────────────────────────────────────────────*/
  .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation (Placement(transformation(extent=
            {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-36.0,70.27})));
  .Modelica.Blocks.Math.Gain convCrate(k=1 / (battery.i_nom_1C))
    annotation (Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-35.31,109.2})));
  .Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=0.35, uHigh=0.5,pre_y_start = true)
    annotation (Placement(transformation(extent={{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-35.83,208.37})));
  .Modelica.Blocks.Logical.Not LowCrate annotation (Placement(transformation(
          extent={{10.0,-10.0},{-10.0,10.0}},rotation = -90.0,origin = {-11.100000000000001,275.46})));

  /*──────────────────────────────────────────────
   * 9. Control Signals
   *──��───────────────────────────────────────────*/
  .Electrification.Batteries.Control.Signals.close_contactors close_contactors(
      id=battery.id) annotation (Placement(transformation(extent={{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-73.45,193.46})));
  .Electrification.Converters.Control.Signals.mode_ref mode_ref(id=dcdcSC.id)
    annotation (Placement(transformation(extent={{-4.0,-4.0},{4.0,4.0}},rotation = -90.0,origin = {24.0,136.0})));
  .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerTrue=4, integerFalse=
        6)
    annotation (Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}},rotation = -90.0,origin = {24.9,209.46})));
    .Electrification.Machines.Control.Signals.tau_ref tau_ref(id = machine.id) annotation(Placement(transformation(extent = {{-4.0,4.0},{4.0,-4.0}},rotation = 180.0,origin = {98.46,57.52})));
    
    
 
    .Electrification.Mechanical.SimpleChassis1D chassis annotation(Placement(transformation(extent = {{148.24,-14.19},{180.24,17.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelon.Visualizers.RealValue distance_show(precision = 1,number = chassis.s / 1000) annotation(Placement(transformation(extent = {{110.24,67.81},{130.24,87.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Utilities.Blocks.Driver driver(tauMax = machine.core.limits.tau_max_mot,repeat = false,redeclare replaceable .Electrification.Utilities.DriveCycles.NEDC driveCycle) annotation(Placement(transformation(extent = {{176.0,37.81},{152.0,61.81}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.1) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-35.5,180.64},rotation = 90.0)));
    .Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 0.2) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-34.96,147.54},rotation = 90.0)));

equation

  /*──────────────────────────────────────────────
   * Connect - State Machine
   *──────────────────────────────────────────────*/
  connect(initialStep.outPort[1], transition.inPort) annotation (Line(points={{-123.6,251.46},{-117.1,251.46}}, color={0,0,0}));
  connect(transition.outPort, Bat.inPort[1]) annotation (Line(points={{-111.6,251.46},{-84.1,251.46}}, color={0,0,0}));
  connect(HighCurrent.outPort, SC.inPort[1]) annotation (Line(points={{-33.6,251.46},{13.9,251.46}}, color={0,0,0}));
  connect(Back2Batt.outPort, Bat.inPort[2]) annotation (Line(points={{-34.6,311.81},{-89.1,311.81},{-89.1,251.46},{-84.1,251.46}}, color={0,0,0}));

  /*──────────────────────────────────────────────
   * Connect - Signal Processing
   *─────────────────────────���────────────────────*/
  connect(dCSensor.y[2], absI.u) annotation (Line(points={{-34.92,15.14},{-34.92,58.27},{-36,58.27}}, color={0,0,127}));
  connect(absI.y, convCrate.u) annotation (Line(points={{-36,81.27},{-36,97.2},{-35.31,97.2}}, color={0,0,127}));
  connect(hysteresis.y, HighCurrent.condition) annotation (Line(points={{-35.83,219.37},{-35.1,219.37},{-35.1,239.46}}, color={255,0,255}));
  connect(hysteresis.y, LowCrate.u) annotation (Line(points={{-35.83,219.37},{-35.83,232.96},{-11.1,232.96},{-11.1,263.46}}, color={255,0,255}));
  connect(LowCrate.y, Back2Batt.condition) annotation (Line(points={{-11.1,286.46},{-33.1,286.46},{-33.1,299.81}}, color={255,0,255}));
  connect(close_contactors.systemBus, battery.controlBus) annotation (Line(
      points={{-73.45,185.21},{-73.45,81.88},{-107.2,81.88},{-107.2,20}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(booleanToInteger.u, SC.active) annotation (Line(points={{24.9,221.46},{24.9,240.46}}, color={255,0,255}));
  connect(booleanToInteger.y, mode_ref.u_i) annotation (Line(points={{24.9,198.46},{24,198.46},{24,142}}, color={255,127,0}));
  connect(mode_ref.systemBus, dcdcSC.controlBus) annotation (Line(
      points={{24,132},{24,-16},{-5.51,-16},{-5.51,-22.11}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(hESSControllerOuter.controlBus, battery.controlBus) annotation (Line(
      points={{-185.06,97.72},{-107.2,97.72},{-107.2,20}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(hESSControllerOuter.controlBus, dcdcSC.controlBus) annotation (Line(
      points={{-185.06,97.72},{-5.51,97.72},{-5.51,-22.11}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(dcdcSC.controlBus, batterySC.controlBus) annotation (Line(
      points={{-5.51,-22.11},{-5.51,-16},{-56,-16},{-56,-28}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-73.1,240.46},{-73.1,205.84},{-73.45,205.84}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-62.6,251.46},{-39.1,251.46}},color = {0,0,0}));
    connect(machine.plug_a,dCSensor.plug_b) annotation(Line(points = {{34,4},{-24.92,4},{-24.92,6.14}},color = {255,128,0}));
    connect(dCSensor.plug_a,battery.plug_a) annotation(Line(points = {{-44.92,6.14},{-104,6.14},{-104,4}},color = {255,128,0}));
    connect(vInitHV.plug_a,battery.plug_a) annotation(Line(points = {{-92,42},{-86,42},{-86,4},{-104,4}},color = {255,128,0}));
    connect(dcdcSC.plug_b,machine.plug_a) annotation(Line(points = {{23.29,-38.11},{23.29,4},{34,4}},color = {255,128,0}));
    connect(dcdcSC.plug_a,batterySC.plug_a) annotation(Line(points = {{-8.71,-38.11},{-8.71,-38},{-54,-38}},color = {255,128,0}));
    connect(vInitSC.plug_a,batterySC.plug_a) annotation(Line(points = {{-44,-72},{-38,-72},{-38,-38},{-54,-38}},color = {255,128,0}));
    connect(SC.outPort[1],Back2Batt.inPort) annotation(Line(points = {{35.4,251.46},{41.4,251.46},{41.4,311.81},{-29.1,311.81}},color = {0,0,0}));
    connect(tau_ref.systemBus,machine.controlBus) annotation(Line(points = {{94.46,57.52},{37.2,57.52},{37.2,20}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{164.24,19.41},{164.24,36.61},{164,36.61}},color = {0,0,127}));
    connect(driver.tau_ref,tau_ref.u_r) annotation(Line(points = {{150.8,49.81},{127.63,49.81},{127.63,57.52},{104.46,57.52}},color = {0,0,127}));
    connect(machine.flange,chassis.flangeR) annotation(Line(points = {{66,4},{107.12,4},{107.12,1.81},{148.24,1.81}},color = {0,0,0}));
    connect(firstOrder.y,hysteresis.u) annotation(Line(points = {{-35.5,191.64},{-35.83,191.64},{-35.83,196.37}},color = {0,0,127}));
    connect(firstOrder2.u,convCrate.y) annotation(Line(points = {{-34.96,135.54},{-34.96,127.87},{-35.31,127.87},{-35.31,120.2}},color = {0,0,127}));
    connect(firstOrder.u,firstOrder2.y) annotation(Line(points = {{-35.5,168.64},{-35.5,163.58999999999997},{-34.96,163.58999999999997},{-34.96,158.54}},color = {0,0,127}));
    connect(machine.controlBus,hESSControllerOuter.controlBus) annotation(Line(points = {{37.2,20},{37.2,97.72},{-185.06,97.72}},color = {240,170,40},pattern = LinePattern.Dot));

  annotation (
    experiment(StopTime=1800, Interval=0.1),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{120,300}})),
    Documentation(info="<html>
<p>
This example demonstrates electric vehicle using HESS (Hybrid Energy Storage System) which is combination of HV battery and SuperCapacitor. The SuperCapacitor is used to provide additional power in case of high current demand to reduce the load of HV battery.
</p>
<p>The system is consists of:</p>
<ul>
<li>HV Battery (Li-ion) : Main power source</li>
<li>SuperCapacitor (modeled as Car12V battery) : Auxiliary power source for high current demand</li>
<li>Bidirectional DC/DC converter : Interface between HV Battery and SuperCapacitor</li>
<li>State machine : Controls the operation mode (Battery only vs Battery+SuperCap)</li>
<li>HESS Controller : Overall system controller for power management</li>
</ul>
<p>The state machine operates as follows:</p>
<ul>
<li>Battery mode: Normal operation using HV battery only</li>
<li>SuperCap mode: High current demand, SuperCapacitor assists the HV battery</li>
<li>Transition conditions based on C-rate (current/capacity ratio)</li>
</ul>
</html>"));
end HESSVehicle_wStateF;