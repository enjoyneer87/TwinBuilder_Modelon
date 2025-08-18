within BatNSuperCap_legacy;

partial model Base_1 "Common interface for battery core models"

  replaceable input .Electrification.Batteries.Core.Records.Summary summary(p_loss=heatLoss) annotation (Dialog(tab="Records"), choicesAllMatching=true, Placement(transformation(extent={{82,82}, {98,98}})));

  parameter .Modelica.Units.SI.Voltage vCellMax=1e6 "Maximum cell voltage" annotation (Dialog(tab="Limits",group="Limits"));
  parameter .Modelica.Units.SI.Voltage vCellMin=0 "Minimum cell voltage" annotation (Dialog(tab="Limits",group="Limits"));
  parameter .Modelica.Units.SI.Current iCellMaxDch=1000*iCell_nom_1C "Maximum cell discharging current" annotation (Dialog(tab="Limits",group="Limits"));
  parameter .Modelica.Units.SI.Current iCellMaxCh=1000*iCell_nom_1C "Maximum cell charging current" annotation (Dialog(tab="Limits",group="Limits"));
  parameter .Modelica.Units.SI.Power pCellMaxDch=vCellMax*iCellMaxDch "Maximum cell discharging power" annotation (Dialog(tab="Limits",group="Limits"));
  parameter .Modelica.Units.SI.Power pCellMaxCh=vCellMax*iCellMaxCh "Maximum cell charging power" annotation (Dialog(tab="Limits",group="Limits"));
  parameter Real SoC_max = 1 "Maximum SoC [0..1]" annotation(Dialog(tab="Limits",group="Limits"));
  parameter Real SoC_min = 0 "Minimum SoC [0..1]" annotation(Dialog(tab="Limits",group="Limits"));

  parameter .Modelon.Types.FaultAction limitActionV = .Modelon.Types.FaultAction.Error
    "Action when violating voltage limits" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelon.Types.FaultAction limitActionI = .Modelon.Types.FaultAction.Warning
    "Action when violating the current limits" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelon.Types.FaultAction limitActionP = .Modelon.Types.FaultAction.Warning
    "Action when violating the power limits" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelon.Types.FaultAction limitActionSoC = .Modelon.Types.FaultAction.Error
    "Action when violating SoC limits" annotation (Dialog(tab="Limits", group="Warnings/Errors"));

  parameter .Modelica.Units.SI.Voltage limitTolV(min=0) = 0.001 "Epsilon tolerance on cell voltage" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelica.Units.SI.Current limitTolI(min=0)=1e-6 "Epsilon tolerance on cell current" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelica.Units.SI.Power limitTolP(min=0)=1e-6 "Epsilon tolerance on cell power" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter Real limitTolSoC(min=0)=1e-6 "Epsilon tolerance on SoC level" annotation (Dialog(tab="Limits", group="Warnings/Errors"));

  parameter .Modelica.Units.SI.Time limitStartV=.Modelica.Constants.eps "Start monitoring voltage level at this time" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelica.Units.SI.Time limitStartI=0 "Start monitoring cell current at this time" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelica.Units.SI.Time limitStartP=0 "Start monitoring cell power at this time" annotation (Dialog(tab="Limits", group="Warnings/Errors"));
  parameter .Modelica.Units.SI.Time limitStartSoC=0 "Start monitoring SoC level at this time" annotation (Dialog(tab="Limits", group="Warnings/Errors"));

  parameter Boolean initialize_with_OCV = false "Initialize state of charge (SoC) based on OCV_start" annotation (Dialog(tab="Initialization"));
  parameter Real SOC_start(unit="1")=0.6 "Initial SoC [0..1]" annotation (Dialog(tab="Initialization",enable=(not initialize_with_OCV)));
  input .Modelica.Units.SI.Voltage OCV_start=100 "Initial OCV" annotation (Dialog(tab="Initialization", enable=initialize_with_OCV));

  extends .Electrification.Batteries.Interfaces.Internal.PackArrayParameters;
  extends .Electrification.Batteries.Icons.BatteryCell;

  parameter Boolean enable_heatport = false
    "true to enable port for heat losses and external temperature" annotation(Dialog(tab="Conditional"));
  parameter .Modelica.Units.SI.Temperature T0=300 "Internal fixed temperature" annotation (Dialog(tab="Conditional"));

  parameter .Modelica.Units.SI.ElectricCharge Q_cap_all_nom "Nominal battery capacity";
  final parameter .Modelica.Units.SI.ElectricCurrent i_nom_1C=Q_cap_all_nom/3600 "Current at nominal 1C charging";
  final parameter .Modelica.Units.SI.ElectricCurrent iCell_nom_1C=Q_cap_all_nom / (3600 * ngp) "Current at nominal 1C charging";


  .Modelica.Electrical.Analog.Interfaces.NegativePin pin_n "Negative pin" annotation(Placement(transformation(extent={{10,-90},{-10,-110}})));
  .Modelica.Electrical.Analog.Interfaces.PositivePin pin_p "Positive pin" annotation(Placement(transformation(extent={{-10,90},{10,110}})));

  .Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort(Q_flow=-heatLoss) if enable_heatport
    "Heat port battery" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  .Electrification.Batteries.Control.Interfaces.SignalsCore signals annotation (Placement(transformation(extent={{-100,60},{-60,100}})));
protected
  .Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=T0,port(Q_flow=heatLoss)) if not enable_heatport annotation (Placement(transformation(extent={{120,-26},{108,-14}})));
  .Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b temp "Internal heat port"
    annotation (Placement(transformation(extent={{95,-15},{105,-25}})));
  .Modelica.Units.SI.Power heatLoss "Heat loss power leaving component via heatPort (> 0, if heat is flowing out of component)";
equation
  connect(heatPort, temp)
    annotation (Line(points={{100,0},{100,-20}}, color={191,0,0}));
  connect(fixedTemperature.port, temp)
    annotation (Line(points={{108,-20},{100,-20}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-100,-116},{100,-140}},
          lineColor={63,63,63},
          horizontalAlignment=TextAlignment.Right,
          textString="%name"),
        Line(
          points={{100,0},{60,0}},
          color={191,0,0},
          visible=enable_heatport,
          pattern=LinePattern.Dash),
        Line(
          points={{-10,36},{10,36}},
          color={255,255,255},
          thickness=0.5),
        Line(
          points={{0,46},{0,26}},
          color={255,255,255},
          thickness=0.5),
        Line(
          points={{-10,-72},{10,-72}},
          color={255,255,255},
          thickness=0.5)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is the common interface for all battery core models, including electrical, thermal, and sensor/actuator connections, as well as the record of summary variables.</p>
<p>Note that this interface is common to models of single battery cells and models of several cells lumped together as one. For more information about this, please refer to the section <a href=\"modelica://Electrification.Batteries.Information.CellGroups\">Lumped packs and cell arrays</a>.</p>
<h4>Limits</h4>
<p>The interface allows specifying maximum and minimum limits for cell voltage, current, and power, including tolerances for monitoring. In addition, it is possible to specify the action if any of the limits are exceeded. These limits are applied e.g. in the <a href=\"modelica://Electrification.Batteries.Core.Templates.Modular\">Modular</a> template.</p>
</html>"));
end Base_1;
