within SafetyAssessmentLibrary;
package TimeWindows "Orthogonal Boolean time locators"
  extends Modelica.Icons.Package;

  block Always "Active for the complete simulation"
    extends Interfaces.PartialTimeWindow;
  equation
    active=true;
    configurationValid=true;
    annotation(Icon(graphics={Text(extent={{-70,54},{70,28}}, textString="ALL", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> monitor for the entire simulation.</p><p><b>Inputs:</b> none. <b>Outputs:</b> active=true, configurationValid=true.</p><p><b>Parameters:</b> none. <b>Usage:</b> whole-run objectives. <b>Limitation:</b> the evaluator still resolves only according to its evaluation mode.</p></html>"));
  end Always;

  block FixedWindow "Fixed start-inclusive, end-exclusive window"
    extends Interfaces.PartialTimeWindow;
    parameter Modelica.Units.SI.Time startTime=0 "Inclusive start";
    parameter Modelica.Units.SI.Time endTime=1 "Exclusive end";
  equation
    configurationValid=startTime <= endTime;
    active=configurationValid and time >= startTime and time < endTime;
    annotation(Icon(graphics={Text(extent={{-94,56},{94,34}}, textString="%startTime .. %endTime", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> select [startTime,endTime).</p><p><b>Inputs:</b> none. <b>Output:</b> active.</p><p><b>Parameters:</b> startTime, endTime. <b>Mathematical meaning:</b> active iff startTime&lt;=time&lt;endTime.</p><p><b>Usage:</b> mission phases known a priori. <b>Limitation:</b> startTime&gt;endTime is Invalid; equal endpoints form an empty valid window.</p></html>"));
  end FixedWindow;

  block During "Active while an external Boolean condition is true"
    extends Interfaces.PartialTimeWindow;
    Modelica.Blocks.Interfaces.BooleanInput condition "Externally defined phase condition"
      annotation(Placement(transformation(extent={{-120,-20},{-100,20}})));
  equation
    active=condition;
    configurationValid=true;
    annotation(Icon(graphics={Text(extent={{-70,56},{70,32}}, textString="DURING", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> expose an existing behavioral phase as a time window.</p><p><b>Input:</b> condition. <b>Output:</b> active=condition.</p><p><b>Parameters:</b> none. <b>Usage:</b> bind to a scenario mode or command read-only signal. <b>Limitation:</b> condition semantics remain the responsibility of the external scenario.</p></html>"));
  end During;

  block After "Active from the first start-trigger edge onward"
    extends Interfaces.PartialTimeWindow;
    Modelica.Blocks.Interfaces.BooleanInput startTrigger "Start event"
      annotation(Placement(transformation(extent={{-120,-20},{-100,20}})));
  protected
    discrete Boolean started(start=false, fixed=true);
  initial equation
    pre(startTrigger)=startTrigger;
  equation
    when initial() then
      started=startTrigger;
    elsewhen edge(startTrigger) then
      started=true;
    end when;
    active=started;
    configurationValid=true;
    annotation(Icon(graphics={Text(extent={{-70,56},{70,32}}, textString="AFTER", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> activate permanently after the first rising start trigger.</p><p><b>Input:</b> startTrigger. <b>Output:</b> active.</p><p><b>Parameters:</b> none. <b>Usage:</b> post-fault assessment. <b>Limitation:</b> the block does not reset; use StartStop for reusable phases.</p></html>"));
  end After;

  block AfterFor "Single-shot window for a duration after the first trigger"
    extends Interfaces.PartialTimeWindow;
    parameter Modelica.Units.SI.Time duration(min=0)=1 "Window duration";
    Modelica.Blocks.Interfaces.BooleanInput startTrigger "First rising edge starts the window"
      annotation(Placement(transformation(extent={{-120,-20},{-100,20}})));
  protected
    discrete Boolean triggered(start=false, fixed=true);
    discrete Modelica.Units.SI.Time triggerTime(start=0, fixed=true);
  initial equation
    pre(startTrigger)=startTrigger;
  equation
    when initial() then
      triggered=startTrigger;
      triggerTime=if startTrigger then time else 0;
    elsewhen edge(startTrigger) then
      triggered=true;
      triggerTime=if not pre(triggered) then time else pre(triggerTime);
    end when;
    configurationValid=duration >= 0;
    active=configurationValid and triggered and time >= triggerTime and time < triggerTime + duration;
    annotation(Icon(graphics={Text(extent={{-80,56},{80,32}}, textString="AFTER %duration", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> select the first [triggerTime,triggerTime+duration) interval.</p><p><b>Input:</b> startTrigger. <b>Output:</b> active.</p><p><b>Parameter:</b> nonnegative duration. <b>Usage:</b> one-shot post-event requirements. <b>Limitation:</b> later triggers do not restart the window; use TriggeredDuration when restart behavior is required.</p></html>"));
  end AfterFor;

  block AfterUntil "Latch active after start and clear at stop"
    extends Interfaces.PartialTimeWindow;
    Modelica.Blocks.Interfaces.BooleanInput startTrigger annotation(Placement(transformation(extent={{-120,20},{-100,40}})));
    Modelica.Blocks.Interfaces.BooleanInput stopTrigger annotation(Placement(transformation(extent={{-120,-40},{-100,-20}})));
  protected
    discrete Boolean activeState(start=false, fixed=true);
  initial equation
    pre(startTrigger)=startTrigger;
    pre(stopTrigger)=stopTrigger;
  equation
    when initial() then
      activeState=startTrigger and not stopTrigger;
    elsewhen {edge(startTrigger),edge(stopTrigger)} then
      activeState=if edge(stopTrigger) then false elseif edge(startTrigger) then true else pre(activeState);
    end when;
    active=activeState;
    configurationValid=true;
    annotation(Icon(graphics={Text(extent={{-84,56},{84,32}}, textString="AFTER / UNTIL", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> activate after a rising start event until a rising stop event.</p><p><b>Inputs:</b> startTrigger, stopTrigger. <b>Output:</b> active.</p><p><b>Parameters:</b> none. <b>Usage:</b> event-delimited mission phases. <b>Limitation:</b> simultaneous edges give stop priority.</p></html>"));
  end AfterUntil;

  block TriggeredDuration "Restartable fixed-duration window"
    extends Interfaces.PartialTimeWindow;
    parameter Modelica.Units.SI.Time duration(min=0)=1 "Duration after the latest trigger";
    Modelica.Blocks.Interfaces.BooleanInput startTrigger annotation(Placement(transformation(extent={{-120,-20},{-100,20}})));
  protected
    discrete Boolean triggered(start=false, fixed=true);
    discrete Modelica.Units.SI.Time triggerTime(start=0, fixed=true);
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
    configurationValid=duration >= 0;
    active=configurationValid and triggered and time >= triggerTime and time < triggerTime + duration;
    annotation(Icon(graphics={Text(extent={{-88,56},{88,32}}, textString="TRIG %duration", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> select [latestTrigger,latestTrigger+duration), restarting at each rising edge.</p><p><b>Input:</b> startTrigger. <b>Output:</b> active.</p><p><b>Parameter:</b> nonnegative duration. <b>Usage:</b> repeated operations or fault injections. <b>Limitation:</b> overlapping requests merge because the latest edge restarts the end time.</p></html>"));
  end TriggeredDuration;

  block StartStop "Reusable start/stop-triggered window"
    extends Interfaces.PartialTimeWindow;
    Modelica.Blocks.Interfaces.BooleanInput startTrigger annotation(Placement(transformation(extent={{-120,20},{-100,40}})));
    Modelica.Blocks.Interfaces.BooleanInput stopTrigger annotation(Placement(transformation(extent={{-120,-40},{-100,-20}})));
  protected
    discrete Boolean activeState(start=false, fixed=true);
  initial equation
    pre(startTrigger)=startTrigger;
    pre(stopTrigger)=stopTrigger;
  equation
    when initial() then
      activeState=startTrigger and not stopTrigger;
    elsewhen {edge(startTrigger),edge(stopTrigger)} then
      activeState=if edge(stopTrigger) then false elseif edge(startTrigger) then true else pre(activeState);
    end when;
    active=activeState;
    configurationValid=true;
    annotation(Icon(graphics={Text(extent={{-82,56},{82,32}}, textString="START / STOP", textColor={90,70,140})}), Documentation(info="<html><p><b>Purpose:</b> implement reusable event-delimited active phases.</p><p><b>Inputs:</b> startTrigger and stopTrigger. <b>Output:</b> active.</p><p><b>Parameters:</b> none. <b>Usage:</b> repeated operating modes. <b>Limitation:</b> simultaneous start/stop edges give stop priority.</p></html>"));
  end StartStop;

  annotation(Documentation(info="<html><p>TimeWindows follows condition/time separation: every block produces only active and configurationValid. Numerical safety rules belong in Criteria, and the two outputs connect once to Evaluation.</p></html>"));
end TimeWindows;
