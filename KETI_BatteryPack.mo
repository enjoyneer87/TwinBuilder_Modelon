model KETI_BatteryPack
  import Electrification.Batteries.*;
  extends Templates.BatteryPackLumped(
    ns=96,
    np=4,
    fixed_temperature = true,
    redeclare replaceable .HESS.KETI_Battery_Core_TABULAR_Ideal_56Ah core,
    redeclare replaceable Electrical.Pack.SymmetricIdeal electrical,
    redeclare replaceable Electrification.Batteries.Control.LimitsFixed controller(
      SoC_max=1,
      SoC_high=0.9,
      SoC_low=0.1,
      SoC_min=0),redeclare replaceable .Electrification.Batteries.Thermal.Examples.Lumped thermal);
end KETI_BatteryPack;