within HESS;
model SCap_Core_TABULAR_Ideal_2nd_Frompaper    

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
        ]
        ),
    // Dynamic1stTabular impedance Table 
      redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic2ndTabular impedance(
      R0_table = [
          0, -20, 0, 25, 45;
          0.2, 9.205e-4, 9.052e-4, 1.284e-3, 1.270e-3;
          0.3, 9.119e-4, 8.930e-4, 1.282e-3, 1.267e-3;
          0.4, 9.035e-4, 8.871e-4, 1.274e-3, 1.266e-3;
          0.5, 9.046e-4, 8.924e-4, 1.273e-3, 1.269e-3;
          0.6, 9.101e-4, 9.033e-4, 1.278e-3, 1.268e-3;
          0.7, 9.435e-4, 9.229e-4, 1.271e-3, 1.259e-3;
          0.8, 9.640e-4, 9.568e-4, 1.258e-3, 1.253e-3;
          0.9, 1.004e-3, 9.753e-4, 1.272e-3, 1.248e-3;
          1.0, 1.041e-3, 1.010e-3, 1.263e-3, 1.254e-3
      ],
      R1_table = [
          0, -20, 0, 25, 45;
          0.2, 4.561e-1, 2.804e-1, 2.072, 6.721e-1;
          0.3, 4.159e-1, 1.807e-1, 1.449, 5.016e-1;
          0.4, 3.765e-1, 1.157e-1, 1.057, 4.473e-1;
          0.5, 3.330e-1, 8.059e-2, 7.779e-1, 4.362e-1;
          0.6, 2.840e-1, 6.139e-2, 5.325e-1, 4.329e-1;
          0.7, 2.365e-1, 5.109e-2, 3.194e-1, 4.275e-1;
          0.8, 1.893e-1, 4.719e-2, 1.676e-1, 3.960e-1;
          0.9, 1.355e-1, 4.662e-2, 1.064e-1, 3.407e-1;
          1.0, 8.579e-2, 4.592e-2, 1.070e-1, 2.278e-1
      ],
      R2_table = [
          0, -20, 0, 25, 45;
          0.2, 1.030e-4, 7.409e-5, 8.607e-5, 7.579e-5;
          0.3, 1.045e-4, 7.980e-5, 8.792e-5, 7.387e-5;
          0.4, 1.117e-4, 8.359e-5, 9.297e-5, 7.161e-5;
          0.5, 1.126e-4, 8.315e-5, 9.310e-5, 6.765e-5;
          0.6, 1.234e-4, 8.460e-5, 9.034e-5, 6.737e-5;
          0.7, 1.153e-4, 9.278e-5, 9.733e-5, 7.741e-5;
          0.8, 1.098e-4, 8.186e-5, 1.091e-4, 8.924e-5;
          0.9, 8.862e-5, 8.137e-5, 1.046e-4, 1.001e-4;
          1.0, 4.859e-5, 7.517e-5, 1.145e-4, 9.724e-5
      ],
      C1_table = [
          0, -20, 0, 25, 45;
          0.2, 5.8582e4, 4.7992e4, 2.4378e4, 3.1222e4;
          0.3, 5.9159e4, 4.8847e4, 2.5422e4, 3.2466e4;
          0.4, 5.9754e4, 4.8118e4, 2.6371e4, 3.3584e4;
          0.5, 5.9782e4, 4.6573e4, 2.7115e4, 3.4481e4;
          0.6, 5.9294e4, 4.4745e4, 2.7530e4, 3.5288e4;
          0.7, 5.8145e4, 4.3273e4, 2.8094e4, 3.5978e4;
          0.8, 5.6125e4, 4.3098e4, 2.8614e4, 3.6514e4;
          0.9, 5.3095e4, 4.3113e4, 2.8753e4, 3.6912e4;
          1.0, 4.7274e4, 3.9139e4, 2.8367e4, 3.6371e4
      ],
      C2_table = [
          0, -20, 0, 25, 45;
          0.2, 2.923e3, 3.262e3, 2.410e3, 5.133e3;
          0.3, 2.964e3, 2.936e3, 2.375e3, 5.338e3;
          0.4, 2.845e3, 2.805e3, 2.266e3, 5.612e3;
          0.5, 2.912e3, 2.837e3, 2.290e3, 6.074e3;
          0.6, 2.742e3, 2.768e3, 2.398e3, 6.263e3;
          0.7, 3.057e3, 2.467e3, 2.277e3, 5.560e3;
          0.8, 3.385e3, 2.817e3, 2.122e3, 4.950e3;
          0.9, 4.679e3, 2.812e3, 2.379e3, 4.544e3;
          1.0, 1.0545e4, 3.243e3, 2.422e3, 4.807e3
      ]
  ),
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
<p>Henry Miniguano (2021), <em>Li-Ion Battery and Supercapacitor Modeling for Electric Vehicles Based on Pulse – Pseudo Random Binary Sequence, V1<br />
<a href=\"https://ieeexplore.ieee.org/abstract/document/9537627/?casa_token=qZC2vWPOBSkAAAAA:hJUsiKxSNuj-2m9JgxYCntMcoONHODQYrqsfGdkYQcwiknzvZJAzcUzZdSv7t5vJurMH_2xMkrhJjgE</a></p>
</html>")); 

end SCap_Core_TABULAR_Ideal_2nd_Frompaper;
