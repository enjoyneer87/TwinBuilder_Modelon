within BatNSuperCap_legacy;

model BatFromCar_ContactNLimit "A battery pack for an electric car"
  extends .Electrification.Batteries.Templates.BatteryPackLumped(
    ns=100,
    np=60,
    redeclare .Electrification.Batteries.Core.Examples.NCA.Characteristic core,redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,
    redeclare replaceable .Electrification.Batteries.Thermal.Examples.Lumped thermal(C_cell=50, C_pack=0),redeclare replaceable .BatNSuperCap_legacy.BatLimitsAndContactors controller(contactors(contactors_closed = false)));
annotation (
  defaultComponentName="battery1",
  Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a <a href=\"modelica://Electrification.Batteries.Information.CellGroups\">lumped</a> model of a battery pack for an electric vehicle application, 
with the number of cells scaled according to the energy and power requirements of the corresponding electric powertrain. 
The model captures basic dynamics of the state of charge, voltage, heat losses, and temperature. 
The battery pack has a controller for communicating limits to the loads in the electric system, to ensure the battery pack is not overloaded.</p>
<p>The model is used in several of the automotive examples, including:<br />
<a href=\"modelica://Electrification.Examples.SeriesDriveCycle\">Electrification.Examples.SeriesDriveCycle</a><br />
<a href=\"modelica://Electrification.Examples.ElectricRange\">Electrification.Examples.ElectricRange</a><br />
<a href=\"modelica://Electrification.Examples.BatteryCharging\">Electrification.Examples.BatteryCharging</a><br />
<a href=\"modelica://Electrification.Examples.MaximumPerformance\">Electrification.Examples.MaximumPerformance</a></p>
</html>"));
end BatFromCar_ContactNLimit;
