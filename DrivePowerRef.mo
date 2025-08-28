block DrivePowerRef "주행모드 Power Ref (버스전압 디레이트 + 캡 클램프)"
import SI = Modelica.Units.SI;
parameter SI.Voltage V_bus_hi = 420 "회생 시 버스 과전압 보호 상한";
parameter SI.Voltage V_bus_lo = 320 "구동 시 버스 저전압 보호 하한";
parameter SI.Time T_smooth = 0.01 "출력 부드럽게(1차)";
parameter SI.Power epsW = 1.0;


// 입력
Modelica.Blocks.Interfaces.RealInput P_dem_raw "운전자/VCU 요구전력(+구동/-회생)" annotation(Placement(transformation(extent={{-140,20},{-100,60}})));
Modelica.Blocks.Interfaces.RealInput p_max_out_load "방전 cap 합[W]" annotation(Placement(transformation(extent={{-140,-20},{-100,20}})));
Modelica.Blocks.Interfaces.RealInput p_max_in_load "충전 cap 합[W]" annotation(Placement(transformation(extent={{-140,-60},{-100,-20}})));
Modelica.Blocks.Interfaces.RealInput V_bus "버스전압[V]" annotation(Placement(transformation(extent={{-140,-100},{-100,-60}})));


// 출력
Modelica.Blocks.Interfaces.RealOutput P_drive_ref annotation(Placement(transformation(extent={{100,-10},{140,30}})));


protected
Real P_clamp, alpha_v, P_pre;
Modelica.Blocks.Continuous.FirstOrder f(T=T_smooth, k=1,
initType=Modelica.Blocks.Types.Init.InitialOutput, y_start=0)
annotation(Placement(transformation(extent={{-10,-10},{10,10}})));


equation
// 한계 내 클램프
P_clamp = if P_dem_raw >= 0 then min(P_dem_raw, p_max_out_load)
else max(P_dem_raw, -p_max_in_load);
// 버스전압 기반 디레이트(구동: 저전압, 회생: 과전압)
alpha_v = if (P_dem_raw < 0) and (V_bus > V_bus_hi) then max(0.0, 1 - (V_bus - V_bus_hi)/20)
else if (P_dem_raw > 0) and (V_bus < V_bus_lo) then max(0.0, 1 - (V_bus_lo - V_bus)/20)
else 1.0;
P_pre = alpha_v * P_clamp;


f.u = P_pre; P_drive_ref = f.y;


annotation(Documentation(info="<html><p>주행모드에서 운전자 요구전력 <code>P_dem_raw</code>을 cap으로 클램프하고, 버스전압 기반으로 디레이트한 뒤 1차 필터로 부드럽게 출력합니다.</p></html>"),
Icon(graphics={Rectangle(extent={{-100,40},{100,-40}}, lineColor={28,108,200}), Text(extent={{-80,10},{80,-10}}, textString="DriveRef")}));
end DrivePowerRef;