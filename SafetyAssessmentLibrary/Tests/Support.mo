within SafetyAssessmentLibrary.Tests;
package Support "Reusable test fixtures"
  extends Modelica.Icons.InternalPackage;

  partial model StaticAllInside "Complete static P-C-W-E-Q fixture"
    parameter Real signalValue=0;
    parameter Real lower[3]={-1,-2,-3};
    parameter Real upper[3]={1,2,3};
    parameter BaseClasses.BoundaryType lowerBoundary[3]=fill(BaseClasses.BoundaryType.Closed,3);
    parameter BaseClasses.BoundaryType upperBoundary[3]=fill(BaseClasses.BoundaryType.Closed,3);
    Modelica.Blocks.Sources.RealExpression source(y=signalValue);
    Preprocessing.Identity p;
    Criteria.GradedCriteria c(lower=lower,upper=upper,lowerBoundary=lowerBoundary,upperBoundary=upperBoundary);
    TimeWindows.Always w;
    Evaluation.AllInside e(samplePeriod=0.01);
    Results.SafetyResult q;
  equation
    connect(source.y,p.xFault[1]);
    connect(p.z,c.indicator);
    connect(c.criteria,e.criteria);
    connect(w.window,e.window);
    connect(e.evaluation,q.evaluation);
  end StaticAllInside;

  partial model ValidityFixture "Complete chain with data-validity coverage"
    parameter Real minimumCoverage=1;
    Modelica.Blocks.Sources.RealExpression source(y=0);
    Modelica.Blocks.Sources.BooleanExpression valid(y=not (time>=2 and time<4));
    Criteria.GradedCriteria c(lower={-1,-2,-3},upper={1,2,3});
    TimeWindows.FixedWindow w(startTime=0,endTime=10);
    Evaluation.AllInside e(useDataValidityInput=true,minimumDataCoverage=minimumCoverage,samplePeriod=0.01);
    Results.SafetyResult q;
  equation
    connect(source.y,c.indicator);
    connect(c.criteria,e.criteria);
    connect(w.window,e.window);
    connect(valid.y,e.dataValid);
    connect(e.evaluation,q.evaluation);
  end ValidityFixture;
end Support;