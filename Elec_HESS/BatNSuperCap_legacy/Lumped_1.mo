within BatNSuperCap_legacy;

model Lumped_1 "Battery pack with all cells lumped as one unit"
  extends .Electrification.Batteries.Templates.BatteryPackLumped(
    redeclare replaceable .Electrification.Batteries.Core.Examples.Modular core,
    redeclare replaceable .Electrification.Batteries.Electrical.Pack.Ideal electrical,
    redeclare replaceable .Electrification.Batteries.Thermal.Examples.Lumped thermal,
    redeclare replaceable .Electrification.Batteries.Control.LimitsFixed controller,
    ns=100,
    np=2);

annotation (
  defaultComponentName="battery1",
  Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a re-configurable battery pack model, where the collection of cells in the pack are &quot;lumped&quot; into a single virtual cell. 
This is the most common type of model, which is efficient to simulate, and useful for any case when the cells in the pack can be assumed to be identical.</p>
<p>All sub-components of this model can be redeclared, and configured to represent any pack with lumped cells. 
The model can be used directly in a system model and configured in-place, or <em>duplicated</em> into a new model and re-configured as a re-usable model.</p>
<p>For more information, please refer to the guide: <a href=\"modelica://Electrification.Batteries.Information.ConfigureBattery\">Configure a battery model</a>.</p>
</html>"));
end Lumped_1;
