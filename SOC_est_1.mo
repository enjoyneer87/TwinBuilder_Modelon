model SOC_est_1
  // "CoulombCountingSOC_Block"
  "블록 다이어그램 형태의 SOC 추정기 (Diagram 레이어에서 아이콘 표시)"

  // ---- Parameters ----
  // 초기 SOC (State of Charge) 값, 0에서 1 사이
  parameter Real SOC0(min=0, max=1) = 0.8 "Initial SOC";
  // 정격 용량 [C] (예: 200 Ah = 200*3600)
  parameter Real C_rated = 200*3600
    "Rated capacity [C] (e.g., 200 Ah = 200*3600)";
  // 전류 방향 설정: true면 I>0은 방전, false면 I>0은 충전
  parameter Boolean dischargePositive = true
    "true: I>0 is DISCHARGE; false: I>0 is CHARGE";
  // 충전 효율 (Coulombic efficiency)
  parameter Real eta_chg(min=0, max=1) = 0.99 "Coulombic eff. on charge";
  // 방전 효율 (Coulombic efficiency)
  parameter Real eta_dis(min=0, max=1) = 1.00 "Coulombic eff. on discharge";

  // ---- I/O ----
  // 배터리 전류 입력 [A]
  .Modelica.Blocks.Interfaces.RealInput  I "Battery current [A]"
    annotation (Placement(transformation(extent={{-184.29,4.89},{-144.29,44.89}},rotation = 0.0,origin = {0.0,0.0})));
  // 추정된 SOC 출력 [0..1]
  .Modelica.Blocks.Interfaces.RealOutput SOC_est "State of Charge [0..1]"
    annotation (Placement(transformation(extent={{172.71,21.3},{212.71,61.3}},rotation = 0.0,origin = {0.0,0.0})));

protected
  // 전류 방향에 따른 부호 변환 (방전/충전 방향 설정에 따라)
  .Modelica.Blocks.Math.Gain signGain(k = if dischargePositive then 1 else -1)
    annotation (Placement(transformation(extent={{-111.87,15.52},{-91.87,35.52}},rotation = 0.0,origin = {0.0,0.0})));

  // 방전 효율의 역수 (1/eta_dis)
  .Modelica.Blocks.Sources.Constant invEtaDis(k = if eta_dis>0 then 1/eta_dis else 1e9)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  // 충전 효율 상수
  .Modelica.Blocks.Sources.Constant etaChg(k = eta_chg)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  // 방전 전류와 효율 곱셈 (I * 1/eta_dis)
  .Modelica.Blocks.Math.Product prodDis
    annotation (Placement(transformation(extent={{-42.36,8.5},{-22.36,28.5}},rotation = 0.0,origin = {0.0,0.0})));
  // 충전 전류와 효율 곱셈 (I * eta_chg)
  .Modelica.Blocks.Math.Product prodChg
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  // 전류가 0 이상인지 판별 (방전/충전 구분)
  .Modelica.Blocks.Logical.GreaterEqualThreshold geZero(threshold = 0)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  // 방전/충전 모드에 따라 유효 전류 선택
  .Modelica.Blocks.Logical.Switch pickIeff
    annotation (Placement(transformation(extent={{11.84,-1.29},{31.84,18.71}},rotation = 0.0,origin = {0.0,0.0})));

  // 유효 전류를 SOC 변화율로 변환 (-I_eff / C_rated)
  .Modelica.Blocks.Math.Gain kGain(k = -1/C_rated)
    annotation (Placement(transformation(extent={{42.62,2.09},{62.62,22.09}},rotation = 0.0,origin = {0.0,0.0})));

  // SOC 변화율을 적분하여 SOC 계산 (초기값 SOC0)
  .Modelica.Blocks.Continuous.Integrator integ(
    k = 1,
    y_start = SOC0,
    initType = .Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{79.09,31.63},{99.09,51.63}},rotation = 0.0,origin = {0.0,0.0})));

  // SOC를 0~1 범위로 제한 (물리적 제약)
  .Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 1)
    annotation (Placement(transformation(extent={{122.64,31.24},{142.64,51.24}},rotation = 0.0,origin = {0.0,0.0})));

equation
  // 전류 방향 변환 및 효율 적용
  connect(signGain.y, prodDis.u1) annotation (Line(points={{-90.87,25.52},{-90.87,15.61},{-44.36,15.61},{-44.36,24.5}}, color={0,0,127}));
  connect(invEtaDis.y, prodDis.u2) annotation (Line(points={{-60,-10},{-50,-10},{-50,12.5},{-44.36,12.5}}, color={0,0,127}));

  connect(signGain.y, prodChg.u1) annotation (Line(points={{-90.87,25.52},{-50,25.52},{-50,-30},{-40,-30}}, color={0,0,127}));
  connect(etaChg.y, prodChg.u2) annotation (Line(points={{-60,-50},{-50,-50},{-50,-35},{-40,-35}}, color={0,0,127}));

  // 방전/충전 모드 판별
  connect(signGain.y, geZero.u) annotation (Line(points={{-90.87,25.52},{-50,25.52},{-50,50},{-40,50}}, color={0,0,127}));

  // 유효 전류 선택 (방전: prodDis, 충전: prodChg)
  connect(prodDis.y, pickIeff.u1) annotation (Line(points={{-21.36,18.5},{9.84,18.5},{9.84,16.71}}, color={0,0,127}));
  connect(geZero.y, pickIeff.u2) annotation (Line(points={{-20,50},{-1.02,50},{-1.02,8.71},{9.84,8.71}}, color={255,0,255}));
  connect(prodChg.y, pickIeff.u3) annotation (Line(points={{-20,-30},{9.84,-30},{9.84,0.71}}, color={0,0,127}));

  // SOC 계산 및 제한
  connect(pickIeff.y, kGain.u) annotation (Line(points={{32.84,8.71},{32.84,12.09},{40.62,12.09}}, color={0,0,127}));
  connect(kGain.y, integ.u) annotation (Line(points={{63.62,12.09},{70.29,12.09},{70.29,41.63},{77.09,41.63}}, color={0,0,127}));
  connect(integ.y, limiter.u) annotation (Line(points={{100.09,41.63},{120.64,41.63},{120.64,41.24}}, color={0,0,127}));
  connect(limiter.y, SOC_est) annotation (Line(points={{143.64,41.24},{143.64,41.3},{192.71,41.3}}, color={0,0,127}));
  // 입력 전류 연결
  connect(I,signGain.u) annotation(Line(points = {{-164.29,24.89},{-113.87,24.89},{-113.87,25.52}},color = {0,0,127}));

annotation(    Icon(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-62,76},{18,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-22,76},{-22,58}},
                                     color={0,0,0}),
        Line(points={{-10,52},{4,66}}, color={0,0,0}),
        Line(points={{-38,52},{-50,64}}, color={0,0,0}),
        Line(points={{0,36},{18,36}},color={0,0,0}),
        Line(points={{-44,36},{-62,36}},
                                       color={0,0,0}),
        Polygon(
          points={{-24,35},{-22,36},{-20,37},{-36,68},{-24,35}},
          lineColor={0,0,0},
          fillColor={35,35,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-27,41},{-17,31}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-22,14},{-22,-4}},
                                       color={0,0,0}),
        Line(points={{-38,20},{-50,8}},    color={0,0,0}),
        Polygon(
          points={{4,36},{2,46},{-6,56},{4,66},{10,60},{14,52},{16,48},{18,36},{
              4,36}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-62,76},{18,-4}},  lineColor={0,0,0})}),
       Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),Documentation(info="<html>
<p>SOC 추정기: 초기 SoC에서의 정격 용량을 기반으로 측정 전류를 적분하여 배터리의 충전 상태(State of Charge)를 추정합니다.</p>
<p>주요 특징:</p>
<ul>
<li>방전/충전 효율 고려 (Coulombic efficiency)</li>
<li>전류 방향 설정 가능 (dischargePositive 파라미터)</li>
<li>SOC 범위 자동 제한 (0~1)</li>
<li>블록 다이어그램 형태로 구현</li>
</ul>
</html>",
    revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any MOASOFT.</html>"));
end SOC_est_1;
