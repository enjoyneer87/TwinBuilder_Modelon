
/**
 * Local EMS for one load and two sources (Supercap + Battery).
 * Uses Electrification.Control.PowerAllocation.Components.GenerousStack directly.
 * - Separate OUT(방전) / IN(충전) stacks (allocate_negative=false)
 * - Dynamic caps per source (pMax/iMax, sign-aware)
 * - Slew-limited P_cmd
 * - Derating alpha for load, P_allow, P_unserved
 */
model LocalEMS_SC_Batt_Full
  import SI = Modelica.Units.SI;
  import MC = Modelica.Constants;

  parameter Integer N(min=1) = 2 "1:SC, 2:Battery";
  parameter Real eta[N]         = {0.985, 0.97};
  parameter Real k_ratio_out[N] = {0.7, 1.0};
  parameter Real k_ratio_in[N]  = {0.7, 1.0};
  parameter Boolean generous[N] = {true, true};
  parameter SI.Time T_available = 0.10;

  parameter Real dP_rise[N] = {3e6, 1e6};
  parameter Real dP_fall[N] = {3e6, 1e6};
  parameter SI.Time T_slew[N] = {0.03, 0.08};

  parameter SI.Time T_alpha = 0.03;
  parameter Real alpha_min = 0.0;

  // Inputs
  Modelica.Blocks.Interfaces.RealInput P_dem "Load demand (+dis/-chg) [W]" 
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput V_bus "Bus voltage [V]" 
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput p_used_abs[N] "abs used power per source [W]" 
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput pMaxOut_in[N] "Max discharge power caps [W]" 
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput pMaxIn_in[N] "Max charge power caps [W]" 
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput iMaxOut_in[N] "Max discharge current caps [A]" 
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}})));
  Modelica.Blocks.Interfaces.RealInput iMaxIn_in[N] "Max charge current caps [A]" 
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput P_cmd[N] "Power commands to sources [W]" 
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput i_ref[N] "Current references to sources [A]" 
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput P_allow "Total available power [W]" 
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealOutput alpha_load "Load derating factor [0-1]" 
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
  Modelica.Blocks.Interfaces.RealOutput P_unserved "Unserved power [W]" 
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));
  Modelica.Blocks.Interfaces.RealOutput p_max_out_load "Max discharge power [W]" 
    annotation (Placement(transformation(extent={{100,-140},{140,-100}})));
  Modelica.Blocks.Interfaces.RealOutput p_max_in_load "Max charge power [W]" 
    annotation (Placement(transformation(extent={{100,-180},{140,-140}})));

protected
  Real sgn = noEvent(if P_dem >= 0 then 1.0 else -1.0);
  SI.Power P_dem_mag = abs(P_dem);
  parameter SI.Voltage Veps = 1e-3;

  Electrification.Control.PowerAllocation.Components.GenerousStack outStack(
    N=N, generous=generous, k_ratio=k_ratio_out,
    k_absolute=fill(MC.inf, N), T_available=T_available, negative_available=false)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
    
  Electrification.Control.PowerAllocation.Components.GenerousStack inStack(
    N=N, generous=generous, k_ratio=k_ratio_in,
    k_absolute=fill(MC.inf, N), T_available=T_available, negative_available=false)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  SI.Power P_alloc[N], P_cap_sign[N], P_state[N](each start=0);
  SI.Power P_allow_out, P_allow_in;
  
  Modelica.Blocks.Continuous.FirstOrder alphaFilt(k=1, T=T_alpha)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  // 신호 처리용 추가 블록들
  Modelica.Blocks.Math.Gain negGain[N](each k=-1) 
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Nonlinear.Limiter powerLimiter[N] 
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Math.Division voltageDivision[N] 
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

equation
  outStack.p_available = if sgn >= 0 then P_dem_mag else 0;
  inStack.p_available  = if sgn <  0 then P_dem_mag else 0;
  outStack.p_used = p_used_abs;
  inStack.p_used  = p_used_abs;

  for i in 1:N loop
    P_alloc[i] = if sgn >= 0 then +outStack.p_allocated[i] else -inStack.p_allocated[i];

    if sgn >= 0 then
      P_cap_sign[i] = min( max(0, pMaxOut_in[i]), eta[i]*V_bus*max(0, iMaxOut_in[i]) );
    else
      P_cap_sign[i] = min( max(0, pMaxIn_in[i]),  eta[i]*V_bus*max(0, iMaxIn_in[i])  );
    end if;

    SI.Power P_tgt = Modelica.Math.Vectors.Utilities.limit(-P_cap_sign[i], P_alloc[i], +P_cap_sign[i]);

    der(P_state[i]) =
      noEvent( if (P_tgt - P_state[i]) >= 0
               then min(dP_rise[i], (P_tgt - P_state[i]) / max(1e-6, T_slew[i]))
               else max(-dP_fall[i], (P_tgt - P_state[i]) / max(1e-6, T_slew[i])) );

    P_cmd[i] = P_state[i];
    i_ref[i] = P_cmd[i] / (eta[i] * max(Veps, V_bus));
  end for;

  P_allow_out = sum( min( max(0, pMaxOut_in[i]), eta[i]*V_bus*max(0,iMaxOut_in[i]) ) for i in 1:N );
  P_allow_in  = sum( min( max(0, pMaxIn_in[i]),  eta[i]*V_bus*max(0,iMaxIn_in[i])  ) for i in 1:N );
  p_max_out_load = P_allow_out;
  p_max_in_load  = P_allow_in;

  P_allow = if sgn >= 0 then P_allow_out else P_allow_in;

  alphaFilt.u = max(alpha_min, min(1.0, P_allow / max(1e-6, P_dem_mag)));
  alpha_load  = alphaFilt.y;
  P_unserved  = max(0, P_dem_mag - P_allow);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,100}}), 
         graphics={
           Rectangle(
             extent={{-100,100},{100,-200}},
             lineColor={0,0,0},
             fillColor={255,255,255},
             fillPattern=FillPattern.Solid),
           Text(
             extent={{-80,80},{80,40}},
             lineColor={0,0,127},
             textString="Local EMS"),
           Text(
             extent={{-80,20},{80,-20}},
             lineColor={0,0,127},
             textString="SC + Battery"),
           Rectangle(
             extent={{-80,-40},{-20,-80}},
             lineColor={0,0,127},
             fillColor={0,127,255},
             fillPattern=FillPattern.Solid),
           Text(
             extent={{-75,-55},{-25,-65}},
             lineColor={255,255,255},
             textString="IN"),
           Rectangle(
             extent={{20,-40},{80,-80}},
             lineColor={0,0,127},
             fillColor={255,127,0},
             fillPattern=FillPattern.Solid),
           Text(
             extent={{25,-55},{75,-65}},
             lineColor={255,255,255},
             textString="OUT"),
           Line(
             points={{-50,-80},{-50,-120},{50,-120},{50,-80}},
             color={0,0,127},
             thickness=0.5),
           Text(
             extent={{-40,-110},{40,-130}},
             lineColor={0,0,127},
             textString="Power Flow")
         }),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,100}})),
    Documentation(info="<html>
<h4>Local Energy Management System (EMS)</h4>
<p>SuperCapacitor + Battery 조합의 로컬 전력 할당 제어기</p>
<ul>
<li><b>입력:</b> 부하 요구전력, 버스전압, 소스 한계값들</li>
<li><b>출력:</b> 소스별 전력/전류 지령, 가용전력, 디레이팅 팩터</li>
<li><b>특징:</b> 방전/충전 분리 할당, 슬루레이트 제한, 동적 용량 계산</li>
</ul>
</html>"));

end LocalEMS_SC_Batt_Full;