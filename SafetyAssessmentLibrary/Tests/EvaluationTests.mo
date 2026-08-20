within SafetyAssessmentLibrary.Tests;
package EvaluationTests "End-to-end E semantics"
  extends Modelica.Icons.ExamplesPackage;

  model AllInsideNoViolation
    extends Support.StaticAllInside(signalValue=0);
  equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and q.result.grade==BaseClasses.SafetyGrade.A,"AllInside no-violation failed"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end AllInsideNoViolation;

  model TotalOutsideDuration
    Modelica.Blocks.Sources.RealExpression x(y=if time>=1 and time<3 then 1.5 else 0);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.MaxOutsideDuration e(maxAllowed={1,2,3},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.B and abs(q.result.violationDuration)<1e-6,"Outer duration trace failed"); assert(abs(e.evaluation.outsideDuration[1]-2)<0.02,"A total outside duration failed"); end when;
    annotation(experiment(StopTime=5,Interval=0.01));
  end TotalOutsideDuration;

  model ConsecutiveOutside
    Modelica.Blocks.Sources.RealExpression x(y=if (time>=1 and time<1.6) or (time>=3 and time<3.6) then 1.5 else 0);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.MaxConsecutiveOutside e(maxAllowed={0.7,1,2},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.A and abs(e.evaluation.longestOutsideDuration[1]-0.6)<0.02,"Consecutive duration failed"); end when;
    annotation(experiment(StopTime=5,Interval=0.01));
  end ConsecutiveOutside;

  model InsideFraction
    Modelica.Blocks.Sources.RealExpression x(y=if time>=2 and time<4 then 1.5 else 0);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.FixedWindow w(startTime=0,endTime=10);
    Evaluation.MinInsideFraction e(minimumFraction={0.9,0.8,0.7},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.B and abs(e.evaluation.insideFraction[1]-0.8)<0.02,"Inside fraction failed"); end when;
    annotation(experiment(StopTime=10,Interval=0.01));
  end InsideFraction;

  model OutsideCount
    Modelica.Blocks.Sources.RealExpression x(y=if (time>=1 and time<2) or (time>=3 and time<4) then 1.5 else 0);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.MaxOutsideCount e(maxAllowed={1,1,2},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.B and e.evaluation.outsideCount[1]==2,"Outside count failed"); end when;
    annotation(experiment(StopTime=5,Interval=0.01));
  end OutsideCount;

  model FirstRecovery
    Modelica.Blocks.Sources.RealExpression x(y=if time>=1 and time<4 then 0.3 else 0);
    Modelica.Blocks.Sources.BooleanExpression trigger(y=time>=1);
    Criteria.GradedCriteria c(lower={-0.1,-0.2,-0.4},upper={0.1,0.2,0.4}); TimeWindows.TriggeredDuration w(duration=8);
    Evaluation.FirstRecoveryWithin e(maxRecoveryDuration={2,4,8},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(trigger.y,w.startTrigger); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.B and abs(e.evaluation.recoveryDuration[1]-3)<0.02 and abs(e.evaluation.firstRecoveryTime[1]-4)<0.02,"First recovery failed"); end when;
    annotation(experiment(StopTime=10,Interval=0.01));
  end FirstRecovery;

  model TriggeredResponse
    Modelica.Blocks.Sources.RealExpression x(y=if time<2.5 then 4 else if time<3 then 2.5 else if time<4 then 1.5 else 0);
    Modelica.Blocks.Sources.BooleanExpression trigger(y=time>=1);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.TriggeredResponseWithin e(maxResponseDuration={2.5,2.5,2.5},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(trigger.y,e.trigger); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.B and abs(e.evaluation.responseDuration[1]-3)<0.02 and abs(e.evaluation.responseDuration[2]-2)<0.02,"Triggered response failed"); end when;
    annotation(experiment(StopTime=5,Interval=0.01));
  end TriggeredResponse;

  model MissingResponseTrigger
    Modelica.Blocks.Sources.Constant x(k=0); Modelica.Blocks.Sources.BooleanConstant trigger(k=false);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.TriggeredResponseWithin e(samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(trigger.y,e.trigger); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Unresolved and q.result.invalidReason==BaseClasses.InvalidReason.MissingTrigger,"Missing response trigger shall be Unresolved"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end MissingResponseTrigger;

  model SafeDwell
    Modelica.Blocks.Sources.RealExpression x(y=if time<2 then 1.5 else 0);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.MinConsecutiveInside e(minimumDuration={3,2,1},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.A and e.evaluation.longestInsideDuration[1]>=3,"Safe dwell failed"); end when;
    annotation(experiment(StopTime=6,Interval=0.01));
  end SafeDwell;

  model IntegratedViolation
    Modelica.Blocks.Sources.RealExpression x(y=if time>=1 and time<3 then 2 else 0);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.MaxIntegratedViolation e(maxAllowed={1,2,3},samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.B and abs(e.evaluation.integratedViolation[1]-2)<0.02,"Integrated violation failed"); end when;
    annotation(experiment(StopTime=5,Interval=0.01));
  end IntegratedViolation;

  model CheckAtEnd
    Modelica.Blocks.Sources.RealExpression x(y=if time<2 then 1.5 else 0);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.FixedWindow w(startTime=0,endTime=4);
    Evaluation.CheckAtEnd e(samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.A,"CheckAtEnd failed"); end when;
    annotation(experiment(StopTime=5,Interval=0.01));
  end CheckAtEnd;
end EvaluationTests;