within HESS;
model DischargeCharge_Verification
  import Electrification.Batteries.*;
  extends  .Electrification.Batteries.Experiments.Verification.Templates.DischargeCharge(
    redeclare replaceable .HESS.KETI_BatteryPack batteryPack);
annotation (
  experiment(StopTime=40000, Interval=40, Tolerance=1e-06),
  Documentation(
    revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>",
    info="<html>
<p>In this experiment, the battery pack is put through a full discharge cycle and then a full charge cycle.</p>
<p>The load is configured to listen to limits communicated by the battery pack via the control bus connection. 
The battery pack has been configured to use the <a href=\"modelica://Electrification.Batteries.Control.LimitsFixed\">LimitsFixed</a> controller, which specifies the limits of the battery, and reduces the limits close to the SoC limits. 
The load is configured to change from discharging to charging mode when the current is reduced as the SoC limit is reached.</p>
<p>For more information, please refer to the <a href=\"modelica://Electrification.Batteries.Experiments.Verification.Templates.DischargeCharge\">DischargeCharge</a> template.</p>
<h4>Outputs</h4>
<p>Some of the relevant outputs are:</p>
<p>
<code>batteryPack.summary.v</code><br />
<code>batteryPack.summary.i</code><br />
<code>batteryPack.summary.SoC</code>
</p>
</html>"));
end DischargeCharge_Verification;
