within BatNSuperCap_Charge_ContactNLimit;

model LimitedSub
  "Sub-controller for machine limits"
  extends .Electrification.Machines.Control.Interfaces.Base(
    enable_electrical=false,
    enable_mechanical=false,
    enable_thermal=false,
    enable_core=false);

  parameter Boolean external_limits = false "Get limits from control bus" annotation (Dialog(group="Limits"));
  parameter Boolean listen= false "Get limits from another controller (instead of the local bus)" annotation(Dialog(group="ControlBus",enable=external_limits));
  parameter Integer id_listen=1 "Identifier of controller to get limits from" annotation (Dialog(group="ControlBus",enable=(external_limits and listen)));
  parameter .Electrification.Utilities.Types.ControllerType typeListen=.Electrification.Utilities.Types.ControllerType.Controller
    "Type of controller to get limits from" annotation (Dialog(group="ControlBus", enable=listen));

  parameter .Modelica.Units.SI.Current iMaxIn=100 "Maximum input current" annotation (Dialog(group="Limits", enable=not external_limits));
  parameter .Modelica.Units.SI.Current iMaxOut=100 "Maximum output current" annotation (Dialog(group="Limits", enable=not external_limits));
  parameter .Modelica.Units.SI.Power pMaxIn=35e3 "Maximum input power" annotation (Dialog(group="Limits", enable=not external_limits));
  parameter .Modelica.Units.SI.Power pMaxOut=35e3 "Maximum output power" annotation (Dialog(group="Limits", enable=not external_limits));

  .Electrification.Control.Limits.LimitedComponent componentLimits(
    final id=id,
    final typeLocal=.Electrification.Utilities.Types.ControllerType.Machine,
    id_listen=id_listen,
    typeListen=typeListen,
    vMaxSignal=false,
    vMinSignal=false,
    iMaxInSignal=external_limits,
    iMaxOutSignal=external_limits,
    pMaxInSignal=external_limits,
    pMaxOutSignal=external_limits,
    iMaxIn=iMaxIn,
    iMaxOut=iMaxOut,
    pMaxIn=pMaxIn,
    pMaxOut=pMaxOut,
    vMax=.Modelica.Constants.inf,
    vMin=0,
    listen=listen,
    k_pMax=k_pMax,
    use_core_sensor=false)
    annotation (Placement(transformation(extent={{-20.0,-40.0},{20.0,40.0}},rotation = 0.0,origin = {0.0,0.0})));
  parameter Real k_pMax=1 "Scaling factor of pMax[In/Out]"
    annotation (Dialog(group="Limits"));
    .Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(extent = {{60.0,24.0},{80.0,44.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Interfaces.RealOutput y2 annotation(Placement(transformation(extent = {{62.0,6.0},{82.0,26.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Interfaces.RealOutput y3 annotation(Placement(transformation(extent = {{60.0,-14.0},{80.0,6.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Interfaces.RealOutput y4 annotation(Placement(transformation(extent = {{60.0,-42.0},{80.0,-22.0}},origin = {0.0,0.0},rotation = 0.0)));
equation
  connect(componentLimits.systemBus, controlBus) annotation (Line(
      points={{0,40},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(electrical, componentLimits.sensors) annotation (Line(
      points={{100,-60},{-40,-60},{-40,0},{-20,0}},
      color={120,180,200},
      pattern=LinePattern.Dot,
      thickness=0.5));
    connect(componentLimits.p_max_in,y3) annotation(Line(points = {{22,-16},{46,-16},{46,-4},{70,-4}},color = {0,0,127}));
    connect(componentLimits.p_max_out,y4) annotation(Line(points = {{22,-28},{46,-28},{46,-32},{70,-32}},color = {0,0,127}));
    connect(componentLimits.i_max_out,y2) annotation(Line(points = {{22,-4},{47,-4},{47,16},{72,16}},color = {0,0,127}));
    connect(componentLimits.i_max_in,y) annotation(Line(points = {{22,8},{46,8},{46,34},{70,34}},color = {0,0,127}));
   annotation(Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This controller provides limit signals to the machine core model, based on paramers or external signals from the system control bus. It also provides sensor measurements to the system control bus. This allows using the machine with a system <a href=\"modelica://Electrification.Control.PowerAllocation\">power allocation controller</a>.</p>
<p><b>Note:</b> This controller cannot be used alone. It is typically used together with another sub-controller providing a torque reference to the core machine. An example of this is the <a href=\"modelica://Electrification.Machines.Control.LimitedTorque\">LimitedTorque</a> controller.</p>
<p>For related information, refer to the section <a href=\"modelica://Electrification.Machines.Information.Limits\">Specifying machine limits</a>.</p>
</html>"));
end LimitedSub;
