within BatNSuperCap_legacy;

model SuperCapCharging_1

  .Electrification.Loads.Examples.BatteryCharger charger(
    core(vTh=0.1),
    display_name=true,
    enable_thermal_port=false,
    controller(id_battery=SCap_interp.id))
    annotation(Placement(transformation(extent={{-6.0,-6.09},{-46.0,33.91}})));
    .Electrification.Electrical.DCInit vInit(init_start(fixed = false) = true,v_start = SCap_interp.OCV_start) annotation(Placement(transformation(extent = {{24.34,-14.69},{44.34,5.31}},origin = {0,0},rotation = 0)));
    replaceable .Electrification.Batteries.Templates.BatteryPackLumped SCap_interp(redeclare replaceable .Electrification.Batteries.Core.Examples.NCA.TabularTransient core(vCellMax = 2.7,redeclare replaceable .Electrification.Batteries.Core.Capacity.Ideal capacity(Q_cap_cell_nom = 13200),redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic1stTabular impedance(R0_table = [0.00,0.310000;0.05,0.308750;0.10,0.307500;0.15,0.306250;0.20,0.305000;0.25,0.303750;0.30,0.302500;0.35,0.301250;0.40,0.300000;0.45,0.298750;0.50,0.297500;0.55,0.296250;0.60,0.295000;0.65,0.293750;0.70,0.292500;0.75,0.291250;0.80,0.290000;0.85,0.288750;0.90,0.287500;0.95,0.286250;1.00,0.285000],R1_table = [0.00,0.002600;0.05,0.002550;0.10,0.002500;0.15,0.002450;0.20,0.002400;0.25,0.002350;0.30,0.002300;0.35,0.002250;0.40,0.002200;0.45,0.002150;0.50,0.002100;0.55,0.002050;0.60,0.002000;0.65,0.001950;0.70,0.001900;0.75,0.001850;0.80,0.001800;0.85,0.001750;0.90,0.001700;0.95,0.001650;1.00,0.001600]),voltage(cellOCV_table = [0.00,0.000;0.05,0.135;0.10,0.270;0.15,0.405;0.20,0.540;0.25,0.675;0.30,0.810;0.35,0.945;0.40,1.080;0.45,1.215;0.50,1.350;0.55,1.485;0.60,1.620;0.65,1.755;0.70,1.890;0.75,2.025;0.80,2.160;0.85,2.295;0.90,2.430;0.95,2.565;1.00,2.700],ref_SoC_0 = 0,ref_SoC_1 = 1)),redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical,redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1,redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2),ns = 86,np = 2) constrainedby .Electrification.Batteries.Templates.BatteryPackLumped annotation(Placement(transformation(extent = {{58.93,5.64},{78.93,25.64}},origin = {0.0,0.0},rotation = 0.0)));
equation
    connect(charger.plug_a,SCap_interp.plug_a) annotation(Line(points = {{-6,13.91},{26.465,13.91},{26.465,15.64},{58.93,15.64}},color = {255,128,0}));
    connect(vInit.plug_a,SCap_interp.plug_a) annotation(Line(points = {{44.34,-4.69},{51.635000000000005,-4.69},{51.635000000000005,15.64},{58.93,15.64}},color = {255,128,0}));
    connect(SCap_interp.controlBus,charger.controlBus) annotation(Line(points = {{60.93,25.64},{60.93,39.91},{-10,39.91},{-10,33.91}},color = {240,170,40},pattern = LinePattern.Dot));

  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
           graphics={Rectangle(lineColor={0,0,0}, fillColor={230,230,230}, fillPattern=FillPattern.Solid, extent={{-100,-100},{100,100}}),
                     Text(lineColor={0,0,255}, extent={{-150,150},{150,110}}, textString="%name")}));
end SuperCapCharging_1;
