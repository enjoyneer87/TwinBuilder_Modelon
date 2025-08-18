within BatNSuperCap_legacy;

model ModuleTest_1 "Rimac R&D battery module test"
  extends .Electrification.Examples.Rimac.Experiments.Templates.CyclerWithThermal(
    redeclare .Electrification.Examples.Rimac.Module.Module batteryPack(
      SOC_start=0.7, limitActionDch=.Modelon.Types.FaultAction.Nothing),
    redeclare replaceable .Electrification.Examples.Rimac.Experiments.Data.ModulePower reference,
    initialVoltage(init_start=true, v_start=batteryPack.summary.ocv),
    load(
      vMin=0,
      k_ch_v=[2.5,1; 4.1,1; 4.2,0],
      k_dch_v=[2.51,0; 2.55,1; 4.18,1; 4.2,1],
      k_dch_soc=[0.1,0; 0.15,1; 1,1],
      k_ch_soc=[0,1; 0.95,1; 1,0],
      iMaxDch=600,
      pMaxDch=50e3,
      id_battery=batteryPack.id,
      limit_factors=true,
      k_dch_temp=[
        173.15,0.0; 273.15,0.1; 283.15,0.2; 293.15,0.4; 303.15,0.8;
        308.15,1.0; 318.15,1.0; 328.15,0.5; 333.15,0.0; 373.15,0.0],
      vMax=100));

annotation (Documentation(revisions="<html>Copyright &copy; 2004-2024, MODELON AB <br /> The use of this software component is regulated by the licensing conditions for Modelon Libraries. <br />This copyright notice must, unaltered, accompany all components that are derived from, copied from, <br />or by other means have their origin from any Modelon Library.</html>", info="<html>
<p>This experiment represents a virtual lab test for the Rimac R&amp;D battery module (<a href=\"modelica://Electrification.Examples.Rimac.Module.Module\">Examples.Rimac.Module.Module</a>). The battery module is charged/discharged according to a pre-defined power cycle. The module is placed in an environment chamber, with a controlled ambient temperature. Cooling plates with circulating liquid are connected to the cell terminals.</p>
<p>The purpose of this experiment is to replicate a corresponding lab test with an actual battery module (<i>Figure 1</i>). One use case of this experiment is model validation. Another use case is to evaluate the lab test setup, including the power cycle and limits of the battery. To identify issues with the setup and inputs before exposing an actual battery module to this power cycle in the lab.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Rimac/ModuleTestLab.png\"/></p>
<p><i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Figure 1: Actual Rimac R&amp;D test module inside the climate chamber during lab test</i> </p>
<h4>Module cooling</h4>
<p>The battery module has cooling plates attached to the bus bars of the top and bottom of the battery cells, as illustrated in <i>Figure 2</i>. This thermal design is modelled in <a href=\"modelica://Electrification.Examples.Rimac.Module.ThermalModuleCommonCell\">Examples.Rimac.Module.ThermalModuleCommonCell</a>.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Rimac/ModuleCooling.png\"/></p>
<p><i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Figure 2: Illustration of cell cooling in the Rimac R&amp;D test module</i> </p>
<h4>Limited power cycle</h4>
<p>The battery module is connected to a <a href=\"modelica://Electrification.Loads.Examples.BatteryCycler\">BatteryCycler</a> load. This load component is used for discharging and charging of the battery module according to a pre-defined power cycle. In this example, the reference power cycle is specified in an external file, specified in the parameters of the BatteryCycler load component.</p>
<p>This battery module does not have a BMS system for monitoring and reporting limits. Instead, the following limits are specified directly in the BatteryCycler: </p>
<ul>
<li>Maximum power: 50 kW</li>
<li>Maximum current: 600 A</li>
<li>Maximum voltage 100 V</li>
</ul>
<p>Dynamic derating factors are also applied to the maximum power: </p>
<ul>
<li>The maximum discharge power is reduced for SOC &lt; 15 &percnt; and cell voltage &lt; 2.55 V</li>
<li>The maximum charge power is reduced for SOC &gt; 95 &percnt; and cell voltage &gt; 4.1 V</li>
</ul>
<p>The power limits are also reduced for temperatures below 35 degrees and above 45 degrees Celcius.</p>
<p><b>Note</b> that the battery module is configured to use the <a href=\"modelica://Electrification.Batteries.Control.CellSensors\">CellSensors</a> controller. This standard controller reports sensor values via the control bus to the BatteryCycler, which are used for applying the power derating factors. </p>
<h4>Initialization</h4>
<p>The <i>initialVoltage</i> component is used to initialize the system voltage to the open circuit voltage of the battery pack at the start SoC. </p>
<h4>Results</h4>
<p><i>Figure 3</i> shows the discharge power of the battery module. We can see that the actual power follows the reference for most of the cycle, except at the beginning and the end of the cycle, where the limits of the BatteryCycler are derated.</p>
<p>Looking at the state of charge in <i>Figure 4</i>, we can see that the derating at the end is due to the SoC reaching the lower limit. Most of the other derating is due to the cell temperature (<i>Figure 5</i>) initially being a bit low and later a bit high. We can also see in <i>Figure 6</i>, that there are a few moments of transient derating, when the cell voltage drops to the lower limit.</p>
<p>Finally, <i>Figure 7</i> shows the discharge current of the battery pack module, along with the maximum possible continuous discharge current based on the OCV and internal resistance of the battery. </p>
<p>&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Rimac/ModuleTest_power.png\"/></p>
<p><i>&nbsp;&nbsp;&nbsp;Figure 3: Battery discharge power reference, actual and limit.</i></p>
<p>&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Rimac/ModuleTest_SoC.png\"/></p>
<p><i>&nbsp;&nbsp;&nbsp;Figure 4: Battery state of charge, with BatteryCycler de-rating limits.</i></p>
<p>&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Rimac/ModuleTest_CellTemperature.png\"/></p>
<p><i>&nbsp;&nbsp;&nbsp;Figure 5: Battery cell temperature, with BatteryCycler de-rating limits.</i></p>
<p>&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Rimac/ModuleTest_CellVoltage.png\"/></p>
<p><i>&nbsp;&nbsp;&nbsp;Figure 6: Battery cell voltage, with BatteryCycler de-rating limits.</i></p>
<p>&nbsp;&nbsp;&nbsp;<img src=\"modelica://Electrification/Resources/Images/Rimac/ModuleTest_DischargeCurrent.png\"/></p>
<p><i>&nbsp;&nbsp;&nbsp;Figure 7: Battery module discharge current, with maximum possible continuous current limit.</i> </p>
</html>"),
      experiment(StopTime=1170, Interval=1));
end ModuleTest_1;
