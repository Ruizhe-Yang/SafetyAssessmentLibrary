within SafetyAssessmentLibrary.Tests;
package TimeWindowTests "Fixed, trigger, duration, start/stop, and terminal tests"
  extends Modelica.Icons.ExamplesPackage;

  model FixedWindowTest
    TimeWindows.FixedWindow window(startTime=1,endTime=2);
  equation
    when time >= 1.5 then assert(window.active,"Fixed window should be active at 1.5 s"); end when;
    when terminal() then assert(not window.active and window.configurationValid,"Fixed window should be inactive after exclusive end"); end when;
    annotation(experiment(StopTime=3),Documentation(info="<html><p><b>Purpose:</b> verify [1,2) fixed-window semantics.</p></html>"));
  end FixedWindowTest;

  model TriggeredDurationTest
    Modelica.Blocks.Sources.BooleanStep trigger(startTime=1,startValue=false);
    TimeWindows.TriggeredDuration window(duration=2);
  equation
    window.startTrigger=trigger.y;
    when time >= 1.5 then assert(window.active,"Triggered window should be active"); end when;
    when terminal() then assert(not window.active,"Triggered window should end at trigger+duration"); end when;
    annotation(experiment(StopTime=4),Documentation(info="<html><p><b>Purpose:</b> verify rising-trigger start and duration end.</p></html>"));
  end TriggeredDurationTest;

  model StartStopTest
    Modelica.Blocks.Sources.BooleanStep startTrigger(startTime=1,startValue=false);
    Modelica.Blocks.Sources.BooleanStep stopTrigger(startTime=2,startValue=false);
    TimeWindows.StartStop window;
  equation
    window.startTrigger=startTrigger.y;
    window.stopTrigger=stopTrigger.y;
    when time >= 1.5 then assert(window.active,"StartStop should be active after start"); end when;
    when terminal() then assert(not window.active,"StartStop should be inactive after stop"); end when;
    annotation(experiment(StopTime=3),Documentation(info="<html><p><b>Purpose:</b> verify start/stop-triggered activity.</p></html>"));
  end StartStopTest;

  model SimulationEndTest
    TimeWindows.Always window;
  equation
    when terminal() then assert(window.active,"Always must remain active at simulation end"); end when;
    annotation(experiment(StopTime=1),Documentation(info="<html><p><b>Purpose:</b> verify terminal-time activity for an unbounded window.</p></html>"));
  end SimulationEndTest;

  annotation(Documentation(info="<html><p>Time-window regression models.</p></html>"));
end TimeWindowTests;
