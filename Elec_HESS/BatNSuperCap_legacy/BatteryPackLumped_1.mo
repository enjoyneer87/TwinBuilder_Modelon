within BatNSuperCap_legacy;

partial model BatteryPackLumped_1 "Template for battery pack with lumped cells"
  extends .Electrification.Batteries.Interfaces.BatteryPackLumped(
    final hide_interface_icon=true,
    final Q_cap_all_nom=core.Q_cap_all_nom,
    summary(
      v=plug_a.v,
      v_internal=electrical.summary.v_core,
      v_cell_max=core.summary.v_cell,
      v_cell_min=core.summary.v_cell,
      ocv=core.summary.ocv,
      ocv_cell_max=core.summary.ocv_cell,
      ocv_cell_min=core.summary.ocv_cell,
      i=plug_a.i,
      i_ch=electrical.summary.i_core,
      i_ch_max=availablePower.iMaxCh,
      i_dch_max=availablePower.iMaxDch,
      p_ch_max=availablePower.pMaxCh,
      p_dch_max=availablePower.pMaxDch,
      i_cell_max=core.summary.i_cell,
      i_cell_min=core.summary.i_cell,
      i_self_cell_max=core.summary.i_self_cell,
      i_self_cell_min=core.summary.i_self_cell,
      p_loss=losses.power,
      p_loss_cell_max=core.summary.p_loss_cell,
      p_loss_cell_min=core.summary.p_loss_cell,
      e_loss=losses.energy,
      e_out=accumulated.energy,
      T=thermal.summary.T_cell_max,
      T_cell_max=thermal.summary.T_cell_max,
      T_cell_min=thermal.summary.T_cell_min,
      Q=core.summary.Q,
      Q_cell_max=core.summary.Q_cell,
      Q_cell_min=core.summary.Q_cell,
      Q_cap_nom=Q_cap_all_nom,
      Q_cap=core.summary.Q_cap_all_aged,
      Q_cap_cell_max=core.summary.Q_cap_cell_aged,
      Q_cap_cell_min=core.summary.Q_cap_cell_aged,
      Q_out=accumulated.charge,
      core_v=[core.summary.v],
      core_i=[core.summary.i],
      core_ocv=[core.summary.ocv],
      core_Q=[core.summary.Q],
      core_SoC=[core.summary.SoC],
      core_Q_cap_aged=[core.summary.Q_cap_all_aged],
      core_i_self=[core.summary.i_self],
      core_T=[thermal.tempCore.T],
      core_heat_flow=[thermal.tempCore.Q_flow],
      core_R_max_dch=[core.summary.R_max_dch]),
    geometry(thermal=thermal.geometry));
  extends .Electrification.Batteries.Icons.BatteryPack;

  replaceable .Electrification.Batteries.Core.Interfaces.Base core(
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp,
    final enable_heatport=true,
    T0=thermal.T0,
    SOC_start=SOC_start,
    OCV_start=OCV_start,
    initialize_with_OCV=initialize_with_OCV,
    limitActionSoC=limitActionSoC,
    SoC_max=SoC_max,
    SoC_min=SoC_min,
    limitStartSoC=limitStartSoC,
    limitActionV=limitActionV,
    limitStartV=limitStartV,
    limitActionI=limitActionI,
    limitStartI=limitStartI,
    limitActionP=limitActionP,
    limitStartP=limitStartP) annotation (
      choicesAllMatching=true,
      Dialog(group="Components"),
      Placement(transformation(extent={{-18,-18},{18,18}},origin={0,0})));
  replaceable .Electrification.Batteries.Electrical.Pack.Interfaces.Base electrical(
    final internal_ground=internal_ground or not common_mode,
    final common_mode=common_mode) annotation (
      choicesAllMatching=true,
      Dialog(group="Components"),
      Placement(transformation(extent={{-18,-18},{18,18}},origin={-60,0})));
  replaceable .Electrification.Batteries.Thermal.Interfaces.Base thermal(
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp,
    fixed_temperature=fixed_temperature,
    final enable_external=enable_thermal_port,
    limitActionT=limitActionT,
    limitStartT=limitStartT,
    limitUnitT=limitUnitT) annotation (
      choicesAllMatching=true,
      Dialog(group="Components"),
      Placement(transformation(extent={{-18,-18},{18,18}},origin={0,60})));
  replaceable .Electrification.Batteries.Control.Interfaces.Base controller(
    hide_bus_signals=hide_bus_signals,
    final ns=ns,
    final np=np,
    final gs=gs,
    final gp=gp,
    id=id,
    final enable_core=true,
    final enable_electrical=true,
    final enable_thermal=true,
    vCellMax=core.vCellMax,
    vCellMin=core.vCellMin,
    iCellMaxDch=core.iCellMaxDch,
    iCellMaxCh=core.iCellMaxCh,
    pCellMaxDch=core.pCellMaxDch,
    pCellMaxCh=core.pCellMaxCh)
    annotation (
      choicesAllMatching=true,
      Dialog(group="Components"),
      Placement(transformation(extent={{-98,54},{-62,90}})));

  .Modelon.Utilities.Limits.RealLimitFault limitDischarge(
    use_explicit_checking_time=true,
    t0=limitStartDch,
    message="The battery current has passed the limit of maximum discharge power. This typically results in a large voltage drop and failure to deliver power.",
    action=limitActionDch,
    x=summary.i_dch,
    xMax=summary.i_dch_max + iTolDch,
    xMin=-.Modelica.Constants.inf,
    xName="Battery discharge current")
    "Monitors whether the discharge current exceeds the power limit"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  .Electrification.Utilities.AccumulatedLoss losses(enable=accumulated_outputs,
    power=sum(thermal.tempCore.Q_flow) + thermal.tempElectrical.Q_flow) annotation (Placement(transformation(extent={{10,90},{20,100}})));

  inner .Electrification.Batteries.Utilities.AvailablePower.Outputs availablePower(
    iMaxDch=core.summary.i_dch_max,
    iMaxCh=core.summary.i_ch_max,
    pMaxDch=core.summary.p_dch_max,
    pMaxCh=core.summary.p_ch_max) "Available power (and current)"
    annotation (Placement(transformation(extent={{102,-78},{118,-62}})));
  .Electrification.Utilities.AccumulatedElectrical accumulated(
    voltage=summary.v,
    current=summary.i_dch,
    enable=accumulated_outputs) annotation (
      Placement(transformation(extent={{-100,-30},{-90,-20}})));
equation
  connect(core.heatPort, thermal.tempCore[1, 1]) annotation (
    Line(points={{18,0},{24,0},{24,36},{0,36},{0,42}}, color={191,0,0}));
  connect(thermal.externalPort, thermalPort) annotation (
    Line(points={{0,78},{0,100}}, color={191,0,0}));
  connect(controller.electrical, electrical.signals) annotation (Line(
      points={{-62,61.2},{-56,61.2},{-56,48},{-74.4,48},{-74.4,14.4}},
      color={120,180,200},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(controller.thermal, thermal.signals) annotation (Line(
      points={{-62,82.8},{-14.4,82.8},{-14.4,74.4}},
      color={200,100,100},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(controller.core[1, 1], core.signals) annotation (Line(
      points={{-62,72},{-24,72},{-24,14.4},{-14.4,14.4}},
      color={150,150,150},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(thermal.tempElectrical, electrical.heatPort) annotation (
    Line(points={{-18,42},{-60,42},{-60,18}}, color={191,0,0}));
  connect(controller.controlBus, controlBus) annotation (
    Line(
      points={{-80,90},{-80,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(electrical.pin_p, core.pin_p) annotation (
    Line(points={{-42,7.2},{-30,7.2},{-30,24},{0,24},{0,18}}, color={0,0,255}));
  connect(electrical.pin_n, core.pin_n) annotation (
    Line(points={{-42,-7.2},{-30,-7.2},{-30,-24},{0,-24},{0,-18}}, color={0,0,255}));
  connect(electrical.plug_a, plug_a) annotation (Line(
      points={{-78,0},{-100,0}},
      color={255,128,0},
      thickness=0.5));
annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is a template for a battery pack (or module), where all the cells have been lumped into a single core model.</p>
<p>For more information, please refer to the <a href=\"modelica://Electrification.Batteries.Information\">Information</a> about the Batteries package, and the section about <a href=\"modelica://Electrification.Batteries.Information.CellGroups\">Lumped packs and cell arrays</a>.</p>
</html>"));
end BatteryPackLumped_1;
