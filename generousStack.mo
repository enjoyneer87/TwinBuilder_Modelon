block GenerousStack "캐스케이드 전력 분배 제어기 - 우선순위 기반 전력 할당 알고리즘"
  extends Modelica.Blocks.Icons.Block;

  //=== 제어기 개념 ===
  // 이 블록은 PI/PID 제어기가 아닌 "전력 분배 알고리즘"입니다.
  // 캐스케이드 방식으로 여러 부하에 우선순위에 따라 전력을 순차 분배합니다.
  // 
  // 7단계 처리 구조:
  // 1단계: 캐스케이드 분배 (stack) - 순차적 전력 할당의 핵심
  // 2단계: 비율 제한 (ratio) - 각 블록이 받을 수 있는 최대 비율
  // 3단계: 절대값 제한 (absolute) - 절대 전력값으로 상한 제한
  // 4단계: 잔여 전력 계산 (remain) - 할당량에서 사용량을 뺀 미사용 전력
  // 5단계: 관대성 스위치 (swGenerous) - 미사용 전력을 다음 블록에 전달할지 결정
  // 6단계: 사용 전력 분석 (positiveUsed/negativeUsed) - 양/음 전력 분리
  // 7단계: 피드백 필터 (pAvailableFiltered) - 회생 전력의 1차 지연 필터링

  parameter Integer N = 1 "캐스케이드 블록 개수";
  parameter Boolean generous[N] "관대성: true=미사용 전력을 다음 블록에 전달";
  parameter Real k_ratio[N](each min=0.0, each max=1.0) "각 블록의 최대 할당 비율 [0~1]";
  parameter Real k_absolute[N](each min=0.0) "각 블록의 절대 전력 제한값 [W]";
  parameter Modelica.Units.SI.Time T_available=0.01 "가용 전력 피드백 필터 시정수";
  parameter Boolean negative_available = false "음의 전력을 가용 전력에 피드백 여부";

  //=== 입출력 ===
  Modelica.Blocks.Interfaces.RealInput p_available "총 가용 전력 입력 [W]" annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput p_allocated[N] "각 블록 할당 전력 출력 [W]" annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealInput p_used[N] "각 블록 실제 사용 전력 피드백 [W]" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));

  //=== 7단계 처리 블록들 ===
  
  // 1단계: 캐스케이드 분배기 (핵심 알고리즘)
  Electrification.Utilities.Blocks.CascadedReal stack(N=N) "캐스케이드 분배: 앞 블록부터 순차 할당" annotation (Placement(transformation(extent={{0,40},{40,80}})));
  
  // 2단계: 비율 제한기
  Modelica.Blocks.Math.Gain ratio[N](k=k_ratio) "비율 제한: 가용 전력 × k_ratio" annotation (Placement(transformation(extent={{-40,-58},{-20,-38}})));
  
  // 3단계: 절대값 제한기  
  Modelica.Blocks.Nonlinear.Limiter absolute[N](each uMin=0, uMax=k_absolute) "절대값 제한: min(비율제한값, k_absolute)" annotation (Placement(transformation(extent={{0,-58},{20,-38}})));
  
  // 4단계: 잔여 전력 계산
  Modelica.Blocks.Math.Feedback remain[N] "잔여 전력 = 할당량 - 사용량" annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Modelica.Blocks.Nonlinear.Limiter lowerLimit[N](each uMax=Modelica.Constants.inf, each uMin=0) "음수 제거: 잔여 ≥ 0" annotation (Placement(transformation(extent={{10,10},{30,30}})));
  
  // 5단계: 관대성 스위치
  Modelon.Blocks.Routing.SwitchViaDialog swGenerous[N](output1=generous) "관대성 스위치: 미사용 전력 vs 할당 전력 선택" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,-20})));
  
  // 6단계: 사용 전력 분석
  Modelica.Blocks.Nonlinear.Limiter positiveUsed[N](each uMax= Modelica.Constants.inf, each uMin=0) "양의 사용 전력 추출" annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Nonlinear.Limiter negativeUsed[N](each uMax=0, each uMin=-Modelica.Constants.inf) "음의 사용 전력 추출 (회생)" annotation (Placement(transformation(extent={{-10,-90},{-30,-70}})));
  Modelica.Blocks.Math.Feedback unUsed[N] "미사용 전력 계산" annotation (Placement(transformation(extent={{54,-6},{66,6}})));
  
  // 7단계: 피드백 및 총 가용 전력 계산
  Modelica.Blocks.Math.Add pAvailableTotal(k1=+1, k2=k_neg) "총 가용 전력 = 외부 입력 + 회생 전력" annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Modelica.Blocks.Math.Sum sumNegative(nin=N) "음의 사용량 합계" annotation (Placement(transformation(extent={{-40,-90},{-60,-70}})));
  Modelica.Blocks.Continuous.FirstOrder pAvailableFiltered(T=T_available, initType=
       Modelica.Blocks.Types.Init.InitialOutput) "회생 전력 1차 지연 필터" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-80,-80})));

protected
  parameter Real k_neg = if negative_available then -1 else 0 "음의 사용량 피드백 게인";

equation
  // 주 전력 분배 경로: 캐스케이드 → 비율 제한 → 절대값 제한 → 최종 할당
  connect(stack.yN, ratio.u) annotation (Line(points={{-2,44},{-60,44},{-60,-48},{-42,-48}}, color={0,0,127}));
  connect(ratio.y, absolute.u) annotation (Line(points={{-19,-48},{-2,-48}}, color={0,0,127}));
  connect(absolute.y, p_allocated) annotation (Line(points={{21,-48},{80,-48},{80,0},{120,0}}, color={0,0,127}));

  // 잔여 전력 계산 및 순환
  connect(lowerLimit.y, stack.uN) annotation (Line(points={{31,20},{60,20},{60,44},{42,44}}, color={0,0,127}));
  connect(remain.y, lowerLimit.u) annotation (Line(points={{-11,20},{8,20}}, color={0,0,127}));
  connect(remain.u1, stack.yN) annotation (Line(points={{-28,20},{-60,20},{-60,44},{-2,44}},  color={0,0,127}));

  // 관대성 스위치 연결
  connect(swGenerous.y, remain.u2) annotation (Line(points={{19,-20},{-20,-20},{-20,12}}, color={0,0,127}));
  connect(swGenerous.u2, absolute.y) annotation (Line(points={{42,-28},{50,-28},{50,-48},{21,-48}}, color={0,0,127}));

  // 사용 전력 분석 연결
  connect(positiveUsed.u, p_used) annotation (Line(points={{18,-80},{0,-80},{0,-120}}, color={0,0,127}));
  connect(unUsed.u1, stack.yN) annotation (Line(points={{55.2,0},{-60,0},{-60,44},{-2,44}}, color={0,0,127}));
  connect(unUsed.u2, positiveUsed.y) annotation (Line(points={{60,-4.8},{60,-80},{41,-80}}, color={0,0,127}));
  connect(positiveUsed.y, swGenerous.u1) annotation (Line(points={{41,-80},{60,-80},{60,-12},{42,-12}}, color={0,0,127}));

  // 총 가용 전력 및 피드백 연결
  connect(pAvailableTotal.u1, p_available) annotation (Line(points={{-72,66},{-90,66},{-90,0},{-120,0}}, color={0,0,127}));
  connect(pAvailableTotal.y, stack.u) annotation (Line(points={{-49,60},{-4,60}}, color={0,0,127}));
  connect(negativeUsed.u, p_used) annotation (Line(points={{-8,-80},{0,-80},{0,-120}}, color={0,0,127}));
  connect(sumNegative.u, negativeUsed.y) annotation (Line(points={{-38,-80},{-31,-80}}, color={0,0,127}));
  connect(pAvailableFiltered.u, sumNegative.y) annotation (Line(points={{-68,-80},{-61,-80}}, color={0,0,127}));
  connect(pAvailableFiltered.y, pAvailableTotal.u2) annotation (Line(points={{-91,-80},{-100,-80},{-100,-20},{-80,-20},{-80,54},{-72,54}}, color={0,0,127}));

  annotation (Documentation(info="<html>
<h4>제어기 종류: 캐스케이드 전력 분배 제어기 (7단계 처리)</h4>
<p><b>PI/PID 제어기가 아닌 전력 할당 알고리즘</b>입니다.</p>
<p>제한된 전력을 여러 부하에 우선순위와 제한조건에 따라 효율적으로 분배합니다.</p>
<p><b>응용:</b> 배터리 팩, 전기차, 마이크로그리드 전력 관리</p>
</html>"));
end GenerousStack;