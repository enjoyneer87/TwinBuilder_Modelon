block EMS_ModeMux "충전/주행 모드별 참조 선택"
  // 선택적 입력 설정 (미사용 입력은 커넥터 제거, 기본값으로 대체)
  parameter Boolean useDriveInput = true "주행 입력 사용"
    annotation(Evaluate=true, Dialog(group="Options"));
  parameter Boolean useChgInput   = true "충전 입력 사용"
    annotation(Evaluate=true, Dialog(group="Options"));
  parameter Real    defaultDrive  = 0 "주행 입력 미사용시 대체값"
    annotation(Dialog(group="Options"));
  parameter Real    defaultChg    = 0 "충전 입력 미사용시 대체값"
    annotation(Dialog(group="Options"));

  Modelica.Blocks.Interfaces.BooleanInput isCharging annotation(Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput     P_drive   if useDriveInput
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput     P_chg     if useChgInput
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput    P_req_raw annotation(Placement(transformation(extent={{100,-10},{140,30}})));

equation
  // 사용 설정에 따라 커넥터가 제거되며, 제거된 경우 기본값으로 대체
  P_req_raw = if isCharging then
                (if useChgInput then P_chg else defaultChg)
              else
                (if useDriveInput then P_drive else defaultDrive);

  annotation(Documentation(info="<html><p>충전 모드에서는 <code>P_chg</code>(CCCV), 주행 모드에서는 <code>P_drive</code>(버스전압 디레이트) 참조를 선택합니다.<br/>양쪽 입력은 옵션이며, 미사용 시 커넥터가 제거되고 지정한 기본값으로 대체됩니다.</p></html>"),
    Icon(graphics={Rectangle(extent={{-100,40},{100,-40}}, lineColor={28,108,200}), Text(extent={{-90,10},{90,-10}}, textString="ModeMux")}));
end EMS_ModeMux;
