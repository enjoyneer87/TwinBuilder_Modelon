within BatNSuperCap_legacy;
model BatteryPackArray_1
    extends .Electrification.Batteries.Templates.BatteryPackArray(redeclare replaceable .Electrification.Batteries.Electrical.Array.Examples.Contactors electrical);
end BatteryPackArray_1;
