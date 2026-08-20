within SafetyAssessmentLibrary.TimeWindows;
block FixedWindow "Start-inclusive, end-exclusive fixed domain"
  extends BaseClasses.PartialTimeWindow;
  parameter Modelica.Units.SI.Time startTime=0;
  parameter Modelica.Units.SI.Time endTime=1;
equation
  window.configurationValid=startTime <= endTime;
  window.active=window.configurationValid and time >= startTime and time < endTime;
  window.invalidReason=if window.configurationValid then BaseClasses.InvalidReason.None else BaseClasses.InvalidReason.TimeWindowConfiguration;
  annotation(Icon(graphics={Text(extent={{-94,56},{94,34}}, textString="%startTime .. %endTime", textColor={90,70,140})}), Documentation(info="<html><p>Defines [startTime,endTime). Equal endpoints form an empty but valid domain; startTime&gt;endTime is invalid.</p></html>"));
end FixedWindow;