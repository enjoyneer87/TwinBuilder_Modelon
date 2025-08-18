within BatNSuperCap_legacy;
model stateG
// ✅ 상태 정의
Modelica.StateGraph.StepWithSignal Use_Battery(nIn=2, nOut=1) 
  annotation(Placement(transformation(extent={{-39.32,44.89},{-19.32,64.89}},rotation = 0.0,origin = {0.0,0.0})));

Modelica.StateGraph.StepWithSignal Use_Supercap(nIn=1, nOut=1) 
  annotation(Placement(transformation(extent={{39.48,45.01},{59.48,65.01}},rotation = 0.0,origin = {0.0,0.0})));

Modelica.StateGraph.InitialStep initialStep(nOut=1) 
  annotation(Placement(transformation(extent={{-91.1,44.86},{-71.1,64.86}},rotation = 0.0,origin = {0.0,0.0})));

Modelica.StateGraph.Transition toBat 
  annotation(Placement(transformation(extent={{-59.96,44.91},{-49.96,64.91}},rotation = 0.0,origin = {0.0,0.0})));

// ✅ 논리 블록 (상태 기반 토크 제한)

Modelica.Blocks.Sources.Constant tau_max_bat(k=320);
Modelica.Blocks.Sources.Constant tau_max_sc(k=120);
Modelica.Blocks.Logical.Switch tauSelector;
    .Modelica.Blocks.Sources.BooleanExpression isBattery(y=Use_Battery.active) annotation(Placement(transformation(extent = {{-104.23,-42.49},{-84.23,-22.49}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Switch switch annotation(Placement(transformation(extent = {{-67.81,-55.99},{-47.81,-35.99}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And and1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-10.059999999999999,-44.36},rotation = 90.0)));
    .Modelica.StateGraph.TransitionWithSignal toSC annotation(Placement(transformation(extent = {{0.27,44.97},{20.27,64.97}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Hysteresis hysteresis annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {8.07,-8.170000000000002},rotation = 90.0)));
    .Modelica.StateGraph.TransitionWithSignal BackToBat annotation(Placement(transformation(extent = {{14.19,83.55},{-5.81,103.55}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {-9.61,23.9},rotation = 90.0)));
    
    
    equation
  // ✅ StateGraph 상태 연결
  connect(initialStep.outPort[1], toBat.inPort) annotation(Line(points = {{-70.6,54.86},{-64.54,54.86},{-64.54,54.91},{-56.96,54.91}}));
  connect(toBat.outPort, Use_Battery.inPort[1]) annotation(Line(points = {{-54.21,54.91},{-47.7,54.91},{-47.7,54.89},{-40.32,54.89}}));
  connect(toSC.outPort, Use_Supercap.inPort[1]) annotation(Line(points = {{11.77,54.97},{24.56,54.97},{24.56,55.01},{38.48,55.01}}));

  // ✅ 토크 선택 로직 연결
  connect(isBattery.y, tauSelector.u2);         // 선택 조건 (true → 배터리)
  connect(tau_max_bat.y, tauSelector.u1);       // true 일 때 값
  connect(tau_max_sc.y, tauSelector.u3);        // false 일 때 값

  connect(tauSelector.y, machine.controller.torqueControl.tau_max); // 최종 연결
    connect(initialStep.outPort[1],toBat.inPort) annotation(Line(points = {{-72.13,54.42},{-64.545,54.42},{-64.545,55.13},{-56.96,55.13}},color = {0,0,0}));
    connect(toBat.outPort,Use_Battery.inPort[1]) annotation(Line(points = {{-54.21,55.13},{-47.705,55.13},{-47.705,54.89},{-41.2,54.89}},color = {0,0,0}));
    connect(Use_Battery.outPort[1],toSC.inPort) annotation(Line(points = {{-18.82,54.89},{-7.02,54.89},{-7.02,54.97},{6.27,54.97}},color = {0,0,0}));
    connect(Use_Battery.outPort[1],toSC.inPort) annotation(Line(points = {{-18.82,54.89},{-7.025,54.89},{-7.025,55.16},{4.77,55.16}},color = {0,0,0}));
    connect(toSC.outPort,Use_Supercap.inPort[1]) annotation(Line(points = {{11.77,54.97},{24.560000000000002,54.97},{24.560000000000002,54.82},{37.35,54.82}},color = {0,0,0}));
    connect(Use_Supercap.outPort[1],BackToBat.inPort) annotation(Line(points = {{59.98,55.01},{65.97999999999999,55.01},{65.97999999999999,93.55},{8.19,93.55}},color = {0,0,0}));
    connect(BackToBat.outPort,Use_Battery.inPort[2]) annotation(Line(points = {{2.69,93.55},{-46.32,93.55},{-46.32,54.89},{-40.32,54.89}},color = {0,0,0}));
    connect(hysteresis.y,toSC.condition) annotation(Line(points = {{8.07,2.83},{8.07,30.41},{10.27,30.41},{10.27,42.97}},color = {255,0,255}));
    connect(hysteresis.y,not1.u) annotation(Line(points = {{8.07,2.83},{8.07,7.56},{-9.61,7.56},{-9.61,11.9}},color = {255,0,255}));
    connect(BackToBat.condition,not1.y) annotation(Line(points = {{4.19,81.55},{4.19,58.224999999999994},{-9.61,58.224999999999994},{-9.61,34.9}},color = {255,0,255}));
end stateG;
