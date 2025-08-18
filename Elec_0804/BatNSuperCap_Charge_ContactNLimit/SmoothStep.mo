within BatNSuperCap_Charge_ContactNLimit;
model SmoothStep
  parameter Real uLow = 0.45 "Lower threshold";
  parameter Real uHigh = 0.55 "Upper threshold";

  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

protected
  Real t;

equation
  t = noEvent((u - uLow) / (uHigh - uLow));
  y = if u <= uLow then 0
      else if u >= uHigh then 1
      else 3*t^2 - 2*t^3;

annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics = {
         Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-80,-60},{80,60}}),
         Text(lineColor={0,0,255}, extent={{-70,20},{70,50}}, textString="SmoothStep"),
         Line(points={{-100,0},{-80,0}}, color={0,0,127}),
         Line(points={{80,0},{100,0}}, color={0,0,127}),
         Ellipse(extent={{-106,6},{-94,-6}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid),
         Ellipse(extent={{94,6},{106,-6}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid)
       })
);
end SmoothStep;