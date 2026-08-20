within SafetyAssessmentLibrary.Tests;
package SemanticTests "Coverage, lifecycle, verdict, and Top Event tests"
  extends Modelica.Icons.ExamplesPackage;

  model SufficientCoverage
    extends Support.ValidityFixture(minimumCoverage=0.8);
  equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and abs(q.result.dataCoverage-0.8)<0.02 and abs(q.result.invalidDataDuration-2)<0.02,"Sufficient coverage failed"); end when;
    annotation(experiment(StopTime=10,Interval=0.01));
  end SufficientCoverage;

  model InsufficientCoverage
    extends Support.ValidityFixture(minimumCoverage=0.81);
  equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Unresolved and q.result.invalidReason==BaseClasses.InvalidReason.InsufficientDataCoverage,"Insufficient coverage shall be Unresolved"); end when;
    annotation(experiment(StopTime=10,Interval=0.01));
  end InsufficientCoverage;

  model ZeroValidCoverage
    Modelica.Blocks.Sources.Constant x(k=0); Modelica.Blocks.Sources.BooleanConstant valid(k=false);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.FixedWindow w(startTime=0,endTime=2);
    Evaluation.AllInside e(useDataValidityInput=true,minimumDataCoverage=0.1,samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(valid.y,e.dataValid); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Unresolved and q.result.validDataDuration<0.01,"Zero valid coverage failed"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end ZeroValidCoverage;

  model InvalidAtSimulationEnd
    Modelica.Blocks.Sources.Constant x(k=0); Modelica.Blocks.Sources.BooleanExpression valid(y=time<9);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.FixedWindow w(startTime=0,endTime=10);
    Evaluation.AllInside e(useDataValidityInput=true,minimumDataCoverage=0.9,samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(valid.y,e.dataValid); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and abs(q.result.dataCoverage-0.9)<0.02,"Final dataValid=false must be decided by coverage, not final sample"); end when;
    annotation(experiment(StopTime=10,Interval=0.01));
  end InvalidAtSimulationEnd;

  model EvaluationTriggerEnabled
    Modelica.Blocks.Sources.RealExpression x(y=if time<1.5 then 0 else 4); Modelica.Blocks.Sources.BooleanExpression evaluateNow(y=time>=1);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w;
    Evaluation.AllInside e(evaluationMode=BaseClasses.EvaluationMode.OnTrigger,samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(evaluateNow.y,e.evaluateTrigger); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and q.result.grade==BaseClasses.SafetyGrade.A and q.result.violationDuration<0.01,"OnTrigger freeze/connector failed"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end EvaluationTriggerEnabled;

  model DynamicInvalidOutsideWindow
    Modelica.Blocks.Sources.RealExpression x(y=0),la(y=if time<1 then -2.5 else -1),ua(y=1),lb(y=-2),ub(y=2),lc(y=-3),uc(y=3);
    Criteria.DynamicGradedCriteria c; TimeWindows.FixedWindow w(startTime=1,endTime=2); Evaluation.AllInside e(samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.value); connect(la.y,c.lowerA); connect(ua.y,c.upperA); connect(lb.y,c.lowerB); connect(ub.y,c.upperB); connect(lc.y,c.lowerC); connect(uc.y,c.upperC); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved,"Dynamic invalidity outside W shall not invalidate A"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end DynamicInvalidOutsideWindow;

  model DynamicInvalidInsideWindow
    Modelica.Blocks.Sources.RealExpression x(y=0),la(y=if time<1.5 then -1 else -2.5),ua(y=1),lb(y=-2),ub(y=2),lc(y=-3),uc(y=3);
    Criteria.DynamicGradedCriteria c; TimeWindows.FixedWindow w(startTime=1,endTime=2); Evaluation.AllInside e(samplePeriod=0.01); Results.SafetyResult q;
  equation connect(x.y,c.value); connect(la.y,c.lowerA); connect(ua.y,c.upperA); connect(lb.y,c.lowerB); connect(ub.y,c.upperB); connect(lc.y,c.lowerC); connect(uc.y,c.upperC); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation);
    when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Invalid and q.result.invalidReason==BaseClasses.InvalidReason.DynamicGradeNesting,"Dynamic invalidity inside W not latched"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end DynamicInvalidInsideWindow;

  model GradeThresholdTopEvent
    extends Support.StaticAllInside(signalValue=2.5);
    Results.SafetyResult qC(topEventThreshold=BaseClasses.SafetyGrade.C);
  equation connect(e.evaluation,qC.evaluation);
    when terminal() then assert(qC.result.grade==BaseClasses.SafetyGrade.C and qC.result.topEvent,"C threshold Top Event failed"); end when;
    annotation(experiment(StopTime=1));
  end GradeThresholdTopEvent;

  model IndependentTopEvent
    Modelica.Blocks.Sources.Constant x(k=0); Modelica.Blocks.Sources.BooleanConstant hazard(k=true);
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3}); TimeWindows.Always w; Evaluation.AllInside e; Results.SafetyResult q(useGradeTopEvent=false);
  equation connect(x.y,c.indicator); connect(c.criteria,e.criteria); connect(w.window,e.window); connect(e.evaluation,q.evaluation); connect(hazard.y,q.independentTopEvent);
    when terminal() then assert(q.result.grade==BaseClasses.SafetyGrade.A and q.result.topEvent,"Independent Top Event failed"); end when;
    annotation(experiment(StopTime=1));
  end IndependentTopEvent;
end SemanticTests;