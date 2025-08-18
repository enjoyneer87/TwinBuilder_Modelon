within BatNSuperCap_Charge_ContactNLimit;

model LimitsFixed "Fixed limits and SoC thresholds"
  extends .Electrification.Batteries.Control.Templates.Limits(
    enable_electrical=false,
    enable_thermal=false,
    enable_core=false,external_enable = true,id = 1);

  parameter .Modelica.Units.SI.Power pMaxOut=ns*np*pCellMaxDch "Maximum discharging power" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Power pMaxIn=ns*np*pCellMaxCh "Maximum charging power" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Current iMaxOut=np*iCellMaxDch "Maximum discharging current" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Current iMaxIn=np*iCellMaxCh "Maximum charging current" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Voltage vMax=ns*vCellMax "Maximum voltage" annotation (Dialog(group="Limits (battery pack)"));
  parameter .Modelica.Units.SI.Voltage vMin=ns*vCellMin "Minimum voltage" annotation (Dialog(group="Limits (battery pack)"));
  parameter Real bid;
  parameter Boolean theoretical_limit = true "Apply theoretical discharge power limit (based on internal resistance)" annotation(Dialog(group="Limits (battery pack)"), choices(checkBox=true));

  parameter Boolean SoC_limits=true    "Enable SoC limits" annotation(Dialog(group="State of charge"), choices(checkBox=true));
  parameter Real SoC_max = 0.9 "Absolute maximum SoC" annotation(Dialog(group="State of charge",enable=SoC_limits));
  parameter Real SoC_high = 0.8 "Upper SoC threshold" annotation(Dialog(group="State of charge",enable=SoC_limits));
  parameter Real SoC_low = 0.2 "Lower SoC threshold" annotation(Dialog(group="State of charge",enable=SoC_limits));
  parameter Real SoC_min = 0.1 "Absolute minimum SoC" annotation(Dialog(group="State of charge",enable=SoC_limits));
    .Electrification.Control.Interfaces.SystemBus controlBus2 annotation(HideResult = hide_bus_signals,Placement(transformation(extent = {{46.0,52.0},{86.0,92.0}},rotation = 0.0,origin = {0.0,0.0})));
    .BatNSuperCap_Charge_ContactNLimit.LimitedSub limitedSub(enable_core = false,enable_electrical = false,external_limits = true,listen = true,typeListen = Electrification.Utilities.Types.ControllerType.Battery,id = bid,id_listen = id) annotation(Placement(transformation(extent = {{12.0,-16.0},{-8.0,4.0}},origin = {0.0,0.0},rotation = 0.0)));
equation
  connect(limits.componentBus, componentBus) annotation (Line(
      points={{-92,0},{-96,0},{-96,80},{0,80}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
    connect(limitedSub.controlBus,controlBus2) annotation(Line(points = {{2,4},{2,28},{66,28},{66,72}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(limits.i_max_in,limitedSub.y) annotation(Line(points = {{-70,4},{-37.5,4},{-37.5,-2.6},{-5,-2.6}},color = {0,0,127}));
    connect(limits.i_max_out,limitedSub.y2) annotation(Line(points = {{-70,-2},{-37.6,-2},{-37.6,-4.4},{-5.2,-4.4}},color = {0,0,127}));
    connect(limits.p_max_in,limitedSub.y3) annotation(Line(points = {{-70,-8},{-37.5,-8},{-37.5,-6.4},{-5,-6.4}},color = {0,0,127}));
    connect(limits.p_max_out,limitedSub.y4) annotation(Line(points = {{-70,-14},{-37.5,-14},{-37.5,-9.2},{-5,-9.2}},color = {0,0,127}));
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
end LimitsFixed;
