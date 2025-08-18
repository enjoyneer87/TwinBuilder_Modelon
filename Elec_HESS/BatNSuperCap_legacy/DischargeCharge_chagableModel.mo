within BatNSuperCap_legacy;

partial model DischargeCharge_chagableModel


  "Template for an experiment with a fulle discharge and charge cycle"
  extends .Modelon.Icons.Experiment;
  replaceable .Electrification.Batteries.Interfaces.BatteryPack batteryPack(
    internal_ground=true,
    enable_thermal_port=false,
    SOC_start=1.0,
    display_name=true,
    limitActionSoC=.Modelon.Types.FaultAction.Warning,
    limitActionV=.Modelon.Types.FaultAction.Warning)
    annotation (Placement(transformation(extent={{10,-20},{50,20}})));
  .Electrification.Loads.Examples.Current       load(
    enable_thermal_port=false,
    display_name=true,
    redeclare .Electrification.Loads.Control.BatteryCycler controller(
      iDischarge=0.2*batteryPack.i_nom_1C,
      T_rest=600,
      repeat=false,
      external_limits=true,
      listen_to_battery=true,
      id_battery=batteryPack.id))
    annotation (Placement(transformation(extent={{-30,-20},{-70,20}})));
  .Electrification.Electrical.DCInit initialVoltage(
    init_start=true,
    v_start=batteryPack.summary.ocv) annotation (
      Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(load.plug_a, batteryPack.plug_a) annotation (Line(
      points={{-30,0},{10,0}},
      color={255,128,0},
      thickness=0.5));
  connect(batteryPack.controlBus, load.controlBus) annotation (Line(
      points={{14,20},{-34,20}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(initialVoltage.plug_a, load.plug_a) annotation (
    Line(
      points={{-40,-30},{-30,-30},{-30,0}},
      color={255,128,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is an experiment template for putting a battery pack through a full discharge cycle and then a full charge cycle, while respecting the limits reported by the battery controller.</p>
<h4>Load cycle</h4>
<p>The discharge/charge load cycle is controlled via the <em>load</em> component. 
The cycle can be modified by adjusting the parameters of the controller sub-component of the load.</p>
<h4>Battery limits</h4>
<p>By default, the load is configured to listen to limits provided by the battery pack via the control bus connection. 
<strong>Note</strong> that the battery pack needs to use a controller that publishes such limits (e.g. the <a href=\"modelica://Electrification.Batteries.Control.LimitsFixed\">LimitsFixed</a> controller). 
Alternatively, the load controller can be configured with manually specified limits. In that case, the battery pack does not need any specific controller.</p>
<h4>Initial voltage</h4>
<p>Also note that the load component includes an output capacitor. 
To avoid large initial transients, a <a href=\"modelica://Electrification.Electrical.DCInit\">DCInit</a> component is used to initialize the capacitor voltage to match the OCV of the battery pack.</p>
</html>"));
end DischargeCharge_chagableModel;
