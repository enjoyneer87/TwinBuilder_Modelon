within HESS;

model ElectricRange_SCap
    extends .HESS.partial_ElectricRange_Bat(
    redeclare replaceable .HESS.KETI_SCapPack battery(
    redeclare replaceable .Electrification.Batteries.Electrical.Pack.SymmetricIdeal electrical,limitActionSoC = Modelon.Types.FaultAction.Error,limitActionV = Modelon.Types.FaultAction.Error,SOC_start = 0.3),vInitA(init_steady = false,init_start = true,v_start = battery.summary.ocv),machine(mechanical(ratio = 14)),chassis(m = 18),torqueArbitration(regen_torque = 1000)
    );
end ElectricRange_SCap;
