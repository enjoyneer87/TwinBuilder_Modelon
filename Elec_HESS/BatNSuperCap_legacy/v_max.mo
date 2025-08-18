within BatNSuperCap_legacy;

model v_max "Minimum voltage"
  extends .Electrification.Loads.Control.Signals.Templates.SignalReal(unit="V",
    causality=.Electrification.Utilities.Types.Causality.Input);
equation
  connect(s, componentBus.v_max) annotation (
    Line(
      points={{-24,0},{20,0}},
      color={0,0,127}),
    Text(
      string="%second",
      index=1,
      extent={{18,3},{18,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>"));
end v_max;
