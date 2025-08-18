within HESS;
model ElectricRange_Bat_1
    import Electrification.Batteries.*;
    extends .HESS.partial_ElectricRange_Bat(
    redeclare replaceable .HESS.KETI_BatteryPack battery(
    redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIdeal electrical),
    torqueArbitration(regen_torque = 300))
    ;
end ElectricRange_Bat_1;
