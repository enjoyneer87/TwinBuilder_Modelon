within HESS;

model HESS_StateGraph_Core
  "직결형 HESS(������������������������������������������������������������������������������������������������������������������터리 + 슈퍼캡) 상위 StateGraph: 주행/회생/외부충전/SC보충/프리차지/고장 상태 전환"

  import Modelica.StateGraph.*;
  import Modelica.Blocks.Interfaces.*;
  import Modelica.Blocks.Logical.*;

  // ==== 파라미터 ====
  parameter Real dwell_precharge = 0.5  "초, 프리차지 완료 후 대기 시간";
  parameter Real dwell_mode      = 0.3  "초, 모드 전환 최소 체류 시간";
  parameter Boolean start_in_idle = true "시작 시 Idle(대기) 상태로 시작 여부";

  // ==== 외부 조건 입력 ====
  // 하드웨어/충전 상태
  BooleanInput plugIn            "외부 DC충전 커넥터 체결 및 통신 OK"            annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-250.0,0.0})));
  BooleanInput prechargeOK       "프리차지 완료 여부 (버스 전압 차 허용 범위)"      annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-250.0,50.0})));
  BooleanInput contactorsOK      "메인 컨택터 닫힘 및 상태 정상"                 annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-250.0,100.0})));
  BooleanInput dcChargeAllowed   "BMS에서 DC충전 세션 승인 여부"                annotation(Placement(transformation(extent = {{-260.59,139.97},{-239.41,161.15}},rotation = 0.0,origin = {0.0,0.0})));
  BooleanInput clearFault        "고장 해제 승인 (안전조건 충족)"                annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-250.0,-300.0})));
  BooleanInput faultAny          "임계 고장 (OV/UV/OT/OC/절연불량 등)"         annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-250.0,-250.0})));

  // 차량 운행 요구
  BooleanInput driveDemand       "구동 토크/전력 요구 있음"                     annotation(Placement(transformation(extent = {{-260.84,-60.59},{-239.66,-39.41}},rotation = 0.0,origin = {0.0,0.0})));
  BooleanInput regenDemand       "회생 가능 및 안전 조건 충족"                   annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-250.0,-100.0})));
  BooleanInput needSCReplenish   "슈퍼캡 보충 충전 필요 (SoC/전압 저하)"           annotation(Placement(transformation(extent = {{-260.59,-160.59},{-239.41,-139.41}},rotation = 0.0,origin = {0.0,0.0})));        

  // 배터리 CV/테이퍼 상태(선택 정보)
//  BooleanInput taperPhase        "배터리가 CV 구간에 진입한 상태"                annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-250.0,-200.0})));     


  // ==== 상태 정의 ====
  Step Idle(start=start_in_idle,nOut = 4,nIn = 2)     "1    대기 상태"                            annotation(Placement(transformation(extent = {{-20.59,-10.88},{0.59,10.3}},rotation = 0.0,origin = {0.0,0.0})));  
  StepWithSignal Precharge(nOut = 2,nIn = 1)          "2    프리차지 단계"                       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {50.0,0.0})));  
  StepWithSignal Drive(nOut = 3,nIn = 4)              "3    주행 (방전 우선)"                    annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {100.0,50.0})));  
  StepWithSignal Regen(nOut = 2,nIn = 1)                      "4    회생 제동 (충전 우선)"               annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {200.0,0.0})));  
  StepWithSignal DCCharge(nOut = 1,nIn = 2)           "5    외��� DC충�� 세션"                   annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {100.0,-50.0})));  
  StepWithSignal SC_Replenish(nOut = 2,nIn = 2)               "6    슈퍼캡 보충 충전 (배터리→SC)"       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {350.0,0.0})));  
  StepWithSignal Fault(nOut = 1,nIn = 6)                      "7    고장 상태 (Latch 유지)"           annotation(Placement(transformation(extent = {{339.41,-250.59},{360.59,-229.41}},rotation = 0.0,origin = {0.0,0.0}))); 
    
  // ==== 상태 전이 정의 ====
  // Idle -> {Pre, Drive, DC}
  TransitionWithSignal t_Idle_to_Pre (use_conditionPort=true)                           annotation(Placement(transformation(extent = {{14.409999999999998,-10.59},{35.59,10.59}},rotation = 0.0,origin = {0.0,0.0})));  
  TransitionWithSignal t_Idle_to_Drive(use_conditionPort=true, waitTime=dwell_mode)    annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {25.0,50.0})));  
  TransitionWithSignal t_Idle_to_DC  (use_conditionPort=true, waitTime=dwell_mode)    annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {25.0,-50.0})));  


  // Pre -> {Idle, Drive, DC}
  TransitionWithSignal t_Pre_to_Idle (use_conditionPort=true, waitTime=dwell_precharge)     annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {75.0,100.0})));  
  TransitionWithSignal t_Pre_to_Drive(use_conditionPort=true, waitTime=dwell_mode)        annotation(Placement(transformation(extent = {{64.41,14.41},{85.59,35.59}},rotation = 0.0,origin = {0.0,0.0})));  
  TransitionWithSignal t_Pre_to_DC   (use_conditionPort=true, waitTime=dwell_mode)      annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {75.0,-25.0})));  

  // Drive <-> Regen
  TransitionWithSignal t_Drive_to_Regen(use_conditionPort=true, waitTime=dwell_mode)       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = -90.0,origin = {140.0,25.0})));  
  TransitionWithSignal t_Regen_to_Drive(use_conditionPort=true, waitTime=dwell_mode)       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 90.0,origin = {180.0,25.0})));  

  // Drive/Regen -> SC, SC -> Drive
  TransitionWithSignal t_Drive_to_SC  (use_conditionPort=true, waitTime=dwell_mode)        annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = -90.0,origin = {300.0,25.0}))); 
  TransitionWithSignal t_SC_to_Drive  (use_conditionPort=true, waitTime=dwell_mode)        annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 90.0,origin = {350.0,25.0})));  
  TransitionWithSignal t_Regen_to_SC  (use_conditionPort=true, waitTime=dwell_mode)        annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {300.0,-50.0})));  

  // 고장 전이 (각 상태별 개별 연결)
  TransitionWithSignal t_Idle_to_Fault   (use_conditionPort=true)             annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {25.00,-260.0})));     
  TransitionWithSignal t_Fault_to_Idle   (use_conditionPort=true)             annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {55.0,-240.0})));    

  TransitionWithSignal t_Pre_to_Fault    (use_conditionPort=true)             annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {75.,-80.0})));          
  TransitionWithSignal t_Drive_to_Fault  (use_conditionPort=true)             annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {125.0,-110.0})));         
  TransitionWithSignal t_Regen_to_Fault  (use_conditionPort=true)             annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {300.0,-170.0})));          
  TransitionWithSignal t_DC_to_Fault     (use_conditionPort=true)             annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {125.0,-170.0})));          
  TransitionWithSignal t_SC_to_Fault     (use_conditionPort=true)             annotation(Placement(transformation(extent = {{364.41,-220.59},{385.59,-199.41}},rotation = 0.0,origin = {0.0,0.0})));           
    
  // ==== 출력 (현재 상태 플래그 �� 모��� 코��) ====
  BooleanOutput isIdle                                                        annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {450.0,0.0})));
  BooleanOutput isPrecharge                                                   annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {450.0,-50.0})));
  BooleanOutput isDrive                                                       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {450.0,-100.0})));
  BooleanOutput isRegen                                                       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {450.0,-150.0})));
  BooleanOutput isDCCharge                                                    annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {450.0,-200.0})));
  BooleanOutput isSCReplenish                                                 annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {450.0,-250.0})));
  BooleanOutput isFault                                                       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {450.0,-300.0})));
  IntegerOutput mode "0=Idle, 1=Pre, 2=Drive, 3=Regen, 4=DC, 5=SC, 9=Fault"   annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {550.0,-150.0})));

  // ==== 보조 논리 블럭 ====
  Not notPlugIn          annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-200.0,0.0})));          // plugIn 반전
  And canStartPre        annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,50.0})));          //         // Idle -> Pre 조건
  And idle_to_drive_ok   annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,100.0})));          //  // Idle -> Drive 조건
  And idle_to_dc_ok      annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,150.0})));          //  // Idle -> DC 조건
  And goIdleFromPre_aux  annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,200.0})));          // // Pre -> Idle 조건
  And preDone_goDrive    annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,250.0})));          // Pre -> Drive 조건
  And preDone_goDC       annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,300.0})));          //  // Pre -> DC 조건
  And sc_to_drive_ok     annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,350.0})));          //  // SC -> Drive 조건
  And regen_to_drive_ok  annotation(Placement(transformation(extent = {{-10.59,-10.59},{10.59,10.59}},rotation = 0.0,origin = {-150.0,400.0})));          //  // Regen -> Drive 조건
    .Modelica.Blocks.Logical.Not notDriveDemand annotation(Placement(transformation(extent = {{-195.68,30.88},{-174.5,52.06}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.BooleanConstant booleanConstant annotation(Placement(transformation(extent = {{-212.48,168.52},{-192.48,188.52}},origin = {0.0,0.0},rotation = 0.0)));
    .Modelica.Blocks.Logical.And ContactNPrecharge annotation(Placement(transformation(extent = {{-214.07,218.57},{-192.89,239.75}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.And PlugInNdeChargeAllowed annotation(Placement(transformation(extent = {{-213.19,266.24},{-192.01,287.42}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.Not Not_SCReplenish annotation(Placement(transformation(extent = {{-212.33,319.17},{-191.15,340.35}},rotation = 0.0,origin = {0.0,0.0})));

equation
      // ==== 상태 연결 ====

    
     // Idle -> (Pre, Drive, DC)
    connect(Idle.outPort[1],t_Idle_to_Pre.inPort) annotation(Line(points = {{1.12,-0.29},{1.12,0},{20.76,0}},color = {0,0,0}));
    connect(Idle.outPort[2],t_Idle_to_Drive.inPort) annotation(Line(points = {{1.12,-0.29},{10.94,-0.29},{10.94,50},{20.76,50}},color = {0,0,0}));
    connect(Idle.outPort[3],t_Idle_to_DC.inPort) annotation(Line(points = {{1.12,-0.29},{10.94,-0.29},{10.94,-50},{20.76,-50}},color = {0,0,0}));
    connect(Idle.outPort[4],t_Idle_to_Fault.inPort) annotation(Line(points = {{1.12,-0.29},{10.94,-0.29},{10.94,-260},{20.76,-260}},color = {0,0,0}));
      // Pre -> (Idle, Drive, DC)
    connect(Precharge.outPort[1],t_Pre_to_Idle.inPort) annotation(Line(points = {{61.12,0},{67.12,0},{67.12,50},{58.41,50},{58.41,100},{70.76,100}},color = {0,0,0}));
    connect(Precharge.outPort[2],t_Pre_to_Drive.inPort) annotation(Line(points = {{61.12,0},{67.13,0},{67.13,25},{70.76,25}},color = {0,0,0}));
    connect(Precharge.outPort[3],t_Pre_to_DC.inPort) annotation(Line(points = {{61.12,0},{67.14,0},{67.14,-25},{70.76,-25}},color = {0,0,0}));
    connect(Precharge.outPort[4],t_Pre_to_Fault.inPort) annotation(Line(points = {{61.12,0},{67.12,0},{67.12,-80},{70.76,-80}},color = {0,0,0}));
    
      // Drive <-> Regen
    connect(Drive.outPort[1],t_Drive_to_Regen.inPort) annotation(Line(points = {{111.12,50},{140,50},{140,29.24}},color = {0,0,0}));
    connect(Regen.outPort[1],t_Regen_to_Drive.inPort) annotation(Line(points = {{211.12,0},{217.12,0},{217.12,-16.59},{180,-16.59},{180,20.76}},color = {0,0,0}));
    connect(Drive.outPort[2],t_Drive_to_Fault.inPort) annotation(Line(points = {{111.12,50},{117.12,50},{117.12,-110},{120.76,-110}},color = {0,0,0}));
      // Drive/Regen -> SC, SC -> Drive
  
    connect(Drive.outPort[3],t_Drive_to_SC.inPort) annotation(Line(points = {{111.12,50},{300,50},{300,29.24}},color = {0,0,0}));
    connect(Regen.outPort[2],t_Regen_to_SC.inPort) annotation(Line(points = {{211.12,0},{253.44,0},{253.44,-50},{295.76,-50}},color = {0,0,0}));
    connect(SC_Replenish.outPort[1],t_SC_to_Drive.inPort) annotation(Line(points = {{361.12,0},{367.12,0},{367.12,14.760000000000002},{350,14.760000000000002},{350,20.76}},color = {0,0,0}));
    connect(SC_Replenish.outPort[2],t_SC_to_Fault.inPort) annotation(Line(points = {{361.12,0},{367.12,0},{367.12,-210},{370.76,-210}},color = {0,0,0}));
    connect(DCCharge.outPort[1],t_DC_to_Fault.inPort) annotation(Line(points = {{111.12,-50},{117.12,-50},{117.12,-170},{120.76,-170}},color = {0,0,0}));
    
      // 고장 상태에�� Idle��� 복귀
    connect(Fault.outPort[1],t_Fault_to_Idle.inPort) annotation(Line(points = {{361.12,-240},{367.12,-240},{367.12,-256.59000000000003},{38.41,-256.59000000000003},{38.41,-240},{50.76,-240}},color = {0,0,0}));

  // ==== 전이 연결 ====
     
    connect(Regen.outPort[2],t_Regen_to_Fault.inPort) annotation(Line(points = {{211.12,0},{253.44,0},{253.44,-170},{295.76,-170}},color = {0,0,0}));
    // transition
    connect(t_Idle_to_Drive.outPort,Drive.inPort[1]) annotation(Line(points = {{26.59,50},{88.35,50}},color = {0,0,0}));
    connect(t_Idle_to_Pre.outPort,Precharge.inPort[1]) annotation(Line(points = {{26.59,0},{38.35,0}},color = {0,0,0}));
    connect(t_Idle_to_DC.outPort,DCCharge.inPort[1]) annotation(Line(points = {{26.59,-50},{88.35,-50}},color = {0,0,0}));
    connect(t_Pre_to_Idle.outPort,Idle.inPort[1]) annotation(Line(points = {{76.59,100},{82.59,100},{82.59,128.15},{-32.47,128.15},{-32.47,-0.29},{-21.65,-0.29}},color = {0,0,0}));
    connect(t_Pre_to_Drive.outPort,Drive.inPort[2]) annotation(Line(points = {{76.59,25},{82.47,25},{82.47,50},{88.35,50}},color = {0,0,0}));
    connect(t_Pre_to_DC.outPort,DCCharge.inPort[2]) annotation(Line(points = {{76.59,-25},{82.47,-25},{82.47,-50},{88.35,-50}},color = {0,0,0}));
    
    //
    connect(canStartPre.y,t_Idle_to_Pre.condition) annotation(Line(points = {{-138.35,50},{-133.41,50},{-133.41,-18.71},{25,-18.71},{25,-12.71}},color = {255,0,255}));
    connect(idle_to_drive_ok.y,t_Idle_to_Drive.condition) annotation(Line(points = {{-138.35,100},{-133.41,100},{-133.41,31.29},{25,31.29},{25,37.29}},color = {255,0,255}));
    connect(idle_to_dc_ok.y,t_Idle_to_DC.condition) annotation(Line(points = {{-138.35,150},{-133.41,150},{-133.41,-68.71000000000001},{25,-68.71000000000001},{25,-62.71}},color = {255,0,255}));
    connect(goIdleFromPre_aux.y,t_Pre_to_Idle.condition) annotation(Line(points = {{-138.35,200},{-133.41,200},{-133.41,81.29},{75,81.29},{75,87.29}},color = {255,0,255}));
    connect(preDone_goDrive.y,t_Pre_to_Drive.condition) annotation(Line(points = {{-138.35,250},{-125.57,250},{-125.57,6.29},{75,6.29},{75,12.29}},color = {255,0,255}));
    connect(preDone_goDC.y,t_Pre_to_DC.condition) annotation(Line(points = {{-138.35,300},{-133.41,300},{-133.41,-43.71},{75,-43.71},{75,-37.71}},color = {255,0,255}));
    connect(t_Drive_to_Regen.condition,regenDemand) annotation(Line(points = {{127.29,25},{-61.355,25},{-61.355,-100},{-250,-100}},color = {255,0,255}));
    connect(regen_to_drive_ok.y,t_Regen_to_Drive.condition) annotation(Line(points = {{-138.35,400},{198.71,400},{198.71,25},{192.71,25}},color = {255,0,255}));
    connect(needSCReplenish,t_Regen_to_SC.condition) annotation(Line(points = {{-250,-150},{-180.25,-150},{-180.25,-106.35},{300,-106.35},{300,-62.71}},color = {255,0,255}));
    connect(needSCReplenish,t_Drive_to_SC.condition) annotation(Line(points = {{-250,-150},{272.67,-150},{272.67,25},{287.29,25}},color = {255,0,255}));

    // to Fault Inport
    connect(t_Regen_to_Fault.outPort,Fault.inPort[1]) annotation(Line(points = {{301.59,-170},{319.97,-170},{319.97,-240},{338.35,-240}},color = {0,0,0}));
    connect(t_SC_to_Fault.outPort,Fault.inPort[2]) annotation(Line(points = {{376.59,-210},{382.59,-210},{382.59,-193.41},{333.41,-193.41},{333.41,-240},{338.35,-240}},color = {0,0,0}));
    connect(t_Idle_to_Fault.outPort,Fault.inPort[3]) annotation(Line(points = {{26.59,-260},{182.47,-260},{182.47,-240},{338.35,-240}},color = {0,0,0}));
    connect(t_DC_to_Fault.outPort,Fault.inPort[4]) annotation(Line(points = {{126.59,-170},{232.47000000000003,-170},{232.47000000000003,-240},{338.35,-240}},color = {0,0,0}));
    connect(t_Drive_to_Fault.outPort,Fault.inPort[5]) annotation(Line(points = {{126.59,-110},{232.47000000000003,-110},{232.47000000000003,-240},{338.35,-240}},color = {0,0,0}));
    connect(t_Pre_to_Fault.outPort,Fault.inPort[6]) annotation(Line(points = {{76.59,-80},{207.47000000000003,-80},{207.47000000000003,-240},{338.35,-240}},color = {0,0,0}));
    connect(t_Fault_to_Idle.outPort,Idle.inPort[2]) annotation(Line(points = {{56.59,-240},{62.59,-240},{62.59,-120.145},{-26.59,-120.145},{-26.59,-0.29},{-21.65,-0.29}},color = {0,0,0}));
    
    //
    connect(t_Drive_to_Regen.outPort,Regen.inPort[1]) annotation(Line(points = {{140,23.41},{140,0},{188.35,0}},color = {0,0,0}));
    connect(t_Regen_to_Drive.outPort,Drive.inPort[3]) annotation(Line(points = {{180,26.59},{180,66.59},{82.35,66.59},{82.35,50},{88.35,50}},color = {0,0,0}));
    connect(t_Drive_to_SC.outPort,SC_Replenish.inPort[1]) annotation(Line(points = {{300,23.41},{300,0},{338.35,0}},color = {0,0,0}));
    connect(t_Regen_to_SC.outPort,SC_Replenish.inPort[2]) annotation(Line(points = {{301.59,-50},{319.97,-50},{319.97,0},{338.35,0}},color = {0,0,0}));
    connect(t_SC_to_Drive.outPort,Drive.inPort[4]) annotation(Line(points = {{350,26.59},{350,66.59},{82.35,66.59},{82.35,50},{88.35,50}},color = {0,0,0}));
 
  // 어떤 상���든 Fault 조건����� true이면 Fault로
  // Any -> Fault
    connect(t_Idle_to_Fault.condition,faultAny)     annotation(Line(points = {{25,-272.71},{25,-279.67},{-213.83,-279.67},{-213.83,-250},{-250,-250}},color = {255,0,255}));
    connect(t_DC_to_Fault.condition,faultAny)       annotation(Line(points = {{125,-182.71},{125,-219.73},{-214.79,-219.73},{-214.79,-250},{-250,-250}},color = {255,0,255}));
    connect(t_Drive_to_Fault.condition,faultAny)    annotation(Line(points = {{125,-122.71},{125,-136.76},{-214.79,-136.76},{-214.79,-250},{-250,-250}},color = {255,0,255}));
    connect(t_Regen_to_Fault.condition,faultAny)    annotation(Line(points = {{300,-182.71},{300,-216.35},{-214.31,-216.35},{-214.31,-250},{-250,-250}},color = {255,0,255}));
    connect(faultAny,t_SC_to_Fault.condition)       annotation(Line(points = {{-250,-250},{-214.3,-250},{-214.3,-237.36},{375,-237.36},{375,-222.71}},color = {255,0,255}));
    connect(t_Pre_to_Fault.condition,faultAny) annotation(Line(points = {{75,-92.71},{75,-171.35},{-157.29,-171.35},{-157.29,-250},{-250,-250}},color = {255,0,255}));
    //  Fault -> Idle
      // Fault -> Idle: clearFault
    connect(clearFault,t_Fault_to_Idle.condition)   annotation(Line(points = {{-250,-300},{55,-300},{55,-252.71}},color = {255,0,255}));


    
    
  // ==== 전이 조건 ====  
        // Idle -> Pre: plugIn AND NOT driveDemand  (원하시면 조건 단순화/변경 가능)
  //canStartPre.u1 = plugIn;
  //canStartPre.u2 = not driveDemand;
    connect(canStartPre.u1,plugIn) annotation(Line(points = {{-162.71,50},{-206.35500000000002,50},{-206.35500000000002,0},{-250,0}},color = {255,0,255}));
    connect(notDriveDemand.u,driveDemand) annotation(Line(points = {{-197.8,41.47},{-224.02,41.47},{-224.02,-50},{-250.25,-50}},color = {255,0,255}));
    connect(notDriveDemand.y,canStartPre.u2) annotation(Line(points = {{-173.44,41.47},{-162.71,41.53}},color = {255,0,255}));
    // Idle -> Drive: driveDemand AND NOT plugIn
   //idle_to_drive_ok.u1 = driveDemand;
  //idle_to_drive_ok.u2 = notPlugIn.y;
    connect(driveDemand,idle_to_drive_ok.u1) annotation(Line(points = {{-250.25,-50},{-170.58,-50},{-170.58,100},{-162.71,100}},color = {255,0,255}));
    connect(notPlugIn.y,idle_to_drive_ok.u2) annotation(Line(points = {{-188.35,0},{-170.14,0},{-170.14,91.53},{-162.71,91.53}},color = {255,0,255}));
  // Idle -> DC: plugIn AND dcChargeAllowed
  //idle_to_dc_ok.u1 = plugIn;
  //idle_to_dc_ok.u2 = dcChargeAllowed;
    connect(plugIn,idle_to_dc_ok.u1) annotation(Line(points = {{-250,0},{-223.68,0},{-223.68,150},{-162.71,150}},color = {255,0,255}));
    connect(dcChargeAllowed,idle_to_dc_ok.u2) annotation(Line(points = {{-250,150.56},{-205.04,150.56},{-205.04,141.53},{-162.71,141.53}},color = {255,0,255}));
  
    // Pre -> Idle: (NOT plugIn) OR (NOT contactorsOK)
  // 간단화를 위해 AND 블록 하나로 (부울식 바꾸려면 Or 블록 사용 가능)
  // 여기서는 예시로 "plug out" 만으로 복귀
  // Pre -> Idle: plugOut 상태 (예시)
 // goIdleFromPre_aux.u1 = notPlugIn.y;
  //goIdleFromPre_aux.u2 = true;
    connect(notPlugIn.y,goIdleFromPre_aux.u1) annotation(Line(points = {{-188.35,0},{-171.57,0},{-171.57,200},{-162.71,200}},color = {255,0,255}));
    connect(goIdleFromPre_aux.u2,booleanConstant.y) annotation(Line(points = {{-162.71,191.53},{-162.71,178.52},{-191.48,178.52}},color = {255,0,255}));
    
      // Pre -> Drive: prechargeOK & contactorsOK & NOT plugIn  
  // Pre -> Drive: 프리차지 완료 & 컨택�� OK & plugOut
  //preDone_goDrive.u1 = prechargeOK and contactorsOK;
  //preDone_goDrive.u2 = notPlugIn.y;
    connect(ContactNPrecharge.u1,contactorsOK) annotation(Line(points = {{-216.19,229.16},{-233.095,229.16},{-233.095,100},{-250,100}},color = {255,0,255}));
    connect(ContactNPrecharge.u2,prechargeOK) annotation(Line(points = {{-216.19,220.69},{-233.095,220.69},{-233.095,50},{-250,50}},color = {255,0,255}));
    connect(ContactNPrecharge.y,preDone_goDrive.u1) annotation(Line(points = {{-191.83,229.16},{-177.27,229.16},{-177.27,250},{-162.71,250}},color = {255,0,255}));
    connect(notPlugIn.y,preDone_goDrive.u2) annotation(Line(points = {{-188.35,0},{-169.57,0},{-169.57,241.53},{-162.71,241.53}},color = {255,0,255}));
    
      // Pre -> DC: prechargeOK & contactorsOK & plugIn & dcChargeAllowed
      // Pre -> DC: 프리차지 완��� & 컨택터 OK & plugIn & 충전 승인
     // preDone_goDC.u1 = prechargeOK and contactorsOK;
     // preDone_goDC.u2 = plugIn and dcChargeAllowed;
    connect(ContactNPrecharge.y,preDone_goDC.u1) annotation(Line(points = {{-191.83,229.16},{-177.27,229.16},{-177.27,300},{-162.71,300}},color = {255,0,255}));
    connect(PlugInNdeChargeAllowed.u1,plugIn) annotation(Line(points = {{-215.31,276.83},{-232.655,276.83},{-232.655,0},{-250,0}},color = {255,0,255}));
    connect(PlugInNdeChargeAllowed.u2,dcChargeAllowed) annotation(Line(points = {{-215.31,268.36},{-227.41,268.36},{-227.41,150.56},{-250,150.56}},color = {255,0,255}));
    connect(PlugInNdeChargeAllowed.y,preDone_goDC.u2) annotation(Line(points = {{-190.95,276.83},{-178.04,276.83},{-178.04,291.53},{-162.71,291.53}},color = {255,0,255}));
    
     // Drive <-> Regen
      // Drive -> Regen: regenDemand
  // Regen -> Drive: driveDemand
  //regen_to_drive_ok.u1 = driveDemand;
  //regen_to_drive_ok.u2 = true;
    connect(driveDemand,regen_to_drive_ok.u1) annotation(Line(points = {{-250.25,-50},{-229.32,-50},{-229.32,400},{-162.71,400}},color = {255,0,255}));
    connect(booleanConstant.y,regen_to_drive_ok.u2) annotation(Line(points = {{-191.48,178.52},{-179.97,178.52},{-179.97,391.53},{-162.71,391.53}},color = {255,0,255}));
    // Drive/Regen -> SC 보충
    // SC -> Drive: ������� ������ ��음
    //  sc_to_drive_ok.u1 = not needSCReplenish;
    //  sc_to_drive_ok.u2 = true;
    connect(Not_SCReplenish.u,needSCReplenish) annotation(Line(points = {{-214.45,329.76},{-232.225,329.76},{-232.225,-150},{-250,-150}},color = {255,0,255}));
    connect(Not_SCReplenish.y,sc_to_drive_ok.u1) annotation(Line(points = {{-190.09,329.76},{-176.4,329.76},{-176.4,350},{-162.71,350}},color = {255,0,255}));
    connect(booleanConstant.y,sc_to_drive_ok.u2) annotation(Line(points = {{-191.48,178.52},{-176.57,178.52},{-176.57,341.53},{-162.71,341.53}},color = {255,0,255}));
    connect(sc_to_drive_ok.y,t_SC_to_Drive.condition) annotation(Line(points = {{-138.35,350},{368.71,350},{368.71,25},{362.71,25}},color = {255,0,255}));
    
    
  // ==== 상태 플래그 & 모드 코드 ====
  isIdle        = Idle.active;
  isPrecharge   = Precharge.active;
  isDrive       = Drive.active;
  isRegen       = Regen.active;
  isDCCharge    = DCCharge.active;
  isSCReplenish = SC_Replenish.active;
  isFault       = Fault.active;

  mode = if isFault then 9
     else if isDCCharge then 4
     else if isRegen then 3
     else if isDrive then 2
     else if isPrecharge then 1
     else if isSCReplenish then 5
     else 0;
    
end HESS_StateGraph_Core;
