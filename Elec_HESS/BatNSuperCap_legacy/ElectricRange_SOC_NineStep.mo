within BatNSuperCap_legacy;
model ElectricRange_SOC_NineStep "Range of SCap electric vehicle for a specific drive cycle"
  extends .Modelon.Icons.Experiment;

  .Electrification.Electrical.DCInit vInitA(
    init_steady=false, stateSelect=StateSelect.default,
    init_start=true, v_start=200, common_mode=false)
    annotation(Placement(transformation(extent={{-155.54,-64.8},{-135.54,-44.8}},rotation = 0.0,origin = {0.0,0.0})));

  inner .Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation(Placement(transformation(extent={{85.89,309.2},{105.89,329.2}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.StateGraph.InitialStep initialStep(nOut=1,nIn=0)
    annotation(Placement(transformation(extent={{-297.29,311.65},{-277.29,331.65}})));

  .Modelica.StateGraph.Transition transition
    annotation(Placement(transformation(extent={{-276.29,311.65},{-256.29,331.65}})));

  .Modelica.StateGraph.StepWithSignal Bat(nIn=1,nOut=1)
    annotation(Placement(transformation(extent={{-26.25,271.87},{-6.25,291.87}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.StateGraph.TransitionWithSignal HighCurrent(waitTime=5, enableTimer=true)
    annotation(Placement(transformation(extent={{66.39,345.49},{46.39,365.49}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Abs absI(generateEvent=true)
    annotation(Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}}, rotation=90.0, origin={-36.87,120.00999999999999})));

  .Modelica.Blocks.Math.Gain convCrate(k=1/(batty.i_nom_1C))
    annotation(Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}}, rotation=90.0, origin={-36.97,159.84})));

  .Electrification.Batteries.Control.Signals.close_contactors close_contactors(id=batty.id)
    annotation(Placement(transformation(extent={{-8.25,-8.25},{8.25,8.25}}, rotation=-90.0, origin={-92.98,77.38})));

  .Electrification.Electrical.DCInit vInitA2(common_mode=false, v_start=400, init_start=true, stateSelect=StateSelect.avoid, init_steady=false)
    annotation(Placement(transformation(extent={{-129.55,-160.57},{-109.55,-140.57}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Converters.Control.Signals.mode_ref mode_ref(id=averageStepUpDownDCDC.id)
    annotation(Placement(transformation(extent={{-128.75,74.25},{-120.75,82.25}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.BooleanToInteger booleanToInteger(
    integerFalse=Integer(.Electrification.Utilities.Types.ConverterMode.CurrentB),
    integerTrue =Integer(.Electrification.Utilities.Types.ConverterMode.PowerB))
    annotation(Placement(transformation(extent={{-176.1,68.21},{-156.1,88.21}})));

  .Modelica.Blocks.Logical.And and1
    annotation(Placement(transformation(extent={{-10,-10},{10,10}}, origin={-200.5,97.41}, rotation=-90)));

  .Modelica.Blocks.Math.BooleanToReal OnSC(realFalse=SCap.i_nom_1C, realTrue=0)
    annotation(Placement(transformation(extent={{-213.75,28.86},{-193.75,48.86}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Batteries.Examples.Applications.ElectricCar batty(
    np=24, ns=100,
    limitActionI=.Modelon.Types.FaultAction.Terminate,
    limitActionV=.Modelon.Types.FaultAction.Terminate,
    limitActionSoC=.Modelon.Types.FaultAction.Error,
    SoC_min=0.1, SoC_max=1.0, SOC_start=0.6,
    fixed_temperature=true, display_name=true,
    enable_control_bus=true, enable_thermal_port=false,
    redeclare replaceable .Electrification.Batteries.Control.TwoSubControllers controller(
      redeclare replaceable .Electrification.Batteries.Control.LimitsAndContactors controller1(
        limits(iMaxOut=batty.i_nom_1C*0.5, enable_thermal=false, iMaxIn=batty.i_nom_1C*0.5),
        contactors(external_control=true, contactors_closed=false, maxVoltageDiff=10, preChargeOverlap=0.1, enable_core=true),
        enable_thermal=false),
      redeclare replaceable .Electrification.Batteries.Control.CellSensors controller2(enable_thermal=false)
    ),
    redeclare replaceable .Electrification.Batteries.Electrical.Pack.Contactors electrical(preChargeResistance=0.1),
    initialize_with_OCV=false,
    core(capacityNom=3.6, iCellMaxDch=1000, iCellMaxCh=1000),
    common_mode=false)
    annotation(Placement(transformation(extent={{-114.21,-117.18},{-146.21,-85.18}})));

  // NOTE: outPort가 필요하므로 nOut=2로 변경
  .Modelica.StateGraph.StepWithSignal SCon(nOut=3, nIn=2)
    annotation(Placement(transformation(extent={{-248.94,311.64},{-228.94,331.64}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.StateGraph.TransitionWithSignal lowCurrentSCap(enableTimer=false)
    annotation(Placement(transformation(extent={{-215.38,262.47},{-195.38,282.47}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Gain convCrate3(k=1/(batty.i_nom_1C))
    annotation(Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}}, rotation=90.0, origin={-396.59,223.87})));

  .Modelica.Blocks.Math.Abs absI2(generateEvent=true)
    annotation(Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}}, rotation=90.0, origin={-396.25,180.69})));

  .BatNSuperCap_0804.SCCap SCap(
    id=2, SoC_min=0,
    redeclare replaceable .Electrification.Batteries.Core.Examples.NCA.TabularTransient core(
      vCellMin=0, vCellMax=1000,
      redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic1stTabular impedance(
        interpolation_degree=3,
        interpolation_method=.Modelon.Blocks.Interpolation.Types.Method.Polynomial,
        C1_table=[0.2,6.830667e+03;0.3,5.654858e+03;0.4,7.071634e+03;0.5,1.620276e+04;0.6,1.085817e+04;0.7,1.452638e+04;0.8,2.401400e+04;0.9,1.250130e+04;1.0,4.580168e+03],
        R1_table=[0.2,3.728732e-03;0.3,4.537486e-03;0.4,2.206103e-03;0.5,1.545534e-03;0.6,1.749724e-03;0.7,1.753031e-03;0.8,1.678829e-03;0.9,3.100650e-03;1.0,6.274575e-03],
        R0_table=[0.2,0.3170192;0.3,0.3102788;0.4,0.3128846;0.5,0.2990385;0.6,0.2941587;0.7,0.2926683;0.8,0.2949038;0.9,0.2922837;1.0,0.3994471]),
      redeclare replaceable .Electrification.Batteries.Core.OCV.Table voltage(
        interpolation_degree=3,
        interpolation_method=.Modelon.Blocks.Interpolation.Types.Method.Polynomial,
        ref_SoC_0=0,
        cellOCV_table=[0.2,0.788471;0.3,1.078110;0.4,1.355740;0.5,1.620590;0.6,1.876870;0.7,2.127530;0.8,2.376170;0.9,2.630110;1.0,2.908830],
        limitStart=2),
      capacity(Q_cap_cell_nom=6635)
    ),
    ns=86, SoC_max=0.95,
    limitActionV=.Modelon.Types.FaultAction.Terminate,
    limitActionSoC=.Modelon.Types.FaultAction.Terminate,
    display_name=true,
    controller(controller2(enable_thermal=false), redeclare replaceable .Electrification.Batteries.Control.LimitsTabular controller1),
    redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIdeal electrical,
    initialize_with_OCV=false,
    common_mode=false,
    limitActionI=.Modelon.Types.FaultAction.Terminate)
    annotation(Placement(transformation(extent={{-240.91,-53.12},{-260.91,-33.12}})));

  .Electrification.Converters.Control.Signals.i_b_ref i_b_ref(id=averageStepUpDownDCDC.id)
    annotation(Placement(transformation(extent={{-149.41,24.56},{-141.41,32.56}})));

  .Electrification.Electrical.DCSensor dCSensor(common_mode=false)
    annotation(Placement(transformation(extent={{-199.85,-53.02},{-219.85,-33.02}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Logical.Hysteresis hysteresis(uHigh=0.5, uLow=0.45, pre_y_start=false)
    annotation(Placement(transformation(extent={{-389.55,240.15},{-369.55,260.15}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Logical.Not not1
    annotation(Placement(transformation(extent={{-310.96,240.84},{-290.96,260.84}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Machines.Control.Signals.pwr_sns pwr_sns(id=machine.id)
    annotation(Placement(transformation(extent={{-198.28,-19.16},{-190.28,-11.16}})));

  .Electrification.Electrical.DCSensor dCSensor2
    annotation(Placement(transformation(extent={{-61.36,-61.68},{-41.36,-41.68}})));

  .BatNSuperCap_legacy.AverageStepUpDownDCDC averageStepUpDownDCDC(
    enable_thermal_port=false,
    controller(
      external_mode=true,
      mode=.Electrification.Utilities.Types.ConverterMode.CurrentA,
      external_limits=true, listen=true, id_listen=SCap.id, typeListen=.Electrification.Utilities.Types.ControllerType.Battery,
      external_i_b=false, iMaxInB=1000,
      external_i_a=false, pMaxInA=SCap.controller.controller1.pMaxIn*100, pMaxInB=1e16,
      external_pwr_b=true, external_pwr_a(fixed=false)=false,
      i_b_ref=-SCap.i_nom_1C,
      v_a_ref=0, external_v_a=false,
      iMaxInA=SCap.controller.controller1.iMaxIn*100, i_a_ref=SCap.controller.controller1.iMaxIn,
      pwr_a_ref=0, k_v=10, aggregate_limits=false),
    common_mode=false, internal_ground=false,
    redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_b,
    redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_a(v_start=0, v_start_fixed=false),
    redeclare replaceable .Electrification.Converters.Core.AverageStepUpDown core)
    annotation(Placement(transformation(extent={{-122.09,-8.47},{-102.09,11.53}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Converters.Control.Signals.pwr_a_ref pwr_a_ref(id=averageStepUpDownDCDC.id)
    annotation(Placement(transformation(extent={{-208.9,2.96},{-200.9,10.96}})));

  .Electrification.Batteries.Control.Signals.SoC_cell soc(id=batty.id)
    annotation(Placement(transformation(extent={{-319.99,-4.3},{-311.99,3.7}},rotation = 0.0,origin = {0.0,0.0})));

  // 모니터링용 피드백(제어는 socPI가 담당)
  .Modelica.Blocks.Math.Feedback feedback
    annotation(Placement(transformation(extent={{-447.43,87.19},{-427.43,67.19}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Sources.Constant targetSOC(k=0.8)
    annotation(Placement(transformation(extent={{-505.57,26.85},{-485.57,46.85}})));

  .Modelica.Blocks.Nonlinear.Limiter limiter(
    uMin=-machine.core.limits.P_max_mot, uMax=machine.core.limits.P_max_mot, strict=true)
    annotation(Placement(transformation(extent={{-395.4,20.83},{-375.4,40.83}},rotation = 0.0,origin = {0.0,0.0})));

  // === 외부 SOC 루프: PI 컨트롤러 + Feed-forward 합산 ===
  .Modelica.Blocks.Continuous.LimPID socPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1e4, Ti=10,
    yMax= machine.core.limits.P_max_mot,
    yMin=-machine.core.limits.P_max_mot)
    annotation(Placement(transformation(extent={{-463.59,26.81},{-443.59,46.81}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Add addPI
    annotation(Placement(transformation(extent={{-405.45,57.99},{-385.45,77.99}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Continuous.Filter filter(f_cut=0.05)
    annotation(Placement(transformation(extent={{-363.24,20.69},{-343.24,40.69}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Machines.Examples.Machine machine(
    redeclare replaceable .Electrification.Machines.Control.MultiMode controller(external_torque=true),
    redeclare replaceable .Electrification.Machines.Mechanical.Gearbox mechanical(d_viscous=0, ratio=10),
    core(redeclare replaceable .Electrification.Machines.Core.Limits.Scalar limits(tau_max_mot=1000),
         redeclare .Electrification.Machines.Core.Losses.Efficiency lossesMachine,
         redeclare .Electrification.Machines.Core.Losses.Efficiency lossesConverter),
    display_name=true, fixed_temperature=true, enable_thermal_port=false,
    electrical(v_start=400))
    annotation(Placement(transformation(extent={{57.86,-133.21},{89.86,-101.21}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Mechanical.SimpleChassis1D chassis(m=2000)
    annotation(Placement(transformation(extent={{98.86,-132.89},{130.86,-100.89}},rotation = 0.0,origin = {0.0,0.0})));

  .Electrification.Machines.Control.Signals.tau_ref torqueReference(id=machine.id)
    annotation(Placement(transformation(extent={{-4,4},{4,-4}}, rotation=180, origin={76.89,-67.14})));

  .Electrification.Utilities.Blocks.Driver driver(
    tauMax=machine.core.limits.tau_max_mot, repeat=true,
    redeclare .Electrification.Utilities.DriveCycles.WLTP driveCycle)
    annotation(Placement(transformation(extent={{126.89,-79.14},{102.89,-55.14}})));

  .Electrification.Converters.Control.Signals.pwr_b_ref pwr_b_ref(id=averageStepUpDownDCDC.id)
    annotation(Placement(transformation(extent={{-209.75,-7.89},{-201.75,0.11}})));

  .Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=0.9)
    annotation(Placement(transformation(extent={{16.27,207.49},{36.27,227.49}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.1)
    annotation(Placement(transformation(extent={{18.29,175.14},{38.29,195.14}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Logical.Or or1
    annotation(Placement(transformation(extent={{-10,-10},{10,10}}, origin={119.02,206.29}, rotation=90)));

  .Modelica.Blocks.Logical.And and2
    annotation(Placement(transformation(extent={{10.0,-10.0},{-10.0,10.0}}, origin={132.31,265.04}, rotation=-90.0)));

  .Modelica.Blocks.Logical.Hysteresis hysteresis2(uLow=0.35,uHigh=0.5,pre_y_start=false)
    annotation(Placement(transformation(extent={{-10.0,10.0},{10.0,-10.0}}, rotation=90.0, origin={100.31,160.03})));

  .Modelica.Blocks.Logical.And and3
    annotation(Placement(transformation(extent={{10,-10},{-10,10}}, origin={75.24,226.43}, rotation=-90)));

  .Electrification.Batteries.Control.Signals.SoC_cell soC_cell(id=batty.id)
    annotation(Placement(transformation(extent={{-4.0,-4.0},{4.0,4.0}}, origin={100.61,61.5}, rotation=-90.0)));

  .Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold=0.9)
    annotation(Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}}, origin={100.27,101.17}, rotation=90.0)));

  .Electrification.Batteries.Control.Signals.SoC_cell soc_sc(id=SCap.id)
    annotation(Placement(transformation(extent={{4.49,117.33},{-3.51,125.33}},rotation = 0.0,origin = {0.0,0.0})));

  .BatNSuperCap_legacy.AverageStepUpDownDCDC DCDC_Bat(
    redeclare replaceable .Electrification.Converters.Core.AverageStepUpDown core,
    redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_a(v_start_fixed=false, v_start=0),
    redeclare replaceable .Electrification.Converters.Electrical.Capacitor electrical_b,
    internal_ground=false, common_mode=false,
    controller(
      external_mode=false, mode=Electrification.Utilities.Types.ConverterMode.VoltageA,
      external_limits=false, listen=true, id_listen=SCap.id, typeListen=.Electrification.Utilities.Types.ControllerType.Battery,
      external_i_b=false, iMaxInB=1000,
      external_i_a=false, pMaxInA=SCap.controller.controller1.pMaxIn*100, pMaxInB=1e16,
      external_pwr_b=false, external_pwr_a(fixed=false)=false,
      i_b_ref=-SCap.i_nom_1C, v_a_ref=400, external_v_a=false,
      iMaxInA=batty.i_nom_1C*0.5, i_a_ref=SCap.controller.controller1.iMaxIn,
      pwr_a_ref=0, k_v=10, aggregate_limits=false),
    enable_thermal_port=false)
    annotation(Placement(transformation(extent={{-93.47,-111.26},{-73.47,-91.26}})));

  .Electrification.Electrical.DCInit vInitA3(init_steady=false, stateSelect=StateSelect.avoid, init_start=true, v_start=machine.electrical.v_start, common_mode=false)
    annotation(Placement(transformation(extent={{-9.18,-148.36},{10.82,-128.36}})));

  .Modelica.Blocks.Math.Add add2(k2=-1)
    annotation(Placement(transformation(extent={{-341.02,134.83},{-321.02,154.83}})));

  .Modelica.Blocks.Sources.Constant const(k=200)
    annotation(Placement(transformation(extent={{-379.65,134.25},{-359.65,154.25}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Math.Abs absI_del_voltage(generateEvent=true)
    annotation(Placement(transformation(extent={{-306.0,134.9},{-286.0,154.9}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.Blocks.Logical.Hysteresis hysteresis_voltage(pre_y_start=false, uLow=5, uHigh=10)
    annotation(Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}},rotation = 90.0,origin = {-71.03,228.14})));

  .Modelica.StateGraph.TransitionWithSignal transitionWithSignal
    annotation(Placement(transformation(extent={{-126.07,223.62},{-106.07,243.62}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.StateGraph.StepWithSignal PowerMode(nIn=2, nOut=2)
    annotation(Placement(transformation(extent={{-178.76,360.39},{-158.76,340.39}},rotation = 0.0,origin = {0.0,0.0})));

  .Modelica.StateGraph.StepWithSignal VoltHold(nOut=2, nIn=3)
    annotation(Placement(transformation(extent={{-178.71,294.6},{-158.71,314.6}},rotation = 0.0,origin = {0.0,0.0})));

  // --- 6-step 상태머신 보조 선언 ---
  .Modelica.Blocks.Logical.LessThreshold sc_low(threshold=0.35)
    annotation(Placement(transformation(extent={{128.57,147.77},{148.57,167.77}}, origin={0.0,0.0},rotation = 0.0)));
  .Modelica.Blocks.Logical.GreaterThreshold sc_ok(threshold=0.5)
    annotation(Placement(transformation(extent={{131.52,108.24},{151.52,128.24}}, origin={0.0,0.0},rotation = 0.0)));

  .Modelica.StateGraph.TransitionWithSignal t_SCon_to_Volt
    annotation(Placement(transformation(extent={{-215.75,294.64},{-195.75,314.64}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.TransitionWithSignal t_SCon_to_Power
    annotation(Placement(transformation(extent={{-214.66,360.26},{-194.66,340.26}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.TransitionWithSignal t_Volt_to_Power
    annotation(Placement(transformation(extent={{-144.62,294.75},{-124.62,314.75}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.TransitionWithSignal t_Power_to_Volt
    annotation(Placement(transformation(extent={{-145.74,340.61},{-125.74,360.61}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.StepWithSignal Recharge(nIn=1, nOut=1)
    annotation(Placement(transformation(extent={{-71.87,313.51},{-51.87,333.51}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.TransitionWithSignal t_to_Recharge
    annotation(Placement(transformation(extent={{-102.69,313.31},{-82.69,333.31}},rotation = 0.0,origin = {0.0,0.0})));
  .Modelica.StateGraph.TransitionWithSignal t_Recharge_to_Volt
    annotation(Placement(transformation(extent={{-81.73,277.62},{-101.73,297.62}},rotation = 0.0,origin = {0.0,0.0})));

  // PowerMode에서만 슈퍼캡 전류참조 사용
  .Modelica.Blocks.Logical.Switch sw_iBref
    annotation(Placement(transformation(extent={{-172,22},{-160,34}})));
  .Modelica.Blocks.Sources.Constant zeroA(k=0)
    annotation(Placement(transformation(extent={{-190.23,11.7},{-180.23,21.7}},rotation = 0.0,origin = {0.0,0.0})));

  // HighDemand 반전
  .Modelica.Blocks.Logical.Not notHighDem
    annotation(Placement(transformation(extent={{-4.0,-4.0},{4.0,4.0}},rotation = 90.0,origin = {-148.13,224.54})));
    .Modelica.Blocks.Logical.Or or_close annotation(Placement(transformation(extent = {{-10.0,10.0},{10.0,-10.0}},origin = {-93.13,165.72},rotation = -90.0)));

equation
  connect(initialStep.outPort[1], transition.inPort) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(absI.y, convCrate.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-36.87,131.01},{-36.87,139.36},{-36.97,139.36},{-36.97,147.84}}));
  connect(and1.y, booleanToInteger.u) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(booleanToInteger.y, mode_ref.u_i) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-155.1,78.21},{-142.86,78.21},{-142.86,78.25},{-130.75,78.25}}));
  connect(close_contactors.systemBus, batty.controlBus) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-92.98,69.13},{-92.98,-8.21},{-117.41,-8.21},{-117.41,-85.18}}));
  connect(SCon.active, and1.u2) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-238.94,310.64},{-238.94,115.44},{-208.5,115.44},{-208.5,109.41}}));
  connect(convCrate3.u, absI2.y) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(SCon.active, and1.u1) annotation (Line(color={0,0,127}, thickness=0.5));
  // i_b_ref: PowerMode에서만 OnSC 사용, 아니면 0 A
  connect(OnSC.y,      sw_iBref.u1) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-192.75,38.86},{-173.2,38.86},{-173.2,32.8}}));
  connect(zeroA.y,     sw_iBref.u3) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(PowerMode.active, sw_iBref.u2) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-168.76,361.39},{-168.76,367.19},{-193.86,367.19},{-193.86,28},{-173.2,28}}));
  connect(sw_iBref.y,  i_b_ref.u_r) annotation (Line(color={0,0,127}, thickness=0.5));

  connect(dCSensor.plug_b, SCap.plug_a) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(dCSensor.y[2], absI2.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-209.85,-52.02},{-209.85,-58.02},{-396.25,-58.02},{-396.25,168.69}}));
  connect(convCrate3.y, hysteresis.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-396.59,234.87},{-396.59,250.15},{-391.55,250.15}}));
  connect(not1.y, lowCurrentSCap.condition) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-289.96,250.84},{-205.38,250.84},{-205.38,260.47}}));
  connect(hysteresis.y, not1.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-368.55,250.15},{-312.96,250.15},{-312.96,250.84}}));
  connect(transition.outPort, SCon.inPort[1]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-264.79,321.65},{-256.92,321.65},{-256.92,321.64},{-249.94,321.64}}));
  connect(Bat.outPort[1], HighCurrent.inPort) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-5.75,281.87},{66.39,281.87},{66.39,355.49},{60.39,355.49}}));
  connect(HighCurrent.outPort, SCon.inPort[2]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{54.89,355.49},{3.78,355.49},{3.78,380.67},{-255.94,380.67},{-255.94,321.64},{-249.94,321.64}}));

  connect(mode_ref.systemBus, averageStepUpDownDCDC.controlBus) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-120.75,78.25},{-116.26,78.25},{-116.26,17.53},{-120.09,17.53},{-120.09,11.53}}));
  connect(averageStepUpDownDCDC.controlBus, SCap.controlBus) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(i_b_ref.systemBus, averageStepUpDownDCDC.controlBus) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(averageStepUpDownDCDC.plug_a, dCSensor.plug_a) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(vInitA.plug_a, averageStepUpDownDCDC.plug_a) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-135.54,-54.8},{-126.44,-54.8},{-126.44,1.53},{-122.09,1.53}}));
  connect(pwr_a_ref.systemBus, averageStepUpDownDCDC.controlBus) annotation (Line(color={0,0,127}, thickness=0.5));

  // PI setpoint/measurement
  connect(targetSOC.y, socPI.u_s) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-484.57,36.85},{-469.2,36.85},{-469.2,36.81},{-465.59,36.81}}));
  connect(soc.y_r,     socPI.u_m) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-320.99,-0.3},{-453.59,-0.3},{-453.59,24.81}}));

  // PI + Feed-forward → limiter → filter → refs
  connect(socPI.y,     addPI.u1) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-442.59,36.81},{-407.45,36.81},{-407.45,73.99}}));
  connect(pwr_sns.y_r, addPI.u2) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(addPI.y,     limiter.u) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(filter.u,    limiter.y) annotation (Line(color={0,0,127}, thickness=0.5));

  // (기존 모니터링용)
  connect(targetSOC.y, feedback.u1) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(feedback.u2, soc.y_r) annotation (Line(color={0,0,127}, thickness=0.5));

  connect(filter.y, pwr_a_ref.u_r) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(chassis.velocity, driver.speed_m) annotation (Line(color={0,0,127}, thickness=0.5,points = {{114.86,-99.29},{114.86,-90.1},{114.89,-90.1},{114.89,-80.34}}));
  connect(driver.tau_ref, torqueReference.u_r) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(machine.flange, chassis.flangeR) annotation (Line(color={0,0,127}, thickness=0.5,points = {{89.86,-117.21},{89.86,-116.89},{98.86,-116.89}}));
  connect(torqueReference.systemBus, machine.controlBus) annotation (Line(color={0,0,127}, thickness=0.5,points = {{72.89,-67.14},{61.06,-67.14},{61.06,-101.21}}));
  connect(machine.plug_a, dCSensor2.plug_b) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(averageStepUpDownDCDC.plug_b, machine.plug_a) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(pwr_sns.systemBus, machine.controlBus) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(filter.y, pwr_b_ref.u_r) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(pwr_b_ref.systemBus, averageStepUpDownDCDC.controlBus) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(batty.controlBus, soc.systemBus) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-117.41,-85.18},{-311.99,-85.18},{-311.99,-0.3}}));
  connect(lessThreshold.y, and3.u1) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(greaterThreshold.y, and3.u2) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(and3.y, and2.u2) annotation (Line(color={0,0,127}, thickness=0.5,points = {{75.24,237.43},{75.24,253.04},{124.31,253.04}}));
  connect(soC_cell.y_r, greaterThreshold2.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{100.61,66.5},{100.61,78.84},{100.27,78.84},{100.27,89.17}}));
  connect(hysteresis2.y, or1.u1) annotation (Line(color={0,0,127}, thickness=0.5,points = {{100.31,171.03},{100.31,184.47},{119.02,184.47},{119.02,194.29}}));
  connect(greaterThreshold2.y, or1.u2) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(or1.y, and2.u1) annotation (Line(color={0,0,127}, thickness=0.5,points = {{119.02,217.29},{119.02,235.52},{132.31,235.52},{132.31,253.04}}));
  connect(convCrate.y, hysteresis2.u) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(soC_cell.systemBus, batty.controlBus) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(SCap.controlBus, soc_sc.systemBus) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-242.91,-33.12},{-242.91,121.33},{-3.51,121.33}}));
  connect(soc_sc.y_r, greaterThreshold.u) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(soc_sc.y_r, lessThreshold.u) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(and2.y, HighCurrent.condition) annotation (Line(color={0,0,127}, thickness=0.5,points = {{132.31,276.04},{132.31,294.29},{56.39,294.29},{56.39,343.49}}));
  connect(lowCurrentSCap.outPort, Bat.inPort[1]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-203.88,272.47},{-20.71,272.47},{-20.71,281.87},{-27.25,281.87}}));
  connect(absI.u, dCSensor2.y[2]) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(vInitA2.plug_a, DCDC_Bat.plug_a) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-109.55,-150.57},{-97.01,-150.57},{-97.01,-101.26},{-93.47,-101.26}}));
  connect(batty.plug_a, DCDC_Bat.plug_a) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(dCSensor2.plug_a, DCDC_Bat.plug_b) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(vInitA3.plug_a, machine.plug_a) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(dCSensor.y[1], add2.u1) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(const.y, add2.u2) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(add2.y, absI_del_voltage.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-320.02,144.83},{-314.64,144.83},{-314.64,144.9},{-308,144.9}}));
  connect(absI_del_voltage.y, hysteresis_voltage.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-285,144.9},{-71.03,144.9},{-71.03,216.14}}));
  connect(hysteresis_voltage.y, transitionWithSignal.condition) annotation (Line(color={0,0,127}, thickness=0.5));

  // --- 새 상태머신 연결 ---
  // SCon → VoltHold / PowerMode
  connect(SCon.outPort[1], t_SCon_to_Volt.inPort) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(t_SCon_to_Volt.outPort, VoltHold.inPort[1]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-204.25,304.64},{-197.28,304.64},{-197.28,304.6},{-179.71,304.6}}));

  connect(SCon.outPort[2], t_SCon_to_Power.inPort) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(t_SCon_to_Power.outPort, PowerMode.inPort[1]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-203.16,350.26},{-191.62,350.26},{-191.62,350.39},{-179.76,350.39}}));

  // VoltHold ↔ PowerMode (HighDemand = hysteresis2.y)
  connect(VoltHold.outPort[1], t_Volt_to_Power.inPort) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-158.21,304.6},{-158.21,304.75},{-138.62,304.75}}));
  connect(t_Volt_to_Power.outPort, PowerMode.inPort[2]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-133.12,304.75},{-121.95,304.75},{-121.95,326.83},{-186.11,326.83},{-186.11,350.39},{-179.76,350.39}}));

  connect(PowerMode.outPort[1], t_Power_to_Volt.inPort) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-158.26,350.39},{-149.29,350.39},{-149.29,350.61},{-139.74,350.61}}));
  connect(t_Power_to_Volt.outPort, VoltHold.inPort[2]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-134.24,350.61},{-115.97,350.61},{-115.97,323.49},{-186.22,323.49},{-186.22,304.6},{-179.71,304.6}}));

  // HighDemand/NotHighDemand 조건
  connect(hysteresis2.y, t_SCon_to_Power.condition) annotation (Line(color={0,0,127}, thickness=0.5,points = {{100.31,171.03},{100.31,408.98},{-204.66,408.98},{-204.66,362.26}}));
  connect(hysteresis2.y, t_Volt_to_Power.condition) annotation (Line(color={0,0,127}, thickness=0.5,points = {{100.31,171.03},{100.31,262.28},{-134.62,262.28},{-134.62,292.75}}));
  connect(hysteresis2.y, notHighDem.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{100.31,171.03},{100.31,200.28},{-148.13,200.28},{-148.13,219.74}}));
  connect(notHighDem.y,  t_SCon_to_Volt.condition) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-148.13,228.94},{-148.13,239.55},{-224.19,239.55},{-224.19,288.44},{-205.75,288.44},{-205.75,292.64}}));
  connect(notHighDem.y,  t_Power_to_Volt.condition) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-148.13,228.94},{-148.13,332.07},{-135.74,332.07},{-135.74,338.61}}));

  // Recharge: SoC_sc < 0.35 → Recharge, SoC_sc > 0.5 → VoltHold
  connect(soc_sc.y_r, sc_low.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{5.49,121.33},{117.75,121.33},{117.75,157.77},{126.57,157.77}}));
  connect(soc_sc.y_r, sc_ok.u) annotation (Line(color={0,0,127}, thickness=0.5,points = {{5.49,121.33},{80.53,121.33},{80.53,118.24},{129.52,118.24}}));
  connect(PowerMode.outPort[1], t_to_Recharge.inPort) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(VoltHold.outPort[1],  t_to_Recharge.inPort) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(t_to_Recharge.outPort, Recharge.inPort[1]) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-91.19,323.31},{-82.35,323.31},{-82.35,323.51},{-72.87,323.51}}));
  connect(sc_low.y,   t_to_Recharge.condition) annotation (Line(color={0,0,127}, thickness=0.5));
  connect(Recharge.outPort[1],  t_Recharge_to_Volt.inPort) annotation (Line(color={0,0,127}, thickness=0.5,points = {{-51.37,323.51},{-45.37,323.51},{-45.37,287.62},{-87.73,287.62}}));
  connect(sc_ok.y,    t_Recharge_to_Volt.condition) annotation (Line(color={0,0,127}, thickness=0.5,points = {{152.52,118.24},{158.52,118.24},{158.52,265.81},{-91.73,265.81},{-91.73,275.62}}));
  connect(t_Recharge_to_Volt.outPort, VoltHold.inPort[1]) annotation (Line(color={0,0,127}, thickness=0.5));
    connect(initialStep.outPort[1],transition.inPort) annotation(Line(points = {{-276.79,321.65},{-270.29,321.65}},color = {0,0,0}));
    connect(Bat.active,close_contactors.u_b) annotation(Line(points = {{-19.85,308.92},{-19.85,199.155},{-93.35,199.155},{-93.35,89.39}},color = {255,0,255}));
    connect(absI.y,convCrate.u) annotation(Line(points = {{-49.84,163.63},{-49.84,171.78},{-50.34,171.78},{-50.34,179.93}},color = {0,0,127}));
    connect(and1.y,booleanToInteger.u) annotation(Line(points = {{-200.5,86.41},{-200.5,78.21},{-178.1,78.21}},color = {255,0,255}));
    connect(booleanToInteger.y,mode_ref.u_i) annotation(Line(points = {{-155.1,78.21},{-142.865,78.21},{-142.865,78.82},{-130.63,78.82}},color = {255,127,0}));
    connect(close_contactors.systemBus,batty.controlBus) annotation(Line(points = {{-93.35,68.76},{-93.35,-8.21},{-117.41,-8.21},{-117.41,-85.18}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(SCon.active,and1.u2) annotation(Line(points = {{-238.04,309.13},{-238.04,109.41},{-208.5,109.41}},color = {255,0,255}));
    connect(absI2.y,convCrate3.u) annotation(Line(points = {{-396.25,191.69},{-396.25,201.43},{-396.59,201.43},{-396.59,211.87}},color = {0,0,127}));
    connect(Bat.active,OnSC.u) annotation(Line(points = {{-16.25,270.87},{-16.25,245.15},{-221.75,245.15},{-221.75,38.86},{-215.75,38.86}},color = {255,0,255}));
    connect(OnSC.y,sw_iBref.u1) annotation(Line(points = {{-193.73,28.54},{-187.73,28.54},{-187.73,38.8},{-173.2,38.8},{-173.2,32.8}},color = {0,0,127}));
    connect(zeroA.y,sw_iBref.u3) annotation(Line(points = {{-179.73,16.7},{-173.2,16.7},{-173.2,23.2}},color = {0,0,127}));
    connect(PowerMode.active,sw_iBref.u2) annotation(Line(points = {{-164.42,308.42},{-164.42,303.42},{-179.2,303.42},{-179.2,28},{-173.2,28}},color = {255,0,255}));
    connect(sw_iBref.y,i_b_ref.u_r) annotation(Line(points = {{-159.4,28},{-155.405,28},{-155.405,28.56},{-151.41,28.56}},color = {0,0,127}));
    connect(dCSensor.plug_b,SCap.plug_a) annotation(Line(points = {{-219.85,-43.02},{-230.38,-43.02},{-230.38,-43.12},{-240.91,-43.12}},color = {255,128,0}));
    connect(dCSensor.y[2],absI2.u) annotation(Line(points = {{-209.85,-52.02},{-209.85,-58.02},{-277.45,-58.02},{-277.45,176.86}},color = {0,0,127}));
    connect(convCrate3.y,hysteresis.u) annotation(Line(points = {{-277.79,243.04},{-277.79,272.95},{-267.53,272.95}},color = {0,0,127}));
    connect(hysteresis.y,not1.u) annotation(Line(points = {{-244.53,272.95},{-228.9,272.95},{-228.9,274.66},{-213.27,274.66}},color = {255,0,255}));
    connect(not1.y,lowCurrentSCap.condition) annotation(Line(points = {{-190.27,274.66},{-185.27,274.66},{-185.27,262.28},{-79.31,262.28},{-79.31,268.28}},color = {255,0,255}));
    connect(transition.outPort,SCon.inPort[1]) annotation(Line(points = {{-264.79,321.65},{-256.915,321.65},{-256.915,320.13},{-249.04,320.13}},color = {0,0,0}));
    connect(Bat.outPort[1],HighCurrent.inPort) annotation(Line(points = {{-9.35,319.92},{22.41,319.92},{22.41,356.19},{16.41,356.19}},color = {0,0,0}));
    connect(HighCurrent.outPort,SCon.inPort[2]) annotation(Line(points = {{10.91,356.19},{-255.94,356.19},{-255.94,321.64},{-249.94,321.64}},color = {0,0,0}));
    connect(mode_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-122.26,78.55},{-116.26,78.55},{-116.26,17.53},{-120.09,17.53},{-120.09,11.53}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.controlBus,SCap.controlBus) annotation(Line(points = {{-120.09,11.53},{-120.09,17.53},{-242.91,17.53},{-242.91,-33.12}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(i_b_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-141.41,28.56},{-120.09,28.56},{-120.09,11.53}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(averageStepUpDownDCDC.plug_a,dCSensor.plug_a) annotation(Line(points = {{-122.09,1.53},{-160.97,1.53},{-160.97,-43.02},{-199.85,-43.02}},color = {255,128,0}));
    connect(vInitA.plug_a,averageStepUpDownDCDC.plug_a) annotation(Line(points = {{-132.44,-55.02},{-126.44,-55.02},{-126.44,-26.745},{-128.09,-26.745},{-128.09,1.53},{-122.09,1.53}},color = {255,128,0}));
    connect(pwr_a_ref.systemBus,averageStepUpDownDCDC.controlBus) annotation(Line(points = {{-200.9,6.96},{-194.9,6.96},{-194.9,17.53},{-120.09,17.53},{-120.09,11.53}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(targetSOC.y,socPI.u_s) annotation(Line(points = {{-484.57,36.85},{-469.2,36.85},{-469.2,36.81},{-453.83,36.81}},color = {0,0,127}));
    connect(soc.y_r,socPI.u_m) annotation(Line(points = {{-330.57,60.85},{-336.57,60.85},{-336.57,18.81},{-453.59,18.81},{-453.59,24.81}},color = {0,0,127}));
    connect(socPI.y,addPI.u1) annotation(Line(points = {{-442.59,36.81},{-421.83,36.81}},color = {0,0,127}));
    connect(chassis.velocity,driver.speed_m) annotation(Line(points = {{114.57,-99.86},{114.57,-90.1},{114.89,-90.1},{114.89,-80.34}},color = {0,0,127}));
    connect(driver.tau_ref,torqueReference.u_r) annotation(Line(points = {{101.69,-67.14},{82.89,-67.14}},color = {0,0,127}));
    connect(torqueReference.systemBus,machine.controlBus) annotation(Line(points = {{72.89,-67.14},{57.8,-67.14},{57.8,-101.78}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(machine.flange,chassis.flangeR) annotation(Line(points = {{86.6,-117.78},{92.585,-117.78},{92.585,-117.46},{98.57,-117.46}},color = {0,0,0}));
    connect(averageStepUpDownDCDC.plug_b,machine.plug_a) annotation(Line(points = {{-102.09,1.53},{-22.115000000000002,1.53},{-22.115000000000002,-117.21},{57.86,-117.21}},color = {255,128,0}));
    connect(pwr_sns.systemBus,machine.controlBus) annotation(Line(points = {{-190.28,-15.16},{61.06,-15.16},{61.06,-101.21}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(batty.controlBus,soc.systemBus) annotation(Line(points = {{-117.41,-85.18},{-117.41,-0.3},{-311.99,-0.3}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(lessThreshold.y,and3.u2) annotation(Line(points = {{37.27,217.49},{52.254999999999995,217.49},{52.254999999999995,214.43},{67.24,214.43}},color = {255,0,255}));
    connect(greaterThreshold.y,and3.u1) annotation(Line(points = {{39.29,185.14},{75.24,185.14},{75.24,214.43}},color = {255,0,255}));
    connect(and3.y,and2.u2) annotation(Line(points = {{75.24,237.43},{75.24,243.43},{74.33,243.43},{74.33,253.74},{80.33,253.74}},color = {255,0,255}));
    connect(batty.controlBus,soC_cell.systemBus) annotation(Line(points = {{-117.41,-85.18},{-117.41,-13.51},{100.61,-13.51},{100.61,57.5}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(soC_cell.y_r,greaterThreshold2.u) annotation(Line(points = {{113.62,67.17},{113.62,78.83500000000001},{114.66,78.83500000000001},{114.66,90.5}},color = {0,0,127}));
    connect(greaterThreshold2.y,hysteresis2.u) annotation(Line(points = {{100.27,112.17},{100.27,132.02},{100.31,132.02},{100.31,148.03}},color = {255,0,255}));
    connect(hysteresis2.y,or1.u1) annotation(Line(points = {{100.31,174.65},{100.31,184.47},{119.02,184.47},{119.02,194.29}},color = {255,0,255}));
    connect(or1.y,and2.u1) annotation(Line(points = {{119.02,217.29},{119.02,235.515},{88.33,235.515},{88.33,253.74}},color = {255,0,255}));
    connect(SCap.controlBus,soc_sc.systemBus) annotation(Line(points = {{-242.91,-33.12},{-242.91,113.38},{16.2,113.38}},color = {240,170,40},pattern = LinePattern.Dot));
    connect(soc_sc.y_r,sc_ok.u) annotation(Line(points = {{35.05,118.31},{80.525,118.31},{80.525,120},{126,120}},color = {0,0,127}));
    connect(soc_sc.y_r,sc_low.u) annotation(Line(points = {{35.05,118.31},{80.81,118.31},{80.81,157.77},{126.57,157.77}},color = {0,0,127}));
    connect(and2.y,HighCurrent.condition) annotation(Line(points = {{88.33,276.74},{88.33,310.46500000000003},{12.41,310.46500000000003},{12.41,344.19}},color = {255,0,255}));
    connect(lowCurrentSCap.outPort,Bat.inPort[1]) annotation(Line(points = {{-77.81,280.28},{-54.33,280.28},{-54.33,319.92},{-30.85,319.92}},color = {0,0,0}));
    connect(vInitA2.plug_a,DCDC_Bat.plug_a) annotation(Line(points = {{-89.13,-149.21},{-83.13,-149.21},{-83.13,-125.23500000000001},{-99.47,-125.23500000000001},{-99.47,-101.26},{-93.47,-101.26}},color = {255,128,0}));
    connect(DCDC_Bat.plug_b,dCSensor2.plug_a) annotation(Line(points = {{-73.47,-101.26},{-67.41499999999999,-101.26},{-67.41499999999999,-51.68},{-61.36,-51.68}},color = {255,128,0}));
    connect(vInitA3.plug_a,machine.plug_a) annotation(Line(points = {{10.82,-138.36},{34.34,-138.36},{34.34,-117.21},{57.86,-117.21}},color = {255,128,0}));
    connect(dCSensor2.y[1],add2.u2) annotation(Line(points = {{-51.36,-60.68},{-51.36,-66.68},{-349.02,-66.68},{-349.02,138.83},{-343.02,138.83}},color = {0,0,127}));
    connect(add2.y,absI_del_voltage.u) annotation(Line(points = {{-320.02,144.83},{-314.645,144.83},{-314.645,142.68},{-309.27,142.68}},color = {0,0,127}));
    connect(absI_del_voltage.y,hysteresis_voltage.u) annotation(Line(points = {{-286.27,142.68},{-280.27,142.68},{-280.27,125.41},{-321.15,125.41},{-321.15,108.14},{-317.15,108.14}},color = {0,0,127}));
    connect(transitionWithSignal.condition,hysteresis_voltage.y) annotation(Line(points = {{-116.07,221.62},{-116.07,258.48},{-71.03,258.48},{-71.03,239.14}},color = {255,0,255}));
    connect(SCon.outPort[1],t_SCon_to_Power.inPort) annotation(Line(points = {{-228.44,321.64},{-219.19,321.64},{-219.19,350.26},{-208.66,350.26}},color = {0,0,0}));
    connect(SCon.outPort[2],t_SCon_to_Volt.inPort) annotation(Line(points = {{-228.44,321.64},{-219.095,321.64},{-219.095,304.64},{-209.75,304.64}},color = {0,0,0}));
    connect(t_SCon_to_Power.outPort,PowerMode.inPort[1]) annotation(Line(points = {{-203.16,350.26},{-191.36,350.26},{-191.36,349.16},{-179.56,349.16}},color = {0,0,0}));
    connect(t_SCon_to_Volt.outPort,VoltHold.inPort[1]) annotation(Line(points = {{-204.25,304.64},{-197.28,304.64},{-197.28,303.57},{-190.31,303.57}},color = {0,0,0}));
    connect(VoltHold.outPort[1],t_Volt_to_Power.inPort) annotation(Line(points = {{-169.33,304.6},{-159.925,304.6},{-159.925,304.23},{-150.52,304.23}},color = {0,0,0}));
    connect(PowerMode.outPort[1],t_Power_to_Volt.inPort) annotation(Line(points = {{-159.61,350.19},{-147.22000000000003,350.19},{-147.22000000000003,348.79},{-134.83,348.79}},color = {0,0,0}));
    connect(t_Volt_to_Power.outPort,PowerMode.inPort[2]) annotation(Line(points = {{-131.31,304.75},{-125.31,304.75},{-125.31,327.47},{-186.11,327.47},{-186.11,350.19},{-181.11,350.19}},color = {0,0,0}));
    connect(t_Power_to_Volt.outPort,VoltHold.inPort[2]) annotation(Line(points = {{-129.85,350.35},{-123.85,350.35},{-123.85,327.475},{-195.83,327.475},{-195.83,304.6},{-190.83,304.6}},color = {0,0,0}));
    connect(hysteresis2.y,t_Volt_to_Power.condition) annotation(Line(points = {{100.31,171.03},{100.31,231.89},{-134.62,231.89},{-134.62,292.75}},color = {255,0,255}));
    connect(hysteresis2.y,t_SCon_to_Power.condition) annotation(Line(points = {{100.31,171.03},{100.31,368.26},{-204.66,368.26},{-204.66,362.26}},color = {255,0,255}));
    connect(hysteresis2.y,notHighDem.u) annotation(Line(points = {{100.31,171.03},{100.31,177.03},{-167.79,177.03},{-167.79,224.07},{-161.79,224.07}},color = {255,0,255}));
    connect(notHighDem.y,t_SCon_to_Volt.condition) annotation(Line(points = {{-157,228.47},{-157,260.555},{-205.75,260.555},{-205.75,292.64}},color = {255,0,255}));
    connect(notHighDem.y,t_Power_to_Volt.condition) annotation(Line(points = {{-157,228.47},{-157,283.54},{-134.97,283.54},{-134.97,338.61}},color = {255,0,255}));
    connect(PowerMode.outPort[2],t_to_Recharge.inPort) annotation(Line(points = {{-158.26,350.39},{-152.24,350.39},{-152.24,323.31},{-96.69,323.31}},color = {0,0,0}));
    connect(VoltHold.outPort[2],t_to_Recharge.inPort) annotation(Line(points = {{-158.21,304.6},{-151.86,304.6},{-151.86,323.31},{-96.69,323.31}},color = {0,0,0}));
    connect(t_to_Recharge.outPort,Recharge.inPort[1]) annotation(Line(points = {{-91.19,323.31},{-82.35,323.31},{-82.35,322.87},{-73.51,322.87}},color = {0,0,0}));
    connect(Recharge.outPort[1],t_Recharge_to_Volt.inPort) annotation(Line(points = {{-51.37,323.51},{-45.37,323.51},{-45.37,288.89},{-88.68,288.89}},color = {0,0,0}));
    connect(t_Recharge_to_Volt.outPort,VoltHold.inPort[3]) annotation(Line(points = {{-93.23,287.62},{-185.71,287.62},{-185.71,304.6},{-179.71,304.6}},color = {0,0,0}));
    connect(sc_ok.y,t_Recharge_to_Volt.condition) annotation(Line(points = {{152.52,118.24},{158.52,118.24},{158.52,269.62},{-91.73,269.62},{-91.73,275.62}},color = {255,0,255}));
    connect(t_to_Recharge.condition,sc_low.y) annotation(Line(points = {{-92.69,311.31},{-92.69,304.36},{155.57,304.36},{155.57,157.77},{149.57,157.77}},color = {255,0,255}));
    connect(or_close.y,close_contactors.u_b) annotation(Line(points = {{-93.13,154.72},{-93.13,122.86},{-92.98,122.86},{-92.98,89.76}},color = {255,0,255}));
    connect(Recharge.active,or_close.u1) annotation(Line(points = {{-61.87,312.51},{-61.87,195.3},{-93.13,195.3},{-93.13,177.72}},color = {255,0,255}));
    connect(Bat.active,OnSC.u) annotation(Line(points = {{24.13,308.22},{24.13,303.22},{-221.75,303.22},{-221.75,38.86},{-215.75,38.86}},color = {255,0,255}));
    connect(Bat.active,or_close.u2) annotation(Line(points = {{-16.25,270.87},{-16.25,254.32},{-26.78,254.32},{-26.78,184.52},{-85.13,184.52},{-85.13,177.72}},color = {255,0,255}));
    connect(SCon.outPort[3],lowCurrentSCap.inPort) annotation(Line(points = {{-228.44,321.64},{-218.91,321.64},{-218.91,272.47},{-209.38,272.47}},color = {0,0,0}));

annotation (
  experiment(StopTime=22000),
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This example demonstrates an experiment for predicting the range of an electric vehicle. The powertrain for the vehicle consists of a SCap pack, an electric machine, and an electric load that represents additional consumers in the vehicle. The mechanics of the vehicle are captured by a simple 1D chassis model. A model of the friction brakes are also included, as well as control for blending the friction braking with electric regeneration. The driver controls the vehicle speed to follow a repeated sequence of the <a href=\"modelica://Electrification.Utilities.DriveCycles.WLTP\">WLTP</a> cycle (class 3).</p>
</html>"));
end ElectricRange_SOC_NineStep;