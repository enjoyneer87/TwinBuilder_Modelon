within HESS;
model KETI_SCapPack
  import Electrification.Batteries.*;
  extends Templates.BatteryPackLumped(
    ns=86,
    np=2,
    fixed_temperature = true,
    redeclare HESS.KETI_SCap_Core_TABULAR_Ideal core,
    redeclare replaceable Electrical.Pack.SymmetricIdeal electrical,
    redeclare replaceable Thermal.Examples.Lumped thermal(C_cell=50, C_pack=0),redeclare replaceable .HESS.LimitsFixed_SCap controller
    );
end KETI_SCapPack;
