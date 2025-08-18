within BatNSuperCap_Charge_ContactNLimit;

model BaseController_wTwoControllBus_1
    extends .Electrification.Control.Interfaces.BaseController;
     parameter Integer id = 1 "Unique identifier of this controller" annotation(Dialog(group="ControlBus"));

    .Electrification.Control.Interfaces.ComponentBus componentBus annotation(Placement(transformation(extent = {{-90.0,30.0},{-50.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Interfaces.ComponentBus componentBus2 annotation(Placement(transformation(extent = {{106.0,12.0},{146.0,52.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Interfaces.ComponentBus componentBus3 annotation(Placement(transformation(extent = {{94.0,-48.0},{134.0,-8.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits4Battery(vMax = 400,vMaxSignal = true,vMinSignal = true,iMaxInSignal = true,iMaxOutSignal = true,pMaxInSignal = true,pMaxOutSignal = true,aggregate = true,power_in_current = false) annotation(Placement(transformation(extent = {{88.0,-106.0},{68.0,-66.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(extent = {{38.0,122.0},{78.0,162.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Interfaces.SystemBus controlBus2 annotation(HideResult = hide_bus_signals,Placement(transformation(extent = {{152.0,8.0},{192.0,48.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Control.Interfaces.SystemBus controlBus3 annotation(HideResult = hide_bus_signals,Placement(transformation(extent = {{154.0,-50.0},{194.0,-10.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Control.Limits.SetComponentLimits setComponentLimits(external_enable = false) annotation(Placement(transformation(extent = {{-28.0,-108.0},{-48.0,-68.0}},origin = {0.0,0.0},rotation = 0.0)));
equation
    connect(getComponentLimits4Battery.componentBus,componentBus2) annotation(Line(points = {{88,-86},{92,-86},{92,32},{126,32}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(controlBus.machine[id],componentBus) annotation(Line(points = {{-70,50},{-35,50},{-35,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(controlBus2.battery[id],componentBus2) annotation(Line(points = {{172,28},{148,28},{148,32},{126,32}},color = {240,170,40},pattern = LinePattern.Dot));    
    connect(controlBus3.sc[id],componentBus3) annotation(Line(points = {{174,-30},{114,-30},{114,-28}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(setComponentLimits.componentBus,componentBus) annotation(Line(points = {{-48,-88},{-59,-88},{-59,50},{-70,50}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits4Battery.v_max,setComponentLimits.v_max) annotation(Line(points = {{67,-70},{67,-72},{-26,-72}},color = {0,0,127}));
    connect(setComponentLimits.v_min,getComponentLimits4Battery.v_min) annotation(Line(points = {{-26,-78},{67,-78},{67,-76}},color = {0,0,127}));
    connect(getComponentLimits4Battery.i_max_in,setComponentLimits.i_max_in) annotation(Line(points = {{67,-82},{67,-84},{-26,-84}},color = {0,0,127}));
    connect(setComponentLimits.i_max_out,getComponentLimits4Battery.i_max_out) annotation(Line(points = {{-26,-90},{67,-90},{67,-88}},color = {0,0,127}));
    connect(getComponentLimits4Battery.p_max_in,setComponentLimits.p_max_in) annotation(Line(points = {{67,-94},{67,-96},{-26,-96}},color = {0,0,127}));
    connect(getComponentLimits4Battery.p_max_out,setComponentLimits.p_max_out) annotation(Line(points = {{67,-100},{67,-102},{-26,-102}},color = {0,0,127}));

    
end BaseController_wTwoControllBus_1;
