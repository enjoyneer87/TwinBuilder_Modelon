within BatNSuperCap_legacy;

model ElectricRange_SOC_PI_1_1 "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;
  .Electrification.Electrical.DCInit vInitA(init_steady=false, stateSelect=StateSelect.default,init_start = true,v_start = 200,common_mode = false) annotation (
    Placement(transformation(extent={{-152.87,-65.02},{-132.87,-45.02}},rotation = 0.0,origin = {0.0,0.0})));
    inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(Placement(transformation(extent = {{41.91,309.9},{61.91,329.9}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.InitialStep initialStep(nOut = 1,nIn = 0) annotation(Placement(transformation(extent = {{-156.66,311.07},{-136.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.Transition transition annotation(Placement(transformation(extent = {{-135.66,311.07},{-115.66,331.07}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal Bat(nIn = 2,nOut = 1) annotation(Placement(transformation(extent = {{-103.2,311.39},{-83.2,331.39}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime = 0.3,enableTimer = false) annotation(Placement(transformation(extent = {{-59.95,311.11},{-39.95,331.11}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Abs absI(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-49.84,152.99})));
    .Modelica.Blocks.Math.Gain convCrate(k = 1 / batty.i_nom_1C) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-48.76,193.02})));
    .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id = batty.id) annotation(Placement(transformation(extent = {{-8.25,-8.25},{8.25,8.25}},rotation = -90.0,origin = {-92.98,77.75})));
    .Electrification.Electrical.DCInit vInitA2(common_mode = false,v_start = 400,init_start = true,stateSelect = StateSelect.avoid,init_steady = false) annotation(Placement(transformation(extent = {{-108.86,-159.48},{-88.86,-139.48}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-200.5,97.41},rotation = -90.0)));
    .Electrification.Batteries.Examples.Applications.ElectricCar batty(np = 24,ns = 100,limitActionI = .Modelon.Types.FaultAction.Terminate,limitActionV = .Modelon.Types.FaultAction.Terminate,limitActionSoC = .Modelon.Types.FaultAction.Error,SoC_min = 0.1,SoC_max = 1.0,SOC_start = 0.6,fixed_temperature = true,display_name = true,enable_control_bus = true,enable_thermal_port = false,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(limits(iMaxOut = batty.i_nom_1C * 0.5,enable_thermal = false),contactors(external_control = true,contactors_closed = false,maxVoltageDiff = 10,preChargeOverlap = 0.1,enable_core = true),enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,initialize_with_OCV = false,core(capacityNom = 3.6),common_mode = false) annotation(Placement(transformation(extent = {{-83.75,-116.27},{-115.75,-84.27}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.StepWithSignal SCon(nOut = 1,nIn = 1) annotation(Placement(transformation(extent = {{-19.13,311.51},{0.87,331.51}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer = true,waitTime = 2) annotation(Placement(transformation(extent = {{-64.79,354.08},{-84.79,374.08}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Math.Gain convCrate3(k = 1 / (((batty.i_nom_1C)))) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-274.4,228.39})));
    .Modelica.Blocks.Math.Abs absI2(generateEvent = true) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-277.45,188.44})));
    .BatNSuperCap_0804.SCCap SCap(id = 2,SoC_min = 0,redeclare replaceable .Electrification.Batteries.Core.Examples.NCA.TabularTransient core(vCellMin = 0,vCellMax = 1000,redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic1stTabular impedance(interpolation_degree = 3,interpolation_method = .Modelon.Blocks.Interpolation.Types.Method.Polynomial,C1_table = [0.2,6.830667e+03;0.3,5.654858e+03;0.4,7.071634e+03;0.5,1.620276e+04;0.6,1.085817e+04;0.7,1.452638e+04;0.8,2.401400e+04;0.9,1.250130e+04;1.0,4.580168e+03],R1_table = [0.2,3.728732e-03;0.3,4.537486e-03;0.4,2.206103e-03;0.5,1.545534e-03;0.6,1.749724e-03;0.7,1.753031e-03;0.8,1.678829e-03;0.9,3.100650e-03;1.0,6.274575e-03],R0_table = [0.2,0.3170192;0.3,0.3102788;0.4,0.3128846;0.5,0.2990385;0.6,0.2941587;0.7,0.2926683;0.8,0.2949038;0.9,0.2922837;1.0,0.3994471]),redeclare replaceable .Electrification.Batteries.Core.OCV.Table voltage(interpolation_degree = 3,interpolation_method = .Modelon.Blocks.Interpolation.Types.Method.Polynomial,ref_SoC_0 = 0,cellOCV_table = [0.2,0.788471;0.3,1.078110;0.4,1.355740;0.5,1.620590;0.6,1.876870;0.7,2.127530;0.8,2.376170;0.9,2.630110;1.0,2.908830],limitStart = 2),capacity(Q_cap_cell_nom = 13200)),ns = 86,SoC_max = 0.95,limitActionV = .Modelon.Types.FaultAction.Terminate,limitActionSoC = .Modelon.Types.FaultAction.Terminate,display_name = true,controller(controller2(enable_thermal = false),redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(contactors(external_control = false,contactors_closed = true),limits(enable_thermal = false,external_enable = false),enable_thermal = false)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical(preChargeResistance = 2),initialize_with_OCV = false,common_mode = false,limitActionI = Modelon.Types.FaultAction.Terminate) annotation(Placement(transformation(extent = {{-240.68,-52.89},{-260.68,-32.89}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Examples.Machine motor(redeclare replaceable .Electrification.Machines.Control.Torque controller(external_torque = true),display_name = true,core(limits(I_dc_max_mot = 200,tau_max_mot = 300,enable_smooth_splice = true)),redeclare replaceable .Electrification.Machines.Mechanical.IdealShaft mechanical,id = 1,common_mode = false,enable_thermal_port = false,fixed_temperature = true) annotation(Placement(transformation(extent = {{43.18,-39.15},{68.7,-19.15}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Mechanical.SimpleChassis1D chassis2(m = 2000) annotation(Placement(transformation(extent = {{93.69,-39.44},{119.21,-19.44}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Machines.Control.Signals.tau_ref torqueCommand(id = motor.id) annotation(Placement(transformation(extent = {{66.01,17.46},{55.81,25.46}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Utilities.Blocks.Driver driver2(tauMax = 1000,driveCycle(multiple = false)) annotation(Placement(transformation(extent = {{119.59,11.46},{94.07,31.46}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.5) annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-50.18,237.13},rotation = 90.0)));
    .Electrification.Electrical.DCSensor dCSensor(common_mode = false) annotation(Placement(transformation(extent = {{-200.56,-50.59},{-220.56,-30.59}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis hysteresis(uHigh = 0.5,uLow = 0.45) annotation(Placement(transformation(extent = {{-259.66,262.31},{-239.66,282.31}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-202.24,263.02},{-182.24,283.02}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{-30.57,-109.66},{-50.57,-89.66}},origin = {0,0},rotation = 0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC CapDCDC(enable_thermal_port = false,core(L = 1e-4),display_name = true,controller(external_limits = false,listen = true,id_listen = SCap.id,typeListen = .Electrification.Utilities.Types.ControllerType.Battery,external_v_b = false,v_b_ref = 400,Ti_v = 0.1,external_mode = true,mode = Electrification.Utilities.Types.ConverterMode.PowerB,external_pwr_b = true)) annotation(Placement(transformation(extent = {{-128.23,-19.81},{-148.23,0.19}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Converters.Control.Signals.mode_ref mode_ref(id = CapDCDC.id) annotation(Placement(transformation(extent = {{-192.8,61.8},{-184.8,69.8}},origin = {0,0},rotation = 0)));
    .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerTrue = Integer(.Electrification.Utilities.Types.ConverterMode.PowerB)) annotation(Placement(transformation(extent = {{-231.26,55.92},{-211.26,75.92}},origin = {0,0},rotation = 0)));
    .Electrification.Converters.Control.Signals.pwr_b_ref pwr_b_ref(id = CapDCDC.id) annotation(Placement(transformation(extent = {{-113.91,17.03},{-121.91,25.03}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Machines.Control.Signals.pwr_sns pwr_sns(id(fixed = false) = motor.id) annotation(Placement(transformation(extent = {{-33.48,9.33},{-25.48,17.33}},origin = {0.0,0.0},rotation = 0.0)));
equation
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-136.16,321.07},{-129.66,321.07}},color = {0,0,0}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-49.84,163.99},{-49.84,181.02},{-48.76,181.02}},color = {0,0,127}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-93.2,310.39},{-93.2,90.13},{-92.98,90.13}},color = {255,0,255}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-82.7,321.39},{-69.43,321.39},{-69.43,321.11},{-53.95,321.11}},color = {0,0,0}));
    connect(transition.outPort,Bat.inPort[1]) annotation(Line(points = {{-124.16,321.07},{-104.2,321.07},{-104.2,321.39}},color = {0,0,0}));
    connect(vInitA2.plug_a,batty.plug_a) annotation(Line(points = {{-88.86,-149.48},{-48.33,-149.48},{-48.33,-100.27},{-83.75,-100.27}},color = {255,128,0}));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-92.98,69.5},{-92.98,-84.27},{-86.95,-84.27}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCon.active,and1.u2) annotation(Line(points = {{-9.13,310.51},{-9.13,295.64},{-218,295.64},{-218,109.41},{-208.5,109.41}},color = {255,0,255}));
    connect(HighCurrent.outPort,SCon.inPort[1]) annotation(Line(points = {{-48.45,321.11},{-32.4,321.11},{-32.4,321.51},{-20.13,321.51}},color = {0,0,0}));
    connect(SCon.outPort[1],lowCurrentSCap.inPort) annotation(Line(points = {{1.37,321.51},{6.92,321.51},{6.92,364.08},{-70.79,364.08}},color = {0,0,0}));
    connect(convCrate3.u,absI2.y) annotation(Line(points = {{-274.4,216.39},{-274.4,207.36},{-277.45,207.36},{-277.45,199.44}},color = {0,0,127}));
    connect(torqueCommand.systemBus,motor.controlBus) annotation(Line(points = {{55.81,21.46},{17.54,21.46},{17.54,-19.15},{45.73,-19.15}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(chassis2.velocity,driver2.speed_m) annotation(Line(points = {{106.45,-18.44},{106.83,-18.44},{106.83,10.46}},color = {0,0,127}));
    connect(driver2.tau_ref,torqueCommand.u_r) annotation(Line(points = {{92.8,21.46},{68.56,21.46}},color = {0,0,127}));
    connect(motor.flange,chassis2.flangeR) annotation(Line(points = {{68.7,-29.15},{68.7,-29.44},{93.69,-29.44}},color = {0,0,0}));
    connect(SCon.active,and1.u1) annotation(Line(points = {{-9.13,310.51},{-9.13,209.8},{-200.5,209.8},{-200.5,109.41}},color = {255,0,255}));
    connect(lowCurrentSCap.outPort,Bat.inPort[2]) annotation(Line(points = {{-76.29,364.08},{-110.2,364.08},{-110.2,321.39},{-104.2,321.39}},color = {0,0,0}));
    connect(greaterEqualThreshold.u,convCrate.y) annotation(Line(points = {{-50.18,225.13},{-50.18,214.15},{-48.76,214.15},{-48.76,204.02}},color = {0,0,127}));
    connect(greaterEqualThreshold.y,HighCurrent.condition) annotation(Line(points = {{-50.18,248.13},{-50.18,278.38},{-49.95,278.38},{-49.95,309.11}},color = {255,0,255}));
    connect(dCSensor.plug_b,SCap.plug_a) annotation(Line(points = {{-220.56,-40.59},{-230.62,-40.59},{-230.62,-42.89},{-240.68,-42.89}},color = {255,128,0}));
    connect(convCrate3.y,hysteresis.u) annotation(Line(points = {{-274.4,239.39},{-274.4,272.31},{-261.66,272.31}},color = {0,0,127}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-181.24,273.02},{-74.79,273.02},{-74.79,352.08}},color = {255,0,255}));
    connect(hysteresis.y,not1.u) annotation(Line(points = {{-238.66,272.31},{-221.45,272.31},{-221.45,273.02},{-204.24,273.02}},color = {255,0,255}));
    connect(motor.plug_a,dCSensor2.plug_a) annotation(Line(points = {{43.18,-29.15},{6.305,-29.15},{6.305,-99.66},{-30.57,-99.66}},color = {255,128,0}));
    connect(dCSensor2.plug_b,batty.plug_a) annotation(Line(points = {{-50.57,-99.66},{-67.16,-99.66},{-67.16,-100.27},{-83.75,-100.27}},color = {255,128,0}));
    connect(dCSensor.plug_a,CapDCDC.plug_b) annotation(Line(points = {{-200.56,-40.59},{-174.39,-40.59},{-174.39,-9.81},{-148.23,-9.81}},color = {255,128,0}));
    connect(CapDCDC.plug_a,motor.plug_a) annotation(Line(points = {{-128.23,-9.81},{-42.52,-9.81},{-42.52,-29.15},{43.18,-29.15}},color = {255,128,0}));
    connect(CapDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-130.23,0.19},{-130.23,6.52},{-242.68,6.52},{-242.68,-32.89}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(mode_ref.systemBus,CapDCDC.controlBus) annotation(Line(points = {{-184.8,65.8},{-130.23,65.8},{-130.23,0.19}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(vInitA.plug_a,CapDCDC.plug_b) annotation(Line(points = {{-132.87,-55.02},{-126.87,-55.02},{-126.87,-32.39},{-154.23,-32.39},{-154.23,-9.81},{-148.23,-9.81}},color = {255,128,0}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-210.26,65.92},{-202.53,65.92},{-202.53,65.8},{-194.8,65.8}},color = {255,127,0}));
    connect(and1.y,booleanToInteger.u) annotation(Line(points = {{-200.5,86.41},{-200.5,49.92},{-239.26,49.92},{-239.26,65.92},{-233.26,65.92}},color = {255,0,255}));
    connect(dCSensor2.y[2],absI.u) annotation(Line(points = {{-40.57,-108.66},{-40.57,-114.66},{-56.57,-114.66},{-56.57,-82.66},{-49.84,-82.66},{-49.84,140.99}},color = {0,0,127}));
    connect(dCSensor.y[2],absI2.u) annotation(Line(points = {{-210.56,-49.59},{-210.56,-55.59},{-277.45,-55.59},{-277.45,176.44}},color = {0,0,127}));
    connect(pwr_b_ref.systemBus,CapDCDC.controlBus) annotation(Line(points = {{-121.91,21.03},{-130.23,21.03},{-130.23,0.19}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(motor.controlBus,pwr_sns.systemBus) annotation(Line(points = {{45.73,-19.15},{45.73,13.33},{-25.48,13.33}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(pwr_sns.y_r,pwr_b_ref.u_r) annotation(Line(points = {{-34.48,13.33},{-73.06,13.33},{-73.06,21.03},{-111.91,21.03}},color = {0,0,127}));

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
end ElectricRange_SOC_PI_1_1;
