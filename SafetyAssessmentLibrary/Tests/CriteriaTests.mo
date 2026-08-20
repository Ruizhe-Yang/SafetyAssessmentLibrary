within SafetyAssessmentLibrary.Tests;
package CriteriaTests "Static, dynamic, and boundary criteria tests"
  extends Modelica.Icons.ExamplesPackage;

  model StaticNested
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3});
    Modelica.Blocks.Sources.Constant x(k=0);
  equation connect(x.y,c.indicator);
    when terminal() then assert(c.criteria.configurationValid and Modelica.Math.BooleanVectors.allTrue(c.criteria.inside),"Nested criteria failed"); end when;
    annotation(experiment(StopTime=0.1));
  end StaticNested;

  model ClosedBoundary
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3});
    Modelica.Blocks.Sources.Constant x(k=1);
  equation connect(x.y,c.indicator);
    when terminal() then assert(c.criteria.inside[1] and abs(c.criteria.margin[1])<1e-12,"Closed boundary shall be inside with zero margin"); end when;
    annotation(experiment(StopTime=0.1));
  end ClosedBoundary;

  model OpenBoundary
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3},upperBoundary={BaseClasses.BoundaryType.Open,BaseClasses.BoundaryType.Closed,BaseClasses.BoundaryType.Closed});
    Modelica.Blocks.Sources.Constant x(k=1);
  equation connect(x.y,c.indicator);
    when terminal() then assert(not c.criteria.inside[1] and c.criteria.inside[2],"Open A boundary shall fail A only"); end when;
    annotation(experiment(StopTime=0.1));
  end OpenBoundary;

  model InvalidNesting
    Criteria.GradedCriteria c(lower={-1,-0.5,-3},upper={1,0.5,3});
    Modelica.Blocks.Sources.Constant x(k=0);
  equation connect(x.y,c.indicator);
    when terminal() then assert(not c.criteria.configurationValid and c.criteria.invalidReason==BaseClasses.InvalidReason.GradeNesting,"Invalid nesting not detected"); end when;
    annotation(experiment(StopTime=0.1));
  end InvalidNesting;

  model OutsideOuter
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3});
    Modelica.Blocks.Sources.Constant x(k=4);
  equation connect(x.y,c.indicator);
    when terminal() then assert(c.criteria.configurationValid and not Modelica.Math.BooleanVectors.anyTrue(c.criteria.inside),"Outside C must remain valid configuration"); end when;
    annotation(experiment(StopTime=0.1));
  end OutsideOuter;

  model DynamicNested
    Criteria.DynamicGradedCriteria c;
    Modelica.Blocks.Sources.RealExpression x(y=0),la(y=-1),ua(y=1),lb(y=-2),ub(y=2),lc(y=-3),uc(y=3);
  equation
    connect(x.y,c.value); connect(la.y,c.lowerA); connect(ua.y,c.upperA); connect(lb.y,c.lowerB); connect(ub.y,c.upperB); connect(lc.y,c.lowerC); connect(uc.y,c.upperC);
    when terminal() then assert(c.criteria.configurationValid and c.criteria.isDynamic,"Valid dynamic nesting failed"); end when;
    annotation(experiment(StopTime=1));
  end DynamicNested;

  model DynamicCrossing
    Criteria.DynamicGradedCriteria c;
    Modelica.Blocks.Sources.RealExpression x(y=0),la(y=if time<0.5 then -1 else -2.5),ua(y=1),lb(y=-2),ub(y=2),lc(y=-3),uc(y=3);
  equation
    connect(x.y,c.value); connect(la.y,c.lowerA); connect(ua.y,c.upperA); connect(lb.y,c.lowerB); connect(ub.y,c.upperB); connect(lc.y,c.lowerC); connect(uc.y,c.upperC);
    when terminal() then assert(not c.criteria.configurationValid and c.criteria.invalidReason==BaseClasses.InvalidReason.DynamicGradeNesting,"Dynamic crossing not detected"); end when;
    annotation(experiment(StopTime=1));
  end DynamicCrossing;
end CriteriaTests;