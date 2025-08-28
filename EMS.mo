  
 model EMS
  import Electrification.Control.PowerAllocation.*;
  import Electrification.*;
  import Electrification.Control.*;
  
  replaceable input Records.Summary summary(
    p_avail_out=pMaxOutAllocation.pAvailableTotal.y,
    p_avail_in=pMaxInAllocation.pAvailableTotal.y,
    p_alloc_out=pMaxOutAllocation.p_allocated,
    p_alloc_in=pMaxInAllocation.p_allocated,
    final N=N,
    p_in=loadPower.p,
    p_used_out=-pMaxInAllocation.sumNegative.y,
    p_used_in=-pMaxOutAllocation.sumNegative.y) annotation (
      Dialog(tab="Records"),
      Placement(transformation(extent={{82,82},{98,98}})), choicesAllMatching=true);

  extends Control.Interfaces.BaseController;

  parameter Integer battery_id=1 "Identifier of the battery controller" annotation(Dialog(group="ControlBus"));
  final parameter Integer N(min=1) = size(allocation,1) "Number of \"loads\"";
  parameter Electrification.Control.PowerAllocation.Records.AllocationRecord
    allocation[:]={
      Electrification.Control.PowerAllocation.Records.AllocationRecord(),
     Electrification.Control.PowerAllocation.Records.AllocationRecord()}
    "Power allocation table";

  parameter Boolean allocate_negative=false
    "Allocate negative power usage to available power";
  parameter Modelica.Units.SI.Time T_available=0.01 "Time constant of available power calculation" annotation (Dialog(enable=allocate_negative));

  Signals.BusSelector busLoad(id=load_id, category=Electrification.Utilities.Types.ControllerType.Load)
    annotation (Placement(transformation(
        extent={{25.68,64.32},{13.68,76.32}},
        rotation=0.0,
        origin={0.0,0.0})));
  Signals.BusSelector busBattery[N](id=allocation.id, category=allocation.category
      ) annotation (Placement(transformation(
        extent={{-26.81,64.0},{-14.81,76.0}},
        rotation=0.0,
        origin={0.0,0.0})));

  Limits.GetComponentLimits batteryLimits[N](
    vMaxSignal=true,
    vMinSignal=true,
    iMaxInSignal=false,
    iMaxOutSignal=false,
    pMaxInSignal=true,
    pMaxOutSignal=true,
    iMaxIn=Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{-76.27,-16.0},{-44.27,48.0}},rotation = 0.0,origin = {0.0,0.0})));
  Limits.SetComponentLimits loadLimits(i_max_in=allocation.i_max_in,
      i_max_out=allocation.i_max_out)
    annotation (Placement(transformation(extent={{44.0,-15.74},{76.0,48.26}},rotation = 0.0,origin = {0.0,0.0})));
  Limits.GetComponentVIP loadPower
    annotation (Placement(transformation(extent={{80.26,-90.0},{60.26,-70.0}},rotation = 0.0,origin = {0.0,0.0})));
  Components.GenerousStack pMaxOutAllocation(N=1,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_out,
    k_absolute=allocation.p_max_out,
    T_available=T_available,
    negative_available=allocate_negative)
                                     annotation (Placement(transformation(extent={{20.26,-59.74},{40.26,-39.74}},rotation = 0.0,origin = {0.0,0.0})));
  Components.GenerousStack pMaxInAllocation(N=N,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_in,
    k_absolute=allocation.p_max_in,
    T_available=T_available,
    negative_available=allocate_negative)
                                    annotation (Placement(transformation(extent={{-60.0,-59.74},{-40.0,-39.74}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Math.Gain p_neg[N](each k=-1) annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        rotation=0,
        origin={44,-74})));
equation
  for xn in 1:N loop
    connect(busLoad[xn].systemBus, controlBus) annotation (Line(
      points={{14,70},{0,70},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
    connect(loadLimits[xn].v_max, batteryLimits.v_max) annotation (Line(points={{40.8,
            41.6},{-2,41.6},{-2,41.6},{-42.4,41.6}},                                                               color={0,0,127}));
    connect(loadLimits[xn].v_min, batteryLimits.v_min) annotation (Line(points={{40.8,32},
            {-2,32},{-2,32},{-42.4,32}},                                                           color={0,0,127}));
  end for;
  connect(busBattery.systemBus, controlBus) annotation (Line(
      points={{-14.81,70},{0,70},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(loadLimits.componentBus, busLoad.componentBus) annotation (Line(
      points={{76,16.26},{90,16.26},{90,70.32},{25.68,70.32}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(loadPower.componentBus, busLoad.componentBus) annotation (Line(
      points={{80.26,-80},{90,-80},{90,70.32},{25.68,70.32}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(loadPower.p, pMaxInAllocation.p_used) annotation (Line(points={{59.26,-86},{-50,-86},{-50,-61.74}}, color={0,0,127}));
  connect(batteryLimits.p_max_in, pMaxOutAllocation.p_available) annotation (
      Line(points={{-42.67,3.2},{0,3.2},{0,-49.74},{18.26,-49.74}},
                                                    color={0,0,127}));
  connect(pMaxOutAllocation.p_allocated, loadLimits.p_max_out) annotation (Line(
        points={{42.26,-49.74},{60,-49.74},{60,-30},{20,-30},{20,-6.14},{40.8,-6.14}},
                                                                        color={0,
          0,127}));
  connect(pMaxInAllocation.p_allocated, loadLimits.p_max_in) annotation (Line(
        points={{-38,-49.74},{-10,-49.74},{-10,-12},{10,-12},{10,3.46},{40.8,3.46}},
                                                                       color={0,
          0,127}));
  connect(p_neg.y, pMaxOutAllocation.p_used) annotation (Line(points={{39.6,-74},{30.26,-74},{30.26,-61.74}},                                                                        color={0,0,127}));
  connect(p_neg.u, loadPower.p) annotation (Line(points={{48.8,-74},{54,-74},{54,-86},{59.26,-86}}, color={0,0,127}));
  connect(pMaxInAllocation.p_available, batteryLimits.p_max_out) annotation (
      Line(points={{-62,-49.74},{-70,-49.74},{-70,-30},{-30,-30},{-30,-6.4},{-42.67,-6.4}},
        color={0,0,127}));
  connect(busBattery.componentBus, batteryLimits.componentBus) annotation (Line(
      points={{-26.81,70},{-90,70},{-90,16},{-76.27,16}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This controller allocates power from a battery controller to the controllers of other components (like machines and other loads). Note that if multiple batteries are used, a master battery controller could sum up the available power to be used as input to this controller. The power allocation is implemented with the <a href=\"modelica://Electrification.Control.PowerAllocation.Components.GenerousStack\">GenerousStack</a> block.</p>
<p>The power allocation table specifies what amount of available power to distribute to each component. This table is hierarchical, which means that each component in the table is allocated a portion of the power that remains after the component before it. The power available to a component depends on the preceeding component. For example, if a component is assigned 50 &percnt; of available input power (p_rat_in=0.5), then the remaining 50 &percnt; is what is available for the following components in the table.</p>
<p>The components in the table are identified by a controller type and id.</p>
<p>If the &quot;generous&quot; option is enabled, then any unused power is available to the following component, independent of the allocation. In this case, the allocation only acts as an upper limit. Thus, if a generous allocation of 70 &percnt; is used, then the following component will always have a minimum of 30 &percnt; power available, but it can be up to 100 &percnt;.</p>
<p>The Sankey diagram illustrates the hierarchical allocation, and the difference between the strict and generous option. Note how component 2 use generous allocation, allowing component 3 to utilize any unused power. Also note how component 3 is configured to use 100 &percnt; of the available power remaining after component 2.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Control/PowerAllocation.png\"/></p>
<p>Absolute power limits can also be specified in addition to the relative limits. The smallest limit applies. If only an asbolute limit should be used, specify a ratio of 1.0. If only a ratio should be used, specify an infinite absolute limit (<span style=\"font-family: Courier New;\">Modelica.Constants.inf</span>).</p>
<h4>Allocating negative power usage</h4>
<p>When components are supplying power, more power can be consumed by other components without violating the total available power of the system. To enable this, set the parameter allocate_negative = true. <b>Note</b> that fast changes to power usage can still lead to temporary violation of the available power limits. This is because the negative power usage is filtered. To make the overshoot smaller, reduce the time constant T_available.</p>
</html>"),                                                            Icon(
        graphics={Text(
          extent={{-88,-64},{88,-96}},
          lineColor={95,95,95},
          textString="%name"),
        Bitmap(extent={{-94,-94},{94,94}}, fileName=
              "modelica://Electrification/Resources/Images/Control/PowerAllocationIcon.png"),
                  Text(
          extent={{-100,-104},{100,-128}},
          lineColor={0,0,0},
          textString="%name")}));

end EMS;