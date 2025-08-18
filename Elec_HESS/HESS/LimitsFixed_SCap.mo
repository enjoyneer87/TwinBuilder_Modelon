within HESS;

model LimitsFixed_SCap "Fixed limits and SoC thresholds"
  extends .Electrification.Batteries.Control.Templates.Limits(
    enable_electrical=false,
    enable_thermal=false,
    enable_core=true);

  parameter .Modelica.Units.SI.Power pMaxOut=10*ns*np*pCellMaxDch "Maximum discharging power" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Power pMaxIn=10*ns*np*pCellMaxCh "Maximum charging power" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Current iMaxOut=10*np*iCellMaxDch "Maximum discharging current" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Current iMaxIn=10*np*iCellMaxCh "Maximum charging current" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Voltage vMax=ns*vCellMax "Maximum voltage" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Voltage vMin=ns*vCellMin "Minimum voltage" annotation (Dialog(group="Limits (battery pack)"));

  parameter Boolean theoretical_limit = true "Apply theoretical discharge power limit (based on internal resistance)" annotation(Dialog(group="Limits (battery pack)"), choices(checkBox=true));

  parameter Boolean SoC_limits=true    "Enable SoC limits" annotation(Dialog(group="State of charge"), choices(checkBox=true));
  parameter Real SoC_max = 0.9 "Absolute maximum SoC" annotation(Dialog(group="State of charge",enable=SoC_limits));
  parameter Real SoC_high = 0.8 "Upper SoC threshold" annotation(Dialog(group="State of charge",enable=SoC_limits));
  parameter Real SoC_low = 0.2 "Lower SoC threshold" annotation(Dialog(group="State of charge",enable=SoC_limits));
  parameter Real SoC_min = 0.1 "Absolute minimum SoC" annotation(Dialog(group="State of charge",enable=SoC_limits));

  .Electrification.Utilities.Blocks.MatrixMax cell_ch_soc(
    final m=gs, final n=gp) if SoC_limits
    "Cell SoC value for the charging limits"
    annotation (Placement(transformation(extent={{70,20},{50,40}})));
  .Electrification.Utilities.Blocks.MatrixMin cell_dch_soc(
    final m=gs, final n=gp) if SoC_limits
    "Cell SoC value for the discharging limits"
    annotation (Placement(transformation(extent={{70,-40},{50,-20}})));

  .Modelica.Blocks.Math.Gain gainIDch(k=iMaxOut) annotation (Placement(transformation(extent={{-12,14},
            {-20,22}})));
  .Modelica.Blocks.Math.Gain gainICh(k=iMaxIn) annotation (Placement(transformation(extent={{-12,30},
            {-20,38}})));
  .Modelica.Blocks.Math.Gain gainPDch(k=pMaxOut) annotation (Placement(transformation(extent={{-12,-18},
            {-20,-10}})));
  .Modelica.Blocks.Math.Gain gainPCh(k=pMaxIn) annotation (Placement(transformation(extent={{-12,-2},
            {-20,6}})));

  .Modelica.Blocks.Sources.Constant vMaxConst(k=vMax) annotation (Placement(transformation(extent={{-48,34},
            {-56,42}})));
  .Modelica.Blocks.Sources.Constant vMinConst(k=vMin) annotation (Placement(transformation(extent={{-48,18},
            {-56,26}})));
  .Modelon.Blocks.Routing.ConditionalInput pDchLim(
    off=not theoretical_limit,
    final k=.Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{-20,-92},{-28,-84}})));
  .Modelica.Blocks.Math.Min minPDch annotation (Placement(transformation(extent={{-48,-42},
            {-56,-34}})));
  .Electrification.Batteries.Control.Blocks.UpperDerate chargeFactor(u_max=SoC_max, u_high=SoC_high) if SoC_limits
                                                                  annotation (Placement(transformation(extent={{40,20},
            {20,40}})));
  .Electrification.Batteries.Control.Blocks.LowerDerate dischargeFactor(u_min=SoC_min, u_low=SoC_low)
    if SoC_limits annotation (Placement(transformation(extent={{40,-40},
            {20,-20}})));
  .Modelica.Blocks.Math.Min minIDch annotation (Placement(transformation(extent={{-48,-12},
            {-56,-4}})));
  .Modelon.Blocks.Routing.ConditionalInput iDchLim(
    off=not theoretical_limit,
    final k=.Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{-20,-76},{-28,-68}})));
  .Modelon.Blocks.Routing.ConditionalInput socGainCh(final k=1, off=not
        SoC_limits)
    annotation (Placement(transformation(extent={{14,26},{6,34}})));
  .Modelon.Blocks.Routing.ConditionalInput socGainDch(final k=1, off=not
        SoC_limits)
    annotation (Placement(transformation(extent={{14,-34},{6,-26}})));
  outer .Electrification.Batteries.Utilities.AvailablePower.Outputs availablePower
    annotation (Placement(transformation(extent={{100,-100},{80,-80}})));
  .Modelica.Blocks.Math.Min minPCh
    annotation (Placement(transformation(extent={{-48,-28},{-56,-20}})));
  .Modelon.Blocks.Routing.ConditionalInput iChLim(off=not theoretical_limit,
      final k=.Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{-6,-84},{-14,-76}})));
  .Modelon.Blocks.Routing.ConditionalInput pChLim(off=not theoretical_limit,
      final k=.Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{-6,-100},{-14,-92}})));
  .Modelica.Blocks.Math.Min minICh
    annotation (Placement(transformation(extent={{-48,2},{-56,10}})));
equation
  connect(iChLim.y, minICh.u2) annotation (Line(points={{-14.4,-80},{-36,-80},{-36,3.6},{-47.2,3.6}}, color={0,0,127}));
  connect(pChLim.y, minPCh.u2) annotation (Line(points={{-14.4,-96},{-44,-96},{-44,-26.4},{-47.2,-26.4}}, color={0,0,127}));
  connect(iDchLim.y, minIDch.u2) annotation (Line(points={{-28.4,-72},{-32,-72},{-32,-10.4},{-47.2,-10.4}},                                                                      color={0,0,127}));
  connect(gainPCh.y, minPCh.u1) annotation (Line(points={{-20.4,2},{-28,2},{-28,-21.6},{-47.2,-21.6}}, color={0,0,127}));
  connect(limits.componentBus, componentBus) annotation (Line(
      points={{-92,0},{-96,0},{-96,80},{0,80}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(cell_ch_soc.u, core.SoC_sns) annotation (
    Line(points={{72,30},{80,30},{80,0},{100,0}}, color={0,0,127}),
    Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(cell_dch_soc.u, core.SoC_sns) annotation (
    Line(points={{72,-30},{80,-30},{80,0},{100,0}},color={0,0,127}),
    Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(vMinConst.y, limits.v_min) annotation (Line(points={{-56.4,22},{-62,
          22},{-62,10},{-70,10}},                                                                    color={0,0,127}));
  connect(vMaxConst.y, limits.v_max) annotation (Line(points={{-56.4,38},{-64,
          38},{-64,16},{-70,16}},                                                                    color={0,0,127}));
  connect(minPDch.y, limits.p_max_out) annotation (Line(points={{-56.4,-38},{-64,-38},{-64,-14},{-70,-14}},color={0,0,127}));
  connect(minPDch.u1, gainPDch.y) annotation (Line(points={{-47.2,-35.6},{-24,-35.6},{-24,-14},{-20.4,-14}},color={0,0,127}));
  connect(pDchLim.y, minPDch.u2) annotation (Line(points={{-28.4,-88},{-40,-88},{-40,-40.4},{-47.2,-40.4}},color={0,0,127}));
  connect(chargeFactor.u, cell_ch_soc.y) annotation (Line(points={{42,30},{49,30}},color={0,0,127}));
  connect(dischargeFactor.u, cell_dch_soc.y) annotation (Line(points={{42,-30},{49,-30}},color={0,0,127}));
  connect(minIDch.u1, gainIDch.y) annotation (Line(points={{-47.2,-5.6},{-32,-5.6},{-32,18},{-20.4,18}},color={0,0,127}));
  connect(minIDch.y, limits.i_max_out) annotation (Line(points={{-56.4,-8},{-60,-8},{-60,-2},{-70,-2}},color={0,0,127}));
  connect(socGainCh.u, chargeFactor.y) annotation (Line(points={{14,30},{19,30}}, color={0,0,127}));
  connect(socGainCh.y, gainICh.u) annotation (Line(points={{5.6,30},{-2,30},{-2,34},{-11.2,34}}, color={0,0,127}));
  connect(socGainCh.y, gainPCh.u) annotation (Line(points={{5.6,30},{-2,30},{-2,2},{-11.2,2}}, color={0,0,127}));
  connect(socGainDch.u, dischargeFactor.y) annotation (Line(points={{14,-30},{19,-30}}, color={0,0,127}));
  connect(socGainDch.y, gainIDch.u) annotation (Line(points={{5.6,-30},{2,-30},{2,18},{-11.2,18}}, color={0,0,127}));
  connect(socGainDch.y, gainPDch.u) annotation (Line(points={{5.6,-30},{2,-30},{2,-14},{-11.2,-14}}, color={0,0,127}));
  connect(availablePower.iMaxDch, iDchLim.u) annotation (Line(points={{79,-84},
          {8,-84},{8,-72},{-20,-72}}, color={0,0,127}));
  connect(availablePower.pMaxDch, pDchLim.u) annotation (Line(points={{79,-92},
          {0,-92},{0,-88},{-20,-88}}, color={0,0,127}));
  connect(iChLim.u, availablePower.iMaxCh) annotation (Line(points={{-6,-80},{4,
          -80},{4,-88},{79,-88}}, color={0,0,127}));
  connect(pChLim.u, availablePower.pMaxCh)
    annotation (Line(points={{-6,-96},{79,-96}}, color={0,0,127}));
  connect(minPCh.y, limits.p_max_in) annotation (Line(points={{-56.4,-24},{-62,-24},{-62,-8},{-70,-8}}, color={0,0,127}));
  connect(minICh.y, limits.i_max_in) annotation (Line(points={{-56.4,6},{-60,6},{-60,4},{-70,4}}, color={0,0,127}));
  connect(minICh.u1, gainICh.y) annotation (Line(points={{-47.2,8.4},{-36,8.4},{-36,34},{-20.4,34}}, color={0,0,127}));
  annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This controller reports power, current and voltage limits for the battery to the system control bus. These limits are to be used by other controller(s) to ensure that the loads connected to the battery does not exceed these limits.</p>
<h4>Reduced limits based on SoC</h4>
<p>The power and current limits are specified as constant parameters, but will be reduced if the SoC is below <span style=\"font-family: Courier New;\">SoC_low</span> or above <span style=\"font-family: Courier New;\">SoC_high</span>. The limits will be zero if the SoC is below <span style=\"font-family: Courier New;\">SoC_min</span> or above <span style=\"font-family: Courier New;\">SoC_max</span>.</p>
<h4>Theoretical power limit</h4>
<p>When <span style=\"font-family: Courier New;\">theoretical_limit=true</span>, the controller will adjust the limits to ensure that they stay below the physical limit of how much power the battery can provide in steady state. This additional limit is based on the sensed OCV and internal resistance at any moment.</p>
<h4>Enable signal</h4>
<p>The limits are always active by default. 
When <code>external_enable = true</code>, 
the limits are scaled based on the <em>enable</em> signal supplied via the external control bus. 
When this signal is false, the power/current limits will be scaled down to zero, 
to effectively disable the operation of the controlled component.
A smooth transition is used to avoid harsh transients, which is controlled by the time constant (<code>T_enable</code>) parameter.</p>
</html>"));
end LimitsFixed_SCap;
