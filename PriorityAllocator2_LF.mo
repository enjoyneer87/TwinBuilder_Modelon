block PriorityAllocator2_LF "SC 우선(소형 LPF + VIP 헤드룸)"
  // SC(DC/DC)에 우선적으로 전력을 할당하고, 잔여를 배터리에 배분합니다.
  // 작은 1차 지연(FirstOrder)과 VIP(측정 전력)를 고려한 "헤드룸(cap - used)" 기���������으로 안정적으로 동작합니다.

  parameter Modelica.Units.SI.Time T_small = 0.01 "루프 완화용 작은 지연(5~20 ms 권장)";
  parameter Real margin_W = 0.0 "헤드룸 보수 마진 [W] (경계 톱질 방지용)";

  // ===== 입력 =====
  // 요구 전력
  Modelica.Blocks.Interfaces.RealInput P_req
    "요구 전력(+방전/-충전)" annotation (Placement(transformation(extent={{-142.0,66.0},{-102.0,106.0}},rotation = 0.0,origin = {0.0,0.0})));

  // SC(DCDC) 정적 cap 및 측정 전력 (GetComponentLimits + GetComponentVIP)
  Modelica.Blocks.Interfaces.RealInput limit_sc_out
    "SC 방전 cap [W] (limits)" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {-38.0,-87.0})));
  Modelica.Blocks.Interfaces.RealInput limit_sc_in
    "SC 충전 cap [W] (limits)" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {-68.0,-87.0})));
  Modelica.Blocks.Interfaces.RealInput p_sc_meas
    "SC 측정 전력 +out/-in (VIP: DCDCpower.p)" annotation (Placement(transformation(extent={{-142.0,-49.0},{-102.0,-9.0}},rotation = 0.0,origin = {0.0,0.0})));

  // Battery 정적 cap 및 측정 전력 (GetComponentLimits + GetComponentVIP)
  Modelica.Blocks.Interfaces.RealInput limit_bt_out
    "Batt 방전 cap [W] (limits)" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {76.0,-85.0})));
  Modelica.Blocks.Interfaces.RealInput limit_bt_in
    "Batt 충전 cap [W] (limits)" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {46.0,-85.0})));
  Modelica.Blocks.Interfaces.RealInput p_bt_meas
    "Batt 측정 전력 +out/-in (VIP: BatterySensor.p)" annotation (Placement(transformation(extent={{-142.0,-19.0},{-102.0,21.0}},rotation = 0.0,origin = {0.0,0.0})));

  // ===== 출력 =====
  Modelica.Blocks.Interfaces.RealOutput P_sc_cmd
    "DCDC→SC 명령 전력[W] (능동 제어)" annotation (Placement(transformation(extent={{100,40},{140,80}})));

  Modelica.Blocks.Interfaces.RealOutput P_unserved
    "미서빙 전력[W]" annotation (Placement(transformation(extent={{100,-40},{140,0}})));

protected
  // 원시/유효 한계 및 잔여
  Real P_sc_limit_raw, P_res_raw, P_bt_limit_raw;
  Real sc_out_eff, sc_in_eff, bt_out_eff, bt_in_eff;

  // 소형 1차 필터(GenerousStack 철학과 동일하게 루프를 부드럽게)
  Modelica.Blocks.Continuous.FirstOrder f_sc(
    T=T_small, k=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0) annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Blocks.Continuous.FirstOrder f_bt(
    T=T_small, k=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0) annotation (Placement(transformation(extent={{-10,10},{10,30}})));

equation
  // === VIP(측정 전력) 기반 유효 헤드룸 계산: cap - used - margin ===
  sc_out_eff = max(0, limit_sc_out - max(0,  p_sc_meas) - margin_W);
  sc_in_eff  = max(0, limit_sc_in  - max(0, -p_sc_meas) - margin_W);
  bt_out_eff = max(0, limit_bt_out - max(0,  p_bt_meas) - margin_W);
  bt_in_eff  = max(0, limit_bt_in  - max(0, -p_bt_meas) - margin_W);

  // 1) SC에 먼저 cap 내로 클램프(능동 제어)
  P_sc_limit_raw = if P_req >= 0 then min(P_req, sc_out_eff)
                               else max(P_req, -sc_in_eff);

  // 2) 잔여를 배터리에 cap 내로 클램프(수동 배분)
  P_res_raw    = P_req - P_sc_limit_raw;
  P_bt_limit_raw = if P_res_raw >= 0 then min(P_res_raw, bt_out_eff)
                                 else max(P_res_raw, -bt_in_eff);

  // 3) 소형 LPF로 루프 완화(테이블형 모델과의 결합 안정화)
  f_sc.u = P_sc_limit_raw;
  f_bt.u = P_bt_limit_raw;
  P_sc_cmd = f_sc.y;

  // 4) 미서빙 전력 (P_bt_cmd를 쓰지 않는 경우에도 내부 f_bt.y로 일관 계산)
  P_unserved = abs(P_req - (P_sc_cmd + f_bt.y));


 // 미서빙 전력이 있을시에 P_req를 scaling해서 되지않을까
  annotation (
    Documentation(info="<html>
  <h3>PriorityAllocator2_LF — SC 우선, VIP 헤���룸 + 작은 LPF</h3>
  <p>요구 전력 <code>P_req</code>에 대해 먼저 SC(DC/DC)에 cap ���로 전력을 할당하고, 남는 전력을 배터리에 배분합니다.
  <b>GetComponentLimits</b>로부터의 정적 한계(cap)와 <b>GetComponentVIP</b>의 측정 전력(<code>DCDCpower.p</code>, <code>BatterySensor.p</code>)을 사용해 \"헤드룸 = cap − used − margin\"을 계산, 초기화/수치 안정성을 높입니다.</p>
  <h4>입출력</h4>
  <ul>
    <li><b>P_req</b>: 요구 전력(+방전/-충전)</li>
    <li><b>limit_sc_out, limit_sc_in, p_sc_meas</b>: SC(DCDC)의 방전/충전 한계와 측정 전력</li>
    <li><b>limit_bt_out, limit_bt_in, p_bt_meas</b>: 배터리의 방전/충전 한계와 측정 전력</li>
    <li><b>P_sc_cmd</b>: DCDC→SC 명령 전력(능동 제어용)</li>
    <li><b>P_bt_cmd</b>: 배터리 잔여 전력(수동 배분·모니터링용)</li>
    <li><b>P_unserved</b>: 미서빙 전력</li>
  </ul>
  <h4>튜닝</h4>
  <ul>
    <li><b>T_small</b>: 5~20 ms 권장(컨버터 전류루프보다 충분히 느리게)</li>
    <li><b>margin_W</b>: 경계 톱질/깜빡임 방지를 위한 보수 마진</li>
  </ul>
</html>"),
    Icon(graphics={
      Rectangle(extent={{-100,60},{100,-60}}, lineColor={28,108,200}, fillPattern=FillPattern.Solid, fillColor={255,255,255}),
      // 좌: SC(DCDC) 블록 (우선 대상, 진한색)
      Rectangle(extent={{-70,30},{-30,-30}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid),
      Text(extent={{-70,40},{-30,32}}, textString="SC", textColor={255,255,255}),
      // 우: Battery 블록 (잔여, 연한색)
      Rectangle(extent={{10,30},{50,-30}}, lineColor={0,0,127}, fillColor={200,200,200}, fillPattern=FillPattern.Solid),
      Text(extent={{10,40},{50,32}}, textString="Batt", textColor={0,0,0}),
      // 입력/출력 화살표
      Line(points={{-100,0},{-76,0}}, color={0,0,127}, thickness=0.5),
      Line(points={{50,20},{100,20}}, color={0,0,127}, thickness=0.5),
      Line(points={{50,-10},{100,-10}}, color={0,0,127}, thickness=0.5),
      // VIP 표식(작은 원)
      Ellipse(extent={{-90,48},{-82,40}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid),
      Ellipse(extent={{-90,-42},{-82,-50}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid)
    }));
end PriorityAllocator2_LF;
