within SafetyAssessmentLibrary.Tests;
package ObjectiveTests "A/B/C/D/Invalid final-result tests through the white-box pipeline"
  extends Modelica.Icons.ExamplesPackage;

  partial model PartialResultCase
    parameter Real value=0;
    parameter Real lower[4]={-1,-2,-3,-4};
    parameter Real upper[4]={1,2,3,4};
    parameter Types.SafetyGrade expectedGrade=Types.SafetyGrade.A;
    parameter Types.AssessmentState expectedState=Types.AssessmentState.Resolved;
    parameter Integer expectedCode=4;
    Criteria.GradeInterval intervalA(grade=Types.SafetyGrade.A,lower=lower[1],upper=upper[1]) annotation(Placement(transformation(extent={{-90,50},{-60,70}})));
    Criteria.GradeInterval intervalB(grade=Types.SafetyGrade.B,lower=lower[2],upper=upper[2]) annotation(Placement(transformation(extent={{-90,20},{-60,40}})));
    Criteria.GradeInterval intervalC(grade=Types.SafetyGrade.C,lower=lower[3],upper=upper[3]) annotation(Placement(transformation(extent={{-90,-10},{-60,10}})));
    Criteria.GradeInterval intervalD(grade=Types.SafetyGrade.D,lower=lower[4],upper=upper[4]) annotation(Placement(transformation(extent={{-90,-40},{-60,-20}})));
    Evaluation.AllInside evaluation(samplePeriod=0.01) annotation(Placement(transformation(extent={{0,-50},{50,70}})));
    Results.AssessmentResult resultEndpoint(printResult=false) annotation(Placement(transformation(extent={{70,-15},{100,15}})));
  equation
    intervalA.z=value; intervalB.z=value; intervalC.z=value; intervalD.z=value;
    evaluation.active=true;
    evaluation.windowValid=true;
    connect(intervalA.criterion,evaluation.criterionA) annotation(Line(points={{-58.5,60},{-20,60},{-20,52},{-2.5,52}}, color={30,120,90}));
    connect(intervalB.criterion,evaluation.criterionB) annotation(Line(points={{-58.5,30},{-20,30},{-20,28},{-2.5,28}}, color={30,120,90}));
    connect(intervalC.criterion,evaluation.criterionC) annotation(Line(points={{-58.5,0},{-20,0},{-20,4},{-2.5,4}}, color={30,120,90}));
    connect(intervalD.criterion,evaluation.criterionD) annotation(Line(points={{-58.5,-30},{-20,-30},{-20,-20},{-2.5,-20}}, color={30,120,90}));
    connect(evaluation.evidence,resultEndpoint.evidence) annotation(Line(points={{52.5,10},{68.5,10},{68.5,0}}, color={40,100,170}));
    when terminal() then
      assert(resultEndpoint.result.state == expectedState,"Unexpected AssessmentState");
      assert(resultEndpoint.result.displayCode == expectedCode,"Unexpected display code");
      if expectedState == Types.AssessmentState.Resolved then
        assert(resultEndpoint.result.grade == expectedGrade,"Unexpected SafetyGrade");
      end if;
    end when;
    annotation(Documentation(info="<html><p>Shared executable Criteria/Evaluation/Result fixture.</p></html>"));
  end PartialResultCase;

  model GradeA
    extends PartialResultCase(value=0,expectedGrade=Types.SafetyGrade.A,expectedCode=4);
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Inside A resolves A/code 4.</p></html>"));
  end GradeA;

  model GradeB
    extends PartialResultCase(value=1.5,expectedGrade=Types.SafetyGrade.B,expectedCode=3);
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Outside A but inside B resolves B/code 3.</p></html>"));
  end GradeB;

  model GradeC
    extends PartialResultCase(value=2.5,expectedGrade=Types.SafetyGrade.C,expectedCode=2);
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Outside A/B but inside C resolves C/code 2.</p></html>"));
  end GradeC;

  model GradeD
    extends PartialResultCase(value=5,expectedGrade=Types.SafetyGrade.D,expectedCode=1);
  equation
    when terminal() then assert(resultEndpoint.result.outerViolation,"D-envelope failure must set outerViolation"); end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Outside D remains Resolved+D/code 1 with outerViolation.</p></html>"));
  end GradeD;

  model Invalid
    extends PartialResultCase(value=0,lower={-2,-1,-3,-4},upper={2,1,3,4},expectedState=Types.AssessmentState.Invalid,expectedCode=-1);
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Nonnested A/B intervals resolve Invalid/code -1, distinct from D.</p></html>"));
  end Invalid;

  annotation(Documentation(info="<html><p>Final acceptance categories A, B, C, D, and Invalid are exercised through the same graphical blocks used by real assessments.</p></html>"));
end ObjectiveTests;
