within BatNSuperCap_Charge_ContactNLimit;

model ElectricRange_SOC_PI "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;

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
        Placement(transformation(extent={{-12.0,-16.0},{20.0,16.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.SimpleChassis1D chassis(
    m=1800 * 0.5,
    R=0.35155,
    ideal_wheel=false,
    lambda=0.561118,
    Rl=0.335901,
    KX=98300,
    d=0.73196,
    A=2.25,
    Cd=0.339628,
    rho=1,
    CrConstant=0.00845431,initialize_velocity = true,initialize_position = true)
    annotation (Placement(transformation(extent={{60.26,-16.0},{92.26,16.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Machines.Control.Signals.tau_ref tau_ref(id=machine.id)
    annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=180,
        origin={4,50})));
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = SCap.summary.ocv,common_mode = false) annotation (
    Placement(transformation(extent={{-153.24,-65.02},{-133.24,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.Driver driver(
    k=1,
    Ti=2,
    torque_output=false,redeclare replaceable .Electrification.Utilities.DriveCycles.AccelerateDecelerate driveCycle,
    repeat=true)
    annotation (Placement(transformation(extent={{84.0,40.0},{64.0,60.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Mechanical.IdealBrake brakes(enable_mount=false) annotation (Placement(transformation(extent={{27.65,-11.65},{51.65,12.35}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Utilities.Blocks.TorqueArbitration torqueArbitration(
    number_of_motors_front=0,
    number_of_motors_rear=1,
    tauMax=machine.core.limits.tau_max_mot,regen_torque = 300,v_max = 270.777)
    annotation (Placement(transformation(extent={{50.0,40.0},{30.0,60.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,controller(external_mode = true,mode = .Electrification.Utilities.Types.ConverterMode.CurrentA,i_a_ref = -SCap.i_nom_1C,external_limits = false,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_i_b = true,iMaxInB = 500,external_i_a = true,i_b_ref = -SCap.i_nom_1C,iMaxInA = 500,pMaxInA = 1e16,pMaxInB = 1e16),common_mode = false,internal_ground = false) annotation(Placement(transformation(extent = {{-94.0,-10.0},{-114.0,10.0}},origin = {0.0,0.0},rotation = 0.0)));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{96.31,397.19},{116.31,417.19}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 1,nOut = 1) annotation(Placement(transformation(extent = {{-103.52,311.39},{-83.52,331.39}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.1,enableTimer = true) annotation(Placement(transformation(extent = {{-60.0,312.0},{-40.0,332.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.0,138.0})));
    .Modelica.Blocks.Math.Gain convCrate(k = batty.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-54.31999999999999,179.57})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis2(pre_y_start = false,uHigh = 0.5,uLow = 0.35) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-50.0,252.0})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-92.97,169.66})));
    .Electrification.Batteries.Control.Signals.i_cell i_cell(id = batty.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-54.65,66.03},rotation = -90.0)));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = batty.summary.ocv,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-16.42,-111.6},{3.58,-91.6}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-133.67,57.18},{-125.67,65.18}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerFalse = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentA),integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.CurrentB)) annotation(Placement(transformation(extent = {{-180.82,53.04},{-160.82,73.04}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-204.1,82.1},rotation = -90.0)));
    .Electrification.Converters.Control.Signals.i_b_ref i_b_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-4.0,-4.0},{4.0,4.0}},origin = {-118.38,35.93},rotation = -90.0)));
    .Modelica.Blocks.Math.BooleanToReal OnSC(realTrue = -200 * SCap.i_nom_1C,realFalse = 0) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-120.15,105.2},rotation = -90.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 180,limitActionI = .Modelon.Types.FaultAction.Warning,limitActionV = .Modelon.Types.FaultAction.Warning,limitActionSoC = .Modelon.Types.FaultAction.Error,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.ContactorControl controller1(contactors_closed = true,external_control = true,enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6)) annotation(Placement(transformation(extent = {{-84.14,-116.27},{-116.14,-84.27}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.i_a_ref i_a_ref(id = averageStepUpDownDCDC.id) annotation(Placement(transformation(extent = {{-140.76,31.72},{-132.76,39.72}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = -0.1,uHigh = 0,pre_y_start = false) annotation(Placement(transformation(extent = {{12.0,70.0},{-8.0,90.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Math.Gain convCrate2(k = 1) annotation(Placement(transformation(extent = {{-177.24,20.06},{-157.24,40.06}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-20.0,312.0},{0.0,332.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 5) annotation(Placement(transformation(extent = {{-86.07,362.1},{-66.07,382.1}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Batteries.Control.Signals.i_cell i_cellSC(id = SCap.id) annotation(Placement(transformation(extent = {{-17.21,-17.21},{17.21,17.21}},origin = {-334.0,206.0},rotation = -90.0)));
    .Modelica.Blocks.Math.Gain convCrate3(k = 20 * SCap.np / (batty.i_nom_1C)) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-332.0,300.0})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-334.49,260.05})));
    .Modelica.Blocks.Logical.Hysteresis hysteresis3(uLow = 0.01,uHigh = 0.5,pre_y_start = false) annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},rotation = 90.0,origin = {-332.0,332.0})));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-312.97,346.03},{-292.97,366.03}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_Charge_ContactNLimit.SCCap SCap(initialize_with_OCV = true,redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIsolated electrical) annotation(Placement(transformation(extent = {{-146.0,-10.0},{-166.0,10.0}},origin = {0.0,0.0},rotation = 0.0)));
equation
  connect(chassis.velocity, driver.speed_m)
    annotation (Line(points={{76.26,17.6},{76.26,39},{74,39}},   color={0,0,127}));
  connect(tau_ref.systemBus, machine.controlBus) annotation (Line(
      points={{0,50},{-8.8,50},{-8.8,16}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueArbitration.tau_brake_ref, brakes.u)
    annotation (Line(points={{29,44},{20,44},{20,26},{39.65,26},{39.65,13.55}}, color={0,0,127}));
  connect(torqueArbitration.veh_vel_x, chassis.velocity) annotation (
    Line(points={{40,38},{40,32},{76.26,32},{76.26,17.6}}, color={0,0,127}));
  connect(torqueArbitration.tau_ref_rear[1], tau_ref.u_r) annotation (Line(points={{29,50},{10,50}}, color={0,0,127}));
  connect(machine.flange, chassis.flangeR) annotation (Line(points={{20,0},{60.26,0}}, color={0,0,0}));
  connect(brakes.flange_a, chassis.flangeR) annotation (Line(points={{39.65,0.35},{39.65,0},{60.26,0}}, color={0,0,0}));
  connect(driver.acc_cmd, torqueArbitration.acc_cmd) annotation (Line(points={{63,56},{52,56}}, color={0,0,127}));
  connect(driver.brk_cmd, torqueArbitration.brk_cmd) annotation (Line(points={{63,44},{52,44}}, color={0,0,127}));
    connect(machine.controlBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-8.8,16},{-96,16},{-96,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{-12,0},{-94,0}},color = {255,128,0}));
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-54,149},{-54,167.57},{-54.32,167.57}},color = {0,0,127}));
    connect(hysteresis2.y,HighCurrent.condition) annotation(Line(points = {{-50,263},{-50,310}},color = {255,0,255}));
    connect(convCrate.y,hysteresis2.u) annotation(Line(points = {{-54.32,190.57},{-54.32,227.9},{-50,227.9},{-50,240}},color = {0,0,127}));
    connect(i_cell.y_r,absI.u) annotation(Line(points = {{-54.65,87.54},{-54.65,109.39},{-54,109.39},{-54,126}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-93.52,310.39},{-93.52,212.14},{-92.97,212.14},{-92.97,182.04}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-83.02,321.39},{-69.43,321.39},{-69.43,322},{-54,322}},color = {0,0,0}));
    connect(transition.outPort,Bat.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-104.52,321.07},{-104.52,321.39}},color = {0,0,0}));
    connect(and1.y,booleanToInteger.u) annotation(Line(points = {{-204.1,71.1},{-204.1,63.04},{-182.82,63.04}},color = {255,0,255}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-159.82,63.04},{-135.67,63.04},{-135.67,61.18}},color = {255,127,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-125.67,61.18},{-96,61.18},{-96,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(i_b_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-118.38,31.93},{-118.38,23.39},{-96,23.39},{-96,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{3.58,-101.6},{-84.14,-101.6},{-84.14,-100.27}},color = {255,128,0}));
    connect(i_cell.systemBus,batty.controlBus) annotation(Line(points = {{-54.65,48.82},{-54.65,-1.08},{-87.34,-1.08},{-87.34,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-92.97,161.41},{-92.97,-84.27},{-87.34,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.plug_a,batty.plug_a) annotation(Line(points = {{-12,0},{-47.87,0},{-47.87,-100.27},{-84.14,-100.27}},color = {255,128,0}));
    connect(OnSC.y,i_b_ref.u_r) annotation(Line(points = {{-120.15,94.2},{-120.15,72.51},{-118.38,72.51},{-118.38,41.93}},color = {0,0,127}));
    connect(hysteresis2.y,OnSC.u) annotation(Line(points = {{-50,263},{-50,273.06},{-120.15,273.06},{-120.15,117.2}},color = {255,0,255}));
    connect(i_a_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-132.76,35.72},{-96,35.72},{-96,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(hysteresis.y,and1.u1) annotation(Line(points = {{-9,80},{-31.43,80},{-31.43,121.65},{-204.1,121.65},{-204.1,94.1}},color = {255,0,255}));
    connect(torqueArbitration.tau_ref_rear[1],hysteresis.u) annotation(Line(points = {{29,50},{21.45,50},{21.45,80},{14,80}},color = {0,0,127}));
    connect(OnSC.y,convCrate2.u) annotation(Line(points = {{-120.15,94.2},{-120.15,89.2},{-185.24,89.2},{-185.24,30.06},{-179.24,30.06}},color = {0,0,127}));
    connect(convCrate2.y,i_a_ref.u_r) annotation(Line(points = {{-156.24,30.06},{-149.5,30.06},{-149.5,35.72},{-142.76,35.72}},color = {0,0,127}));
    connect(SCon.active,and1.u2) annotation(Line(points = {{-10,311},{-10,295.64},{-218,295.64},{-218,94.1},{-212.1,94.1}},color = {255,0,255}));
    connect(HighCurrent.outPort,SCon.inPort[1]) annotation(Line(points = {{-48.5,322},{-21,322}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{0.5,322},{14.82,322},{14.82,372.1},{-80.07,372.1}},color = {0,0,0}));
    connect(lowCurrentSCap.outPort,initialStep.inPort[1]) annotation(Line(points = {{-74.57,372.1},{-162.66,372.1},{-162.66,321.07},{-157.66,321.07}},color = {0,0,0}));
    connect(i_cellSC.y_r,absI2.u) annotation(Line(points = {{-334,227.51},{-334,237.98},{-334.49,237.98},{-334.49,248.05}},color = {0,0,127}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-332,288},{-332,278.97},{-334.49,278.97},{-334.49,271.05}},color = {0,0,127}));
    connect(hysteresis3.u,convCrate3.y) annotation(Line(points = {{-332,320},{-332,311}},color = {0,0,127}));
    connect(hysteresis3.y,not1.u) annotation(Line(points = {{-332,343},{-332,356.03},{-314.97,356.03}},color = {255,0,255}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-291.97,356.03},{-76.07,356.03},{-76.07,360.1}},color = {255,0,255}));
    connect(SCap.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-146,0},{-114,0}},color = {255,128,0}));
    connect(vInitA.plug_a,SCap.plug_a) annotation(Line(points = {{-133.24,-55.02},{-127.24,-55.02},{-127.24,0},{-146,0}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-96,10},{-96,16},{-148,16},{-148,10}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCap.controlBus,i_cellSC.systemBus) annotation(Line(points = {{-148,10},{-148,4},{-334,4},{-334,188.79}},color = {240,170,40},pattern = LinePattern.Dot));

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
end ElectricRange_SOC_PI;
