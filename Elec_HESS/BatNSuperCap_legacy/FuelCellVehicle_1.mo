within BatNSuperCap_legacy;

model FuelCellVehicle_1 "A battery pack for a fuel cell car"
  extends .Electrification.Batteries.Examples.Nominal(
    capacityNom=14400,
    vNom=300,
    vMin=220,
    iMax=200,
    specify_losses=.Electrification.Batteries.Utilities.Types.SpecLosses.Current,
    limit_voltage=true,
    redeclare replaceable .Electrification.Batteries.Control.CellSensors controller,
    ns=90,
    np=1);
annotation (
  defaultComponentName="battery1",
  Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a <a href=\"modelica://Electrification.Batteries.Information.CellGroups\">lumped</a> model of a battery pack for a fuel cell hybrid electric vehicle application. 
The model captures basic dynamics of the state of charge, voltage, heat losses, and temperature. 
The battery pack has a controller for communicating limits to the loads in the electric system, to ensure the battery pack is not overloaded.</p>
<p>The model is used in the <a href=\"modelica://Electrification.Examples.FuelCellVehicle\">FuelCellVehicle</a> example.</p>
</html>"));
end FuelCellVehicle_1;
