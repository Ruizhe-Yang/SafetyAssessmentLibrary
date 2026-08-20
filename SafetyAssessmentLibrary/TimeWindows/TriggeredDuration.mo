within SafetyAssessmentLibrary.TimeWindows;
block TriggeredDuration "Restartable duration after latest rising trigger"
  extends BaseClasses.PartialTimeWindow;
  parameter Modelica.Units.SI.Time duration(min=0)=1;
  Modelica.Blocks.Interfaces.BooleanInput startTrigger annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
protected
  discrete Boolean triggered(start=false,fixed=true);
  discrete Modelica.Units.SI.Time triggerTime(start=0,fixed=true);
initial equation
  pre(startTrigger)=startTrigger;
equation
  when initial() then
    triggered=startTrigger;
    triggerTime=if startTrigger then time else 0;
  elsewhen edge(startTrigger) then
    triggered=true;
    triggerTime=time;
  end when;
  window.configurationValid=duration >= 0;
  window.active=window.configurationValid and triggered and time >= triggerTime and time < triggerTime + duration;
  window.invalidReason=if window.configurationValid then BaseClasses.InvalidReason.None else BaseClasses.InvalidReason.TimeWindowConfiguration;
  annotation(Icon(graphics={Text(extent={{-84,54},{84,28}}, textString="TRIG %duration", textColor={90,70,140})}), Documentation(info="<html><p>Each rising edge restarts the end of the active domain.</p></html>"));
end TriggeredDuration;