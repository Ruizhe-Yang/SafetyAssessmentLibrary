within SafetyAssessmentLibrary.Tests;
package EvaluationTests "Public policy and hidden online-statistics regression tests"
  extends Modelica.Icons.ExamplesPackage;

  partial model PartialEvaluationCase
    Real z;
    Boolean activeSignal;
    Criteria.GradeInterval intervalA(grade=Types.SafetyGrade.A,lower=-1,upper=1) annotation(Placement(transformation(extent={{-90,50},{-60,70}})));
    Criteria.GradeInterval intervalB(grade=Types.SafetyGrade.B,lower=-2,upper=2) annotation(Placement(transformation(extent={{-90,20},{-60,40}})));
    Criteria.GradeInterval intervalC(grade=Types.SafetyGrade.C,lower=-3,upper=3) annotation(Placement(transformation(extent={{-90,-10},{-60,10}})));
    Criteria.GradeInterval intervalD(grade=Types.SafetyGrade.D,lower=-4,upper=4) annotation(Placement(transformation(extent={{-90,-40},{-60,-20}})));
    replaceable Evaluation.AllInside evaluation(samplePeriod=0.01)
      constrainedby Evaluation.PartialGrade4Evaluation
      annotation(Placement(transformation(extent={{10,-50},{60,70}})));
  equation
    intervalA.z=z; intervalB.z=z; intervalC.z=z; intervalD.z=z;
    evaluation.active=activeSignal;
    evaluation.windowValid=true;
    connect(intervalA.criterion,evaluation.criterionA) annotation(Line(points={{-58.5,60},{-20,60},{-20,52},{7.5,52}}, color={30,120,90}));
    connect(intervalB.criterion,evaluation.criterionB) annotation(Line(points={{-58.5,30},{-20,30},{-20,28},{7.5,28}}, color={30,120,90}));
    connect(intervalC.criterion,evaluation.criterionC) annotation(Line(points={{-58.5,0},{-20,0},{-20,4},{7.5,4}}, color={30,120,90}));
    connect(intervalD.criterion,evaluation.criterionD) annotation(Line(points={{-58.5,-30},{-20,-30},{-20,-20},{7.5,-20}}, color={30,120,90}));
    annotation(Documentation(info="<html><p>Shared four-interval fixture. The public Diagram exposes Criteria and one replaceable Evaluation; OnlineStatistics remains internal.</p></html>"));
  end PartialEvaluationCase;

  model NoViolation
    extends PartialEvaluationCase;
  equation
    z=0;
    activeSignal=true;
    when terminal() then assert(evaluation.evidence.pass[1] and evaluation.evidence.pass[4],"No-violation case must pass all levels"); end when;
    annotation(experiment(StopTime=2), Documentation(info="<html><p>Zero outside duration passes AllInside at all grades.</p></html>"));
  end NoViolation;

  model ShortMultipleViolations
    extends PartialEvaluationCase(redeclare Evaluation.MaxOutsideDuration evaluation(samplePeriod=0.01,maxAllowed={0.5,0.5,0.5,0.5}));
  equation
    z=if (time >= 0.5 and time < 0.7) or (time >= 1.2 and time < 1.4) then 1.5 else 0;
    activeSignal=true;
    when terminal() then
      assert(evaluation.evidence.outsideCount[1] == 2,"Expected two stable violations");
      assert(abs(evaluation.evidence.outsideDuration[1]-0.4) < 1e-5,"Expected 0.4 s total violation");
      assert(evaluation.evidence.pass[1],"Total violation should remain under 0.5 s");
    end when;
    annotation(experiment(StopTime=2), Documentation(info="<html><p>Multiple excursions are counted stably and accumulated by MaxOutsideDuration.</p></html>"));
  end ShortMultipleViolations;

  model ConsecutiveViolation
    extends PartialEvaluationCase(redeclare Evaluation.MaxConsecutiveOutside evaluation(samplePeriod=0.01,maxAllowed={0.5,1.5,1.5,1.5}));
  equation
    z=if time >= 0.5 and time < 1.5 then 1.5 else 0;
    activeSignal=true;
    when terminal() then
      assert(abs(evaluation.evidence.longestOutsideDuration[1]-1.0) < 1e-5,"Expected 1 s longest violation");
      assert(not evaluation.evidence.pass[1] and evaluation.evidence.pass[2],"Expected A fail and B pass");
    end when;
    annotation(experiment(StopTime=2), Documentation(info="<html><p>MaxConsecutiveOutside distinguishes persistence from total exposure.</p></html>"));
  end ConsecutiveViolation;

  model LastInstantViolation
    extends PartialEvaluationCase(redeclare Evaluation.CheckAtEnd evaluation(samplePeriod=0.01));
  equation
    z=if time < 1.999 then 0 else 1.5;
    activeSignal=true;
    when terminal() then assert(not evaluation.evidence.pass[1] and evaluation.evidence.pass[2],"Terminal violation must be captured by CheckAtEnd"); end when;
    annotation(experiment(StopTime=2), Documentation(info="<html><p>A violation immediately before terminal time is retained as last active membership.</p></html>"));
  end LastInstantViolation;

  model EventIterationStability
    extends PartialEvaluationCase;
  equation
    z=if time < 1 then 0 else 1.5;
    activeSignal=time < 1;
    when terminal() then
      assert(evaluation.evidence.outsideCount[1] == 0,"Simultaneous window close and boundary crossing must not create a transient count");
      assert(evaluation.evidence.firstOutsideTime[1] < 0,"Transient event-iteration state must not set first violation time");
    end when;
    annotation(experiment(StopTime=2), Documentation(info="<html><p>Stable event-state handling prevents a false violation when the window closes at the same event that z leaves A.</p></html>"));
  end EventIterationStability;

  model OnTriggerFreeze
    extends PartialEvaluationCase(redeclare Evaluation.CheckAtEnd evaluation(samplePeriod=0.01,evaluationMode=Types.EvaluationMode.OnTrigger));
    Modelica.Blocks.Sources.BooleanStep evaluate(startTime=1,startValue=false)
      annotation(Placement(transformation(extent={{-40,-90},{-20,-70}})));
  equation
    z=if time < 0.5 or time > 1.5 then 0 else 1.5;
    activeSignal=true;
    connect(evaluate.y,evaluation.evaluateTrigger)
      annotation(Line(points={{-19,-80},{52.5,-80},{52.5,-56}}, color={255,0,255}));
    when terminal() then
      assert(evaluation.evidence.evaluated,"OnTrigger evaluator must freeze at the trigger");
      assert(not evaluation.evidence.pass[1] and evaluation.evidence.pass[2],"Frozen result must retain trigger-time membership despite later recovery");
    end when;
    annotation(experiment(StopTime=2), Documentation(info="<html><p>The first evaluation trigger freezes CheckAtEnd and later recovery cannot rewrite it.</p></html>"));
  end OnTriggerFreeze;

  annotation(Documentation(info="<html><p>Regression models cover no violation, repeated and consecutive excursions, terminal state, event iteration, and OnTrigger freezing through the simplified public Evaluation interface.</p></html>"));
end EvaluationTests;
