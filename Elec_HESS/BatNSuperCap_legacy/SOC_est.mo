within BatNSuperCap_legacy;
model SOC_est
  // "CoulombCountingSOC_Block"
  "SOC estimator (block diagram) with visible icons in Diagram layer"
  import Modelica.Blocks;
  import Modelica.Blocks.Types.Init;

  // ---- Parameters ----
  parameter Real SOC0(min=0, max=1) = 0.8 "Initial SOC";
  parameter Real C_rated = 200*3600
    "Rated capacity [C] (e.g., 200 Ah = 200*3600)";
  parameter Boolean dischargePositive = true
    "true: I>0 is DISCHARGE; false: I>0 is CHARGE";
  parameter Real eta_chg(min=0, max=1) = 0.99 "Coulombic eff. on charge";
  parameter Real eta_dis(min=0, max=1) = 1.00 "Coulombic eff. on discharge";

  // ---- I/O ----
  Blocks.Interfaces.RealInput  I "Battery current [A]"
    annotation (Placement(transformation(extent={{-179.16,2.92},{-139.16,42.92}},rotation = 0.0,origin = {0.0,0.0})));
  Blocks.Interfaces.RealOutput SOC "State of Charge [0..1]"
    annotation (Placement(transformation(extent={{172.71,21.3},{212.71,61.3}},rotation = 0.0,origin = {0.0,0.0})));

protected
  Blocks.Math.Gain signGain(k = if dischargePositive then 1 else -1)
    annotation (Placement(transformation(extent={{-111.87,15.52},{-91.87,35.52}},rotation = 0.0,origin = {0.0,0.0})));

  Blocks.Sources.Constant invEtaDis(k = if eta_dis>0 then 1/eta_dis else 1e9)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Blocks.Sources.Constant etaChg(k = eta_chg)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Blocks.Math.Product prodDis
    annotation (Placement(transformation(extent={{-42.36,8.5},{-22.36,28.5}},rotation = 0.0,origin = {0.0,0.0})));
  Blocks.Math.Product prodChg
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Blocks.Logical.GreaterEqualThreshold geZero(threshold = 0)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Blocks.Logical.Switch pickIeff
    annotation (Placement(transformation(extent={{11.84,-1.05},{31.84,18.95}},rotation = 0.0,origin = {0.0,0.0})));

  Blocks.Math.Gain kGain(k = -1/C_rated)
    annotation (Placement(transformation(extent={{42.62,2.09},{62.62,22.09}},rotation = 0.0,origin = {0.0,0.0})));

  Blocks.Continuous.Integrator integ(
    k = 1,
    y_start = SOC0,
    initType = Init.InitialOutput)
    annotation (Placement(transformation(extent={{79.09,31.63},{99.09,51.63}},rotation = 0.0,origin = {0.0,0.0})));

  Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 1)
    annotation (Placement(transformation(extent={{122.64,31.24},{142.64,51.24}},rotation = 0.0,origin = {0.0,0.0})));

equation
  connect(signGain.y, prodDis.u1) annotation (Line(points={{-90.87,25.52},{-90.87,15.61},{-44.36,15.61},{-44.36,24.5}}, color={0,0,127}));
  connect(invEtaDis.y, prodDis.u2) annotation (Line(points={{-60,-10},{-50,-10},{-50,12.5},{-44.36,12.5}}, color={0,0,127}));

  connect(signGain.y, prodChg.u1) annotation (Line(points={{-90.87,25.52},{-50,25.52},{-50,-30},{-40,-30}}, color={0,0,127}));
  connect(etaChg.y, prodChg.u2) annotation (Line(points={{-60,-50},{-50,-50},{-50,-35},{-40,-35}}, color={0,0,127}));

  connect(signGain.y, geZero.u) annotation (Line(points={{-90.87,25.52},{-50,25.52},{-50,50},{-40,50}}, color={0,0,127}));

  connect(prodDis.y, pickIeff.u1) annotation (Line(points={{-21.36,18.5},{9.84,18.5},{9.84,16.95}}, color={0,0,127}));
  connect(geZero.y, pickIeff.u2) annotation (Line(points={{-20,50},{-1.02,50},{-1.02,8.95},{9.84,8.95}}, color={255,0,255}));
  connect(prodChg.y, pickIeff.u3) annotation (Line(points={{-20,-30},{9.84,-30},{9.84,0.95}}, color={0,0,127}));

  connect(pickIeff.y, kGain.u) annotation (Line(points={{32.84,8.95},{32.84,12.09},{40.62,12.09}}, color={0,0,127}));
  connect(kGain.y, integ.u) annotation (Line(points={{63.62,12.09},{70.29,12.09},{70.29,41.63},{77.09,41.63}}, color={0,0,127}));
  connect(integ.y, limiter.u) annotation (Line(points={{100.09,41.63},{120.64,41.63},{120.64,41.24}}, color={0,0,127}));
  connect(limiter.y, SOC) annotation (Line(points={{143.64,41.24},{143.64,41.3},{192.71,41.3}}, color={0,0,127}));
  connect(I,signGain.u) annotation(Line(points = {{-159.16,22.92},{-113.87,22.92},{-113.87,25.52}},color = {0,0,127}));


end SOC_est;
