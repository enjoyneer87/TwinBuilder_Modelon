
model paper_SCapPack
  extends .Electrification.Batteries.Templates.BatteryPackLumped(
    ns=86,
    np=2,
    fixed_temperature = true,redeclare replaceable .HESS.SCap_Core_TABULAR_Ideal_2nd_Frompaper core,
    redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIdeal electrical,
    redeclare replaceable .Electrification.Batteries.Thermal.Examples.Lumped thermal(C_cell=50, C_pack=0),redeclare replaceable .HESS.LimitsFixed_SCap controller
    );
end paper_SCapPack;
