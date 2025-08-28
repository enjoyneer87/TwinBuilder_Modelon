block EMS_ModeMux "충전/주행 모드별 참조 선택"
Modelica.Blocks.Interfaces.BooleanInput isCharging annotation(Placement(transformation(extent={{-140,20},{-100,60}})));
Modelica.Blocks.Interfaces.RealInput P_drive annotation(Placement(transformation(extent={{-140,-20},{-100,20}})));
Modelica.Blocks.Interfaces.RealInput P_chg annotation(Placement(transformation(extent={{-140,-60},{-100,-20}})));
Modelica.Blocks.Interfaces.RealOutput P_req_raw annotation(Placement(transformation(extent={{100,-10},{140,30}})));


equation
P_req_raw = if isCharging then P_chg else P_drive;


annotation(Documentation(info="<html><p>충전 모드에서는 <code>P_chg</code>(CCCV), 주행 모드에서는 <code>P_drive</code>(버스전압 디레이트) 참조를 선택합니다.</p></html>"),
Icon(graphics={Rectangle(extent={{-100,40},{100,-40}}, lineColor={28,108,200}), Text(extent={{-90,10},{90,-10}}, textString="ModeMux")}));
end EMS_ModeMux;