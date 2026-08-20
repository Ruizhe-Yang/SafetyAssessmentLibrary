within SafetyAssessmentLibrary.Tests;
package TimeWindowTests "Canonical W semantics"
  extends Modelica.Icons.ExamplesPackage;

  model FixedHalfOpen
    TimeWindows.FixedWindow w(startTime=1,endTime=2);
    discrete Boolean sawStart(start=false,fixed=true),sawEndInactive(start=false,fixed=true);
  algorithm
    when time>=1 then sawStart:=w.window.active; end when;
    when time>=2 then sawEndInactive:=not w.window.active; end when;
    when terminal() then assert(sawStart and sawEndInactive and w.window.configurationValid,"Fixed [start,end) failed"); end when;
    annotation(experiment(StopTime=2.1));
  end FixedHalfOpen;

  model InvalidFixed
    TimeWindows.FixedWindow w(startTime=2,endTime=1);
  equation when terminal() then assert(not w.window.configurationValid and w.window.invalidReason==BaseClasses.InvalidReason.TimeWindowConfiguration,"Invalid fixed domain not detected"); end when;
    annotation(experiment(StopTime=0.1));
  end InvalidFixed;

  model TriggeredDuration
    TimeWindows.TriggeredDuration w(duration=1);
    Modelica.Blocks.Sources.BooleanExpression trigger(y=time>=0.5);
    discrete Boolean sawActive(start=false,fixed=true),sawClosed(start=false,fixed=true);
  equation connect(trigger.y,w.startTrigger);
  algorithm
    when time>=0.6 then sawActive:=w.window.active; end when;
    when time>=1.51 then sawClosed:=not w.window.active; end when;
    when terminal() then assert(sawActive and sawClosed,"Triggered duration failed"); end when;
    annotation(experiment(StopTime=1.6));
  end TriggeredDuration;

  model BetweenEvents
    TimeWindows.BetweenEvents w;
    Modelica.Blocks.Sources.BooleanExpression startTrigger(y=time>=0.5),stopTrigger(y=time>=1.5);
    discrete Boolean sawActive(start=false,fixed=true),sawStopped(start=false,fixed=true);
  equation connect(startTrigger.y,w.startTrigger); connect(stopTrigger.y,w.stopTrigger);
  algorithm
    when time>=0.6 then sawActive:=w.window.active; end when;
    when time>=1.6 then sawStopped:=not w.window.active; end when;
    when terminal() then assert(sawActive and sawStopped,"BetweenEvents failed"); end when;
    annotation(experiment(StopTime=2));
  end BetweenEvents;
end TimeWindowTests;