block Thermal_ImpactCondtion
     extends .Modelica.Blocks.Sources.PeriodicTimeTable(
    table = [
      // Cycle 1
      0,       333.15;
      21600,   333.15;
      21690,   303.15;   // 60→-40 ramp, T=30C point ( +90s )
      21900,   233.15;
      43500,   233.15;
      43710,   303.15;   // -40→60 ramp, T=30C point ( +210s )
      43800,   333.15;

      // Cycle 2
      65400,   333.15;
      65490,   303.15;   // 60→-40 ramp
      65700,   233.15;
      87300,   233.15;
      87510,   303.15;   // -40→60 ramp
      87600,   333.15;

      // Cycle 3
      109800,  333.15;
      109890,  303.15;   // 60→-40 ramp
      110100,  233.15;
      131700,  233.15;
      131910,  303.15;   // -40→60 ramp
      132000,  333.15;

      // Cycle 4
      153600,  333.15;
      153690,  303.15;   // 60→-40 ramp
      153900,  233.15;
      175500,  233.15;
      175710,  303.15;   // -40→60 ramp
      175800,  333.15;

      // Cycle 5 + Ambient
      197400,  333.15;
      197490,  303.15;   // 60→-40 ramp
      197700,  233.15;
      219300,  233.15;
      219600,  295.15;   // -40→22 ramp (30C 미포함)
      306000,  295.15;   // 24h ambient end
      400000,  295.15    // Hold
    ],
    interpMethod=Modelon.Types.Interpolation.Linear
    extrapMethod=Modelon.Types.Extrapolation.LastTwoPoints);
end Thermal_ImpactCondtion;
