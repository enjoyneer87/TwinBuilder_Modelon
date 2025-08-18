within BatNSuperCap_legacy;

partial model Modular "Template for modular equivalent circuit battery models"
  extends .Electrification.Batteries.Core.Interfaces.Base(final Q_cap_all_nom=capacity.Q_cap_all_nom,
    summary(
      final ns=ns,
      final np=np,
      final gs=gs,
      final gp=gp,
      v=pin_p.v - pin_n.v,
      i=pin_p.i,
      i_ch_max=max(0, ngs*vCellMax - summary.ocv)/max(.Modelica.Constants.eps, summary.R_max_ch),
      i_dch_max=min(summary.ocv/2,max(0, summary.ocv - ngs*vCellMin))/max(.Modelica.Constants.eps, summary.R_max_dch),
      p_ch_max=ngs*vCellMax*summary.i_ch_max,
      p_dch_max=max(summary.ocv/2, ngs*vCellMin)*summary.i_dch_max,
      ocv=voltage.v,
      Q=capacity.Q,
      v_drop=impedance.v,
      i_self=selfDischarge.i,
      Q_cap_all_aged=capacity.Q_cap_all_aged,
      C_rate=capacity.C_rate,
      Q_cap_cell_aged=capacity.Q_cap_cell_aged,
      SoC=capacity.SoC,
      R_max_dch=impedance.R_max_dch.y,
      R_max_ch=impedance.R_max_ch.y));

  replaceable .Electrification.Batteries.Core.Capacity.Interfaces.Base capacity(
    SOC_start=SOC_start,
    final ns=ns,
    final np=np,
    final enable_heatport=true,
    final gs=gs,
    final gp=gp,
    T0=T0,
    initialize_charge=not initialize_with_OCV,
    limitAction=limitActionSoC,
    SoC_max=SoC_max,
    SoC_min=SoC_min,
    SoC_tol=limitTolSoC,
    limitStart=limitStartSoC)
    "Battery charge capacity"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Components"),
    Placement(transformation(
        extent={{-16,16},{16,-16}},
        rotation=180,
        origin={-68,0})));
  replaceable .Electrification.Batteries.Core.OCV.Interfaces.Base voltage(
    final enable_heatport=true,
    final ns=ns, final np=np,
    final gs=gs,
    final gp=gp,
    T0=T0,
    initialize_with_OCV=initialize_with_OCV,
    v_start=OCV_start)
   "Open Circuit Voltage (OCV)" annotation (
      choicesAllMatching=true,
      Dialog(group="Components"),
      Placement(transformation(extent={{36,-16},{4,16}})));
  replaceable .Electrification.Batteries.Core.Impedance.Interfaces.Base impedance(
    final enable_heatport=true,
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp,
    T0=T0) "Battery energy impedance/losses" annotation (
    choicesAllMatching=true,
    Dialog(group="Components"),
    Placement(transformation(extent={{80,-16},{48,16}})));
  replaceable .Electrification.Batteries.Core.SelfDischarge.Interfaces.Base selfDischarge(
    final enable_heatport=true,
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp,
    T0=T0) "Self discharge" annotation (
      choicesAllMatching=true,
      Dialog(group="Components"),
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-68,50})));
  replaceable .Electrification.Batteries.Core.Aging.Interfaces.Base aging(
    final enable_heatport=true,
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp,
    T0=T0) "Battery aging" annotation (
      choicesAllMatching=true,
      Dialog(group="Components"),
      Placement(
        transformation(extent={{-8,-16},{-40,16}})));
  .Modelon.Utilities.Limits.RealLimitFault limitVoltage(
    action=limitActionV,
    use_explicit_checking_time=true,
    xName="Battery cell voltage",
    x=summary.v_cell,
    message=
        "This may be caused by exceeding the power capability (too high current).",
    t0=limitStartV,
    xMax=vCellMax + limitTolV,
    xMin=vCellMin - limitTolV) "Monitors whether the voltage limit is exceeded"
    annotation (Placement(transformation(extent={{-118,-98},{-102,-82}})));
  replaceable .Electrification.Batteries.Core.Sensors.BaseCommon sensors(
    T0=T0,
    v_sns=pin_p.v - pin_n.v,
    ocv_sns=voltage.v,
    i_sns=pin_p.i,
    SoC_sns=capacity.SoC,
    R_max_dch_sns=impedance.R_max_dch.y,
    final enable_heatport=enable_heatport)
    constrainedby .Electrification.Batteries.Core.Sensors.Interfaces.Base(
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp) "Sensors" annotation (
    choicesAllMatching=true,
    Dialog(tab="Sensors"),
    Placement(transformation(extent={{-94,74},{-106,86}})));
  .Modelon.Utilities.Limits.RealLimitFault limitCurrent(
    x=summary.i_cell,
    xMax=iCellMaxCh,
    xMin=-iCellMaxDch,
    action=limitActionI,
    use_explicit_checking_time=true,
    xName="Cell current",
    t0=limitStartI) "Monitors whether the current limit is exceeded"
    annotation (Placement(transformation(extent={{-118,-78},{-102,-62}})));
  .Modelon.Utilities.Limits.RealLimitFault limitPower(
    xMax=pCellMaxCh,
    action=limitActionP,
    use_explicit_checking_time=true,
    xName="Cell power",
    t0=limitStartP,
    x=summary.i_cell*summary.v_cell,
    xMin=-pCellMaxDch) "Monitors whether the power limit is exceeded"
    annotation (Placement(transformation(extent={{-118,-58},{-102,-42}})));

equation
  connect(sensors.cellState, capacity.cellState) annotation (Line(points={{-100,74},
          {-100,32},{-68,32},{-68,16}},                                                                         color={217,67,180}));
  connect(capacity.cellState, impedance.cellState) annotation (Line(points={{-68,16},
          {-68,32},{64,32},{64,16}}, color={217,67,180}));
  connect(impedance.heatPort, temp) annotation (Line(points={{64,-16},{64,-34},
          {100,-34},{100,-20}},     color={191,0,0}));
  connect(impedance.p, pin_p) annotation (Line(points={{80,0},{86,0},{86,70},{0,
          70},{0,100}}, color={0,0,255}));
  connect(capacity.heatPort, temp) annotation (Line(points={{-68,-16},{-68,-34},
          {100,-34},{100,-20}},               color={191,0,0}));
  connect(capacity.cellState, voltage.cellState) annotation (Line(points={{-68,16},{-68,32},{20,32},{20,16}},color={217,67,180}));
  connect(voltage.heatPort, temp) annotation (Line(points={{20,-16},{20,-34},{100,-34},{100,-20}}, color={191,0,0}));
  connect(voltage.p, impedance.n) annotation (Line(points={{36,0},{48,0}}, color={0,0,255}));
  connect(selfDischarge.cellState, capacity.cellState) annotation (Line(points={{-68,40},
          {-68,16}},              color={217,67,180}));
  connect(selfDischarge.p, voltage.p) annotation (Line(points={{-58,50},{42,50},
          {42,0},{36,0}}, color={0,0,255}));
  connect(selfDischarge.n, capacity.n) annotation (Line(points={{-78,50},{-90,50},
          {-90,1.77636e-015},{-84,1.77636e-015}},
                            color={0,0,255}));
  connect(pin_n, capacity.n) annotation (Line(points={{0,-100},{0,-70},{-90,-70},
          {-90,4.44089e-16},{-84,4.44089e-16}},
                            color={0,0,255}));
  connect(selfDischarge.heatPort, temp) annotation (Line(points={{-68,60},{-68,
          68},{-96,68},{-96,-34},{100,-34},{100,-20}}, color={191,0,
          0}));
  connect(aging.cellState, capacity.cellState) annotation (Line(points={{-24,16},{-24,
          16},{-24,32},{-68,32},{-68,16}}, color={217,67,180}));
  connect(aging.heatPort, temp) annotation (Line(points={{-24,-16},{-24,-34},{
          100,-34},{100,-20}}, color={191,0,0}));
  connect(capacity.p, aging.n) annotation (Line(points={{-52,0},{-40,0}}, color={0,0,255}));
  connect(aging.p, voltage.n) annotation (Line(points={{-8,0},{4,0}}, color={0,0,255}));
  connect(sensors.signals, signals) annotation (Line(
      points={{-94,80},{-80,80}},
      color={150,150,150},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(sensors.heatPort, temp) annotation (Line(points={{-106,80},{-110,80},
          {-110,68},{-96,68},{-96,-34},{100,-34},{100,-20}}, color={191,
          0,0}));
annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a common base template for battery core models. For information about the structure provided by this template, please refer to the documentation of the <a href=\"modelica://Electrification.Batteries.Core\">Core package</a>.</p>
<h4>Limits</h4>
<p>The template also applies the limits for cell voltage, current, and power using the <a href=\"modelica://Modelon.Utilities.Limits.RealLimitFault\">RealLimitFault</a> component, which allows generating errors and warnings when these limits are exceeded.</p>
<h4>Sensors</h4>
<p>A sensor component is included, to provide several common variables to the controller via sensor signals. For more information about this concept, the section <a href=\"modelica://Electrification.Information.UsersGuide.BasicConcepts.ControllersAndSignals\">Controllers and signals</a> in the User&apos;s Guide.</p>
</html>"), Diagram(graphics={
        Text(
          extent={{-66,-20},{-36,-26}},
          textColor={150,150,150},
          textString="capacity",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-22,-20},{8,-26}},
          textColor={150,150,150},
          horizontalAlignment=TextAlignment.Left,
          textString="aging"),
        Text(
          extent={{22,-20},{52,-26}},
          textColor={150,150,150},
          horizontalAlignment=TextAlignment.Left,
          textString="voltage"),
        Text(
          extent={{66,-20},{96,-26}},
          textColor={150,150,150},
          horizontalAlignment=TextAlignment.Left,
          textString="impedance"),
        Text(
          extent={{-66,70},{-20,64}},
          textColor={150,150,150},
          horizontalAlignment=TextAlignment.Left,
          textString="self-discharge")}));
end Modular;
