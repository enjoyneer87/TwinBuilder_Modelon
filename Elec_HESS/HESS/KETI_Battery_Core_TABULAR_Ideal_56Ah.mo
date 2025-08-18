within HESS;

model KETI_Battery_Core_TABULAR_Ideal_56Ah    

  extends .Electrification.Batteries.Core.Templates.Modular(
    vCellMax=4.3,
    vCellMin=3.0,
    np = np,ns = ns,
     // capacity 
    redeclare replaceable .Electrification.Batteries.Core.Capacity.Ideal capacity(Q_cap_cell_nom=201600), // 56Ah 
    // OCV Table 
    redeclare replaceable .Electrification.Batteries.Core.OCV.TableThermal voltage(
        ref_SoC_0 = 0,      
        ref_SoC_1=1,
        cellOCV_table =   
    [0.000000e+00, 298.150000 ,   308.150000,   318.150000;      //Temperature [K]
        3.000000e-02, 3.260600e+00 ,3.254100e+00,   3.237600e+00;
        6.000000e-02, 3.414000e+00 ,3.408900e+00,   3.398600e+00;
        9.000000e-02, 3.457500e+00 ,3.458000e+00,   3.457000e+00;
        1.200000e-01, 3.471300e+00 ,3.471300e+00,   3.470400e+00;
        1.500000e-01, 3.523700e+00 ,3.522900e+00,   3.520300e+00;
        3.000000e-01, 3.613300e+00 ,3.615600e+00,   3.616800e+00;
        4.500000e-01, 3.662500e+00 ,3.665100e+00,   3.666900e+00;
        6.000000e-01, 3.794800e+00 ,3.796700e+00,   3.797400e+00;
        7.500000e-01, 3.945100e+00 ,3.946700e+00,   3.946500e+00;
        9.000000e-01, 4.072800e+00 ,4.073300e+00,   4.072700e+00;
        9.300000e-01, 4.111300e+00 ,4.112000e+00,   4.111000e+00;
        9.600000e-01, 4.151800e+00 ,4.152400e+00,   4.151500e+00;
        9.900000e-01, 4.195400e+00 ,4.196000e+00,   4.195600e+00
    ],tableTempUnit = Modelon.Types.TempUnit.Kelvin
    ),
    redeclare replaceable .Electrification.Batteries.Core.Impedance.Dynamic2ndTabular impedance(
    R0_table = 
      // Data for KETI Battery Core Rs Table
    [0.000000e+00, 298.150000 ,   308.150000,   318.150000;      //Temperature [K]
    3.000000e-02, 1.872835e-03, 1.624395e-03, 1.515995e-03;
    6.000000e-02, 1.808707e-03, 1.572639e-03, 1.470547e-03;
    9.000000e-02, 1.763922e-03, 1.551739e-03, 1.447977e-03;
    1.200000e-01, 1.733237e-03, 1.518387e-03, 1.427747e-03;
    1.500000e-01, 1.676521e-03, 1.483112e-03, 1.410792e-03;
    3.000000e-01, 1.618346e-03, 1.439963e-03, 1.371095e-03;
    4.500000e-01, 1.595280e-03, 1.429501e-03, 1.357507e-03;
    6.000000e-01, 1.589607e-03, 1.421924e-03, 1.359726e-03;
    7.500000e-01, 1.580833e-03, 1.422276e-03, 1.362481e-03;
    9.000000e-01, 1.587627e-03, 1.413123e-03, 1.346115e-03;
    9.300000e-01, 1.579376e-03, 1.414779e-03, 1.337439e-03;
    9.600000e-01, 1.574701e-03, 1.403469e-03, 1.338547e-03;
    9.900000e-01, 1.560314e-03, 1.392714e-03, 1.333822e-03
    ],
    R1_table =
    [0.000000e+00, 298.150000 ,   308.150000,   318.150000;      //Temperature [K]
    3.000000e-02, 2.447042e-03, 1.422997e-03, 1.054370e-03;
    6.000000e-02, 1.570703e-03, 1.131760e-03, 9.188304e-04;
    9.000000e-02, 1.197828e-03, 9.186616e-04, 8.657007e-04;
    1.200000e-01, 9.989685e-04, 8.348743e-04, 7.726394e-04;
    1.500000e-01, 1.044312e-03, 9.564878e-04, 8.236010e-04;
    3.000000e-01, 6.254261e-04, 8.451799e-04, 6.778905e-04;
    4.500000e-01, 8.206444e-04, 7.814325e-04, 7.971858e-04;
    6.000000e-01, 8.140708e-04, 8.080259e-04, 7.394437e-04;
    7.500000e-01, 7.134779e-04, 5.768017e-04, 4.742416e-04;
    9.000000e-01, 7.342587e-04, 5.864293e-04, 6.878821e-04;
    9.300000e-01, 6.663595e-04, 6.212866e-04, 6.183215e-04;
    9.600000e-01, 6.429451e-04, 5.973119e-04, 5.626944e-04;
    9.900000e-01, 5.569849e-04, 5.182837e-04, 4.611212e-04
    ],
       // Data for KETI Battery Core C1 Table
    C1_table=
    [0.000000e+00, 298.150000 ,   308.150000,   318.150000;      //Temperature [K]
    3.000000e-02, 2.336172e+03, 6.777515e+03, 1.059697e+04;
    6.000000e-02, 4.357307e+03, 9.679760e+03, 1.311987e+04;
    9.000000e-02, 7.018780e+03, 1.080704e+04, 1.414417e+04;
    1.200000e-01, 8.313901e+03, 1.140659e+04, 1.405693e+04;
    1.500000e-01, 8.249087e+03, 1.305118e+04, 1.544458e+04;
    3.000000e-01, 2.363232e+04, 2.682024e+04, 2.376483e+04;
    4.500000e-01, 2.220244e+04, 2.438495e+04, 2.932131e+04;
    6.000000e-01, 2.292081e+04, 2.615972e+04, 2.603091e+04;
    7.500000e-01, 1.292289e+04, 1.107101e+04, 1.046948e+04;
    9.000000e-01, 1.371117e+04, 1.172823e+04, 1.603426e+04;
    9.300000e-01, 1.326310e+04, 1.423360e+04, 1.655660e+04;
    9.600000e-01, 1.474319e+04, 1.605623e+04, 1.825788e+04;
    9.900000e-01, 1.579439e+04, 1.691570e+04, 1.782504e+04
    ],

    // Data for KETI Battery Core R2 Table
    R2_table=
    [0.000000e+00, 298.150000 ,   308.150000,   318.150000;      //Temperature [K]
    3.000000e-02, 2.899155e-03, 2.246457e-03, 1.960050e-03;
    6.000000e-02, 2.192447e-03, 1.647496e-03, 1.302513e-03;
    9.000000e-02, 3.121442e-03, 2.476145e-03, 1.856812e-03;
    1.200000e-01, 2.373586e-03, 1.786015e-03, 1.378066e-03;
    1.500000e-01, 1.331568e-03, 9.404784e-04, 7.142121e-04;
    3.000000e-01, 2.534521e-03, 1.796011e-03, 1.219288e-03;
    4.500000e-01, 1.672694e-03, 1.276118e-03, 9.736416e-04;
    6.000000e-01, 9.162371e-04, 6.541277e-04, 5.032941e-04;
    7.500000e-01, 1.886178e-03, 1.621825e-03, 1.356877e-03;
    9.000000e-01, 1.223164e-03, 8.699639e-04, 6.974393e-04;
    9.300000e-01, 1.138986e-03, 8.083451e-04, 6.281841e-04;
    9.600000e-01, 1.069747e-03, 7.906439e-04, 5.889055e-04;
    9.900000e-01, 1.009628e-03, 7.557083e-04, 5.717623e-04
    ],

    // Data for KETI Battery Core C2 Table
    C2_table=
    [0.000000e+00, 298.150000 ,   308.150000,   318.150000;      //Temperature [K]
    3.000000e-02, 5.705628e+04, 1.024583e+05, 1.349575e+05;
    6.000000e-02, 6.140909e+04, 1.182119e+05, 1.745968e+05;
    9.000000e-02, 4.605839e+04, 5.851566e+04, 8.353931e+04;
    1.200000e-01, 5.210580e+04, 6.515615e+04, 8.226233e+04;
    1.500000e-01, 9.042505e+04, 1.588267e+05, 2.026856e+05;
    3.000000e-01, 7.995246e+04, 1.185663e+05, 1.338692e+05;
    4.500000e-01, 1.030074e+05, 1.323853e+05, 1.941136e+05;
    6.000000e-01, 2.039551e+05, 3.314338e+05, 4.273869e+05;
    7.500000e-01, 1.117931e+05, 1.159134e+05, 1.206234e+05;
    9.000000e-01, 1.041175e+05, 9.619967e+04, 2.582847e+05;
    9.300000e-01, 9.939141e+04, 1.431798e+05, 2.341501e+05;
    9.600000e-01, 1.160950e+05, 1.615641e+05, 2.513323e+05;
    9.900000e-01, 1.100750e+05, 1.474430e+05, 1.785941e+05
    ],

    tableTempUnit = Modelon.Types.TempUnit.Kelvin),
    // selfDischarge x
    redeclare replaceable .Electrification.Batteries.Core.SelfDischarge.None selfDischarge,
    // aging x

    redeclare replaceable .Electrification.Batteries.Core.Aging.Examples.None aging);
  annotation (Documentation(revisions="<html>Copyright &copy; 2025, MoaSoftware <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p> KETI 배터리 셀의 Table 모델입니다. 
Table 데이터는 OCV(개방 회로 전압)와 SOC(충전 상태)에 따른 임피던스의 변화를 캡처합니다. 
임피던스 매개변수는 상온에서 측정되었습니다. 
이 모델은 주로 0.5초에서 30초 사이의 시간 상수로 임피던스 동역학을 캡처합니다. 
더 느린 이완 역학은 캡처되지 않습니다. 그리고 더 빠른 동역학은 순수 저항으로 가정합니다.</p>
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

end KETI_Battery_Core_TABULAR_Ideal_56Ah;
