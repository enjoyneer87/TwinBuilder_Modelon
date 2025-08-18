within BatNSuperCap_legacy;

model MultiMode "Multi mode (voltage, current or power)"
  extends .Electrification.Converters.Control.Templates.CurrentActuated;

  parameter Boolean external_mode =  false "Get mode from external signal (mode_ref)" annotation (Dialog(group="Mode of operation"),choices(checkBox=true));

  parameter Boolean external_v_a = false "Get reference primary voltage from external signal (v_a_ref)" annotation (Dialog(group="Reference",enable=external_mode or mode==.Electrification.Utilities.Types.ConverterMode.VoltageA),choices(checkBox=true));
  parameter .Modelica.Units.SI.Voltage v_a_ref=0 "Reference primary side voltage" annotation (Dialog(group="Reference", enable=not external_v_a and (external_mode or mode == .Electrification.Utilities.Types.ConverterMode.VoltageA)));

  parameter Boolean external_v_b = false "Get reference secondary voltage from external signal (v_b_ref)" annotation (Dialog(group="Reference",enable=external_mode or mode==.Electrification.Utilities.Types.ConverterMode.VoltageB),choices(checkBox=true));
  parameter .Modelica.Units.SI.Voltage v_b_ref=0 "Reference secondary side voltage" annotation (Dialog(group="Reference", enable=not external_v_b and (external_mode or mode == .Electrification.Utilities.Types.ConverterMode.VoltageB)));

  parameter Boolean external_i_a = false "Get reference primary current from external signal (i_a_ref)" annotation (Dialog(group="Reference",enable=external_mode or mode==.Electrification.Utilities.Types.ConverterMode.CurrentA),choices(checkBox=true));
  parameter .Modelica.Units.SI.Current i_a_ref=0 "Reference primary side current" annotation (Dialog(group="Reference", enable=not external_i_a and (external_mode or mode == .Electrification.Utilities.Types.ConverterMode.CurrentA)));

  parameter Boolean external_i_b = false "Get reference secondary current from external signal (i_b_ref)" annotation (Dialog(group="Reference",enable=external_mode or mode==.Electrification.Utilities.Types.ConverterMode.CurrentB),choices(checkBox=true));
  parameter .Modelica.Units.SI.Current i_b_ref=0 "Reference secondary side current" annotation (Dialog(group="Reference", enable=not external_i_b and (external_mode or mode == .Electrification.Utilities.Types.ConverterMode.CurrentB)));

  parameter Boolean external_pwr_a = false "Get reference primary power from external signal (pwr_a_ref)" annotation (Dialog(group="Reference",enable=external_mode or mode==.Electrification.Utilities.Types.ConverterMode.PowerA),choices(checkBox=true));
  parameter .Modelica.Units.SI.Power pwr_a_ref=0 "Reference primary side power" annotation (Dialog(group="Reference", enable=not external_pwr_a and (external_mode or mode == .Electrification.Utilities.Types.ConverterMode.PowerA)));

  parameter Boolean external_pwr_b = false "Get reference secondary power from external signal (pwr_b_ref)" annotation (Dialog(group="Reference",enable=external_mode or mode==.Electrification.Utilities.Types.ConverterMode.PowerB),choices(checkBox=true));
  parameter .Modelica.Units.SI.Power pwr_b_ref=0 "Reference secondary side power" annotation (Dialog(group="Reference", enable=not external_pwr_b and (external_mode or mode == .Electrification.Utilities.Types.ConverterMode.PowerB)));

  parameter Real k_v=10 "Gain of primary voltage control" annotation (Dialog(tab="Voltage control"));
  parameter .Modelica.Units.SI.Time Ti_v(min=.Modelica.Constants.small) = 0.1 "Time constant of primary voltage control integrator" annotation (Dialog(tab="Voltage control"));
  parameter Real Ni_v(min=100*.Modelica.Constants.eps) = 0.9
    "Time constant of primary voltage anti-windup compensation (Ni_v*Ti_v)" annotation (Dialog(tab="Voltage control"));

  parameter .Electrification.Utilities.Types.ConverterMode mode=.Electrification.Utilities.Types.ConverterMode.VoltageB "Operating mode" annotation (Dialog(group="Mode of operation", enable=not external_mode));

  parameter .Modelica.Units.SI.Current iMaxInA=1000 "Maximum input current" annotation (Dialog(
      tab="Limits",
      group="Primary side",
      enable=(not external_limits) or aggregate_limits));
  parameter .Modelica.Units.SI.Current iMaxOutA=iMaxInA "Maximum output current" annotation (Dialog(
      tab="Limits",
      group="Primary side",
      enable=(not external_limits) or aggregate_limits));
  parameter .Modelica.Units.SI.Power pMaxInA=1e6 "Maximum input power" annotation (Dialog(
      tab="Limits",
      group="Primary side",
      enable=(not external_limits) or aggregate_limits));
  parameter .Modelica.Units.SI.Power pMaxOutA=pMaxInA "Maximum output power" annotation (Dialog(
      tab="Limits",
      group="Primary side",
      enable=(not external_limits) or aggregate_limits));

  parameter Boolean external_limits = false "Get limits from control bus" annotation (Dialog(tab="Limits",group="Primary side"));
  parameter Boolean aggregate_limits=true
    "If true, use both internal and external limits" annotation (Dialog(tab="Limits",group="Primary side", enable=external_limits));
  parameter Boolean listen= false "Get limits from another controller (instead of the local bus)" annotation(Dialog(tab="Limits",group="Primary side",enable=external_limits));
  parameter Integer id_listen=1 "Identifier of controller to get limits from" annotation (Dialog(tab="Limits",group="Primary side",enable=(external_limits and listen)));
  parameter .Electrification.Utilities.Types.ControllerType typeListen=.Electrification.Utilities.Types.ControllerType.Controller
    "Type of controller to get limits from" annotation (Dialog(tab="Limits",group="Primary side", enable=listen));

  parameter .Modelica.Units.SI.Current iMaxInB=1000 "Maximum input current" annotation (Dialog(tab="Limits", group="Secondary side"));
  parameter .Modelica.Units.SI.Current iMaxOutB=iMaxInB "Maximum output current" annotation (Dialog(tab="Limits", group="Secondary side"));
  parameter .Modelica.Units.SI.Power pMaxInB=1e6 "Maximum input power" annotation (Dialog(tab="Limits", group="Secondary side"));
  parameter .Modelica.Units.SI.Power pMaxOutB=pMaxInB "Maximum output power" annotation (Dialog(tab="Limits", group="Secondary side"));
  parameter Real k_pMax=1 "Scaling factor of pMax[In/Out]" annotation (Dialog(tab="Limits", group="Primary side"));

  .Modelon.Blocks.Logical.IntegerEquals voltageControl1(k=Integer(.Electrification.Utilities.Types.ConverterMode.VoltageA))
    annotation (Placement(transformation(extent={{16,-70},{24,-62}})));
  .Modelon.Blocks.Logical.IntegerEquals voltageControl2(k=Integer(.Electrification.Utilities.Types.ConverterMode.VoltageB))
    annotation (Placement(transformation(extent={{16,-20},{24,-12}})));
  .Electrification.Control.Limits.LimitedComponent limitsA(
    final id=id,
    final typeLocal=.Electrification.Utilities.Types.ControllerType.Converter,
    id_listen=id_listen,
    typeListen=typeListen,
    aggregate=aggregate_limits,
    vMaxSignal=false,
    vMinSignal=false,
    iMaxInSignal=external_limits,
    iMaxOutSignal=external_limits,
    pMaxInSignal=external_limits,
    pMaxOutSignal=external_limits,
    vMax=.Modelica.Constants.inf,
    vMin=0,
    listen=listen,
    iMaxIn=iMaxInA,
    iMaxOut=iMaxOutA,
    pMaxIn=pMaxInA,
    pMaxOut=pMaxOutA,
    k_pMax=k_pMax,
    power_in_current=true)
    annotation (Placement(transformation(extent={{-86.24,26.0},{-66.24,66.0}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Control.Limits.LimitedComponent limitsB(
    final id=id,
    final typeLocal=.Electrification.Utilities.Types.ControllerType.Converter,
    vMaxSignal=false,
    vMinSignal=false,
    iMaxInSignal=false,
    iMaxOutSignal=false,
    pMaxInSignal=false,
    pMaxOutSignal=false,
    vMax=.Modelica.Constants.inf,
    vMin=0,
    listen=false,
    iMaxIn=iMaxInB,
    iMaxOut=iMaxOutB,
    pMaxIn=pMaxInB,
    pMaxOut=pMaxOutB,
    power_in_current=true)
    annotation (Placement(transformation(extent={{-42,26},{-22,66}})));
  .Electrification.Converters.Control.Blocks.VoltageControl voltageControllerA(
    k=-k_v,
    Ti=Ti_v,
    Ni=Ni_v) "Primary voltage controller"
    annotation (Placement(transformation(extent={{-14,-82},{6,-62}})));
  .Electrification.Converters.Control.Blocks.VoltageControl voltageControllerB(
    k=-k_v,
    Ti=Ti_v,
    Ni=Ni_v) "Secondary voltage controller"
    annotation (Placement(transformation(extent={{-14,-32},{6,-12}})));
  .Modelon.Blocks.LookUp.IntegerVectorLookUp modeLUT(table={Integer(
        .Electrification.Utilities.Types.ConverterModeCurrent.Disabled),Integer(.Electrification.Utilities.Types.ConverterModeCurrent.CurrentA),
        Integer(.Electrification.Utilities.Types.ConverterModeCurrent.CurrentB),Integer(.Electrification.Utilities.Types.ConverterModeCurrent.CurrentA),
        Integer(.Electrification.Utilities.Types.ConverterModeCurrent.CurrentB),Integer(.Electrification.Utilities.Types.ConverterModeCurrent.CurrentA),
        Integer(.Electrification.Utilities.Types.ConverterModeCurrent.CurrentB)})
    annotation (Placement(transformation(extent={{46,64},{58,76}})));
  .Modelon.Blocks.Routing.ConditionalInput extRefPwrB(k=pwr_b_ref, off=(not
        external_mode and mode <> .Electrification.Utilities.Types.ConverterMode.PowerB) or not external_pwr_b)
                                                        annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,-4})));
  .Modelon.Blocks.Routing.ConditionalInput extRefPwrA(k=pwr_a_ref, off=(not
        external_mode and mode <> .Electrification.Utilities.Types.ConverterMode.PowerA) or not external_pwr_a)
                                                        annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,-54})));
  .Modelica.Blocks.Math.Abs absVB(generateEvent=false) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-62,-12})));
  .Modelon.Blocks.Math.Division divIB(u2min=.Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{-46,-10},{-34,2}})));
  .Modelica.Blocks.Math.Abs absVA(generateEvent=false) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-62,-62})));
  .Modelon.Blocks.Math.Division divIA(u2min=.Modelica.Constants.eps)
    annotation (Placement(transformation(extent={{-46,-60},{-34,-48}})));
  .Modelon.Blocks.Logical.IntegerEquals pwrControl2(k=Integer(.Electrification.Utilities.Types.ConverterMode.PowerB))
    annotation (Placement(transformation(extent={{16,0},{24,8}})));
  .Modelon.Blocks.Logical.IntegerEquals pwrControl1(k=Integer(.Electrification.Utilities.Types.ConverterMode.PowerA))
    annotation (Placement(transformation(extent={{16,-50},{24,-42}})));
protected
  .Modelica.Blocks.Sources.IntegerConstant constMode(k=Integer(mode))    if not
    external_mode
    annotation (Placement(transformation(extent={{26,66},{34,74}})));

  .Modelon.Blocks.Routing.ConditionalInput extRefIA(k=i_a_ref, off=(not
        external_mode and mode <> .Electrification.Utilities.Types.ConverterMode.CurrentA) or not external_i_a)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,-38})));
  .Modelon.Blocks.Routing.ConditionalInput extRefVA(k=v_a_ref, off=(not
        external_mode and mode <> .Electrification.Utilities.Types.ConverterMode.VoltageA) or not external_v_a)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,-72})));

  .Electrification.Utilities.Blocks.IntegerLimiter extMode(
    uMax=Integer(.Electrification.Utilities.Types.ConverterMode.PowerB),
    uMin=Integer(.Electrification.Utilities.Types.ConverterMode.Disabled),
    yAbove=Integer(.Electrification.Utilities.Types.ConverterMode.Disabled),
    yBelow=Integer(.Electrification.Utilities.Types.ConverterMode.Disabled)) if external_mode annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={10,60})));
  .Modelica.Blocks.Logical.Switch swRefI1
                                        annotation (Placement(transformation(extent={{34,-60},
            {46,-72}})));
  .Modelica.Blocks.Logical.Switch swRefI2
                                        annotation (Placement(transformation(extent={{34,-10},
            {46,-22}})));
  .Modelon.Blocks.Routing.ConditionalInput extRefVB(k=v_b_ref, off=(not
        external_mode and mode <> .Electrification.Utilities.Types.ConverterMode.VoltageB) or not external_v_b)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,-22})));
  .Modelon.Blocks.Routing.ConditionalInput extRefIB(k=i_b_ref, off=(not
        external_mode and mode <> .Electrification.Utilities.Types.ConverterMode.CurrentB) or not external_i_b)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,12})));
  .Modelica.Blocks.Math.Gain signOut2(k=-1)
    annotation (Placement(transformation(extent={{-60,42},{-56,46}})));
  .Modelica.Blocks.Math.Gain signOut1(k=-1)
    annotation (Placement(transformation(extent={{-16,42},{-12,46}})));
  .Modelica.Blocks.Logical.Switch swRefPwr2
    annotation (Placement(transformation(extent={{34,10},{46,-2}})));
  .Modelica.Blocks.Logical.Switch swRefPwr1
    annotation (Placement(transformation(extent={{34,-40},{46,-52}})));
equation
  connect(limitsA.sensors, electrical_a) annotation (Line(
      points={{-86.24,46},{-90,46},{-90,74},{10,74},{10,86},{110,86},{110,-60},{100,-60}},
      color={120,180,200},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(limitsB.sensors, electrical_b) annotation (Line(
      points={{-42,46},{-46,46},{-46,70},{14,70},{14,82},{100,82},{100,60}},
      color={120,180,200},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(limitsA.systemBus, controlBus) annotation (Line(
      points={{-76.24,66},{-76.24,100},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(extMode.u, componentBus.mode_ref) annotation (Line(points={{4.4,60},{0,
          60},{0,80}},                   color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(extRefIA.u, componentBus.i_a_ref) annotation (Line(points={{-90,-38},{
          -96,-38},{-96,80},{0,80}},
                                color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(extRefVA.u, componentBus.v_a_ref) annotation (Line(points={{-90,-72},{
          -94,-72},{-94,80},{0,80}},
                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(extRefVB.u, componentBus.v_b_ref) annotation (Line(points={{-90,-22},{
          -94,-22},{-94,80},{0,80}},
                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(extRefIB.u, componentBus.i_b_ref) annotation (Line(points={{-90,12},{-94,
          12},{-94,80},{0,80}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(voltageControl1.y, swRefI1.u2)
    annotation (Line(points={{24.4,-66},{32.8,-66}},   color={255,0,255}));
  connect(voltageControl2.y, swRefI2.u2)
    annotation (Line(points={{24.4,-16},{32.8,-16}},   color={255,0,255}));
  connect(limitsA.i_max_out, signOut2.u)
    annotation (Line(points={{-65.24,44},{-60.4,44}}, color={0,0,127}));
  connect(limitsB.i_max_out,signOut1. u)
    annotation (Line(points={{-21,44},{-16.4,44}}, color={0,0,127}));
  connect(extRefVA.y,voltageControllerA. v_ref)
    annotation (Line(points={{-77.4,-72},{-14,-72}}, color={0,0,127}));
  connect(extRefVB.y,voltageControllerB. v_ref)
    annotation (Line(points={{-77.4,-22},{-14,-22}}, color={0,0,127}));
  connect(sns_v_b.y,voltageControllerB. v_m) annotation (Line(points={{65.6,-74},
          {60,-74},{60,-88},{-20,-88},{-20,-28},{-14,-28}}, color={0,0,127}));
  connect(voltageControllerA.i_track, sns_i_a.y) annotation (Line(points={{-4,-82},
          {-4,-86},{58,-86},{58,-58},{65.6,-58}},  color={0,0,127}));
  connect(sns_i_b.y,voltageControllerB. i_track) annotation (Line(points={{65.6,
          -42},{58,-42},{58,-36},{-4,-36},{-4,-32}},
                                     color={0,0,127}));
  connect(swRefI1.u1,voltageControllerA. i_ref) annotation (Line(points={{32.8,-70.8},
          {26,-70.8},{26,-72},{7,-72}},          color={0,0,127}));
  connect(voltageControllerB.i_ref, swRefI2.u1) annotation (Line(points={{7,-22},
          {26,-22},{26,-20.8},{32.8,-20.8}},      color={0,0,127}));
  connect(sns_v_b.y, componentBus.v_b_sns) annotation (Line(points={{65.6,-74},{60,
          -74},{60,-88},{-96,-88},{-96,80},{0,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sns_v_a.y, componentBus.v_a_sns) annotation (Line(points={{65.6,-90},{-98,
          -90},{-98,80},{0,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(signOut2.y, act_i_a_min.u) annotation (Line(points={{-55.8,44},{-52,44},
          {-52,16},{58,16},{58,-26},{66,-26}}, color={0,0,127}));
  connect(limitsA.i_max_in, act_i_a_max.u) annotation (Line(points={{-65.24,50},{-50,50},{-50,18},{60,18},{60,6},{66,6}}, color={0,0,127}));
  connect(limitsB.i_max_in, act_i_b_max.u) annotation (Line(points={{-21,50},{48,
          50},{48,54},{66,54}}, color={0,0,127}));
  connect(signOut1.y, act_i_b_min.u) annotation (Line(points={{-11.8,44},{48,44},
          {48,22},{66,22}}, color={0,0,127}));
  connect(modeLUT.y, act_mode.u)
    annotation (Line(points={{58.6,70},{66,70}}, color={255,127,0}));
  connect(modeLUT.u, extMode.y) annotation (Line(points={{44.8,70},{40,70},{40,60},
          {14.8,60}}, color={255,127,0}));
  connect(constMode.y, modeLUT.u)
    annotation (Line(points={{34.4,70},{44.8,70}}, color={255,127,0}));
  connect(extRefPwrA.u, componentBus.pwr_a_ref) annotation (Line(points={{-90,-54},
          {-94,-54},{-94,80},{0,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(extRefPwrB.u, componentBus.pwr_b_ref) annotation (Line(points={{-90,-4},
          {-94,-4},{-94,80},{0,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sns_v_a.y,voltageControllerA. v_m) annotation (Line(points={{65.6,-90},
          {-18,-90},{-18,-78},{-14,-78}}, color={0,0,127}));
  connect(swRefI2.y, act_i_b.u) annotation (Line(points={{46.6,-16},{52,-16},{52,
          38},{66,38}}, color={0,0,127}));
  connect(swRefI1.y, act_i_a.u) annotation (Line(points={{46.6,-66},{54,-66},{54,
          -10},{66,-10}}, color={0,0,127}));
  connect(extRefPwrB.y, divIB.u1) annotation (Line(points={{-77.4,-4},{-72,-4},{
          -72,-0.4},{-47.2,-0.4}}, color={0,0,127}));
  connect(extRefPwrA.y, divIA.u1) annotation (Line(points={{-77.4,-54},{-72,-54},
          {-72,-50.4},{-47.2,-50.4}}, color={0,0,127}));
  connect(swRefPwr2.y, swRefI2.u3) annotation (Line(points={{46.6,4},{50,4},{50,
          -8},{28,-8},{28,-11.2},{32.8,-11.2}}, color={0,0,127}));
  connect(divIB.y, swRefPwr2.u1) annotation (Line(points={{-33.4,-4},{26,-4},{26,
          -0.8},{32.8,-0.8}}, color={0,0,127}));
  connect(swRefPwr2.u3,extRefIB. y) annotation (Line(points={{32.8,8.8},{26,8.8},
          {26,12},{-77.4,12}}, color={0,0,127}));
  connect(pwrControl2.y, swRefPwr2.u2)
    annotation (Line(points={{24.4,4},{32.8,4}}, color={255,0,255}));
  connect(absVB.y, divIB.u2) annotation (Line(points={{-55.4,-12},{-52,-12},{-52,
          -7.6},{-47.2,-7.6}}, color={0,0,127}));
  connect(sns_v_b.y, absVB.u) annotation (Line(points={{65.6,-74},{60,-74},{60,-88},
          {-96,-88},{-96,-12},{-69.2,-12}}, color={0,0,127}));
  connect(absVA.y, divIA.u2) annotation (Line(points={{-55.4,-62},{-52,-62},{-52,
          -57.6},{-47.2,-57.6}}, color={0,0,127}));
  connect(sns_v_a.y, absVA.u) annotation (Line(points={{65.6,-90},{-98,-90},{-98,
          -62},{-69.2,-62}}, color={0,0,127}));
  connect(pwrControl1.y, swRefPwr1.u2)
    annotation (Line(points={{24.4,-46},{32.8,-46}}, color={255,0,255}));
  connect(swRefPwr1.y, swRefI1.u3) annotation (Line(points={{46.6,-46},{50,-46},
          {50,-58},{28,-58},{28,-61.2},{32.8,-61.2}}, color={0,0,127}));
  connect(divIA.y, swRefPwr1.u1) annotation (Line(points={{-33.4,-54},{26,-54},{
          26,-50.8},{32.8,-50.8}}, color={0,0,127}));
  connect(extRefIA.y, swRefPwr1.u3) annotation (Line(points={{-77.4,-38},{26,-38},
          {26,-41.2},{32.8,-41.2}}, color={0,0,127}));
  connect(modeLUT.u, voltageControl2.u) annotation (Line(points={{44.8,70},{40,70},
          {40,54},{12,54},{12,-16},{15.2,-16}},                  color={255,127,
          0}));
  connect(pwrControl2.u, modeLUT.u) annotation (Line(points={{15.2,4},{12,4},{12,
          54},{40,54},{40,70},{44.8,70}}, color={255,127,0}));
  connect(modeLUT.u, voltageControl1.u) annotation (Line(points={{44.8,70},{40,70},
          {40,54},{12,54},{12,-66},{15.2,-66}},                  color={255,127,
          0}));
  connect(pwrControl1.u, modeLUT.u) annotation (Line(points={{15.2,-46},{12,-46},
          {12,54},{40,54},{40,70},{44.8,70}}, color={255,127,0}));
annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This controller allows operating in multiple modes (current, voltage or power), as well as changing the mode dynamically. 
This controller is compatible with current actuated DCDC core models.</p>
<h4>Modes of operation</h4>
<p>The controller can be configured to control the primary or secondary side current/voltage/power, or to be disabled (typically corresponds to high impedance outputs). 
The mode can be either set with a constant parameter or changed during a simulation with an external signal (<a href=\"modelica://Electrification.Converters.Control.Signals.mode_ref\">mode_ref</a>) from the system control bus. This <code>mode_ref</code> signal is an integer that is specific to this controller. It should typically be specified usign the <a href=\"modelica://Electrification.Utilities.Types.ConverterMode\">ConverterMode</a> enumeration type. The <a href=\"modelica://Electrification.Converters.Experiments.ControlModes\">ControlModes</a> experiment demonstrates the use of this external signal for changing the converter mode.</p>
<h4>Reference signals (control targets)</h4>
<p>The reference current/voltage/power and mode of operation can be specified as constants or obtained as external input signals from the system control bus. These signals are typically provided using the adapters <a href=\"modelica://Electrification.Converters.Control.Signals.v_a_ref\">v_a_ref</a>, <a href=\"modelica://Electrification.Converters.Control.Signals.v_b_ref\">v_b_ref</a>, <a href=\"modelica://Electrification.Converters.Control.Signals.i_a_ref\">i_a_ref</a>, <a href=\"modelica://Electrification.Converters.Control.Signals.i_b_ref\">i_b_ref</a>, <a href=\"modelica://Electrification.Converters.Control.Signals.pwr_a_ref\">pwr_a_ref</a>, <a href=\"modelica://Electrification.Converters.Control.Signals.pwr_b_ref\">pwr_b_ref</a>, and <a href=\"modelica://Electrification.Converters.Control.Signals.mode_ref\">mode_ref</a>.</p>
<h4>Voltage control loop</h4>
<p>This controller applies a voltage control loop outside the internal current control loop in the converter core model. The voltage controller is a typical PI controller with anti-windup. It is assumed that the internal current control loop is much faster than this voltage controller. Careful tuning of the PI controller parameters may be required to achieve desired dynamics of the converter.</p>
<h4>Current/power limits</h4>
<p>The controller applies current/power limits by passing these along as actuation signals to the core converter model. These limits can be specified either as constant parameters or be obtained via external signals from the system control bus. External limits can be provided in one of two ways. Either by sending <a href=\"modelica://Electrification.Control.Limits\">limits</a> directly to the converter controller, or by configuring the controller to listen to limits published by another controller (like a battery controller or power allocation controller).</p>
</html>"));
end MultiMode;
