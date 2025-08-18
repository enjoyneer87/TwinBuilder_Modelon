within BatNSuperCap_legacy;

model FuelCellControllerOuter
  "Controller for a fuel cell converter"
  extends .Modelon.Icons.Framed;
  extends .Modelon.Icons.DigitalController;

  parameter Integer id_Battery = 1 annotation(Dialog(group = "ControlBus"));
  parameter Integer id_Machine = 1 annotation(Dialog(group = "ControlBus"));
  parameter Integer id_Converter = 1 annotation(Dialog(group = "ControlBus"));
  parameter .Modelica.Units.SI.Power pMax(displayUnit="kW")=123000 annotation(Dialog(group = "Limits"));

  .Electrification.Batteries.Control.Signals.SoC_cell soc(id=id_Battery)
    annotation (Placement(transformation(
        extent={{76.0,26.0},{84.0,34.0}},
        origin={0.0,0.0},
        rotation=0.0)));
  .Electrification.Converters.Control.Signals.pwr_a_ref pwr_a_ref(
    id=id_Converter) annotation (
      Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=180,
        origin={80,0})));
  .Electrification.Control.Interfaces.SystemBus controlBus annotation (
    Placement(
        transformation(
        extent={{-20.0,20.0},{20.0,-20.0}},
        rotation=90.0,
        origin={100.0,0.0})));
  .Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-74,16},{-54,-4}})));
  .Modelica.Blocks.Sources.Constant targetSOC(k=0.6)
    annotation (Placement(transformation(extent={{-100,-4},{-80,16}})));
    .Modelica.Blocks.Nonlinear.Limiter limiter(
    uMin=-pMax,
    uMax=pMax,
    strict=true) annotation (Placement(transformation(
        extent={{16.32,-9.44},{36.32,10.56}},
        origin={0.0,0.0},
        rotation=0.0)));
    .Electrification.Machines.Control.Signals.pwr_sns pwr_sns(id=id_Machine)
    annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        origin={80,-30},
        rotation=180)));
  .Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  .Modelica.Blocks.Continuous.Filter filter(f_cut=0.05)
    annotation (Placement(transformation(extent={{45.84,-10.0},{65.84,10.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.Blocks.Math.Gain gain(k=1e4)
    annotation (Placement(transformation(extent={{-46,-4},{-26,16}})));
equation
  connect(soc.systemBus, controlBus) annotation (Line(
      points={{84,30},{100,30},{100,0}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(pwr_a_ref.systemBus, controlBus) annotation (Line(
      points={{84,0},{100,0}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(targetSOC.y, feedback.u1)
    annotation (Line(points={{-79,6},{-72,6}}, color={0,0,127}));
  connect(feedback.u2, soc.y_r)
    annotation (Line(points={{-64,14},{-64,30},{75,30}}, color={0,0,127}));
  connect(pwr_sns.systemBus, controlBus) annotation (Line(
      points={{84,-30},{100,-30},{100,0}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(add.y, limiter.u)
    annotation (Line(points={{7,0},{7,0.56},{14.32,0.56}},  color={0,0,127}));
  connect(gain.y, add.u1)
    annotation (Line(points={{-25,6},{-16,6}}, color={0,0,127}));
  connect(gain.u, feedback.y)
    annotation (Line(points={{-48,6},{-55,6}}, color={0,0,127}));
  connect(filter.y, pwr_a_ref.u_r)
    annotation (Line(points={{66.84,0},{74,0}}, color={0,0,127}));
  connect(filter.u, limiter.y)
    annotation (Line(points={{43.84,0},{37.32,0},{37.32,0.56}}, color={0,0,127}));
  connect(add.u2, pwr_sns.y_r) annotation (Line(points={{-16,-6},{-24,-6},{-24,-30},
          {75,-30}}, color={0,0,127}));
    annotation(Icon(coordinateSystem(preserveAspectRatio = false,
      extent = {{-100.0,-100.0},{100.0,100.0}}),
      graphics={  Text(lineColor={0,0,255},
      extent={{-150,150},{150,110}},textString="%name")}),
      Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a controller for a fuel cell DC/DC converter. The converter power is primarily controlled based on a set-point for state of charge of a buffer battery, with feedback of sensed state of charge. In addition, a feed-forward term is added based on the sensed electric machine power.</p>
</html>"));
end FuelCellControllerOuter;
