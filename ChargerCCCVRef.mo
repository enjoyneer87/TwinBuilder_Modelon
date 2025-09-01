
block ChargerCCCVRef "충���������모드 CCCV Power Ref (헤드룸 반영)"
  import SI = Modelica.Units.SI;
  parameter SI.Current  I_CC    = 300;
  parameter SI.Voltage  V_CV    = 420;
  parameter SI.Voltage  V_hys   = 1;
  parameter SI.Power    P_hw_cap= 300e3;
  parameter Real        kp_v    = 5.0;
  parameter SI.Time     Ti_v    = 0.5;
  parameter SI.Voltage  V_sc_nom= 400;
  parameter Real        k_sc    = 0.0 "CV 구간에서 SC 충전 우선도(0이면 미사용)";
  parameter SI.Power    epsW    = 1.0;
  parameter SI.Voltage Veps = 1e-3 "zero-div guard for voltage";
  // 입력
  Modelica.Blocks.Interfaces.RealInput v_pack annotation(Placement(transformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput V_bus  annotation(Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput v_sc   annotation(Placement(transformation(extent={{-140,0},{-100,40}})));
  // 한계/측정(헤드룸 계산용)
  Modelica.Blocks.Interfaces.RealInput limit_bt_in   "배터리 충전 cap[W]" annotation(Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput i_max_in_bt "배터리 충전 i_max[A]" annotation(Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p_bt_meas   "+out/-in" annotation(Placement(transformation(extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealInput i_bt_meas   "+out/-in" annotation(Placement(transformation(extent={{-140,-160},{-100,-120}})));

  // 출력
  Modelica.Blocks.Interfaces.RealOutput P_chg_ref annotation(Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Boolean in_CC;
  Real p_bt_in_eff, i_bt_in_eff;
  Real i_cmd_cc, i_cmd_cv_unclamped, i_cmd_cv, i_cmd;
  Real P_sc_want, P_batt_target;
  Modelica.Blocks.Continuous.PI cvPI(k=kp_v, T=Ti_v,
    initType=Modelica.Blocks.Types.Init.SteadyState) annotation(Placement(transformation(extent={{-10,40},{10,60}})));

equation
  in_CC = v_pack < V_CV - V_hys;

  // 헤드룸(cap - used)
  p_bt_in_eff = max(0, limit_bt_in   - max(0, -p_bt_meas));
  i_bt_in_eff = max(0, i_max_in_bt - max(0, -i_bt_meas));

  // CC: I_CC를 헤드룸으로 제한
      // CC: 두-인수 min만 중첩해서 사용 + 전압 단위 일치
    i_cmd_cc = min(I_CC,
                   min(i_bt_in_eff,
                       p_bt_in_eff / noEvent(max(Veps, V_bus))));

  // CV: 전압 오차 PI→전류, 헤드룸 제한
  cvPI.u = V_CV - v_pack;  // e_v
  i_cmd_cv_unclamped = max(0, cvPI.y);
// CV도 같은 패턴으로 (네가 쓰신 곳 모두 동일 수정)
i_cmd_cv = min(I_CC,
               min(i_bt_in_eff,
                   min(p_bt_in_eff / max(Veps, V_bus),
                       i_cmd_cv_unclamped)));
  i_cmd = if in_CC then i_cmd_cc else i_cmd_cv;

  // CV에서만(옵션) SC도 함께 충전하고 싶을 때
  P_sc_want = if in_CC then 0 else max(0, k_sc * (V_sc_nom - v_sc));

  // 목표 전력(충전은 음수로 요청)
  P_batt_target = V_bus * i_cmd; // [W]
  P_chg_ref = - min(P_hw_cap, P_batt_target + P_sc_want);

  annotation(Documentation(info="<html><p>충전모드에서 CCCV 로직으로 배터리 전류/전압을 제어하고, 헤드룸(cap − used)을 반영해 과요청을 줄입니다. 출력은 버스 관점의 전력(충전=음수)입니다. CV에서만 선택적으로 SC 충전을 병행할 수 있습니다.</p></html>"),
    Icon(graphics={Rectangle(extent={{-100,40},{100,-40}}, lineColor={28,108,200}), Text(extent={{-90,10},{90,-10}}, textString="ChargerCCCV")}));
end ChargerCCCVRef;
