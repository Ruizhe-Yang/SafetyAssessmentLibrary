within SafetyAssessmentLibrary.Examples.Systems;
model ScheduledFault "Scheduled degradation used by M_F"
  extends PartialFaultBehavior;
  parameter Modelica.Units.SI.Time faultTime=80;
  parameter Real voltageDropAfter(unit="V")=2.4;
  parameter Real dischargeMultiplierAfter=1.4;
  parameter Real heatAdditionAfter(unit="K")=24;
  parameter Real rateDisturbanceAfter(unit="rad/s")=0.11;
equation
  active=time >= faultTime;
  voltageDrop=if active then voltageDropAfter else 0;
  dischargeMultiplier=if active then dischargeMultiplierAfter else 0;
  heatAddition=if active then heatAdditionAfter else 0;
  rateDisturbance=if active then rateDisturbanceAfter else 0;
  annotation(Documentation(info="<html><p><b>Purpose:</b> introduce a deterministic parameter degradation at faultTime.</p><p><b>Usage:</b> redeclared into CubeSatSystem by FaultedSystem.</p></html>"));
end ScheduledFault;
