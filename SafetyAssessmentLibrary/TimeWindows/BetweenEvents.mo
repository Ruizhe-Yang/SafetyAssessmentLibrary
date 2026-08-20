within SafetyAssessmentLibrary.TimeWindows;
block BetweenEvents "Canonical reusable start/stop event domain"
  extends BaseClasses.PartialTimeWindow;
  Modelica.Blocks.Interfaces.BooleanInput startTrigger annotation(Placement(transformation(extent={{-120,30},{-100,50}}), iconTransformation(extent={{-110,30},{-90,50}})));
  Modelica.Blocks.Interfaces.BooleanInput stopTrigger annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}), iconTransformation(extent={{-110,-50},{-90,-30}})));
protected
  discrete Boolean activeState(start=false,fixed=true);
initial equation
  pre(startTrigger)=startTrigger;
  pre(stopTrigger)=stopTrigger;
equation
  when initial() then
    activeState=startTrigger and not stopTrigger;
  elsewhen {edge(startTrigger),edge(stopTrigger)} then
    activeState=if edge(stopTrigger) then false else if edge(startTrigger) then true else pre(activeState);
  end when;
  window.active=activeState;
  window.configurationValid=true;
  window.invalidReason=BaseClasses.InvalidReason.None;
  annotation(Icon(graphics={Text(extent={{-86,54},{86,28}}, textString="BETWEEN", textColor={90,70,140})}), Documentation(info="<html><p>Canonical replacement for the duplicate AfterUntil and StartStop blocks. Rising stop has priority for simultaneous edges.</p></html>"));
end BetweenEvents;