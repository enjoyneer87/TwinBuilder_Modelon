block EMS_Charger_PowerChain "충전 EMS(CCCV, VIP 헤드룸, SC 우선)"
import Modelica.Units.*;
 parameter SI.Current  I_CC    = 50;

parameter SI.Voltage V_CV = 420;
parameter SI.Voltage V_hys = 1;
parameter SI.Power P_hw_cap= 300e3;
parameter Real kp_v = 5.0;
parameter SI.Time Ti_v = 0.5;
parameter SI.Voltage V_sc_nom= 400;
parameter Real k_sc = 0.0 "CV 구간에서 SC 충전 우선도(0=미사용)";


// === 입력 ===
// 측정/상태
Modelica.Blocks.Interfaces.RealInput v_pack annotation (Placement(transformation(extent={{-143.82,188.76},{-103.82,228.76}},rotation = 0.0,origin = {0.0,0.0})));
Modelica.Blocks.Interfaces.RealInput V_bus annotation (Placement(transformation(extent={{-140.0,157.36},{-100.0,197.36}},rotation = 0.0,origin = {0.0,0.0})));
Modelica.Blocks.Interfaces.RealInput v_sc annotation (Placement(transformation(extent={{-137.13,127.87},{-97.13,167.87}},rotation = 0.0,origin = {0.0,0.0})));
// 배터리 한계/측정(헤드룸)
Modelica.Blocks.Interfaces.RealInput limit_bt_in "Batt 충전 cap[W]" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {-69.67,-65.22})));
Modelica.Blocks.Interfaces.RealInput i_max_in_bt "Batt 충전 i_max[A]" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {-28.6,-64.15})));
Modelica.Blocks.Interfaces.RealInput p_bt_meas "+out/-in" annotation (Placement(transformation(extent={{-138.09,49.89},{-98.09,89.89}},rotation = 0.0,origin = {0.0,0.0})));
Modelica.Blocks.Interfaces.RealInput i_bt_meas "+out/-in" annotation (Placement(transformation(extent={{-137.13,16.57},{-97.13,56.57}},rotation = 0.0,origin = {0.0,0.0})));
// 소스 한계/측정(우선배분)
Modelica.Blocks.Interfaces.RealInput limit_sc_out "SC 방전 cap[W]" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {28.71,-63.81999999999999})));
Modelica.Blocks.Interfaces.RealInput limit_sc_in "SC 충전 cap[W]" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {66.92,-64.65})));
Modelica.Blocks.Interfaces.RealInput limit_bt_out "Batt 방전 cap[W]" annotation (Placement(transformation(extent={{-20.0,-20.0},{20.0,20.0}},rotation = 90.0,origin = {116.58000000000001,-64.53})));
Modelica.Blocks.Interfaces.RealInput p_sc_meas "SC 측정 전력" annotation (Placement(transformation(extent={{-136.04,-26.15},{-96.04,13.85}},rotation = 0.0,origin = {0.0,0.0})));


// === 출력 ===
Modelica.Blocks.Interfaces.RealOutput P_sc_cmd "DCDC→SC 명령 전력[W]"
annotation (Placement(transformation(extent={{152.79,157.06},{192.79,197.06}},rotation = 0.0,origin = {0.0,0.0})));
Modelica.Blocks.Interfaces.RealOutput P_load_cmd "충전기 power ref[W] (음수)"
annotation (Placement(transformation(extent={{152.79,117.06},{192.79,157.06}},rotation = 0.0,origin = {0.0,0.0})));


protected
// 서브블록
ChargerCCCVRef cccv(I_CC=I_CC, V_CV=V_CV, V_hys=V_hys, P_hw_cap=P_hw_cap,
kp_v=kp_v, Ti_v=Ti_v, V_sc_nom=V_sc_nom, k_sc=k_sc)
annotation (Placement(transformation(extent={{-18.93,175.29},{19.21,213.43}},rotation = 0.0,origin = {0.0,0.0})));
UnservedDerate derate()
annotation (Placement(transformation(extent={{-32.83,76.14},{26.21,135.18}},rotation = 0.0,origin = {0.0,0.0})));
PriorityAllocator2_LF alloc()
annotation (Placement(transformation(extent={{-38.81,5.73},{14.87,59.41}},rotation = 0.0,origin = {0.0,0.0})));


// 내부 재배선(allocator용 limit_bt_in2는 이름만 다름)


equation
// CCCV 입력 연결
connect(v_pack, cccv.v_pack);
connect(V_bus, cccv.V_bus);
connect(v_sc, cccv.v_sc);
connect(limit_bt_in, cccv.limit_bt_in);
connect(i_max_in_bt, cccv.i_max_in_bt);
connect(p_bt_meas, cccv.p_bt_meas);
connect(i_bt_meas, cccv.i_bt_meas);


// 미서빙 디레이��� → 우선배분
derate.P_req_in = cccv.P_chg_ref; // 충전은 음수
derate.P_unserved = alloc.P_unserved;
alloc.P_req = derate.P_req_out;


// 우선��분기 입력: 소스 헤드룸 계산���
connect(limit_sc_out, alloc.limit_sc_out);
connect(limit_sc_in, alloc.limit_sc_in);
connect(limit_bt_out, alloc.limit_bt_out);
connect(p_sc_meas, alloc.p_sc_meas);
connect(limit_bt_in,  alloc.limit_bt_in);
connect(p_bt_meas,  alloc.p_bt_meas);


// 출력 매핑
connect(alloc.P_sc_cmd, P_sc_cmd);
P_load_cmd = derate.P_req_out; // 충전기 명령(음수)

annotation (Documentation(info="<html>
<h3>EMS_Charger_PowerChain</h3>
<p>충전 모드 전용 EMS. CCCV로 배터리 목표 전류/전압을 만들고, 미서빙 기반 디레이트 후 SC 우선 배분으로 분배합니다.
소스/배터리의 정적 한계(cap)와 VIP 측정 전력을 결합해 헤드룸을 계산합니다.</p>
<ul>
<li><b>입력</b>: v_pack, V_bus, v_sc, cap/i_max, VIP(p, i)</li>
<li><b>출력</b>: P_sc_cmd(→DCDC), P_load_cmd(→충전기), P_unserved, alpha</li>
</ul>
</html>"),
Icon(graphics={Rectangle(extent={{-100,90},{100,-90}}, lineColor={28,108,200}),
Text(extent={{-90,60},{90,40}}, textString="EMS Charger"),
Line(points={{-100,70},{-60,70}}, color={0,0,127}),
Line(points={{60,70},{100,70}}, color={0,0,127})}));
end EMS_Charger_PowerChain;