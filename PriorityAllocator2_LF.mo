block PriorityAllocator2_LF "SC 우선(소형 LPF + VIP 헤드룸)"
// SC(DC/DC)에 우선적으로 전력을 할당하고, 잔여를 배터리에 배분합니다.
// 작은 1차 지연(FirstOrder)과 VIP(측정 전력)를 고려한 "헤드룸(cap - used)" 기반으로 안정적으로 동작합니다.


parameter Modelica.Units.SI.Time T_small = 0.01 "루프 완화용 작은 지연(5~20 ms 권장)";
parameter Real margin_W = 0.0 "헤드룸 보수 마진 [W] (경계 톱질 방지용)";


// ===== 입력 =====
// 요구 전력
Modelica.Blocks.Interfaces.RealInput P_req
"요구 전력(+방전/-충전)" annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));


// SC(DCDC) 정적 cap 및 측정 전력 (GetComponentLimits + GetComponentVIP)
Modelica.Blocks.Interfaces.RealInput cap_sc_out
"SC 방전 cap [W] (limits)" annotation (Placement(transformation(extent={{-140,90},{-100,130}})));
Modelica.Blocks.Interfaces.RealInput cap_sc_in
"SC 충전 cap [W] (limits)" annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
Modelica.Blocks.Interfaces.RealInput p_sc_meas
"SC 측정 전력 +out/-in (VIP: DCDCpower.p)" annotation (Placement(transformation(extent={{-140,30},{-100,70}})));


// Battery 정적 cap 및 측정 전력 (GetComponentLimits + GetComponentVIP)
Modelica.Blocks.Interfaces.RealInput cap_bt_out
"Batt 방전 cap [W] (limits)" annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));
Modelica.Blocks.Interfaces.RealInput cap_bt_in
"Batt 충전 cap [W] (limits)" annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
Modelica.Blocks.Interfaces.RealInput p_bt_meas
"Batt 측정 전력 +out/-in (VIP: BatterySensor.p)" annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));


// ===== 출력 =====
Modelica.Blocks.Interfaces.RealOutput P_sc_cmd
"DCDC→SC 명령 전력[W] (능동 제어)" annotation (Placement(transformation(extent={{100,40},{140,80}})));
Modelica.Blocks.Interfaces.RealOutput P_bt_cmd
"배터리 잔여 전력[W] (수동/모니터링)" annotation (Placement(transformation(extent={{100,0},{140,40}})));
Modelica.Blocks.Interfaces.RealOutput P_unserved
"미서빙 전력[W]" annotation (Placement(transformation(extent={{100,-40},{140,0}})));


protected
// 원시/유효 한계 및 잔여
Real P_sc_lim_raw, P_res_raw, P_bt_lim_raw;
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
sc_out_eff = max(0, cap_sc_out - max(0, p_sc_meas) - margin_W);
sc_in_eff = max(0, cap_sc_in - max(0, -p_sc_meas) - margin_W);
bt_out_eff = max(0, cap_bt_out - max(0, p_bt_meas) - margin_W);
bt_in_eff = max(0, cap_bt_in - max(0, -p_bt_meas) - margin_W);


// 1) SC에 먼저 cap 내로 클램프(능동 제어)
P_sc_lim_raw = if P_req >= 0 then min(P_req, sc_out_eff)
else max(P_req, -sc_in_eff);


// 2) 잔여를 배터리에 cap 내로 클램프(수동 배분)
P_res_raw = P_req - P_sc_lim_raw;
P_bt_lim_raw = if P_res_raw >= 0 then min(P_res_raw, bt_out_eff)
else max(P_res_raw, -bt_in_eff);


// 3) 소형 LPF로 루프 완화(테이블형 모델과의 결합 안정화)
f_sc.u = P_sc_lim_raw;
f_bt.u = P_bt_lim_raw;
P_sc_cmd = f_sc.y;
P_bt_cmd = f_bt.y;


// 4) 미서빙 전력 (P_bt_cmd를 쓰지 않는 경우에도 내부 f_bt.y로 일관 계산)
P_unserved = abs(P_req - (P_sc_cmd + f_bt.y));
end PriorityAllocator2_LF;