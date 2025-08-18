within BatNSuperCap_Charge_ContactNLimit;

model LimitedTorque_1 "Limited torque controller"
  extends .Electrification.Machines.Control.Templates.Limited(
    enable_core=true,
    enable_electrical=true,
    enable_mechanical=false,
    enable_thermal=false,
    limits(
      external_limits=external_limits,
      listen=listen,
      id_listen=id_listen,
      typeListen=typeListen,
      iMaxIn=iMaxIn,
      iMaxOut=iMaxOut,
      pMaxIn=pMaxIn,
      pMaxOut=pMaxOut,
      k_pMax=k_pMax));

  replaceable .Electrification.Machines.Control.Torque torqueControl(
    hide_bus_signals=hide_bus_signals,
    enable_core=true,
    enable_electrical=true) constrainedby .Electrification.Machines.Control.Templates.TorqueControl(final id=id)
    annotation (
    Dialog(group="Components"),
    Placement(transformation(extent={{30,-20},{70,20}})),
    choicesAllMatching=true);
  parameter Real k_pMax=1 "Scaling factor of pMax[In/Out]" annotation (Dialog(group="Limits"));
equation
  connect(torqueControl.controlBus, controlBus) annotation (Line(
      points={{50,20},{50,90},{0,90},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueControl.core, core) annotation (Line(
      points={{70,-4},{84,-4},{84,-36},{100,-36},{100,-20}},
      color={150,150,150},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(torqueControl.electrical, electrical) annotation (Line(
      points={{70,-12},{76,-12},{76,-44},{100,-44},{100,-60}},
      color={120,180,200},
      pattern=LinePattern.Dot,
      thickness=0.5));
annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This controller combines a <a href=\"modelica://Electrification.Machines.Control.LimitedSub\">limit sub-controller</a> with a torque controller.</p>
<p>The default <a href=\"modelica://Electrification.Machines.Control.Torque\">Torque</a> controller can be replaced by any controller based on the <a href=\"modelica://Electrification.Machines.Control.Templates.TorqueControl\">TorqueControl</a> template (e.g. <a href=\"modelica://Electrification.Machines.Control.Power\">Power</a> and <a href=\"modelica://Electrification.Machines.Control.MultiMode\">MultiMode</a>)</p>
<p>For related information, refer to the section about <a href=\"modelica://Electrification.Machines.Information.Limits\">specifying limits</a> for machines.</p>
</html>"));
end LimitedTorque_1;
