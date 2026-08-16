within SafetyAssessmentLibrary.Tests;
package SemanticTests "Evidence, lifecycle, threshold, and transient/final semantics"
  extends Modelica.Icons.ExamplesPackage;

  partial model PartialSemanticPipeline
    parameter Real lower[4]={-1,-2,-3,-4};
    parameter Real upper[4]={1,2,3,4};
    parameter Types.SafetyGrade threshold=Types.SafetyGrade.D;
    Real z;
    Boolean activeSignal;
    Boolean windowValidSignal;
    Criteria.GradeInterval intervalA(grade=Types.SafetyGrade.A,lower=lower[1],upper=upper[1]) annotation(Placement(transformation(extent={{-90,50},{-60,70}})));
    Criteria.GradeInterval intervalB(grade=Types.SafetyGrade.B,lower=lower[2],upper=upper[2]) annotation(Placement(transformation(extent={{-90,20},{-60,40}})));
    Criteria.GradeInterval intervalC(grade=Types.SafetyGrade.C,lower=lower[3],upper=upper[3]) annotation(Placement(transformation(extent={{-90,-10},{-60,10}})));
    Criteria.GradeInterval intervalD(grade=Types.SafetyGrade.D,lower=lower[4],upper=upper[4]) annotation(Placement(transformation(extent={{-90,-40},{-60,-20}})));
    replaceable Evaluation.AllInside evaluation(samplePeriod=0.01)
      constrainedby Evaluation.PartialGrade4Evaluation annotation(Placement(transformation(extent={{0,-50},{50,70}})));
    Results.AssessmentResult resultEndpoint(topEventThreshold=threshold,printResult=false)
      annotation(Placement(transformation(extent={{70,-15},{100,15}})));
  equation
    intervalA.z=z; intervalB.z=z; intervalC.z=z; intervalD.z=z;
    evaluation.active=activeSignal;
    evaluation.windowValid=windowValidSignal;
    connect(intervalA.criterion,evaluation.criterionA) annotation(Line(points={{-58.5,60},{-20,60},{-20,52},{-2.5,52}}, color={30,120,90}));
    connect(intervalB.criterion,evaluation.criterionB) annotation(Line(points={{-58.5,30},{-20,30},{-20,28},{-2.5,28}}, color={30,120,90}));
    connect(intervalC.criterion,evaluation.criterionC) annotation(Line(points={{-58.5,0},{-20,0},{-20,4},{-2.5,4}}, color={30,120,90}));
    connect(intervalD.criterion,evaluation.criterionD) annotation(Line(points={{-58.5,-30},{-20,-30},{-20,-20},{-2.5,-20}}, color={30,120,90}));
    connect(evaluation.evidence,resultEndpoint.evidence) annotation(Line(points={{52.5,10},{68.5,10},{68.5,0}}, color={40,100,170}));
  end PartialSemanticPipeline;

  model NoEvidenceTest "A never-active legal objective is Unresolved"
    extends PartialSemanticPipeline;
    TimeWindows.FixedWindow window(startTime=10,endTime=20);
  equation
    z=0;
    activeSignal=window.active;
    windowValidSignal=window.configurationValid;
    when terminal() then
      assert(resultEndpoint.result.state == Types.AssessmentState.Unresolved,"No evidence must be Unresolved");
      assert(resultEndpoint.result.displayCode == 0,"No evidence must not produce a grade display code");
    end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>A legal but never-active assessment cannot vacuously resolve A.</p></html>"));
  end NoEvidenceTest;

  model MissingReferenceTest "Unavailable required reference is Unresolved"
    extends PartialSemanticPipeline(redeclare Evaluation.AllInside evaluation(samplePeriod=0.01,useDataValidityInput=true));
    Modelica.Blocks.Sources.BooleanConstant available(k=false) annotation(Placement(transformation(extent={{-30,-90},{-10,-70}})));
  equation
    z=0;
    activeSignal=true;
    windowValidSignal=true;
    connect(available.y,evaluation.dataValid) annotation(Line(points={{-9,-80},{32.5,-80},{32.5,-56}}, color={255,0,255}));
    when terminal() then
      assert(resultEndpoint.evidence.configurationValid,"Missing data must not invalidate legal configuration");
      assert(resultEndpoint.result.state == Types.AssessmentState.Unresolved,"Missing required reference must be Unresolved");
    end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>dataValid=false produces Unresolved rather than Invalid.</p></html>"));
  end MissingReferenceTest;

  model InvalidEnvelopeTest "Illegal nesting is Invalid"
    extends PartialSemanticPipeline(lower={0,-1,-2,-3},upper={1,0.5,2,3});
  equation
    z=0;
    activeSignal=true;
    windowValidSignal=true;
    when terminal() then assert(resultEndpoint.result.state == Types.AssessmentState.Invalid and resultEndpoint.result.displayCode == -1,"Nonnested criteria must be Invalid"); end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>I_A is not contained by I_B; Result reports Invalid, not D.</p></html>"));
  end InvalidEnvelopeTest;

  model OutsideDTest "A valid trajectory outside D resolves D plus outerViolation"
    extends PartialSemanticPipeline;
  equation
    z=10;
    activeSignal=true;
    windowValidSignal=true;
    when terminal() then
      assert(resultEndpoint.result.state == Types.AssessmentState.Resolved,"Outside D remains a resolved consequence");
      assert(resultEndpoint.result.grade == Types.SafetyGrade.D and resultEndpoint.result.outerViolation,"Expected Resolved+D+outerViolation");
    end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Observed severe behavior is not an invalid configuration.</p></html>"));
  end OutsideDTest;

  model InstantaneousVsFinalGradeTest "A tolerated D-region transient can finish A"
    extends PartialSemanticPipeline(redeclare Evaluation.MaxOutsideDuration evaluation(samplePeriod=0.01,maxAllowed={0.3,0.3,0.3,0.3}));
    discrete Boolean sawInstantaneousD(start=false,fixed=true);
  equation
    z=if time >= 1 and time < 1.2 then 3.5 else 0;
    activeSignal=true;
    windowValidSignal=true;
    when not intervalC.criterion.inside and intervalD.criterion.inside then
      sawInstantaneousD=true;
    end when;
    when terminal() then
      assert(sawInstantaneousD,"The transient must enter the D region");
      assert(resultEndpoint.result.state == Types.AssessmentState.Resolved and resultEndpoint.result.grade == Types.SafetyGrade.A,"Allowed duration must keep final grade A");
    end when;
    annotation(experiment(StopTime=2), Documentation(info="<html><p>Instantaneous interval region and final temporal grade remain separate.</p></html>"));
  end InstantaneousVsFinalGradeTest;

  model CriticalEvidenceTest "Threshold-C evidence selects Grade-C timing"
    extends PartialSemanticPipeline(threshold=Types.SafetyGrade.C,
      redeclare Evaluation.MaxOutsideDuration evaluation(samplePeriod=0.01,maxAllowed={2,2,2,2}));
  equation
    z=if time >= 0.5 and time < 0.8 then 1.5 elseif time >= 1 and time < 2 then 3.5 else 0;
    activeSignal=true;
    windowValidSignal=true;
    when terminal() then
      assert(abs(resultEndpoint.result.firstCriticalTime-1.0) < 1e-6,"Critical time must select C evidence");
      assert(abs(resultEndpoint.result.criticalDuration-1.0) < 1e-6,"Critical duration must select C evidence");
      assert(not resultEndpoint.result.outerViolation,"D interval is never left");
    end when;
    annotation(experiment(StopTime=3), Documentation(info="<html><p>Critical fields select the configured topEventThreshold rather than fixed A or D evidence.</p></html>"));
  end CriticalEvidenceTest;

  annotation(Documentation(info="<html><p>These tests lock no-vacuous-result, unavailable-data, Invalid/D separation, transient/final separation, and configurable critical-evidence semantics.</p></html>"));
end SemanticTests;
