within SafetyAssessmentLibrary.Examples.Systems;
model CubeSatSystem "Coupled CubeSat-like power, thermal, and attitude demonstrator"
  replaceable NoFault fault constrainedby PartialFaultBehavior 
    annotation(choicesAllMatching=true, Placement(transformation(extent={{-20,-70},{20,-30}})));
  parameter Real initialSOC=0.78;
  parameter Real baseDischargeRate(unit="1/s")=0.00125;
  parameter Modelica.Units.SI.Time thermalTimeConstant=24;
  parameter Modelica.Units.SI.Time rateTimeConstantX=6;
  parameter Modelica.Units.SI.Time rateTimeConstantY=8;
  parameter Modelica.Units.SI.Time rateTimeConstantZ=10;
  parameter Real nominalBusVoltage(unit="V")=28.4;
  parameter Real loadVoltageGain(unit="V")=1.15;
  parameter Real maneuverVoltageGain(unit="V")=0.35;
  parameter Real ambientTemperature(unit="degC")=23;
  parameter Real loadTemperatureGain(unit="K")=15;
  parameter Real maneuverTemperatureGain(unit="K")=3;
  parameter Real maneuverRateGainX(unit="rad/s")=0.018;
  parameter Real maneuverRateGainY(unit="rad/s")=-0.012;
  parameter Real maneuverRateGainZ(unit="rad/s")=0.010;
  Real batterySOC(start=initialSOC, fixed=true) "Public battery state for Scenario binding";
  Real busVoltage(unit="V") "Public bus state for Scenario binding";
  Real equipmentTemperature(unit="degC", start=27, fixed=true) "Coupled thermal state";
  Real bodyRateX(unit="rad/s", start=0, fixed=true) "Public body-rate x observation";
  Real bodyRateY(unit="rad/s", start=0, fixed=true) "Public body-rate y observation";
  Real bodyRateZ(unit="rad/s", start=0, fixed=true) "Public body-rate z observation";
  Real missionLoad(unit="1") "Shared dimensionless power demand profile";
  Real maneuverCommand(unit="1") "Shared dimensionless attitude maneuver task";
  Boolean maneuverTrigger "Public maneuver-start pulse";
  Boolean faultTrigger "Public fault event state";
  Boolean faultActive "Compatibility alias";
equation
  maneuverCommand=if time >= 60 and time < 130 then 1 else 0;
  maneuverTrigger=time >= 60 and time < 60.2;
  missionLoad=0.55 + (if time >= 35 and time < 145 then 0.30 else 0.08)
    + 0.12*maneuverCommand;
  der(batterySOC)=-baseDischargeRate*missionLoad*(1 + fault.dischargeMultiplier);
  busVoltage=nominalBusVoltage - loadVoltageGain*missionLoad
    - maneuverVoltageGain*maneuverCommand - fault.voltageDrop;
  der(equipmentTemperature)=(ambientTemperature + loadTemperatureGain*missionLoad
    + maneuverTemperatureGain*maneuverCommand
    + fault.heatAddition - equipmentTemperature)/thermalTimeConstant;
  der(bodyRateX)=(maneuverRateGainX*maneuverCommand
    + fault.rateDisturbance - bodyRateX)/rateTimeConstantX;
  der(bodyRateY)=(maneuverRateGainY*maneuverCommand
    + 0.65*fault.rateDisturbance - bodyRateY)/rateTimeConstantY;
  der(bodyRateZ)=(maneuverRateGainZ*maneuverCommand
    + 0.45*fault.rateDisturbance - bodyRateZ)/rateTimeConstantZ;
  faultTrigger=fault.active;
  faultActive=faultTrigger;
  annotation(
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,80},{100,-80}}, radius=10, lineColor={60,90,130},
        fillColor={235,245,255}, fillPattern=FillPattern.Solid),
      Text(extent={{-80,42},{80,4}}, textString="M", textColor={60,90,130}, textStyle={TextStyle.Bold}),
      Text(extent={{-88,-12},{88,-44}}, textString="PWR / TH / ATT", textColor={70,70,70})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(StopTime=200, Interval=0.1),
    Documentation(info="<html><p><b>Purpose:</b> provide a small but dynamically coupled behavioral demonstrator for the NISSA Scenario.</p><p><b>Coupling:</b> a common maneuver raises attitude rates and electrical load; load changes bus voltage, SOC depletion, and equipment temperature; a scheduled fault adds voltage loss, faster discharge, heat, and persistent attitude disturbance.</p><p><b>Observations:</b> batterySOC, busVoltage, bodyRateX/Y/Z, maneuverTrigger, and faultTrigger are ordinary public variables. They are not assessment connectors.</p><p><b>Reuse:</b> NominalSystem and FaultedSystem share all equations and differ only by redeclaring the replaceable fault behavior.</p><p><b>Limitations:</b> illustrative lumped dynamics, not a flight design or certification model.</p></html>"));
end CubeSatSystem;