  
 model EMS
  import Electrification.Control.PowerAllocation.*;
  import Electrification.*;
  import Electrification.Control.*;
  import Modelica.Units.*;

  extends .Electrification.Control.Interfaces.BaseController;


  parameter Integer battery_id "Identifier of the battery controller" annotation(Dialog(group="ControlBus"));
  parameter Integer DCDC_id "Identifier of the battery controller" annotation(Dialog(group="ControlBus"));
  parameter Integer load_id "Identifier of the battery controller" annotation(Dialog(group="ControlBus"));
  parameter Integer SC_id "Identifier of the battery controller" annotation(Dialog(group="ControlBus"));

  // Optional wiring: allow running without one side
  parameter Boolean enable_battery = true "Enable battery-side (bus + sensors). If false, EMS uses safe defaults" annotation(Dialog(group = "Optional wiring"));
  parameter Boolean enable_sc_dcdc = true "Enable DCDC+SC side (bus + sensors). If false, EMS uses safe defaults" annotation(Dialog(group = "Optional wiring"));

  final parameter Integer N(min=1) = 2 "Number of \"loads\"";
  parameter .Electrification.Control.PowerAllocation.Records.AllocationRecord
    allocation[:]={
     .Electrification.Control.PowerAllocation.Records.AllocationRecord(),
     .Electrification.Control.PowerAllocation.Records.AllocationRecord()}
    "Power allocation table";

  parameter Boolean allocate_negative=false
    "Allocate negative power usage to available power";
  parameter .Modelica.Units.SI.Time T_available=0.01 "Time constant of available power calculation" annotation (Dialog(enable=allocate_negative));
  .Electrification.Control.Signals.BusSelector busBattery(id=battery_id, category=.Electrification.Utilities.Types.ControllerType.Battery
      ) annotation (Placement(transformation(
        extent={{-27.19,63.67},{-15.19,75.67}},
        rotation=0.0,
        origin={0.0,0.0})));

  .Electrification.Control.Limits.GetComponentLimits batteryLimits(
    vMaxSignal=false,
    vMinSignal=false,
    iMaxInSignal=false,
    iMaxOutSignal=false,
    pMaxInSignal=true,
    pMaxOutSignal=true,
    iMaxIn=.Modelica.Constants.inf,aggregate = false)
    if enable_battery annotation (Placement(transformation(extent={{-66.0,-17.67},{-34.0,46.33}},rotation = 0.0,origin = {0.0,0.0})));
        .Electrification.Control.Signals.BusSelector BusDCDC(id = DCDC_id,category = .Electrification.Utilities.Types.ControllerType.Converter) annotation(Placement(transformation(extent = {{-119.69,74.33},{-107.69,86.33}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Control.Limits.GetComponentVIP SCPower if enable_sc_dcdc annotation(Placement(transformation(extent = {{-117.51,-132.0},{-97.51,-112.0}},rotation = 0.0,origin = {0.0,0.0})));

    // DCDC power vip와 batteryVIP 값 받아와서, (이건 현재 값이니까) 두 값 모두 각 소스의 limits에 도달하지않았으면
    // 외부의 power_ref를 load의 limit으로 주기.. 충전기는 limit으로주면 될텐데... 
    // 주행패턴일때��� limit으로주면 되나? limit으로 도달해도 시뮬레이션이 계속 되게하기 위해서는 derate하는 알고리즘이 필요할듯 

  .Electrification.Control.Limits.GetComponentVIP BatterySensor
    if enable_battery annotation (Placement(transformation(extent={{-118.0,-92.0},{-98.0,-72.0}},rotation = 0.0,origin = {0.0,0.0})));
    // please make derator block
//     .Modelica.Units.SI.Power p_used_abs = sum(abs(pMaxOutAllocation.p_used)) + sum(abs(pMaxInAllocation.p_used));
     //.Modelica.Units.SI.Power p_used_abs = sum(abs()) + sum(abs(pMaxInAllocation.p_used));

  .Electrification.Control.Limits.GetComponentLimits DCDC_SCLimits(
    iMaxIn = .Modelica.Constants.inf,
    pMaxOutSignal = true,
    pMaxInSignal = true,
    iMaxOutSignal = false,
    iMaxInSignal = false,
    vMinSignal = false,
    vMaxSignal = false,
  aggregate = false)
    if enable_sc_dcdc annotation(Placement(transformation(extent = {{-174.0,-59.01},{-142.0,4.99}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Converters.Control.Signals.pwr_b_ref pwr_b_ref(id = DCDC_id) annotation(Placement(transformation(extent = {{140.19,-35.35},{157.37,-18.17}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Loads.Control.Signals.pwr_ref pwr_ref(id = load_id) annotation(Placement(transformation(extent = {{143.57,1.59},{157.27,15.29}},origin = {0.0,0.0},rotation = 0.0)));
    

    .HESS_EMS_allocator.EMS_Charger_PowerChain eMS_Charger_PowerChain annotation(Placement(transformation(extent = {{-32.59,-144.12},{37.93,-73.6}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Signals.BusSelector busSelector(id = SC_id,category = Electrification.Utilities.Types.ControllerType.Battery) annotation(Placement(transformation(extent = {{-115.29,104.45},{-99.99,119.75}},origin = {0.0,0.0},rotation = 0.0)));
  .Electrification.Control.Limits.GetComponentVIP loadSensor annotation(Placement(transformation(extent = {{109.78,-109.79},{89.78,-89.79}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Signals.BusSelector busLoad(id = load_id,category = Electrification.Utilities.Types.ControllerType.Load) annotation(Placement(transformation(extent = {{60.22,55.74},{77.0,72.52}},origin = {0.0,0.0},rotation = 0.0)));

  // Defaults and switches for optional wiring
  .Modelica.Blocks.Sources.Constant zero(k = 0) annotation(Placement(transformation(extent = {{-4,-198},{8,-186}})));
  .Modelica.Blocks.Sources.BooleanConstant use_battery(k = enable_battery) annotation(Placement(transformation(extent = {{-24,-198},{-12,-186}})));
  .Modelica.Blocks.Sources.BooleanConstant use_sc_dcdc(k = enable_sc_dcdc) annotation(Placement(transformation(extent = {{-44,-198},{-32,-186}})));

  .Modelica.Blocks.Logical.Switch sw_bt_p_in annotation(Placement(transformation(extent = {{-12,-168},{0,-156}})));
  .Modelica.Blocks.Logical.Switch sw_bt_p_out annotation(Placement(transformation(extent = {{8,-168},{20,-156}})));
  .Modelica.Blocks.Logical.Switch sw_bt_i_in annotation(Placement(transformation(extent = {{28,-168},{40,-156}})));

  .Modelica.Blocks.Logical.Switch sw_sc_p_in annotation(Placement(transformation(extent = {{48,-168},{60,-156}})));
  .Modelica.Blocks.Logical.Switch sw_sc_p_out annotation(Placement(transformation(extent = {{68,-168},{80,-156}})));

  .Modelica.Blocks.Logical.Switch sw_bt_p_meas annotation(Placement(transformation(extent = {{-12,-180},{0,-168}})));
  .Modelica.Blocks.Logical.Switch sw_bt_i_meas annotation(Placement(transformation(extent = {{8,-180},{20,-168}})));
  .Modelica.Blocks.Logical.Switch sw_bt_v_pack annotation(Placement(transformation(extent = {{28,-180},{40,-168}})));

  .Modelica.Blocks.Logical.Switch sw_sc_p_meas annotation(Placement(transformation(extent = {{48,-180},{60,-168}})));
  .Modelica.Blocks.Logical.Switch sw_sc_v annotation(Placement(transformation(extent = {{68,-180},{80,-168}})));
    
    
    
equation
  connect(busBattery.systemBus, controlBus) annotation (Line(
      points={{-15.19,69.67},{0,69.67},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
    
    
    
    
  // Conditional bus-component wiring
  if enable_battery then
    connect(busBattery.componentBus, batteryLimits.componentBus) annotation (Line(points={{-27.19,69.67},{-90,69.67},{-90,14.33},{-66,14.33}},color={240,170,40},pattern=LinePattern.Dot,thickness=0.5));
    connect(busBattery.componentBus,BatterySensor.componentBus) annotation(Line(points = {{-27.19,69.67},{-124,69.67},{-124,-82},{-118,-82}},color = {240,170,40},pattern = LinePattern.Dot));
  end if;

  connect(BusDCDC.systemBus,controlBus) annotation(Line(points = {{-107.69,80.33},{-69.58,80.33},{-69.58,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));

  if enable_sc_dcdc then
    connect(BusDCDC.componentBus,DCDC_SCLimits.componentBus) annotation(Line(points = {{-119.69,80.33},{-186,80.33},{-186,-27.01},{-174,-27.01}},color = {240,170,40},pattern = LinePattern.Dot));
  end if;
    
  // Battery measurements -> optional
  connect(zero.y, sw_bt_p_meas.u1);
  connect(BatterySensor.p, sw_bt_p_meas.u3);
  connect(use_battery.y, sw_bt_p_meas.u2);
  connect(sw_bt_p_meas.y, eMS_Charger_PowerChain.p_bt_meas);

  connect(zero.y, sw_bt_i_meas.u1);
  connect(BatterySensor.i, sw_bt_i_meas.u3);
  connect(use_battery.y, sw_bt_i_meas.u2);
  connect(sw_bt_i_meas.y, eMS_Charger_PowerChain.i_bt_meas);

  connect(zero.y, sw_bt_v_pack.u1);
  connect(BatterySensor.v, sw_bt_v_pack.u3);
  connect(use_battery.y, sw_bt_v_pack.u2);
  connect(sw_bt_v_pack.y, eMS_Charger_PowerChain.v_pack);

  // SC/DCDC measurements -> optional
  connect(zero.y, sw_sc_p_meas.u1);
  connect(SCPower.p, sw_sc_p_meas.u3);
  connect(use_sc_dcdc.y, sw_sc_p_meas.u2);
  connect(sw_sc_p_meas.y, eMS_Charger_PowerChain.p_sc_meas);

  connect(zero.y, sw_sc_v.u1);
  connect(SCPower.v, sw_sc_v.u3);
  connect(use_sc_dcdc.y, sw_sc_v.u2);
  connect(sw_sc_v.y, eMS_Charger_PowerChain.v_sc);
    
  // Limits -> optional
  connect(zero.y, sw_bt_p_in.u1);
  connect(batteryLimits.p_max_in, sw_bt_p_in.u3);
  connect(use_battery.y, sw_bt_p_in.u2);
  connect(sw_bt_p_in.y, eMS_Charger_PowerChain.limit_bt_in);

  connect(zero.y, sw_bt_i_in.u1);
  connect(batteryLimits.i_max_in, sw_bt_i_in.u3);
  connect(use_battery.y, sw_bt_i_in.u2);
  connect(sw_bt_i_in.y, eMS_Charger_PowerChain.i_max_in_bt);

  connect(zero.y, sw_bt_p_out.u1);
  connect(batteryLimits.p_max_out, sw_bt_p_out.u3);
  connect(use_battery.y, sw_bt_p_out.u2);
  connect(sw_bt_p_out.y, eMS_Charger_PowerChain.limit_bt_out);

  connect(zero.y, sw_sc_p_out.u1);
  connect(DCDC_SCLimits.p_max_out, sw_sc_p_out.u3);
  connect(use_sc_dcdc.y, sw_sc_p_out.u2);
  connect(sw_sc_p_out.y, eMS_Charger_PowerChain.limit_sc_out);

  connect(zero.y, sw_sc_p_in.u1);
  connect(DCDC_SCLimits.p_max_in, sw_sc_p_in.u3);
  connect(use_sc_dcdc.y, sw_sc_p_in.u2);
  connect(sw_sc_p_in.y, eMS_Charger_PowerChain.limit_sc_in);
    connect(eMS_Charger_PowerChain.P_sc_cmd,pwr_b_ref.u_r) annotation(Line(points = {{63.59,-46.43},{100.7,-46.43},{100.7,-26.76},{135.89,-26.76}},color = {0,0,127}));
    connect(eMS_Charger_PowerChain.P_load_cmd,pwr_ref.u_r) annotation(Line(points = {{63.59,-60.53},{77.97,-60.53},{77.97,8.44},{140.15,8.44}},color = {0,0,127}));
    connect(pwr_ref.systemBus,controlBus) annotation(Line(points = {{157.27,8.44},{163.27,8.44},{163.27,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(busSelector.systemBus,controlBus) annotation(Line(points = {{-99.99,112.1},{-49.995,112.1},{-49.995,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));
    if enable_sc_dcdc then
      connect(busSelector.componentBus,SCPower.componentBus) annotation(Line(points = {{-115.29,112.1},{-205.2,112.1},{-205.2,-122},{-117.51,-122}},color = {240,170,40},pattern = LinePattern.Dot));
    end if;
    connect(pwr_b_ref.systemBus,BusDCDC.componentBus) annotation(Line(points = {{157.37,-26.76},{112.19,-26.76},{112.19,-2.69},{-125.69,-2.69},{-125.69,80.33},{-119.69,80.33}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(busLoad.componentBus,loadSensor.componentBus) annotation(Line(points = {{60.22,64.13},{54.22,64.13},{54.22,-17.57},{115.78,-17.57},{115.78,-99.79},{109.78,-99.79}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(busLoad.systemBus,controlBus) annotation(Line(points = {{77,64.13},{83,64.13},{83,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(loadSensor.v,eMS_Charger_PowerChain.V_bus) annotation(Line(points = {{88.78,-93.79},{36.88,-93.79},{36.88,-150.12},{-54.76,-150.12},{-54.76,-46.32},{-39.64,-46.32}},color = {0,0,127}));
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