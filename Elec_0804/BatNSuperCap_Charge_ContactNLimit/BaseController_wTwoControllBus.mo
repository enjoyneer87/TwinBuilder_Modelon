within BatNSuperCap_Charge_ContactNLimit;
model BaseController_wTwoControllBus
    extends .Electrification.Control.Interfaces.BaseController;
     parameter Integer id = 1 "Unique identifier of this controller" annotation(Dialog(group="ControlBus"));
     parameter Integer batid = 1 "Unique identifier of this controller" annotation(Dialog(group="ControlBus"));
     parameter Integer scid = 1 "Unique identifier of this controller" annotation(Dialog(group="ControlBus"));

    .Electrification.Control.Interfaces.ComponentBus componentBus annotation(Placement(transformation(extent = {{-90.0,30.0},{-50.0,70.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Interfaces.ComponentBus componentBus2 annotation(Placement(transformation(extent = {{106.0,12.0},{146.0,52.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Interfaces.ComponentBus componentBus3 annotation(Placement(transformation(extent = {{94.0,-48.0},{134.0,-8.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.SetComponentLimits setComponentLimits(external_enable = true,v_max = switch_vmax.y,v_min = switch_vmin.y,i_max_in = switch_i_max_in.y,i_max_out = switch_i_max_out.y,p_max_in = switch_p_max_in.y,p_max_out = switch_p_max_out.y) annotation(Placement(transformation(extent = {{-34.0,-158.0},{-54.0,-118.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Switch switch_vmax annotation(Placement(transformation(extent = {{30.0,-92.0},{10.0,-72.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Switch switch_vmin annotation(Placement(transformation(extent = {{36.44,-126.22},{16.439999999999998,-106.22}},origin = {0,0},rotation = 0)));
    .Modelica.Blocks.Logical.Switch switch_i_max_in annotation(Placement(transformation(extent = {{38.0,-178.0},{18.0,-158.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Switch switch_i_max_out annotation(Placement(transformation(extent = {{38.44,-204.22},{18.439999999999998,-184.22}},origin = {0,0},rotation = 0)));
    .Modelica.Blocks.Logical.Switch switch_p_max_in annotation(Placement(transformation(extent = {{36.0,-240.0},{16.0,-220.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Switch switch_p_max_out annotation(Placement(transformation(extent = {{37.44,-279.22},{17.439999999999998,-259.22}},origin = {0,0},rotation = 0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits4Battery(vMax = 400,vMaxSignal = true,vMinSignal = true,iMaxInSignal = true,iMaxOutSignal = true,pMaxInSignal = true,pMaxOutSignal = true,aggregate = false,power_in_current = false) annotation(Placement(transformation(extent = {{98.0,-108.0},{78.0,-68.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Limits.GetComponentLimits getComponentLimits_SC(aggregate = false,vMaxSignal = true,vMinSignal = true,iMaxInSignal = true,iMaxOutSignal = true,pMaxInSignal = true,pMaxOutSignal = true) annotation(Placement(transformation(extent = {{100.0,-184.0},{80.0,-144.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(extent = {{38.0,122.0},{78.0,162.0}},origin = {0.0,0.0},rotation = 0.0)));
    .Electrification.Control.Interfaces.SystemBus controlBus2 annotation(HideResult = hide_bus_signals,Placement(transformation(extent = {{152.0,8.0},{192.0,48.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Control.Interfaces.SystemBus controlBus3 annotation(HideResult = hide_bus_signals,Placement(transformation(extent = {{154.0,-50.0},{194.0,-10.0}},rotation = 0.0,origin = {0.0,0.0})));
equation
    connect(switch_vmax.y,setComponentLimits.v_max) annotation(Line(points = {{9,-82},{-4.06,-82},{-4.06,-122},{-32,-122}},color = {0,0,127}));
    connect(switch_vmin.y,setComponentLimits.v_min) annotation(Line(points = {{15.44,-116.22},{-4.06,-116.22},{-4.06,-128},{-32,-128}},color = {0,0,127}));
    connect(getComponentLimits4Battery.v_max,switch_vmax.u1) annotation(Line(points = {{77,-72},{73.44,-72},{73.44,-68.22},{32,-68.22},{32,-74}},color = {0,0,127}));
    connect(getComponentLimits_SC.v_max,switch_vmax.u3) annotation(Line(points = {{79,-148},{64.44,-148},{64.44,-90},{32,-90}},color = {0,0,127}));
    connect(getComponentLimits4Battery.v_min,switch_vmin.u1) annotation(Line(points = {{77,-78},{38.44,-78},{38.44,-108.22}},color = {0,0,127}));
    connect(getComponentLimits_SC.v_min,switch_vmin.u3) annotation(Line(points = {{79,-154},{38.44,-154},{38.44,-124.22}},color = {0,0,127}));
    connect(switch_vmax.u2,switch_vmin.u2) annotation(Line(points = {{32,-82},{44.44,-82},{44.44,-116.22},{38.44,-116.22}},color = {255,0,255}));
    connect(setComponentLimits.componentBus,componentBus) annotation(Line(points = {{-54,-138},{-70,-138},{-70,50}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits4Battery.componentBus,componentBus2) annotation(Line(points = {{98,-88},{104,-88},{104,32},{126,32}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(getComponentLimits_SC.componentBus,componentBus3) annotation(Line(points = {{100,-164},{144,-164},{144,-28},{114,-28}},color = {240,170,40},pattern = LinePattern.Dot));

    connect(switch_vmax.u2,u) annotation(Line(points = {{32,-82},{48.22,-82},{48.22,142},{58,142}},color = {255,0,255}));
    connect(controlBus2.battery[batid],componentBus2) annotation(Line(points = {{172,28},{149,28},{149,32},{126,32}},color = {240,170,40},pattern = LinePattern.Dot));    
    connect(controlBus3.sc[scid],componentBus3) annotation(Line(points = {{174,-30},{174,-28},{114,-28}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(switch_i_max_in.y,setComponentLimits.i_max_in) annotation(Line(points = {{17,-168},{-3.06,-168},{-3.06,-134},{-32,-134}},color = {0,0,127}));
    connect(getComponentLimits4Battery.i_max_in,switch_i_max_in.u1) annotation(Line(points = {{77,-84},{40,-84},{40,-160}},color = {0,0,127}));
    connect(getComponentLimits_SC.i_max_in,switch_i_max_in.u3) annotation(Line(points = {{79,-160},{73.44,-160},{73.44,-182.22},{40,-182.22},{40,-176}},color = {0,0,127}));
    connect(switch_vmin.u2,switch_i_max_in.u2) annotation(Line(points = {{38.44,-116.22},{46.44,-116.22},{46.44,-168},{40,-168}},color = {255,0,255}));
    connect(switch_i_max_out.y,setComponentLimits.i_max_out) annotation(Line(points = {{17.44,-194.22},{-3.06,-194.22},{-3.06,-140},{-32,-140}},color = {0,0,127}));
    connect(getComponentLimits4Battery.i_max_out,switch_i_max_out.u1) annotation(Line(points = {{77,-90},{40.44,-90},{40.44,-186.22}},color = {0,0,127}));
    connect(getComponentLimits_SC.i_max_out,switch_i_max_out.u3) annotation(Line(points = {{79,-166},{73.44,-166},{73.44,-208.22},{40.44,-208.22},{40.44,-202.22}},color = {0,0,127}));
    connect(switch_vmin.u2,switch_i_max_out.u2) annotation(Line(points = {{38.44,-116.22},{46.44,-116.22},{46.44,-194.22},{40.44,-194.22}},color = {255,0,255}));
    connect(switch_p_max_in.y,setComponentLimits.p_max_in) annotation(Line(points = {{15,-230},{-3.56,-230},{-3.56,-146},{-32,-146}},color = {0,0,127}));
    connect(getComponentLimits4Battery.p_max_in,switch_p_max_in.u1) annotation(Line(points = {{77,-96},{38,-96},{38,-222}},color = {0,0,127}));
    connect(getComponentLimits_SC.p_max_in,switch_p_max_in.u3) annotation(Line(points = {{79,-172},{73.44,-172},{73.44,-243.22},{38,-243.22},{38,-238}},color = {0,0,127}));
    connect(switch_i_max_in.u2,switch_p_max_in.u2) annotation(Line(points = {{40,-168},{46.44,-168},{46.44,-230},{38,-230}},color = {255,0,255}));
    connect(switch_p_max_out.y,setComponentLimits.p_max_out) annotation(Line(points = {{16.44,-269.22},{-3.56,-269.22},{-3.56,-152},{-32,-152}},color = {0,0,127}));
    connect(getComponentLimits4Battery.p_max_out,switch_p_max_out.u1) annotation(Line(points = {{77,-102},{39.44,-102},{39.44,-261.22}},color = {0,0,127}));
    connect(getComponentLimits_SC.p_max_out,switch_p_max_out.u3) annotation(Line(points = {{79,-178},{73.44,-178},{73.44,-283.22},{39.44,-283.22},{39.44,-277.22}},color = {0,0,127}));
    connect(switch_i_max_out.u2,switch_p_max_out.u2) annotation(Line(points = {{40.44,-194.22},{46.44,-194.22},{46.44,-269.22},{39.44,-269.22}},color = {255,0,255}));
    connect(componentBus,controlBus) annotation(Line(points = {{-70,50},{-35,50},{-35,100},{0,100}},color = {240,170,40},pattern = LinePattern.Dot));

    
end BaseController_wTwoControllBus;
