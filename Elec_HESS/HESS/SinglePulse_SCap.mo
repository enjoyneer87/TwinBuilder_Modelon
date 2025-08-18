within HESS;
model SinglePulse_SCap
    extends .Electrification.Batteries.Experiments.Verification.SinglePulse(redeclare replaceable .HESS.KETI_SCapPack batteryPack);
end SinglePulse_SCap;
