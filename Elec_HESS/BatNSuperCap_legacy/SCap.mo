within BatNSuperCap_legacy;
model SCap
    extends .Electrification.Batteries.Examples.Applications.ElectricCar(initialize_with_OCV = true,OCV_start = 0.45);
end SCap;
