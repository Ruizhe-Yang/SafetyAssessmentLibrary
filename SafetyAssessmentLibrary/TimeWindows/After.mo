within SafetyAssessmentLibrary.TimeWindows;
block After "Active permanently after first rising trigger"
  extends BaseClasses.PartialTimeWindow;
  Modelica.Blocks.Interfaces.BooleanInput startTrigger annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
protected
  discrete Boolean started(start=false,fixed=true);
initial equation
  pre(startTrigger)=startTrigger;
equation
  when initial() then
    started=startTrigger;
  elsewhen edge(startTrigger) then
    started=true;
  end when;
  window.active=started;
  window.configurationValid=true;
  window.invalidReason=BaseClasses.InvalidReason.None;
  annotation(Icon(graphics={Text(extent={{-70,54},{70,28}}, textString="AFTER", textColor={90,70,140})}), Documentation(info="<html><p>Single-latch post-event time domain. It never resets.</p></html>"));
end After;