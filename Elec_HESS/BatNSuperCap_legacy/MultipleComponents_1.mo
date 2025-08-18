within BatNSuperCap_legacy;

model MultipleComponents_1 "Experiment with multiple components that have different bus IDs"
  extends .Modelon.Icons.Experiment;
  .Modelon.SignalBuses.Examples.MultipleComponents.Components.ComponentModel componentA(id=1,
    v0=-10.0,
    accEn=33.0)
    annotation (Placement(transformation(extent={{20,20},{60,60}})));
  .Modelon.SignalBuses.Examples.MultipleComponents.Components.ComponentModel componentB(id=3, accEn=-12.3)
    annotation (Placement(transformation(extent={{19.78,-60.44},{59.78,-20.44}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelon.SignalBuses.Examples.MultipleComponents.Signals.enable enableB(hide_bus_signals=false,
                         id=componentB.id)
    annotation (Placement(transformation(extent={{-28,26},{-20,34}})));
  .Modelon.SignalBuses.Examples.MultipleComponents.Signals.enable enableA(
    hide_bus_signals=false,
    causality=.Modelon.Types.Causality.Parameter,
    id=componentA.id,
    k=true) annotation (Placement(transformation(extent={{-28,46},{-20,54}})));
  .Modelon.SignalBuses.Examples.MultipleComponents.Signals.mode modeA(
    hide_bus_signals=false,
                     causality=.Modelon.Types.Causality.Output, id=componentA.id)
    annotation (Placement(transformation(extent={{-28,-34},{-20,-26}})));
  .Modelon.SignalBuses.Examples.MultipleComponents.Signals.mode modeB(
    hide_bus_signals=false,
                     causality=.Modelon.Types.Causality.Output, id=componentB.id)
    annotation (Placement(transformation(extent={{-28,-54},{-20,-46}})));
  .Modelon.SignalBuses.Examples.MultipleComponents.Signals.velocity velocityB(
    hide_bus_signals=false,  causality=.Modelon.Types.Causality.Output, id=
        componentB.id)
    annotation (Placement(transformation(extent={{-28,-14},{-20,-6}})));
  .Modelon.SignalBuses.Examples.MultipleComponents.Signals.velocity velocityA(
    hide_bus_signals=false,  causality=.Modelon.Types.Causality.Output, id=
        componentA.id)
    annotation (Placement(transformation(extent={{-28,6},{-20,14}})));
  .Modelica.Blocks.Math.RealToBoolean isPositive(threshold=0.0)
    annotation (Placement(transformation(extent={{-40,4},{-52,16}})));
equation
  connect(enableA.systemBus, componentA.systemBus) annotation (Line(
      points={{-20,50},{0,50},{0,40},{20,40}},
      color={255,204,51},
      thickness=0.5));
  connect(enableB.systemBus, componentA.systemBus) annotation (Line(
      points={{-20,30},{0,30},{0,40},{20,40}},
      color={255,204,51},
      thickness=0.5));
  connect(componentB.systemBus, componentA.systemBus) annotation (Line(
      points={{19.78,-40.44},{0,-40.44},{0,40},{20,40}},
      color={255,204,51},
      thickness=0.5));
  connect(modeA.systemBus, componentA.systemBus) annotation (Line(
      points={{-20,-30},{0,-30},{0,40},{20,40}},
      color={255,204,51},
      thickness=0.5));
  connect(modeB.systemBus, componentA.systemBus) annotation (Line(
      points={{-20,-50},{0,-50},{0,40},{20,40}},
      color={255,204,51},
      thickness=0.5));
  connect(isPositive.y, enableB.u) annotation (Line(points={{-52.6,10},{-60,10},
          {-60,30},{-30,30}}, color={255,0,255}));
  connect(velocityA.y, isPositive.u)
    annotation (Line(points={{-29,10},{-38.8,10}}, color={0,0,127}));
  connect(velocityA.systemBus, componentA.systemBus) annotation (Line(
      points={{-20,10},{0,10},{0,40},{20,40}},
      color={255,204,51},
      thickness=0.5));
  connect(velocityB.systemBus, componentA.systemBus) annotation (Line(
      points={{-20,-10},{0,-10},{0,40},{20,40}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>"));
end MultipleComponents_1;
