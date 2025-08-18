within BatNSuperCap_legacy;

model BatteryChargerFixedLimits_CC "Battery charger with fixed limits"
  parameter .Modelica.Units.SI.Voltage vMax=370 "Maximum voltage" annotation (Dialog(group="Charger limits"));
  parameter .Modelica.Units.SI.Current iMax=1000 "Maximum current" annotation (Dialog(group="Charger limits"));
  parameter .Modelica.Units.SI.Power pMax=35e10 "Maximum power" annotation (Dialog(group="Charger limits"));

  extends .Electrification.Loads.Templates.Base(
    redeclare .Electrification.Loads.Core.PowerSource core(
      final controller_limits=false,
      iMin=-iMax,
      pRef=-pMax,
      vMax=vMax,
      final iMax=0,
      final controlled=false),
    redeclare replaceable .Electrification.Loads.Electrical.CapacitorAndDiode electrical,
    redeclare replaceable .Electrification.Loads.Thermal.Lumped thermal,
    redeclare final .Electrification.Loads.Control.None controller,
    enable_control_bus=false,
    fixed_temperature=true);
  extends .Electrification.Loads.Icons.BatteryCharger(final hide_symbol_icon=hide_component_icon);

  annotation (                                               Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a battery charger component, that provides power according to fixed limits (vMax, iMax, pMax).</p>
<p>Please refer to the <a href=\"modelica://Electrification.Examples.BatteryCharging\">BatteryCharging</a> system example, for a demonstration of how to use the battery charger.</p>
</html>"));
end BatteryChargerFixedLimits_CC;
