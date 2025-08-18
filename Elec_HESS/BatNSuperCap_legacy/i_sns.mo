within BatNSuperCap_legacy;
model i_sns "Battery sensed current (scalar)"
  extends Electrification.Batteries.Control.Signals.Templates.SignalReal(
    unit = "A",
    causality = Electrification.Utilities.Types.Causality.Output
  );

equation
  connect(s, componentBus.core_i_sns) annotation (
    Line(points={{-24,0},{20,0}}, color={0,0,127}),
    Text(
      string="%second",
      index=1,
      extent={{18,3},{18,3}},
      horizontalAlignment=TextAlignment.Left));

annotation (
  Documentation(info="<html>Outputs battery current signal (i_sns) from componentBus to systemBus.</html>")
);
end i_sns;