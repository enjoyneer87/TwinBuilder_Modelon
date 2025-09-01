model EMS_Unified
  import SI = Modelica.Units.SI;

 extends .Electrification.Control.Interfaces.BaseController;
/**
 * EMS_Unified (Driving + Charging in one)
 * - 모드 입력 isCharging에 따라:
 *   Driving:   P_dem = DriveDerating(P_dem_raw, p_max_*, alpha_vbus)
 *   Charging:  P_dem = internal ChargingPowerScheduler(...)
 * - 공통: GenerousStack(방전/충전) + 동적 캡(min(pMax, η·V·iMax)) + Slew → P_cmd[i], i_ref[i]
 * - 부하에 SetComponentLimits(p_max_*)와 P_load_cmd(= 최종 요청 전력) 전달
 */
  // ===== Allocation 테이블 =====
  parameter .Electrification.Control.PowerAllocation.Records.AllocationRecord
    allocation[:] = {
      .Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=1,
        controllerType=.Electrification.Utilities.Types.ControllerType.Converter, // SC(DC/DC)
        generous=true, p_rat_out=0.7, p_rat_in=0.7,
        p_max_out=.Modelica.Constants.inf, p_max_in=.Modelica.Constants.inf, i_max_out=.Modelica.Constants.inf, i_max_in=.Modelica.Constants.inf),
      .Electrification.Control.PowerAllocation.Records.AllocationRecord(
        id=2,
        controllerType=.Electrification.Utilities.Types.ControllerType.Battery,  // Battery
        generous=true, p_rat_out=1.0, p_rat_in=1.0,
        p_max_out=.Modelica.Constants.inf, p_max_in=.Modelica.Constants.inf, i_max_out=.Modelica.Constants.inf, i_max_in=.Modelica.Constants.inf)
    };

  final parameter Integer N(min=1) = size(allocation,1) "Number of sources";

  // ===== 튜닝 =====
  parameter .Modelica.Units.SI.Time T_available  = 0.10 "Negative feedback filter in GenerousStack";
  parameter Boolean allocate_negative = true "Use negative usage as available power";
  parameter Real eta[N] = {0.985,0.97} "Per-source efficiency";

  parameter Real dP_rise[N] = {3e6, 1e6} "Max rising slope [W/s]";
  parameter Real dP_fall[N] = {3e6, 1e6} "Max falling slope [W/s]";

  parameter .Modelica.Units.SI.Time T_slew[N] = {0.03, 0.08} "Slew shaper time [s]";
  parameter .Modelica.Units.SI.Time T_alpha = 0.03 "alpha LPF time";
  parameter Real alpha_min = 0.0;
  parameter Boolean visualConnections = true "Enable visual connection annotations";

  // ===== 외부 입력 =====
  .Modelica.Blocks.Interfaces.RealInput P_dem  "Load request (+discharge/-charge) [W]"      
    annotation (Placement(transformation(extent={{-65.43,-125.96},{-45.43,-105.96}},rotation = 0.0,origin = {0.0,0.0})));
  // ===== 모드/입력 =====
  Modelica.Blocks.Interfaces.BooleanInput isCharging "true: 충전 모드 / false: 주행 모드"    
    annotation (Placement(transformation(extent={{-182.14,76.28},{-162.14,96.28}},rotation = 0.0,origin = {0.0,0.0})));
  // (Driving) 운전자/VCU 파워요청(+구동/-회생)
  Modelica.Blocks.Interfaces.RealInput  P_dem_raw "driver/VCU requested power [W]"     
    annotation (Placement(transformation(extent={{-181.39,9.69},{-161.39,29.69}},rotation = 0.0,origin = {0.0,0.0})));

  // (Charging) 스케줄러 상태 입력
  Modelica.Blocks.Interfaces.RealInput  SOC "0..1"     
    annotation (Placement(transformation(extent={{-180.41,28.04},{-160.41,48.04}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Interfaces.RealInput  T_max "K"      
    annotation (Placement(transformation(extent={{-181.53,-11.65},{-161.53,8.35}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Interfaces.RealInput  v_pack "V"     
    annotation (Placement(transformation(extent={{-182.78,-61.11},{-162.78,-41.11}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Interfaces.RealInput  v_sc "V"       
    annotation (Placement(transformation(extent={{-182.78,-79.69},{-162.78,-59.69}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Blocks.Interfaces.RealInput  v_bus_in "optional Vbus (if not using vipLoad.v)"            
    annotation (Placement(transformation(extent={{-182.53,-101.14},{-162.53,-81.14}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Interfaces.RealInput  P_charger_cap "charger HW limit [W] (pos) = capacity"        
    annotation (Placement(transformation(extent={{-180.19,51.19},{-160.19,71.19}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Interfaces.RealInput  iMaxIn_opt "optional current limit [A] (Inf if unused)"      
    annotation (Placement(transformation(extent={{-183.12,-37.16},{-163.12,-17.16}},rotation = 0.0,origin = {0.0,0.0})));

    
 // ===== 컨트롤 버스 (부하/소스) =====
 
  // ===== 부하 버스/한계/VIP =====
  .Electrification.Control.Signals.BusSelector busLoad(
    category=.Electrification.Utilities.Types.ControllerType.Machine, id=1)
    annotation (Placement(transformation(origin={0.0,0.0}, extent={{23.42,57.52},{11.42,69.52}},rotation = 0.0)));
  .Electrification.Control.Limits.GetComponentVIP vipLoad
    annotation (Placement(transformation(extent={{78.29,-98.78},{58.29,-78.78}},rotation = 0.0,origin = {0.0,0.0})));
  .Electrification.Control.Limits.SetComponentLimits setLoad(
    i_max_in=.Modelica.Constants.inf, i_max_out=.Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{65.11,-5.24},{97.11,26.76}},rotation = 0.0,origin = {0.0,0.0})));

  // ===== 소스 버스/한계/VIP =====
  .Electrification.Control.Signals.BusSelector busSrc[N](
    id=allocation.id, category=allocation.controllerType)
    annotation (Placement(transformation(origin={-20,80}, extent={{-6,-6},{6,6}})));
  .Electrification.Control.Limits.GetComponentLimits srcLimits[N](
    vMaxSignal=true, vMinSignal=true,
    iMaxInSignal=true, iMaxOutSignal=true,
    pMaxInSignal=true, pMaxOutSignal=true)
    annotation (Placement(transformation(extent={{-110.21,17.6},{-78.21,49.6}},rotation = 0.0,origin = {0.0,0.0})));  
  .Electrification.Control.Limits.GetComponentVIP vipSrc[N]
    annotation (Placement(transformation(extent={{-140.55,-54.33},{-108.55,-22.33}},rotation = 0.0,origin = {0.0,0.0})));

  // ===== GenerousStack (방전/충전) =====
  .Electrification.Control.PowerAllocation.Components.GenerousStack pOutAlloc(
    N=N,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_out,
    k_absolute=allocation.p_max_out,
    T_available=T_available,
    negative_available=allocate_negative)
    annotation (Placement(transformation(extent={{27.83,-8.41},{47.83,11.59}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Control.PowerAllocation.Components.GenerousStack pInAlloc(
    N=N,
    generous=allocation.generous,
    k_ratio=allocation.p_rat_in,
    k_absolute=allocation.p_max_in,
    T_available=T_available,
    negative_available=allocate_negative)
    annotation (Placement(transformation(extent={{-1.18,-70.02},{18.82,-50.02}},rotation = 0.0,origin = {0.0,0.0})));

  // ===== Summary =====
  replaceable input .Electrification.Control.PowerAllocation.Records.Summary summary(
    p_avail_out = pOutAlloc.pAvailableTotal.y,
    p_avail_in  = pInAlloc.pAvailableTotal.y,
    p_alloc_out = pOutAlloc.p_allocated,
    p_alloc_in  = pInAlloc.p_allocated,
    p_used_out  = -pInAlloc.sumNegative.y,
    p_used_in   = -pOutAlloc.sumNegative.y,
    p_in        = demandPassthrough.y,
    final N     = N)
    annotation (Dialog(tab="Records"), choicesAllMatching=true);

  // ===== 출력 =====
  .Modelica.Blocks.Interfaces.RealOutput P_cmd[N] "Per-source power cmd [W]"    annotation (Placement(transformation(extent={{123.74,71.96},{143.74,91.96}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.Blocks.Interfaces.RealOutput i_ref[N] "Per-source current ref [A]"  annotation (Placement(transformation(extent={{124.02,4.06},{144.02,24.06}},rotation = 0.0,origin= {0.0,0.0})));
  .Modelica.Blocks.Interfaces.RealOutput alpha_load "Load derate (0..1)"annotation (Placement(transformation(extent={{122.12,-32.2},{142.12,-12.2}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.Blocks.Interfaces.RealOutput p_max_out_load "Sum discharge cap [W]"annotation (Placement(transformation(extent={{122.69,-63.02},{142.69,-43.02}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.Blocks.Interfaces.RealOutput p_max_in_load  "Sum charge cap [W]"annotation (Placement(transformation(extent={{123.72,37.19},{143.72,57.19}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.Blocks.Interfaces.RealOutput P_unserved "Unserved demand [W]"annotation (Placement(transformation(extent={{123.67,-115.67},{143.67,-95.67}},rotation = 0.0,origin = {0.0,0.0})));
  Modelica.Blocks.Interfaces.RealOutput P_load_cmd "부하로 내려줄 최종 power ref [W]"annotation (Placement(transformation(extent={{122.63,-94.71},{142.63,-74.71}},rotation = 0.0,origin = {0.0,0.0})));

protected
      // 공통
  parameter .Modelica.Units.SI.Voltage Veps=1e-3;
  .Modelica.Units.SI.Voltage V_bus;
  // 편의
  Real sgn;
  .Modelica.Units.SI.Power P_dem_mag;
  // Slew 상태
  .Modelica.Units.SI.Power P_state[N](each start=0);
 
  // 동적 한계
  .Modelica.Units.SI.Power cap_out[N], cap_in[N], cap_sign[N];


 // === 내부 모드별 P_dem 생성 ===
  SI.Power P_dem_drive; // 주행 디레이팅 결과
  SI.Power P_dem_chg;   // 충전 스케줄러 결과(음수)
  SI.Power P_dem;       // 최종 채택
  
  // 분배 및 제한 관련 변수
  .Modelica.Units.SI.Power P_alloc[N];
  .Modelica.Units.SI.Power P_tgt[N];


   // alpha 및 버스전압 기반 가중
  .Modelica.Blocks.Continuous.FirstOrder alphaFilt(k=1, T=T_alpha)
    annotation (Placement(transformation(extent={{77.6,77.12},{97.6,97.12}},rotation = 0.0,origin = {0.0,0.0})));

      // (Charging scheduler) 파라미터
  parameter SI.Power   P_nom         = 120e3;
  parameter Real       soc_lo        = 0.10;
  parameter Real       soc_hi        = 0.80;
  parameter SI.Temperature T_nom     = 298.15;
  parameter Real       k_T           = 0.015;
  parameter SI.Voltage V_sc_nom      = 400.0;
  parameter Real       k_sc_p        = 800.0;
  parameter SI.Power   P_min_mag     = 5e3;
  parameter SI.Power   P_max_hw      = 300e3;
  parameter SI.Time    T_req         = 0.10;  // 시간
  parameter Real       ramp_up       = 1e6;
  parameter Real       ramp_dn       = 1e6;
    
    // 스케줄러 내부 중간
  Real k_soc, k_temp, k_sc, k_total;
  SI.Power P_mag_raw, P_from_i, P_mag_capped;
  SI.Power P_mag_shaped(start=0);
  SI.Power P_clamp;
  // (Driving derate) 버스전압 기반 축소
  parameter SI.Voltage V_bus_hi = 420;
  parameter SI.Voltage V_bus_lo = 320;
  Real alpha_v, alpha_tot;
  
  // RealExpression 블록(다이어그램 가시화용)
  .Modelica.Blocks.Sources.RealExpression demandPassthrough(y=P_dem)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  .Modelica.Blocks.Sources.RealExpression dischargeAvailable(y=max(P_dem, 0))
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  .Modelica.Blocks.Sources.RealExpression chargeAvailable(y=max(-P_dem, 0))
    annotation (Placement(transformation(extent={{-38.86,-0.57},{-18.86,19.43}},rotation = 0.0,origin = {0.0,0.0})));

equation
  // === 버스 연결
  connect(busLoad.systemBus, controlBus)
    annotation (Line(points={{11.42,63.52},{0,63.52},{0,100}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
  connect(setLoad.componentBus, busLoad.componentBus)
    annotation (Line(points={{97.11,10.76},{97.11,63.52},{23.42,63.52}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
  connect(vipLoad.componentBus, busLoad.componentBus)
    annotation (Line(points={{78.29,-88.78},{105.11,-88.78},{105.11,63.52},{23.42,63.52}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));

  for i in 1:N loop
    connect(busSrc[i].systemBus, controlBus)
      annotation (Line(points={{-14,80},{0,80},{0,100}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
    connect(srcLimits[i].componentBus, busSrc[i].componentBus)
      annotation (Line(points={{-68,36},{-50,36},{-50,80},{-26,80}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
    connect(vipSrc[i].componentBus, busSrc[i].componentBus)
      annotation (Line(points={{-84,-24},{-50,-24},{-50,80},{-26,80}}, color={240,170,40}, pattern=LinePattern.Dot, thickness=0.5));
  end for;


  // === 버스 전압 (소스 전압 기준)
  // 배터리-DC/DC컨버터-부하 시스템에서는 소스 전압 제약이 중요
  V_bus = max(Veps, min(vipSrc[i].v for i in 1:N));
  // === 버스 전압: 입력값 우선, 없으면 vipLoad.v 사용
//  V_bus = max(Veps, if v_bus_in > 0 then v_bus_in else vipLoad.v);

  // === p_available (RealExpression으로 명시 연결)
  connect(dischargeAvailable.y, pOutAlloc.p_available)
    annotation (Line(points={{-19,50},{15.56,50},{15.56,1.59},{25.83,1.59}}, color={0,0,127}));
  connect(chargeAvailable.y, pInAlloc.p_available)
    annotation (Line(points={{-17.86,9.43},{-17.86,-60.02},{-3.18,-60.02}}, color={0,0,127}));

  // === p_used: 부호 있는 실제 전력(음전력 가용화에 필요)
  if not visualConnections then
    // 일반적인 for 루프 (N 확장 가능)
    for i in 1:N loop
      connect(vipSrc[i].p, pOutAlloc.p_used[i]);
      connect(vipSrc[i].p, pInAlloc.p_used[i]);
    end for;
  else
    // 시각적 연결 (N=2 고정, annotation 포함)
    connect(vipSrc[1].p, pOutAlloc.p_used[1])
      annotation(Line(points={{-84,-16},{50,-16},{50,-45}}, color={0,0,127}));
    connect(vipSrc[1].p, pInAlloc.p_used[1])
      annotation(Line(points={{-84,-16},{-70,-16},{-70,-45}}, color={0,0,127}));
    connect(vipSrc[2].p, pOutAlloc.p_used[2])
      annotation(Line(points={{-84,-32},{50,-32},{50,-55}}, color={0,0,127}));
    connect(vipSrc[2].p, pInAlloc.p_used[2])
      annotation(Line(points={{-84,-32},{-70,-32},{-70,-55}}, color={0,0,127}));
  end if;



  // === 편의 변수
  sgn      = if P_dem >= 0 then 1.0 else -1.0;
  P_dem_mag = abs(P_dem);

  // === 소스별 동적 한계 (min(pMax, η·V·iMax))
  for i in 1:N loop
    cap_out[i] = min( max(0, srcLimits[i].p_max_out),
                      eta[i]*V_bus*max(0, srcLimits[i].i_max_out) );
    cap_in[i]  = min( max(0, srcLimits[i].p_max_in),
                      eta[i]*V_bus*max(0, srcLimits[i].i_max_in)  );
    cap_sign[i] = if sgn>=0 then cap_out[i] else cap_in[i];
  end for;

  // === 부하 허용합 + SetComponentLimits로 전달
  p_max_out_load = sum(cap_out[i] for i in 1:N);
  p_max_in_load  = sum(cap_in[i]  for i in 1:N);

  connect(setLoad.p_max_out, p_max_out_load);
  connect(setLoad.p_max_in,  p_max_in_load);


  // ----------------------------------------------------------------
  // (A) 주행 모드용 디레이팅: P_dem_drive
  // ----------------------------------------------------------------
  // 1) EMS 한계로 즉시 클램프
  P_clamp = if P_dem_raw >= 0 then min(P_dem_raw, p_max_out_load)
                                       else max(P_dem_raw, -p_max_in_load);

  // 2) 버스전압 기반 추가 축소(alpha_v)  alpha_v: 버스 전압 기반 전력 디레이팅 계수
  alpha_v =
    if (P_dem_raw < 0) and (V_bus > V_bus_hi) then max(0.0, 1.0 - (V_bus - V_bus_hi)/20)
    else if (P_dem_raw > 0) and (V_bus < V_bus_lo) then max(0.0, 1.0 - (V_bus_lo - V_bus)/20)
    else 1.0;

  // 3) alpha_tot = alpha_v * (EMS 내부 alpha_load 후보: 여기서는 clamp/요청의 비)
  //    주행모드에선 외부 스케줄러가 없으므로 alpha 필터는 아래 공통 α로만 사용
  alpha_tot = alpha_v;

  // 4) 간단 Slew는 상위에서(부하모델) 처리한다고 가정, 여기서는 즉시 반영
  P_dem_drive = alpha_tot * P_clamp;

  // ----------------------------------------------------------------
  // (B) 충전 모드용 내부 스케줄러: P_dem_chg (음수)
  // ----------------------------------------------------------------
  k_soc  = smooth(1, max(0.0, min(1.0, (soc_hi - SOC)/max(1e-6, soc_hi - soc_lo))));   //(SOC ���반 계수) 로직: SOC가 높을수록 충전 전력 감소 범위: 0.0 ~ 1.0
    //예시: SOC = 10% (soc_lo): k_soc = 1.0 → 최대 충전
    //SOC = 80% (soc_hi): k_soc = 0.0 → 충전 중단
    //SOC = 45%: k_soc = 0.5 → 절반 충��
  k_temp = max(0.0, 1.0 - k_T*max(0, T_max - T_nom));                                //(온도 기반 계수)
    //역할: 고온에서 충전 전력 감소 (열 보호)
    //파라미터:    //T_nom = 298.15K (25°C, 기준 온도)
    //k_T = 0.015 (온도 민감도)
    //범위: 0.0 ~ 1.0
    //예시:
    //T_max = 25°C: k_temp = 1.0 → 온도 제한 없음
    //T_max = 45°C: k_temp = 1.0 - 0.015×20 = 0.7 → 30% 감소
  k_sc   = max(0.0, 1.0 + k_sc_p*(V_sc_nom - v_sc)/max(1.0, P_nom));                 //(슈퍼캐패시터 전압 기반 계수)
    //역할: 슈퍼캐패시터 전압이 낮을 때 충전 우선도 증가
    //파라미터:
    //V_sc_nom = 400V (슈퍼캐패시터 정격 전압)
    //k_sc_p = 800 (전압 보상 계수)
    //P_nom = 120kW (정격 전력)
    //특징: v_sc < V_sc_nom일 때 k_sc > 1.0 가능
  k_total = max(0.0, min(1.25, k_soc*k_temp*k_sc));                                 // (통합 계수)
    //역할: 모든 계수의 곱으로 최종 스케일링
    //범위: 0.0 ~ 1.25 (슈퍼캐패시터 우선 충전 시 125% 가능)

   // 미분방정식 기반 1차필터
    //P_mag_shaped: 현재 출력 전력 (slew 적용된)
    //P_mag_capped: 목표 전력 (모든 제한 적용된)
    //der(P_mag_shaped): 전력 변화율 [W/s]
    // 조건부 기울기 제한
  der(P_mag_shaped) = noEvent(
    if (P_mag_capped - P_mag_shaped) >= 0 then
      min(ramp_up, (P_mag_capped - P_mag_shaped)/max(1e-6, T_req))   //  전력 증가 시 (P_mag_capped > P_mag_shaped):
    //PI 제어: (목표 - 현재)/시간상수로 기본 변화율 계산
    //제한 적용: ramp_up = 1MW/s로 최대 상승율 제한
    //예시: 목표가 100kW 높아도 1MW/s 이상으로는 올라가지 않음
    else
      max(-ramp_dn, (P_mag_capped - P_mag_shaped)/max(1e-6, T_req))
    //PI 제어: 음수 변화율로 감소
    //제한 적용: ramp_dn = 1MW/s로 최대 하강율 제한
    //예시: 급격한 전력 차단 요청에도 1MW/s 이상으로는 떨어지지 않음
  );
   P_dem_chg = -P_mag_shaped; // 음수(충전)

    // 시스템보호
    //급격한 전력 변화 방지: 배터리/컨버터 스트레스 최소화
    //전압 안정성: 버스 전압 급변동 방지
    // 제어 안전성
    //PI 제어: T_req = 0.1s로 적당한 반응 속도
    //포화 방지: 물리적 한계 내에서만 동작
    //부드러운 전환: 계단 입력을 경사로 변환
    //noEvent()의 역할:
    //이벤트 억제: 조건문 변화 시 시뮬레이터 재시작 방지
    //성능 향상: 연속적인 미분방정식으로 처리
    //수치 안정성: 불연속점에서의 진동 방지
  // ----------------------------------------------------------------
  // (C) 최종 P_dem 선택 & 분배·출력
  // ----------------------------------------------------------------

  P_dem = if isCharging then P_dem_chg 
          else P_dem_drive;


  // alpha_load (정보 제공용): 허용/요청 비 기반(절댓값)
  P_dem_mag = abs(P_dem);
  alphaFilt.u = min(1.0,
                    (if P_dem >= 0 then p_max_out_load else p_max_in_load)
                    / max(1e-6, P_dem_mag));
  alpha_load = alphaFilt.y;

  // 부하로 내려줄 최종 power ref
  P_load_cmd = P_dem;

  // GenerousStack p_available
  pOutAlloc.p_available = max(P_dem, 0);
  pInAlloc.p_available  = max(-P_dem, 0);

  // 소스별 분배 → 동적캡 → Slew → P_cmd, i_ref
  sgn = if P_dem >= 0 then 1.0 else -1.0;
  for i in 1:N loop
    cap_sign[i] = if sgn>=0 then cap_out[i] else cap_in[i];

    P_alloc[i] = if sgn>=0 then +pOutAlloc.p_allocated[i]
                                   else -pInAlloc.p_allocated[i];

    P_tgt[i] = min(cap_sign[i], max(-cap_sign[i], P_alloc));

    der(P_state[i]) = noEvent(
      if (P_tgt[i]  - P_state[i]) >= 0 then
        min(dP_rise[i], (P_tgt[i]  - P_state[i]) / max(1e-6, T_slew[i]))
      else
        max(-dP_fall[i], (P_tgt[i]  - P_state[i]) / max(1e-6, T_slew[i])) );

    P_cmd[i] = P_state[i];
    i_ref[i] = P_cmd[i] / (eta[i]*max(Veps, V_bus));
  end for;

  // 미서빙
  P_unserved = max(0, P_dem_mag - (if sgn>=0 then p_max_out_load else p_max_in_load));

  annotation (Documentation(info="
  <html>
    <p><b>EMS_Allocator_GStack</b> (refined):</p>
    <ul>
      <li>GenerousStack(방전/충전) + RealExpression p_available</li>
      <li>signed p_used, dynamic caps(min(pMax, η·V·iMax)), slew</li>
      <li>SetComponentLimits로 부하 허용치, alpha로 디레이트</li>
      <li>Summary 매핑 포함</li>
    </ul>
  </html>"));
end EMS_Unified;