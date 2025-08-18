within BatNSuperCap_legacy;

model Controller_idListen_BatteryCharger "Battery charger controller"
  extends .Electrification.Loads.Control.Templates.LimitedCurrent(
    external_limits=true,
    final listen=listen_to_battery,
    final typeListen=Electrification.Utilities.Types.ControllerType.Battery,
    final iMaxIn=0,
    final pMaxIn=0,
    componentLimits(
      final iMaxInSignal,
      final pMaxInSignal,
      final iMaxIn,
      final pMaxIn,
      final typeListen = Electrification.Utilities.Types.ControllerType.Battery),
    iAct(final off=false));

  parameter Boolean listen_to_battery = true "Listen to the limits from a battery controller" annotation(Dialog(group="ControlBus",enable=external_limits));

equation
  connect(iAct.u, neg_i.y) annotation (Line(points={{60,0},{52,0},{52,38},{
          -55.8,38}}, color={0,0,127}));
annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a controller for a <a href=\"modelica://Electrification.Loads.Examples.BatteryCharger\">battery charger</a> load. It allows defining the charger limits with constant parameters, or by listening to limits reported by the battery controller.</p>
</html>"));
end Controller_idListen_BatteryCharger;
