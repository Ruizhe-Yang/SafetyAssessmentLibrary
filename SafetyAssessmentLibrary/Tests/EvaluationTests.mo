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

  model TriggeredResponseRejectsInvalidData
    "A response during invalid data is not latched; the first valid response is used"
    Modelica.Blocks.Sources.Constant x(k=0)
      annotation(Placement(transformation(extent={{-100,50},{-80,70}})));
    Modelica.Blocks.Sources.BooleanExpression trigger(y=time>=1.5)
      annotation(Placement(transformation(extent={{-100,-50},{-80,-30}})));
    Modelica.Blocks.Sources.BooleanExpression valid(y=not (time>=1 and time<3))
      annotation(Placement(transformation(extent={{-100,-10},{-80,10}})));
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3})
      annotation(Placement(transformation(extent={{-60,40},{-40,60}})));
    TimeWindows.Always w
      annotation(Placement(transformation(extent={{-20,-70},{0,-50}})));
    Evaluation.TriggeredResponseWithin e(
      maxResponseDuration={2,2,2},
      useDataValidityInput=true,
      minimumDataCoverage=0.5,
      samplePeriod=0.01)
      annotation(Placement(transformation(extent={{20,20},{60,60}})));
    Results.SafetyResult q
      annotation(Placement(transformation(extent={{80,30},{100,50}})));
  equation
    connect(x.y,c.indicator)
      annotation(Line(points={{-79,60},{-60,60},{-60,50}},color={0,0,127}));
    connect(trigger.y,e.trigger)
      annotation(Line(points={{-79,-40},{36,-40},{36,20}},color={255,0,255}));
    connect(valid.y,e.dataValid)
      annotation(Line(points={{-79,0},{10,0},{10,36},{20,36}},color={255,0,255}));
    connect(c.criteria,e.criteria)
      annotation(Line(points={{-40,50},{20,50}},color={190,105,35}));
    connect(w.window,e.window)
      annotation(Line(points={{0,-60},{40,-60},{40,20}},color={105,75,155}));
    connect(e.evaluation,q.evaluation)
      annotation(Line(points={{60,40},{80,40}},color={55,135,85}));
    when terminal() then
      assert(q.result.state==BaseClasses.AssessmentState.Resolved and q.result.grade==BaseClasses.SafetyGrade.A,"Valid-data response evaluation failed");
      assert(abs(e.evaluation.responseTime[1]-3)<0.02 and abs(e.evaluation.responseDuration[1]-1.5)<0.02,"Response during dataValid=false was incorrectly latched");
      assert(abs(q.result.responseTime[1]-3)<0.02 and abs(q.result.responseDuration[1]-1.5)<0.02,"Q dropped response evidence");
    end when;
    annotation(
      Diagram(coordinateSystem(extent={{-120,-90},{120,90}})),
      experiment(StopTime=5,Interval=0.01));
  end TriggeredResponseRejectsInvalidData;

  model TriggeredResponseRejectsOutsideWindow
    "An inside value before W opens cannot be recorded as a response"
    Modelica.Blocks.Sources.Constant x(k=0)
      annotation(Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Sources.BooleanExpression trigger(y=time>=1)
      annotation(Placement(transformation(extent={{-100,-40},{-80,-20}})));
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3})
      annotation(Placement(transformation(extent={{-60,30},{-40,50}})));
    TimeWindows.FixedWindow w(startTime=2,endTime=5)
      annotation(Placement(transformation(extent={{-40,-70},{-20,-50}})));
    Evaluation.TriggeredResponseWithin e(maxResponseDuration={1.5,1.5,1.5},samplePeriod=0.01)
      annotation(Placement(transformation(extent={{10,10},{50,50}})));
    Results.SafetyResult q
      annotation(Placement(transformation(extent={{70,20},{90,40}})));
  equation
    connect(x.y,c.indicator)
      annotation(Line(points={{-79,50},{-60,50},{-60,40}},color={0,0,127}));
    connect(trigger.y,e.trigger)
      annotation(Line(points={{-79,-30},{26,-30},{26,10}},color={255,0,255}));
    connect(c.criteria,e.criteria)
      annotation(Line(points={{-40,40},{10,40}},color={190,105,35}));
    connect(w.window,e.window)
      annotation(Line(points={{-20,-60},{30,-60},{30,10}},color={105,75,155}));
    connect(e.evaluation,q.evaluation)
      annotation(Line(points={{50,30},{70,30}},color={55,135,85}));
    when terminal() then
      assert(abs(e.evaluation.responseTime[1]-2)<0.02 and abs(e.evaluation.responseDuration[1]-1)<0.02,"Response outside W was incorrectly latched");
      assert(q.result.grade==BaseClasses.SafetyGrade.A,"Window-qualified response grade failed");
    end when;
    annotation(
      Diagram(coordinateSystem(extent={{-120,-90},{110,80}})),
      experiment(StopTime=6,Interval=0.01));
  end TriggeredResponseRejectsOutsideWindow;

  model TriggeredResponseRejectsInvalidCriterion
    "An inside value under an invalid criterion configuration is not a response"
    Modelica.Blocks.Sources.Constant x(k=0)
      annotation(Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Sources.BooleanExpression trigger(y=time>=1)
      annotation(Placement(transformation(extent={{-100,-40},{-80,-20}})));
    Criteria.GradedCriteria c(lower={-2,-1,-3},upper={2,1,3})
      annotation(Placement(transformation(extent={{-60,30},{-40,50}})));
    TimeWindows.Always w
      annotation(Placement(transformation(extent={{-40,-70},{-20,-50}})));
    Evaluation.TriggeredResponseWithin e(samplePeriod=0.01)
      annotation(Placement(transformation(extent={{10,10},{50,50}})));
    Results.SafetyResult q
      annotation(Placement(transformation(extent={{70,20},{90,40}})));
  equation
    connect(x.y,c.indicator)
      annotation(Line(points={{-79,50},{-60,50},{-60,40}},color={0,0,127}));
    connect(trigger.y,e.trigger)
      annotation(Line(points={{-79,-30},{26,-30},{26,10}},color={255,0,255}));
    connect(c.criteria,e.criteria)
      annotation(Line(points={{-40,40},{10,40}},color={190,105,35}));
    connect(w.window,e.window)
      annotation(Line(points={{-20,-60},{30,-60},{30,10}},color={105,75,155}));
    connect(e.evaluation,q.evaluation)
      annotation(Line(points={{50,30},{70,30}},color={55,135,85}));
    when terminal() then
      assert(q.result.state==BaseClasses.AssessmentState.Invalid and q.result.invalidReason==BaseClasses.InvalidReason.GradeNesting,"Invalid criterion configuration was not propagated");
      assert(e.evaluation.responseTime[1]<0 and q.result.responseTime[1]<0,"Response under an invalid criterion configuration was incorrectly latched");
    end when;
    annotation(
      Diagram(coordinateSystem(extent={{-120,-90},{110,80}})),
      experiment(StopTime=2,Interval=0.01));
  end TriggeredResponseRejectsInvalidCriterion;

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

  model FirstRecoveryUsesPostRecoveryDwell
    "Long safety before a fault cannot satisfy a dwell required after recovery"
    Modelica.Blocks.Sources.RealExpression x(y=if time>=5 and time<6 then 1.5 else 0)
      annotation(Placement(transformation(extent={{-100,30},{-80,50}})));
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3})
      annotation(Placement(transformation(extent={{-60,30},{-40,50}})));
    TimeWindows.Always w
      annotation(Placement(transformation(extent={{-40,-60},{-20,-40}})));
    Evaluation.FirstRecoveryWithin e(
      maxRecoveryDuration={2,2,2},
      minimumSafeDwell={2,1,0},
      samplePeriod=0.01)
      annotation(Placement(transformation(extent={{10,10},{50,50}})));
    Results.SafetyResult q
      annotation(Placement(transformation(extent={{70,20},{90,40}})));
  equation
    connect(x.y,c.indicator)
      annotation(Line(points={{-79,40},{-60,40}},color={0,0,127}));
    connect(c.criteria,e.criteria)
      annotation(Line(points={{-40,40},{10,40}},color={190,105,35}));
    connect(w.window,e.window)
      annotation(Line(points={{-20,-50},{30,-50},{30,10}},color={105,75,155}));
    connect(e.evaluation,q.evaluation)
      annotation(Line(points={{50,30},{70,30}},color={55,135,85}));
    when terminal() then
      assert(e.evaluation.longestInsideDuration[1]>4.9,"Test precondition: long pre-fault safety missing");
      assert(abs(e.evaluation.postRecoverySafeDwell[1]-1)<0.02,"Post-recovery dwell evidence failed");
      assert(q.result.grade==BaseClasses.SafetyGrade.B,"Global pre-fault inside duration incorrectly satisfied minimumSafeDwell");
      assert(abs(q.result.postRecoverySafeDwell[1]-1)<0.02 and abs(q.result.firstRecoveryTimeByLevel[1]-6)<0.02,"Q dropped recovery evidence");
    end when;
    annotation(
      Diagram(coordinateSystem(extent={{-120,-80},{110,80}})),
      experiment(StopTime=7,Interval=0.01));
  end FirstRecoveryUsesPostRecoveryDwell;

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
