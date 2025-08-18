within BatNSuperCap_legacy;

model BatteryCharger_1
  "Battery charger with limits from the controller"
  extends .Electrification.Loads.Templates.Base(
    redeclare replaceable .Electrification.Loads.Core.CurrentSource core(
      iMin=-35,
      controlled=true,
      final iMax=0),
    redeclare replaceable .Electrification.Loads.Electrical.CapacitorAndDiode electrical,
    redeclare replaceable .Electrification.Loads.Thermal.Lumped thermal,redeclare replaceable .BatNSuperCap_legacy.CntrlBatteryCharger controller,
    fixed_temperature=true);
  extends .Electrification.Loads.Icons.BatteryCharger(final hide_symbol_icon=hide_component_icon);
  annotation (                                               Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a battery charger component, that limits the output power based on limits provided by the battery controller.</p>
<p>Please refer to the <a href=\"modelica://Electrification.Examples.BatteryCharging\">BatteryCharging</a> system example, for a demonstration of how to use the battery charger.</p>
</html>"));
end BatteryCharger_1;
