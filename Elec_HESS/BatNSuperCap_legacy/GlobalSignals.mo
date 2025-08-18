within BatNSuperCap_legacy;

model GlobalSignals "Experiment demonstrating usage of global signals"
  extends .Modelon.Icons.Experiment;
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.velocity velocity_in
    annotation (Placement(transformation(extent={{-40,16},{-32,24}})));
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.mode mode_in(causality=.Modelon.Types.Causality.Parameter, k=8)
    annotation (Placement(transformation(extent={{-40,-44},{-32,-36}})));
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.enable enable_in
    annotation (Placement(transformation(extent={{-40,-14},{-32,-6}})));
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.mode mode_out(causality=.Modelon.Types.Causality.Output)
    annotation (Placement(transformation(extent={{40.22,-4.0},{32.22,4.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.enable enable_out(causality=.Modelon.Types.Causality.Output)
    annotation (Placement(transformation(extent={{40,-34},{32,-26}})));
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.velocity velocity_out(causality=.Modelon.Types.Causality.Output)
    annotation (Placement(transformation(extent={{40,26},{32,34}})));
protected
  .Modelon.SignalBuses.Interfaces.SystemBus systemBus
    annotation (Placement(transformation(extent={{-20,40},{20,80}})));
public
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.velocity noname1(display_name=false, causality=.Modelon.Types.Causality.Output)
    annotation (Placement(transformation(extent={{40,-58},{32,-50}})));
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.mode noname2(display_name=false, causality=.Modelon.Types.Causality.Output)
    annotation (Placement(transformation(extent={{40,-64},{32,-56}})));
  .Modelon.SignalBuses.Examples.GlobalSignals.Signals.enable noname3(display_name=false, causality=.Modelon.Types.Causality.Output)
    annotation (Placement(transformation(extent={{40,-70},{32,-62}})));
  .Modelica.Blocks.Sources.BooleanStep     cEnable(startTime=0.5)
    annotation (Placement(transformation(extent={{-68,-16},{-56,-4}})));
  .Modelica.Blocks.Sources.Sine cVelocity(
    amplitude=123.45,
    f=4,
    offset=20)
    annotation (Placement(transformation(extent={{-68,14},{-56,26}})));
equation
  connect(velocity_in.systemBus, systemBus) annotation (Line(
      points={{-32,20},{0,20},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(mode_in.systemBus, systemBus) annotation (Line(
      points={{-32,-40},{0,-40},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(enable_in.systemBus, systemBus) annotation (Line(
      points={{-32,-10},{0,-10},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(velocity_out.systemBus, systemBus) annotation (Line(
      points={{32,30},{0,30},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(mode_out.systemBus, systemBus) annotation (Line(
      points={{32.22,0},{0,0},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(enable_out.systemBus, systemBus) annotation (Line(
      points={{32,-30},{0,-30},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(noname1.systemBus, systemBus) annotation (Line(
      points={{32,-54},{26,-54},{26,-60},{0,-60},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(noname2.systemBus, systemBus) annotation (Line(
      points={{32,-60},{0,-60},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(noname3.systemBus, systemBus) annotation (Line(
      points={{32,-66},{26,-66},{26,-60},{0,-60},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(cEnable.y, enable_in.u)
    annotation (Line(points={{-55.4,-10},{-42,-10}}, color={255,0,255}));
  connect(cVelocity.y,velocity_in. u)
    annotation (Line(points={{-55.4,20},{-42,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>"));
end GlobalSignals;
