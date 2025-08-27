model EMS_Unified
  import SI = Modelica.Units.SI;
  extends .Electrification.Control.Interfaces.BaseController;

  // ===== Allocation 테이블 =====
  parameter Integer dcdc_id = 1 "DC/DC converter component ID";
  parameter Integer battery_id = 1 "Battery component ID";
  parameter Integer load_id = 1 "Load component ID";
  
  parameter .Electrification.Control.PowerAllocation.Records.AllocationRecord
    allocation[:] = {
      .Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=dcdc_id,
        controllerType=.Electrification.Utilities.Types.ControllerType.Converter,
        generous=true, p_rat_out=0.7, p_rat_in=0.7,
        p_max_out=.Modelica.Constants.inf, p_max_in=.Modelica.Constants.inf,
        i_max_out=.Modelica.Constants.inf, i_max_in=.Modelica.Constants.inf),
      .Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=battery_id,
        controllerType=.Electrification.Utilities.Types.ControllerType.Battery,
        generous=true, p_rat_out=1.0, p_rat_in=1.0,
        p_max_out=.Modelica.Constants.inf, p_max_in=.Modelica.Constants.inf,
        i_max_out=.Modelica.Constants.inf, i_max_in=.Modelica.Constants.inf)
    };

  final parameter Integer N(min=1) = size(allocation,1) "Number of sources";

  // ===== 튜닝 =====
  parameter .Modelica.Units.SI.Time T_available  = 0.10;
  parameter Boolean allocate_negative = true;
  parameter Real eta[N] = {0.985,0.97};
  parameter Real dP_rise[N] = {3e6, 1e6};
  parameter Real dP_fall[N] = {3e6, 1e6};
  parameter .Modelica.Units.SI.Time T_slew[N] = {0.03, 0.08};
  parameter .Modelica.Units.SI.Time T_alpha = 0.03;
  parameter Real alpha_min = 0.0;
  parameter Boolean visualConnections = true;

  // ===== 모드/입력 =====
  Modelica.Blocks.Interfaces.BooleanInput isCharging;
  Modelica.Blocks.Interfaces.RealInput  P_dem_raw;
  Modelica.Blocks.Interfaces.RealInput  SOC;
  Modelica.Blocks.Interfaces.RealInput  T_max;
  Modelica.Blocks.Interfaces.RealInput  v_pack;
  Modelica.Blocks.Interfaces.RealInput  v_sc;
  Modelica.Blocks.Interfaces.RealInput  v_bus_in;
  Modelica.Blocks.Interfaces.RealInput  P_charger_cap;
  Modelica.Blocks.Interfaces.RealInput  iMaxIn_opt;

  // ===== 부하 버스/한계/VIP =====
  .Electrification.Control.Signals.BusSelector busLoad(
    category=Electrification.Utilities.Types.ControllerType.Load, id=load_id) annotation (Placement(transformation(origin={0.0,0.0}, extent={{22.87,58.06},{10.87,70.06}},rotation = 0.0)));
  .Electrification.Control.Limits.GetComponentVIP vipLoad annotation (Placement(transformation(extent={{78.29,-98.78},{58.29,-78.78}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Control.Limits.SetComponentLimits setLoad(
    external_enable=false, // 외부 enable 미사용
    i_max_in=.Modelica.Constants.inf, i_max_out=.Modelica.Constants.inf) annotation (Placement(transformation(extent={{65.11,-5.24},{97.11,26.76}},rotation = 0.0,origin = {0.0,0.0})));

  // ===== 소스 버스/한계/VIP =====
  .Electrification.Control.Signals.BusSelector busSrc[N](
    id=allocation.id, category=allocation.controllerType) annotation (Placement(transformation(origin={-20,80}, extent={{-6,-6},{6,6}})));
  .Electrification.Control.Limits.GetComponentLimits srcLimits[N](
    vMaxSignal=true, vMinSignal=true,
    iMaxInSignal=true, iMaxOutSignal=true,
    pMaxInSignal=true, pMaxOutSignal=true) annotation (Placement(transformation(extent={{-110.21,17.6},{-78.21,49.6}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Control.Limits.GetComponentVIP vipSrc[N] annotation (Placement(transformation(extent={{-140.55,-54.33},{-108.55,-22.33}},rotation = 0.0,origin = {0.0,0.0})));

  // ===== GenerousStack (방전/충전) =====
  .Electrification.Control.PowerAllocation.Components.GenerousStack pOutAlloc(
    N=N, generous=allocation.generous,
    k_ratio=allocation.p_rat_out, k_absolute=allocation.p_max_out,
    T_available=T_available, negative_available=allocate_negative) annotation (Placement(transformation(extent={{27.83,-8.41},{47.83,11.59}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Control.PowerAllocation.Components.GenerousStack pInAlloc(
    N=N, generous=allocation.generous,
    k_ratio=allocation.p_rat_in, k_absolute=allocation.p_max_in,
    T_available=T_available, negative_available=allocate_negative) annotation (Placement(transformation(extent={{-1.18,-70.02},{18.82,-50.02}},rotation = 0.0,origin = {0.0,0.0})));

  // ===== Summary =====
  replaceable input .Electrification.Control.PowerAllocation.Records.Summary summary(
    p_avail_out = pOutAlloc.pAvailableTotal.y,
    p_avail_in  = pInAlloc.pAvailableTotal.y,
    p_alloc_out = pOutAlloc.p_allocated,
    p_alloc_in  = pInAlloc.p_allocated,
    p_used_out  = -pInAlloc.sumNegative.y,
    p_used_in   = -pOutAlloc.sumNegative.y,
    p_in        = {demandPassthrough.y, 0},
    final N     = N) annotation (choicesAllMatching=true);

  // ===== 출력 =====
  .Modelica.Blocks.Interfaces.RealOutput P_cmd[N];
  .Modelica.Blocks.Interfaces.RealOutput i_ref[N];
  .Modelica.Blocks.Interfaces.RealOutput alpha_load;
  .Modelica.Blocks.Interfaces.RealOutput p_max_out_load;
  .Modelica.Blocks.Interfaces.RealOutput p_max_in_load;
  .Modelica.Blocks.Interfaces.RealOutput P_unserved;
  Modelica.Blocks.Interfaces.RealOutput P_load_cmd;

protected
  // 공통
  parameter .Modelica.Units.SI.Voltage Veps=1e-3;
  .Modelica.Units.SI.Voltage V_bus;
  // 편의
  Real sgn;
  .Modelica.Units.SI.Power P_dem_mag;
  // 동적 한계
  .Modelica.Units.SI.Power cap_out[N], cap_in[N], cap_sign[N];
  Real p_max_out_vals[N](each start=1e6), p_max_in_vals[N](each start=1e6);
  Real i_max_out_vals[N](each start=1e3), i_max_in_vals[N](each start=1e3);

  // PassThrough (limits → Real)
  .Modelica.Blocks.Routing.RealPassThrough pMaxOutPass[N] annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  .Modelica.Blocks.Routing.RealPassThrough pMaxInPass[N] annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  .Modelica.Blocks.Routing.RealPassThrough iMaxOutPass[N] annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  .Modelica.Blocks.Routing.RealPassThrough iMaxInPass[N] annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));

  // Slew/필터
  .Modelica.Blocks.Continuous.FirstOrder alphaFilt(k=1, T=T_alpha) annotation (Placement(transformation(extent={{77.6,77.12},{97.6,97.12}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.Blocks.Nonlinear.SlewRateLimiter powerSlew(
    Rising=1e6, Falling=1e6, y_start=0) annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  .Modelica.Blocks.Nonlinear.SlewRateLimiter sourceSlew[N](
    Rising=dP_rise, Falling=dP_fall, each y_start=0) annotation (Placement(transformation(extent={{60,40},{80,60}})));

  // 표현용
  .Modelica.Blocks.Sources.RealExpression demandPassthrough(y=P_demand) annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  .Modelica.Blocks.Sources.RealExpression dischargeAvailable(y=max(P_demand, 0)) annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  .Modelica.Blocks.Sources.RealExpression chargeAvailable(y=max(-P_demand, 0)) annotation (Placement(transformation(extent={{-38.86,-0.57},{-18.86,19.43}},rotation = 0.0,origin = {0.0,0.0})));

  // SetComponentLimits 입력에 쓸 RealExpression
  Modelica.Blocks.Sources.RealExpression pMaxOutLoadExpr(y=p_max_out_load);
  Modelica.Blocks.Sources.RealExpression pMaxInLoadExpr (y=p_max_in_load);
  Modelica.Blocks.Sources.RealExpression vMaxExpr(y=max(vipSrc[i].v for i in 1:N) + 50.0);
  Modelica.Blocks.Sources.RealExpression vMinExpr(y=min(vipSrc[i].v for i in 1:N) - 50.0);
  Modelica.Blocks.Sources.RealExpression iMaxOutExpr(y=p_max_out_load / max(Veps, V_bus));
  Modelica.Blocks.Sources.RealExpression iMaxInExpr (y=p_max_in_load  / max(Veps, V_bus));

  // 보조: 일부 라이브러리에서 요구하는 보조합 입력 더미값
  Modelica.Blocks.Sources.Constant ZERO(k=0);

  // Demand 분기
  SI.Power P_dem_drive;
  SI.Power P_dem_chg;
  SI.Power P_demand;
  .Modelica.Units.SI.Power P_alloc[N];
  .Modelica.Units.SI.Power P_tgt[N];

  // Scheduling
  parameter SI.Power   P_nom   = 120e3;
  parameter Real       soc_lo  = 0.10;
  parameter Real       soc_hi  = 0.80;
  parameter SI.Temperature T_nom = 298.15;
  parameter Real       k_T     = 0.015;
  parameter SI.Voltage V_sc_nom= 400.0;
  parameter Real       k_sc_p  = 800.0;
  parameter SI.Power   P_min_mag= 5e3;
  parameter SI.Power   P_max_hw = 300e3;
  parameter SI.Time    T_req   = 0.10;

  Real k_soc, k_temp, k_sc, k_total;
  SI.Power P_mag_raw, P_from_i, P_mag_capped, P_mag_shaped, P_clamp;
  parameter SI.Voltage V_bus_hi = 420;
  parameter SI.Voltage V_bus_lo = 320;
  Real alpha_v, alpha_tot;

equation
  // === 버스/컴포넌트 연결 ===
  connect(busLoad.systemBus, controlBus);
  connect(setLoad.componentBus, busLoad.componentBus);
  connect(vipLoad.componentBus, busLoad.componentBus);
  for i in 1:N loop
    connect(busSrc[i].systemBus, controlBus);
    connect(srcLimits[i].componentBus, busSrc[i].componentBus);
    connect(vipSrc[i].componentBus, busSrc[i].componentBus);  end for;

  // === srcLimits: connector → PassThrough → Real ===
  for i in 1:N loop
    connect(srcLimits[i].p_max_out, pMaxOutPass[i].u);
    connect(srcLimits[i].p_max_in,  pMaxInPass[i].u);
    connect(srcLimits[i].i_max_out, iMaxOutPass[i].u);
    connect(srcLimits[i].i_max_in,  iMaxInPass[i].u);
    p_max_out_vals[i] = pMaxOutPass[i].y;
    p_max_in_vals[i]  = pMaxInPass[i].y;
    i_max_out_vals[i] = iMaxOutPass[i].y;
    i_max_in_vals[i]  = iMaxInPass[i].y;

    // ★ 일부 버전에서 요구하는 Agg 보조 입력 더미 연결
    connect(ZERO.y, srcLimits[i].pMaxInAgg.u2);
    connect(ZERO.y, srcLimits[i].pMaxOutAgg.u2);
    connect(ZERO.y, srcLimits[i].iMaxInAgg.u2);
    connect(ZERO.y, srcLimits[i].iMaxOutAgg.u2);
  end for;

  // === 버스 전압: 측정 입력으로 루프 절단 (초기/번역 안정)
  V_bus = max(Veps, v_bus_in);
  // 필요시 VIP 기반으로 전환할 때는 1차 필터를 끼워 루프 완화
  // Modelica.Blocks.Continuous.FirstOrder vbusFilt(T=0.005, k=1);
  // vbusFilt.u = min(vipSrc[i].v for i in 1:N);
  // V_bus = max(Veps, vbusFilt.y);

  // === p_available: RealExpression → connect로만 (등식 금지)
  connect(dischargeAvailable.y, pOutAlloc.p_available);
  connect(chargeAvailable.y,    pInAlloc.p_available);

  // === p_used: VIP가 발행하는 즉시 전력 사용
  if not visualConnections then
    for i in 1:N loop
      connect(vipSrc[i].p, pOutAlloc.p_used[i]);
      connect(vipSrc[i].p, pInAlloc.p_used[i]);
    end for;
  else
    connect(vipSrc[1].p, pOutAlloc.p_used[1]);
    connect(vipSrc[1].p, pInAlloc.p_used[1]);
    connect(vipSrc[2].p, pOutAlloc.p_used[2]);
    connect(vipSrc[2].p, pInAlloc.p_used[2]);
  end if;

  // === 편의 변수
  sgn       = if P_demand >= 0 then 1.0 else -1.0;
  P_dem_mag = abs(P_demand);

  // === 소스별 동적 한계 (min(pMax, η·V·iMax))
  for i in 1:N loop
    cap_out[i]  = min(p_max_out_vals[i], eta[i]*V_bus*i_max_out_vals[i]);
    cap_in[i]   = min(p_max_in_vals[i],  eta[i]*V_bus*i_max_in_vals[i]);
    cap_sign[i] = if sgn>=0 then cap_out[i] else cap_in[i];
  end for;

  // === 부하 허용합 계산
  p_max_out_load = sum(cap_out[i] for i in 1:N);
  p_max_in_load  = sum(cap_in[i]  for i in 1:N);

  // === SetComponentLimits 입력은 전부 connect 사용
  connect(pMaxOutLoadExpr.y, setLoad.p_max_out);
  connect(pMaxInLoadExpr.y,  setLoad.p_max_in);
  connect(vMaxExpr.y,        setLoad.v_max);
  connect(vMinExpr.y,        setLoad.v_min);
  connect(iMaxOutExpr.y,     setLoad.i_max_out);
  connect(iMaxInExpr.y,      setLoad.i_max_in);

  // ----------------------------------------------------------------
  // (A) 주행 모드
  // ----------------------------------------------------------------
  P_clamp = if P_dem_raw >= 0 then min(P_dem_raw, p_max_out_load)
                                else max(P_dem_raw, -p_max_in_load);
  alpha_v = if (P_dem_raw < 0) and (V_bus > V_bus_hi) then max(0.0, 1.0 - (V_bus - V_bus_hi)/20)
           else if (P_dem_raw > 0) and (V_bus < V_bus_lo) then max(0.0, 1.0 - (V_bus_lo - V_bus)/20)
           else 1.0;
  alpha_tot   = alpha_v;
  P_dem_drive = alpha_tot * P_clamp;

  // ----------------------------------------------------------------
  // (B) 충전 모드 스케줄러
  // ----------------------------------------------------------------
  k_soc   = smooth(1, max(0.0, min(1.0, (soc_hi - SOC)/max(1e-6, soc_hi - soc_lo))));
  k_temp  = max(0.0, 1.0 - k_T*max(0, T_max - T_nom));
  k_sc    = max(0.0, 1.0 + k_sc_p*(V_sc_nom - v_sc)/max(1.0, P_nom));
  k_total = max(0.0, min(1.25, k_soc*k_temp*k_sc));

  P_mag_raw    = k_total * P_nom;
  P_from_i     = if iMaxIn_opt < 1e8 then min(P_mag_raw, V_bus * iMaxIn_opt) else P_mag_raw;
  P_mag_capped = min(P_from_i, P_charger_cap);
  powerSlew.u  = P_mag_capped;
  P_mag_shaped = powerSlew.y;
  P_dem_chg    = -P_mag_shaped;

  // ----------------------------------------------------------------
  // (C) 최종 선택/출력
  // ----------------------------------------------------------------
  P_demand  = if isCharging then P_dem_chg else P_dem_drive;
  alphaFilt.u = min(1.0, (if P_demand >= 0 then p_max_out_load else p_max_in_load) / max(1e-6, abs(P_demand)));
  alpha_load  = alphaFilt.y;
  P_load_cmd  = P_demand;

  for i in 1:N loop
    cap_sign[i]   = if P_demand >= 0 then cap_out[i] else cap_in[i];
    P_alloc[i]    = if P_demand >= 0 then +pOutAlloc.p_allocated[i] else -pInAlloc.p_allocated[i];
    P_tgt[i]      = min(cap_sign[i], max(-cap_sign[i], P_alloc[i]));
    sourceSlew[i].u = P_tgt[i];
    P_cmd[i]      = sourceSlew[i].y;
    i_ref[i]      = P_cmd[i] / (eta[i]*max(Veps, V_bus));
  end for;

  P_unserved = max(0, abs(P_demand) - (if P_demand >= 0 then p_max_out_load else p_max_in_load));

  annotation (Documentation(info="Patched EMS_Unified:\n- setLoad.*를 등식이 아닌 connect로 연결\n- VIP systemBus 연결 보강\n- srcLimits.*Agg.u2 더미 연결로 미연결 해소\n- V_bus는 입력 v_bus_in으로 고정(루프 절단)"));
end EMS_Unified;
