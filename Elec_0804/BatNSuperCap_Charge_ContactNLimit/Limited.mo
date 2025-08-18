within BatNSuperCap_Charge_ContactNLimit;

partial model Limited "Template with sub-controller for handling limits"
  extends .Electrification.Machines.Control.Interfaces.Base;

  parameter Boolean external_limits = false "Get limits from control bus" annotation (Dialog(group="Limits"));
  parameter Boolean listen= false "Get limits from another controller (instead of the local bus)" annotation(Dialog(group="ControlBus",enable=external_limits));
  parameter Integer id_listen=1 "Identifier of controller to get limits from" annotation (Dialog(group="ControlBus",enable=listen));
  parameter .Electrification.Utilities.Types.ControllerType typeListen=.Electrification.Utilities.Types.ControllerType.Controller
    "Type of controller to get limits from" annotation (Dialog(group="ControlBus", enable=listen));

  parameter .Modelica.Units.SI.Current iMaxIn=100 "Maximum input current" annotation (Dialog(group="Limits", enable=not external_limits));
  parameter .Modelica.Units.SI.Current iMaxOut=100 "Maximum output current" annotation (Dialog(group="Limits", enable=not external_limits));
  parameter .Modelica.Units.SI.Power pMaxIn=35e3 "Maximum input power" annotation (Dialog(group="Limits", enable=not external_limits));
  parameter .Modelica.Units.SI.Power pMaxOut=35e3 "Maximum output power" annotation (Dialog(group="Limits", enable=not external_limits));

  .Electrification.Machines.Control.LimitedSub limits(final id=id,
      hide_bus_signals=hide_bus_signals)                          annotation (
      Dialog(group="Components"), Placement(transformation(extent={{-90,-20},{-50,
            20}})));
equation
  connect(limits.core, core) annotation (Line(
      points={{-50,-4},{-36,-4},{-36,-36},{100,-36},{100,-20}},
      color={150,150,150},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(limits.electrical, electrical) annotation (Line(
      points={{-50,-12},{-44,-12},{-44,-44},{100,-44},{100,-60}},
      color={120,180,200},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(limits.controlBus, controlBus) annotation (Line(
      points={{-70,20},{-70,90},{0,90},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
   annotation(Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
</html>"));
end Limited;
