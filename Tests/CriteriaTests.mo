within SafetyAssessmentLibrary.Tests;
package CriteriaTests "GradeInterval, endpoints, nesting, and outside-D tests"
  extends Modelica.Icons.ExamplesPackage;

  model NormalNested
    Criteria.GradeInterval intervalA(grade=Types.SafetyGrade.A,lower=-1,upper=1) annotation(Placement(transformation(extent={{-80,50},{-50,70}})));
    Criteria.GradeInterval intervalB(grade=Types.SafetyGrade.B,lower=-2,upper=2) annotation(Placement(transformation(extent={{-80,20},{-50,40}})));
    Criteria.GradeInterval intervalC(grade=Types.SafetyGrade.C,lower=-3,upper=3) annotation(Placement(transformation(extent={{-80,-10},{-50,10}})));
    Criteria.GradeInterval intervalD(grade=Types.SafetyGrade.D,lower=-4,upper=4) annotation(Placement(transformation(extent={{-80,-40},{-50,-20}})));
    Internal.GradeNestingCheck nesting annotation(Placement(transformation(extent={{20,-40},{50,70}})));
  equation
    intervalA.z=0.5;
    intervalB.z=0.5;
    intervalC.z=0.5;
    intervalD.z=0.5;
    connect(intervalA.criterion,nesting.criterionA) annotation(Line(points={{-48.5,60},{3,60},{3,53.5},{18.5,53.5}}, color={30,120,90}));
    connect(intervalB.criterion,nesting.criterionB) annotation(Line(points={{-48.5,30},{6,30},{6,31.5},{18.5,31.5}}, color={30,120,90}));
    connect(intervalC.criterion,nesting.criterionC) annotation(Line(points={{-48.5,0},{6,0},{6,9.5},{18.5,9.5}}, color={30,120,90}));
    connect(intervalD.criterion,nesting.criterionD) annotation(Line(points={{-48.5,-30},{3,-30},{3,-12.5},{18.5,-12.5}}, color={30,120,90}));
    when terminal() then
      assert(nesting.configurationValid,"Expected valid nested intervals");
      assert(intervalA.criterion.inside and intervalB.criterion.inside and intervalC.criterion.inside and intervalD.criterion.inside,"Expected membership in all grades");
    end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Expected: four individually editable intervals form A subset B subset C subset D and contain z.</p></html>"));
  end NormalNested;

  model BoundaryOpenClosed
    Criteria.GradeInterval closedInterval(lower=0,upper=1);
    Criteria.GradeInterval openInterval(lower=0,upper=1,lowerBoundary=Types.BoundaryType.Open);
  equation
    closedInterval.z=0;
    openInterval.z=0;
    when terminal() then
      assert(closedInterval.criterion.inside,"Closed lower endpoint must be inside");
      assert(not openInterval.criterion.inside,"Open lower endpoint must be outside");
      assert(abs(closedInterval.criterion.signedMargin) < 1e-12 and abs(openInterval.criterion.signedMargin) < 1e-12,"Endpoint geometric margin must be zero");
    end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Open/Closed membership remains exact even though both geometric margins equal zero at the endpoint.</p></html>"));
  end BoundaryOpenClosed;

  model InvalidNested
    Criteria.GradeInterval intervalA(lower=-2,upper=2) annotation(Placement(transformation(extent={{-80,50},{-50,70}})));
    Criteria.GradeInterval intervalB(lower=-1,upper=1) annotation(Placement(transformation(extent={{-80,20},{-50,40}})));
    Criteria.GradeInterval intervalC(lower=-3,upper=3) annotation(Placement(transformation(extent={{-80,-10},{-50,10}})));
    Criteria.GradeInterval intervalD(lower=-4,upper=4) annotation(Placement(transformation(extent={{-80,-40},{-50,-20}})));
    Internal.GradeNestingCheck nesting annotation(Placement(transformation(extent={{20,-40},{50,70}})));
  equation
    intervalA.z=0; intervalB.z=0; intervalC.z=0; intervalD.z=0;
    connect(intervalA.criterion,nesting.criterionA) annotation(Line(points={{-48.5,60},{3,60},{3,53.5},{18.5,53.5}}, color={30,120,90}));
    connect(intervalB.criterion,nesting.criterionB) annotation(Line(points={{-48.5,30},{6,30},{6,31.5},{18.5,31.5}}, color={30,120,90}));
    connect(intervalC.criterion,nesting.criterionC) annotation(Line(points={{-48.5,0},{6,0},{6,9.5},{18.5,9.5}}, color={30,120,90}));
    connect(intervalD.criterion,nesting.criterionD) annotation(Line(points={{-48.5,-30},{3,-30},{3,-12.5},{18.5,-12.5}}, color={30,120,90}));
    when terminal() then assert(not nesting.configurationValid and nesting.invalidCode == 1,"A wider than B must report the A/B nesting error"); end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>Illegal nesting is a configuration error, not Grade D.</p></html>"));
  end InvalidNested;

  model OutsideD
    Criteria.GradeInterval intervalD(grade=Types.SafetyGrade.D,lower=-4,upper=4);
  equation
    intervalD.z=5;
    when terminal() then
      assert(intervalD.criterion.configurationValid,"Outside-D trajectory must not invalidate the interval");
      assert(not intervalD.criterion.inside and intervalD.criterion.signedMargin < 0,"Expected valid outside-D evidence");
    end when;
    annotation(experiment(StopTime=1), Documentation(info="<html><p>A value outside a legal D interval remains valid evidence with negative margin.</p></html>"));
  end OutsideD;

  annotation(Documentation(info="<html><p>Regression coverage for the new user-facing four-block criterion workflow.</p></html>"));
end CriteriaTests;
