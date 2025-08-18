within BatNSuperCap_Charge_ContactNLimit;

partial model ComponentAdapter "Component signal adapter"
  extends .Modelon.SignalBuses.Interfaces.SignalAdapter;
  parameter Integer id = 1
    "Identifier of the component for this signal" annotation (
    Dialog(group="Controller"));
protected
  .Modelon.SignalBuses.MultipleComponents.Interfaces.ComponentBus componentBus
    annotation (HideResult=hide_bus_signals, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,0})));
equation
  connect(componentBus, systemBus.component[id]) annotation (
    Line(
      points={{20,0},{40,0}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-12,6},{-12,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>"));
end ComponentAdapter;
