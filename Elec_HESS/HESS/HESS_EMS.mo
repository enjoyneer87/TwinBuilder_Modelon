within HESS;
model HESS_EMS
    .HESS.HESS_StateGraph_Core hESS_StateGraph_Core annotation(Placement(transformation(extent = {{-54.08,10.62},{-39.9,24.8}},origin = {0.0,0.0},rotation = 0.0)));
    .HESS.KETI_BatteryPack kETI_BatteryPack(enable_thermal_port = false,display_name = true) annotation(Placement(transformation(extent = {{56.41,-80.19},{76.41,-60.19}},origin = {0.0,0.0},rotation = 0.0)));
    .HESS.KETI_SCapPack kETI_SCapPack(display_name = true,enable_thermal_port = false) annotation(Placement(transformation(extent = {{59.63,-124.08},{79.63,-104.08}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.BatteryChargerFixedLimits_CC batteryChargerFixedLimits_CC annotation(Placement(transformation(extent = {{-59.56,-80.27},{-79.56,-60.27}},origin = {0.0,0.0},rotation = 0.0)));
    .BatNSuperCap_legacy.AverageStepUpDownDCDC averageStepUpDownDCDC(enable_thermal_port = false,display_name = true) annotation(Placement(transformation(extent = {{22.01,-80.26},{2.01,-60.26}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(Placement(transformation(extent = {{-104.29,10.54},{-96.23,18.6}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Sources.BooleanConstant booleanConstant2(k = true) annotation(Placement(transformation(extent = {{-100.79,25.2},{-92.73,33.26}},origin = {0.0,0.0},rotation = 0.0)));
equation
    connect(averageStepUpDownDCDC.plug_a,kETI_BatteryPack.plug_a) annotation(Line(points = {{22.01,-70.26},{38.87,-70.26},{38.87,-70.19},{56.41,-70.19}},color = {255,128,0}));
    connect(batteryChargerFixedLimits_CC.plug_a,averageStepUpDownDCDC.plug_b) annotation(Line(points = {{-59.56,-70.27},{-26.53,-70.27},{-26.53,-70.26},{2.01,-70.26}},color = {255,128,0}));
    connect(kETI_SCapPack.plug_a,batteryChargerFixedLimits_CC.plug_a) annotation(Line(points = {{59.63,-114.08},{-21.22,-114.08},{-21.22,-70.27},{-59.56,-70.27}},color = {255,128,0}));
    connect(averageStepUpDownDCDC.controlBus,kETI_BatteryPack.controlBus) annotation(Line(points = {{20.01,-60.26},{20.01,-54.19},{58.41,-54.19},{58.41,-60.19}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(booleanConstant.y,hESS_StateGraph_Core.driveDemand) annotation(Line(points = {{-95.83,14.57},{-82.52,14.57},{-82.52,14.17},{-64.73,14.17}},color = {255,0,255}));
    connect(hESS_StateGraph_Core.regenDemand,booleanConstant.y) annotation(Line(points = {{-64.71,10.62},{-87.53,10.62},{-87.53,14.57},{-95.83,14.57}},color = {255,0,255}));
    connect(hESS_StateGraph_Core.needSCReplenish,booleanConstant.y) annotation(Line(points = {{-64.71,7.08},{-87,7.08},{-87,14.57},{-95.83,14.57}},color = {255,0,255}));
    connect(booleanConstant2.y,hESS_StateGraph_Core.plugIn) annotation(Line(points = {{-92.33,29.23},{-92.33,17.71},{-64.71,17.71}},color = {255,0,255}));
    connect(booleanConstant2.y,hESS_StateGraph_Core.prechargeOK) annotation(Line(points = {{-92.33,29.23},{-92.33,21.26},{-64.71,21.26}},color = {255,0,255}));
    connect(booleanConstant2.y,hESS_StateGraph_Core.dcChargeAllowed) annotation(Line(points = {{-92.33,29.23},{-86.33,29.23},{-86.33,34.379999999999995},{-64.71,34.379999999999995},{-64.71,28.38}},color = {255,0,255}));
    annotation(Icon(coordinateSystem(preserveAspectRatio = false,extent = {{-100.0,-100.0},{100.0,100.0}}),graphics = {Rectangle(lineColor={0,0,0},fillColor={230,230,230},fillPattern=FillPattern.Solid,extent={{-100.0,-100.0},{100.0,100.0}}),Text(lineColor={0,0,255},extent={{-150,150},{150,110}},textString="%name")}));
end HESS_EMS;
