block UnservedDerate "Derate P_req when unserved power appears (stateful, loop-safe)"
  // 미서빙 전력(P_unserved)이 발생할 때, 다음 스텝의 요구전력 P_req를 완만히 낮춰
  // 네트워크/한계 충돌을 완화합니다. 1차 필터 상태를 사용��� 대수루프/고지수화를 피합니다.

  import SI = Modelica.Units.SI;

  // ====== 튜닝 파라미터 ======
  parameter SI.Time T_alpha = 0.10 "derate 반응 시간(0.05~0.2 s 권장)";
  parameter Real k = 1.0 "unserved 비율에 대한 민감도(1.0이면 그대로 반영)";
  parameter SI.Power deadband_W = 2000 "미서빙 데드밴드(작은 잔차 무시)";
  parameter Real alpha_min = 0.0 "최소 derate";
  parameter Real alpha_max = 1.0 "최대 derate(=원래 요청)";
  parameter SI.Power epsW = 1.0 "0 나누기 보호";

  // ====== 입출력 ======
  Modelica.Blocks.Interfaces.RealInput P_req_in
    "원래 요구 전력(+방전/-충전)"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput P_unserved
    "미서빙 전력(양수)"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput P_req_out
    "derate된 요구 전력"
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Modelica.Blocks.Interfaces.RealOutput alpha
    "derate 계수(0..1)"
    annotation (Placement(transformation(extent={{100,-40},{140,0}})));

protected
  Real P_req_abs;
  Real unserved_eff;
  Real alpha_target;
  Modelica.Blocks.Continuous.FirstOrder aFilt(k=1, T=T_alpha,
    initType=Modelica.Blocks.Types.Init.InitialOutput, y_start=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  // 유효 미서빙 (데드밴드 제거)
  unserved_eff = max(0, P_unserved - deadband_W);
  P_req_abs    = max(epsW, abs(P_req_in));

  // 목표 derate: 1 - k*(unserved/|P_req|) 를 [alpha_min, alpha_max]로 클램프
  alpha_target = min(alpha_max, max(alpha_min, 1 - k*unserved_eff / P_req_abs));

  // 1차 필터로 완만히 적용 (상태로 루프 절단)
  aFilt.u = alpha_target;
  alpha   = aFilt.y;

  // 출력 요구전력
  P_req_out = alpha * P_req_in;

  annotation (Documentation(info="<html>
  <h3>UnservedDerate — 미서빙 전력 기반 요구전력 디레이트</h3>
  <p>할당/실행 후 남는 미서빙 전력 <code>P_unserved</code>가 존재하면, 다음 스텝의 요구전력 <code>P_req</code>를 
  <code>alpha</code>(0..1) 계수로 완만히 낮춥니다. 1차 필터 상태(<code>T_alpha</code>)로 대수루프/초기화 문제를 완화합니다.</p>
  <h4>로직</h4>
  <ul>
    <li>유효 미서빙: <code>unserved_eff = max(0, P_unserved - deadband_W)</code></li>
    <li>목표 계수: <code>alpha_target = clip(1 - k * unserved_eff / max(|P_req|, eps), [alpha_min, alpha_max])</code></li>
    <li>적용: <code>alpha = FirstOrder(alpha_target, T_alpha)</code>, <code>P_req_out = alpha * P_req_in</code></li>
  </ul>
  <h4>튜닝 가이드</h4>
  <ul>
    <li><b>T_alpha</b>: 50~200 ms, 전류루프보다 느리게</li>
    <li><b>deadband_W</b>: 수 kW(측정잡음/경계 톱질 제거)</li>
    <li><b>k</b>: 0.5~1.5 범위에서 시작</li>
  </ul>
</html>"),
    Icon(graphics={
      Rectangle(extent={{-100,60},{100,-60}}, lineColor={28,108,200}, fillPattern=FillPattern.Solid, fillColor={255,255,255}),
      // 입력/출력 화살표
      Line(points={{-100,40},{-60,40}}, color={0,0,127}),
      Line(points={{-100,-40},{-60,-40}}, color={0,0,127}),
      Line(points={{60,20},{100,20}}, color={0,0,127}),
      Line(points={{60,-20},{100,-20}}, color={0,0,127}),
      // 게이지 아이콘
      Ellipse(extent={{-30,20},{30,-40}}, lineColor={0,0,127}),
      Line(points={{0,-10},{0,10}}, color={0,0,127}),
      Line(points={{0,-10},{20,-20}}, color={0,0,127})
    }));
end UnservedDerate;
