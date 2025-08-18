within BatNSuperCap_legacy;

model BatLimitsAndContactors
  "Combined controllers for limits and contactors"
  extends .Electrification.Batteries.Control.Templates.SubControllerWithLimits(
    enable_electrical=true,
    enable_thermal=false,
    enable_core=true,
    redeclare replaceable .Electrification.Batteries.Control.LimitsTabular limits(external_enable = false)
    constrainedby .Electrification.Batteries.Control.Templates.Limits(external_enable=true));
  .Electrification.Batteries.Control.ContactorControl contactors(
    hide_bus_signals=hide_bus_signals,
    enable_core=true,
    enable_electrical=true,
    enable_thermal=false,
    final id=id,
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp,external_control = true,vCellMax = vCellMax,vCellMin = vCellMin,iCellMaxDch = iCellMaxDch,iCellMaxCh = iCellMaxCh,pCellMaxDch = pCellMaxDch,pCellMaxCh = pCellMaxCh,contactors_closed = false) annotation (Dialog(group="Components"),Placement(transformation(extent={{-20.0,-80.0},{20.0,-40.0}},rotation = 0.0,origin = {0.0,0.0})));
equation
  connect(contactors.electrical, electrical) annotation (Line(
      points={{20,-72},{100,-72},{100,-60}},
      color={120,180,200},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(contactors.controlBus, controlBus) annotation (Line(
      points={{0,-40},{0,-34},{-26,-34},{-26,26},{0,26},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  annotation(Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This controller combines the functionality of the <a href=\"modelica://Electrification.Batteries.Control.ContactorControl\">ContactorControl</a> controller with a replaceable controller for reporting volage/current/power limits for the battery.</p>
</html>"));
end BatLimitsAndContactors;
