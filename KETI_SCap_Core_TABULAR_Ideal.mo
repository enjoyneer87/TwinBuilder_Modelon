model KETI_SCap_Core_TABULAR_Ideal    

  extends .Electrification.Batteries.Core.Templates.Modular(
    vCellMax=2.91,
    vCellMin=0.79,
    np = np,ns = ns,
     // capacity 
    redeclare replaceable .Electrification.Batteries.Core.Capacity.Ideal capacity(Q_cap_cell_nom=13200),
    // OCV Table 
    redeclare replaceable .Electrification.Batteries.Core.OCV.Table voltage(
        ref_SoC_0 = 0,      
        ref_SoC_1=1,
        cellOCV_table = [
          0.00, 0.000;
          0.05, 0.135;
          0.10, 0.270;
          0.15, 0.405;
          0.20, 0.540;
          0.25, 0.675;
          0.30, 0.810;
          0.35, 0.945;
          0.40, 1.080;
          0.45, 1.215;
          0.50, 1.350;
          0.55, 1.485;
          0.60, 1.620;
          0.65, 1.755;
          0.70, 1.890;
          0.75, 2.025;
          0.80, 2.160;
          0.85, 2.295;
          0.90, 2.430;
          0.95, 2.565;
          1.00, 2.700
        ],
        interpolation_method=Modelon.Blocks.Interpolation.Types.Method.Numerical,
        interpolation_degree=1),
    // Dynamic1stTabular impedance Table 
    redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic1stTabular impedance(
        R0_table = [
          0.00, 0.310000;
          0.05, 0.308750;
          0.10, 0.307500;
          0.15, 0.306250;
          0.20, 0.305000;
          0.25, 0.303750;
          0.30, 0.302500;
          0.35, 0.301250;
          0.40, 0.300000;
          0.45, 0.298750;
          0.50, 0.297500;
          0.55, 0.296250;
          0.60, 0.295000;
          0.65, 0.293750;
          0.70, 0.292500;
          0.75, 0.291250;
          0.80, 0.290000;
          0.85, 0.288750;
          0.90, 0.287500;
          0.95, 0.286250;
          1.00, 0.285000
        ],
        R1_table = [
          0.00, 0.002600;
          0.05, 0.002550;
          0.10, 0.002500;
          0.15, 0.002450;
          0.20, 0.002400;
          0.25, 0.002350;
          0.30, 0.002300;
          0.35, 0.002250;
          0.40, 0.002200;
          0.45, 0.002150;
          0.50, 0.002100;
          0.55, 0.002050;
          0.60, 0.002000;
          0.65, 0.001950;
          0.70, 0.001900;
          0.75, 0.001850;
          0.80, 0.001800;
          0.85, 0.001750;
          0.90, 0.001700;
          0.95, 0.001650;
          1.00, 0.001600
        ],
        C1_table = [
          0.00,   8000;
          0.05,   8265;
          0.10,   8530;
          0.15,   8795;
          0.20,   9060;
          0.25,   9325;
          0.30,   9590;
          0.35,   9855;
          0.40,  10120;
          0.45,  10385;
          0.50,  10650;
          0.55,  10915;
          0.60,  11180;
          0.65,  11445;
          0.70,  11710;
          0.75,  11975;
          0.80,  12240;
          0.85,  12505;
          0.90,  12770;
          0.95,  13035;
          1.00,  13300
        ],
        interpolation_method = Modelon.Blocks.Interpolation.Types.Method.Numerical,interpolation_degree = 1),
    // selfDischarge x
    redeclare replaceable .Electrification.Batteries.Core.SelfDischarge.None selfDischarge,
    // aging x

    redeclare replaceable .Electrification.Batteries.Core.Aging.Examples.None aging);
  annotation (Documentation(revisions="<html>Copyright &copy; 2025, MoaSoftware <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p> KETI 슈퍼커패시터 셀의 Table 모델입니다. 
Table 데이터는 OCV(개방 회로 전압)와 SOC(충전 상태)에 따른 임피던스의 변화를 캡처합니다. 
임피던스 매개변수는 상온에서 측정되었습니다. 
이 모델은 주로 0.5초에서 30초 사이의 시간 상수로 임피던스 동역학을 캡처합니다. 
더 느린 이완 역학은 캡처되지 않습니����. 그리고 더 빠른 동역학은 순수 저항으로 가정합니다.</p>
<p>This model has been parametrized based on lab data (see <em>References</em>) according to the following procedure:</p>
<ul>
<li>OCV는 주로 저속(C/20) 방전(이 정상 전류에서 작은 전압 강하에 대한 보정 포함)에서 확인되었습니다.</li>
<li>The steady state resistance (R0+R1+R2) has been identified from a 1C discharge, based on the voltage drop from OCV (and used for correcting the OCV).</li>
<li>The RC elements of the impedance has been mainly fit from pulse test data (HPPC). These two time constants mainly fit the fast part of the constant phase region (frequency domain).</li>
<li>At low SOC, the faster time constant has been calibrated to match the EIS (<em>Electrochemical Impedence Spectroscopy</em>) data.</li>
<li>The voltage limits have been adjusted to a smaller charge window than the lab data, corresponding to a nominal 2.75 Ah (instead of the 2.9 Ah of the lab data). The SOC window of the OCV and impedance tables have been adjusted to match this range of charge (the <code>ref_SoC_#</code> parameters).</li>
</ul>
<h4>References</h4>
<p>Kollmeyer, Phillip (2018), <em>Panasonic 18650PF Li-ion Battery Data</em>, Mendeley Data, V1<br />
<a href=\"https://doi.org/10.17632/wykht8y7tg.1\">https://doi.org/10.17632/wykht8y7tg.1</a></p>
</html>")); 

end KETI_SCap_Core;
