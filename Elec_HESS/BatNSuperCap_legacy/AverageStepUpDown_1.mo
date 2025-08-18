within BatNSuperCap_legacy;

model AverageStepUpDown_1
  "General step-up/down converter, averaged over the switching period."
  extends .Electrification.Converters.Templates.DCDC(
    redeclare replaceable .Electrification.Converters.Core.AverageStepUpDown core,
    redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_a,
    redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_b,
    redeclare replaceable .Electrification.Converters.Thermal.Lumped thermal,
    redeclare replaceable .Electrification.Converters.Control.MultiMode controller);
annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is an example of a voltage controlled step-up/down DCDC converter. The core model is an averaged representation of a switched DCDC converter, making it suitable for fast (or long) systems simulations.</p>
<p>All of the sub-domain models can be re-declared.</p>
<h4>Controller</h4>
<p>The converter reference voltage and limits are handled by the controller.</p>
<h4>Link capacitors</h4>
<p>Both the primary and secondary side have link capacitors. This is to ensure that the voltage is well defined, and to avoid non-linear equation systems. The reason for this is that the causality of this core converter is describing the current flowing between the primary and secondary side.</p>
<h4>Thermal</h4>
<p>A single lumped mass thermal model is used.</p>
</html>"));
end AverageStepUpDown_1;
