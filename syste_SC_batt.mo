model System_SC_Batt_DCCharger_EMS_PowerMode "Photovoltaic array with maximum power point tracking"
  extends .Modelon.Icons.Experiment;
  // ===== 파라미터 =====
  parameter Integer N = 2 "1: SC(DC/DC), 2: Battery(direct)";
  parameter .Modelica.Units.SI.Time T_available = 0.1;
  parameter Real k_ratio_out[N] = {0.7, 1.0};
  parameter Real k_ratio_in[N]  = {0.7, 1.0};
  parameter Boolean generous[N] = {true, true};
  parameter Real eta[N]         = {0.985, 0.97};

  // 소스 한계(데모용 상수). 실제 적용 시 컨버터/팩 컨트롤러 값으로 대체
  parameter .Modelica.Units.SI.Power   pMaxOut_SC = 180e3, pMaxIn_SC = 180e3;
  parameter .Modelica.Units.SI.Current iMaxOut_SC = 250,   iMaxIn_SC = 250;
  parameter .Modelica.Units.SI.Power   pMaxOut_B  = 110e3, pMaxIn_B  = 100e3;
  parameter .Modelica.Units.SI.Current iMaxOut_B  = 150,   iMaxIn_B  = 120;

    
  // ---- Slew / rate limit on commanded power (W/s). Use Inf to disable. ----
  parameter Real dP_rise[n] = {.Modelica.Constants.inf, .Modelica.Constants.inf} "Max rising slope of P_cmd [W/s]";
  parameter Real dP_fall[n] = {.Modelica.Constants.inf, .Modelica.Constants.inf} "Max falling slope of P_cmd [W/s]";
  parameter .Modelica.Units.SI.Time T_slew[n] = {0.05, 0.10}
    "Approach time shaping for P_cmd tracking (sec). Set small with dP_* to get a pure rate limit.";

    
  // ===== 장치 =====
 
  .Electrification.Converters.Examples.AverageStepUpDown dcdc(
    enable_thermal_port=false,
    display_name=true,
    fixed_temperature=true,
    core(n=400 / 200, iL_start=410),
    redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_a(
      C=0.001,
      v_start=428.4,
      v_start_fixed=true),
    redeclare replaceable .Electrification.Converters.Electrical.Ideal electrical_b,
    redeclare replaceable .Electrification.Converters.Control.Voltage controller(
      external_v_a=true,
      mode=.Electrification.Utilities.Types.ConverterModeVoltage.VoltageA,
      voltageControllerA(xi_start=-26.5)))
    annotation (Placement(transformation(extent={{46.19,122.91},{78.19,154.91}},rotation = 0.0,origin = {0.0,0.0})));

    // Sources
    .HESS.paper_SCapPack paper_SCapPack(np = 6)
    annotation(Placement(transformation(extent = {{103.24,129.01},{123.24,149.01}},origin = {0.0,0.0},rotation = 0.0)));
    
    .HESS.KETI_BatteryPack kETI_BatteryPack(
    SOC_start = 0.9,display_name = true,enable_thermal_port = false,
    redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(
    redeclare replaceable .Electrification.Batteries.Control.CellSensors controller1,
    redeclare replaceable .Electrification.Batteries.Control.LimitsFixed controller2))
    annotation(Placement(transformation(extent = {{78.95,201.75},{98.95,221.75}},origin = {0.0,0.0},rotation = 0.0)));    


    .Electrification.Electrical.DCInit vInit(
    init_start = true,
    v_start = kETI_BatteryPack.summary.ocv) 
    annotation(Placement(transformation(extent = {{42.83,229.42},{62.83,249.42}},origin = {0,0},rotation = 0)));
    
    .Electrification.Converters.Control.Signals.v_a_ref v_a_ref(
        id=dcdc.id) 
    annotation (Placement(transformation(extent={{6,22},{14,30}})));
    
    .Electrification.Loads.Examples.Power load(
        enable_thermal_port = false,
        display_name = true,
        fixed_temperature = true,
        redeclare .Electrification.Loads.Control.PowerMode controller(
        powerTable = {-7000,15000},external_mode = true,vMax = 380)) 
    annotation(Placement(transformation(extent = {{-128.6,121.38},{-168.6,161.38}},rotation = 0.0,origin = {0.0,0.0})));
    
//    .Electrification.Loads.Control.Signals.mode_ref mode_ref(id = load.id) annotation(Placement(transformation(extent = {{-180.39,237.43},{-172.39,245.43}},rotation = 0.0,origin = {0.0,0.0})));
//    replaceable .Modelica.Blocks.Sources.IntegerTable mode(table = [0,0;100,2;400,1]) constrainedby .Modelica.Blocks.Interfaces.IntegerSO annotation(Placement(transformation(extent = {{-221.98,232.04},{-201.98,252.04}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.Constant vAconst(k = 370) annotation(Placement(transformation(extent = {{-25.95,47.85},{-5.95,67.85}},origin = {0.0,0.0},rotation = 0.0)));
    
    .Electrification.Electrical.DCSplitter splitterHVDC annotation(Placement(transformation(extent = {{25.42,132.16},{11.98,145.6}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCSplitter splitterHVDC2 annotation(Placement(transformation(extent = {{35.32,208.32},{27.74,215.9}},rotation = 0.0,origin = {0.0,0.0})));
    .Electrification.Electrical.DCSplitter splitterHVDC3 annotation(Placement(transformation(extent = {{-100.25,182.65},{-91.11,191.79}},rotation = 0.0,origin = {0.0,0.0})));

    .Electrification.Electrical.DCSensor dCSensor2 annotation(Placement(transformation(extent = {{43.63,216.02},{51.31,208.34}},rotation = 0.0,origin = {0.0,0.0})));

    
    .Modelica.Blocks.Sources.BooleanTable booleanTable(table = {0,200,390,450}) annotation(Placement(transformation(extent = {{-79.67,274.96},{-59.67,294.96}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Electrical.Analog.Basic.Ground ground2 annotation(Placement(transformation(extent = {{-10.0,-10.0},{10.0,10.0}},origin = {11.469999999999999,111.05},rotation = 90.0)));

    .Modelica.Electrical.Analog.Ideal.IdealClosingSwitch swBatt annotation(Placement(transformation(extent = {{-31.98,208.66},{-11.98,228.66}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Electrical.Analog.Ideal.IdealClosingSwitch swBus annotation(Placement(transformation(extent = {{-29.53,141.58},{-9.53,161.58}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.Not not1 annotation(Placement(transformation(extent = {{14.26,275.09},{34.26,295.09}},origin = {0.0,0.0},rotation = 0.0)));
    
    

      // ===== DC Fast Charger (부하 측 구성) =====
      // Power load를 "음전력(충전)"으로 구동: 외부에서 P_ref(음수) 입력
      .Electrification.Loads.Examples.Power dcCharger(
        enable_thermal_port=false, display_name=true, fixed_temperature=true,
        redeclare .Electrification.Loads.Control.PowerMode controller(
          external_mode=true, vMax=380))
        annotation(Placement(transformation(extent={{-178.26,176.28},{-218.26,216.28}},rotation = 0.0,origin = {0.0,0.0})));

      // 모드/파워 참조 신호 (모드=Power 모드 상수, 파워는 외부 계산치)
      .Electrification.Loads.Control.Signals.mode_ref mode_ref(id=dcCharger.id);
      .Modelica.Blocks.Sources.IntegerConstant modePower(k=2); // 가정: 2=Power mode
      //Electrification.Loads.Control.Signals.power_ref p_ref(id=dcCharger.id);

      // 충전 요청 파형(음수: 버스로 전력 주입→배터리 충전)
      // 예: 0~1s: 0 kW, 1~6s: 60 kW, 6~10s: 90 kW
      .Modelica.Blocks.Sources.CombiTimeTable P_req_chg(table=[0,0; 1,-60e3; 6,-90e3; 10,-90e3], columns={2});

      // ===== EMS =====
      //YourPackage.LocalEMS_SC_Batt_Full ems(
      //  N=2, eta=eta, k_ratio_out=k_ratio_out, k_ratio_in=k_ratio_in,
      //  generous=generous, T_available=T_available,
      //  dP_rise={3e6,1e6}, dP_fall={3e6,1e6}, T_slew={0.03,0.08}, T_alpha=0.03);

      // 피드백/한계 연결을 위한 보조 블록
      .Modelica.Blocks.Math.Product v_i_batt;  // (필요시) 배터리 전력 계산용
      .Modelica.Blocks.Math.Abs abs1, abs2;
      .Modelica.Blocks.Sources.Constant pMaxOutVec1(k=pMaxOut_SC), pMaxOutVec2(k=pMaxOut_B);
      .Modelica.Blocks.Sources.Constant pMaxInVec1(k=pMaxIn_SC),  pMaxInVec2(k=pMaxIn_B);
      .Modelica.Blocks.Sources.Constant iMaxOutVec1(k=iMaxOut_SC), iMaxOutVec2(k=iMaxOut_B);
      .Modelica.Blocks.Sources.Constant iMaxInVec1(k=iMaxIn_SC),  iMaxInVec2(k=iMaxIn_B);

      // 버스 전압 측정 (여기서는 dcdc 요측 전압으로 사용)
      .Modelica.Blocks.Sources.RealExpression VbusExpr(y=dcdc.summary.v_b);

      // EMS→부하: 디레이트 적용된 충전 파워 참조
      .Modelica.Blocks.Math.Gain alphaGain(k=1.0);
      .Modelica.Blocks.Math.Product P_dem_prod; // alpha * P_req_chg (음수 유지)
      .Modelica.Blocks.Nonlinear.Limiter P_dem_limit(uMin=-1e9, uMax=+1e9);
    
equation
  connect(v_a_ref.systemBus, dcdc.controlBus) annotation (Line(
      points={{14,26},{49.39,26},{49.39,154.91}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
    connect(mode_ref.systemBus,load.controlBus) annotation(Line(points = {{-172.38,241.43},{-132.6,241.43},{-132.6,161.38}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(mode.y,mode_ref.u_i) annotation(Line(points = {{-200.98,242.04},{-182.38,242.04},{-182.38,241.43}},color = {255,127,0}));
    connect(const.y,v_a_ref.u_r) annotation(Line(points = {{-4.95,57.85},{4,57.85},{4,26}},color = {0,0,127}));
    connect(dCSensor2.plug_a,splitterHVDC2.plug_a) annotation(Line(points = {{43.63,212.18},{35.32,212.18},{35.32,212.11}},color = {255,128,0}));
    connect(kETI_BatteryPack.plug_a,dCSensor2.plug_b) annotation(Line(points = {{78.95,211.75},{78.95,212.18},{51.31,212.18}},color = {255,128,0}));
    connect(splitterHVDC3.n,splitterHVDC.n) annotation(Line(points = {{-91.11,182.65},{-91.11,126.16},{11.98,126.16},{11.98,132.16}},color = {0,0,255}));
    connect(ground2.p,splitterHVDC.n) annotation(Line(points = {{1.47,111.05},{-4.53,111.05},{-4.53,126.16},{11.98,126.16},{11.98,132.16}},color = {0,0,255}));
    connect(splitterHVDC.plug_a,dcdc.plug_a) annotation(Line(points = {{25.42,138.88},{35.84,138.88},{35.84,138.91},{46.19,138.91}},color = {255,128,0}));
    connect(load.plug_a,splitterHVDC3.plug_a) annotation(Line(points = {{-128.6,141.38},{-110.79,141.38},{-110.79,187.22},{-100.25,187.22}},color = {255,128,0}));
    connect(splitterHVDC2.n,ground2.p) annotation(Line(points = {{27.74,208.32},{27.74,120.18},{1.47,120.18},{1.47,111.05}},color = {0,0,255}));
    connect(vInit.plug_a,kETI_BatteryPack.plug_a) annotation(Line(points = {{62.83,239.42},{70.29,239.42},{70.29,211.75},{78.95,211.75}},color = {255,128,0}));
    connect(dcdc.plug_b,paper_SCapPack.plug_a) annotation(Line(points = {{78.19,138.91},{78.19,139.01},{103.24,139.01}},color = {255,128,0}));
    connect(booleanTable.y,not1.u) annotation(Line(points = {{-58.67,284.96},{-30.57,284.96},{-30.57,285.09},{12.26,285.09}},color = {255,0,255}));
    connect(splitterHVDC3.p,swBatt.p) annotation(Line(points = {{-91.11,191.79},{-91.11,218.66},{-31.98,218.66}},color = {0,0,255}));
    connect(swBatt.n,splitterHVDC2.p) annotation(Line(points = {{-11.98,218.66},{27.74,218.66},{27.74,215.9}},color = {0,0,255}));
    connect(not1.y,swBatt.control) annotation(Line(points = {{35.26,285.09},{35.26,234.66},{-21.98,234.66},{-21.98,230.66}},color = {255,0,255}));
    connect(swBus.p,splitterHVDC3.p) annotation(Line(points = {{-29.53,151.58},{-43.91,151.58},{-43.91,218.77},{-91.11,218.77},{-91.11,191.79}},color = {0,0,255}));
    connect(swBus.n,splitterHVDC.p) annotation(Line(points = {{-9.53,151.58},{11.98,151.58},{11.98,145.6}},color = {0,0,255}));
    connect(booleanTable.y,swBus.control) annotation(Line(points = {{-58.67,284.96},{-19.53,284.96},{-19.53,163.58}},color = {255,0,255}));

  annotation (
    experiment(StopTime=10,Interval=0.01),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This is an example where a PV (photo-voltaic) array provides power to a battery via a DC/DC converter, using an ideal MPPT control scheme.</p>

<h4>PV array model</h4>
<p>The PV array is an instance of the <a href=\"modelica://Electrification.Loads.Examples.PhotoVoltaic\">PhotoVoltaic</a> load model. The number of solar cells have been configured for the array. Inputs have been enabled for dynamically specifying the boundary conditions for solar irradiance and temperature. The <em>ambient</em> temperature is provided via the <a href=\"modelica://Electrification.Information.UsersGuide.BasicConcepts.Thermal\">thermal interface</a> of the model.</p>

<h4>MPPT control using DC/DC converter</h4>
<p>A <a href=\"modelica://Electrification.Converters\">DC/DC converter</a> is used for controlling (the otherwise un-regulated) output from the PV array. 
This is configured to realize an ideal MPPT (Maximum Power Point Tracker) scheme, to achieve the maximum possible power output for the specific boundary conditions.</p>
<p>The PV array model calculates the maximum power point and provides the corresponding reference voltage. The DC/DC converter has been configured to control the PV array voltage according to this reference.</p>
<p>Note that this ideal reference voltage would not be directly measurable in an actual system, 
but it could represent an estimated output from a practical observer implementation. 
And an ideal simulation could serve as an ideal theoretical reference.</p>

<h4>Initialization</h4>
<p>Initial values have been specified for the following variables of the DC/DC converter, to start the simulation at steady operation without excessive initial transients:
<ul>
<li><code>dcdc.core.iL_start</code> : Current through the converter inductor</li>
<li><code>dcdc.electrical_a.v_start</code> : Voltage of the capacitor at the array side of the converter</li>
<li><code>dcdc.controller.voltageControllerA.xi_start</code> : Integrator state of the voltage controller</li>
</ul></p>

<h4>Results</h4>
<p>In the plots below, we can see that the power and voltage varies with the changes in temperature. 
The DC/DC converter follows the voltage set-point. 
And the power from the array to the battery roughly matches the theoretical maximum power.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/PhotoVoltaicMPPT.png\"/></p>
<p>Some of the relevant result variables are:
<ul>
<li><code>v_a_ref.value</code></li>
<li><code>pvArray.summary.v</code></li>
<li><code>pvArray.core.p_out_max</code></li>
<li><code>pvArray.summary.p_out</code></li>
<li><code>pvArray.summary.p_loss</code></li>
<li><code>pvArray.summary.T</code></li>
<li><code>pvArray.S_in</code></li>
<li><code>dcdc.summary.v_a</code></li>
<li><code>dcdc.summary.v_b</code></li>
<li><code>dcdc.summary.p_in_a</code></li>
<li><code>dcdc.summary.p_out_b</code></li>
<li><code>battery.summary.p_ch</code></li>
<li><code>battery.summary.v</code></li>
</ul>
</p>
</html>"));
    
end System_SC_Batt_DCCharger_EMS_PowerMode;
