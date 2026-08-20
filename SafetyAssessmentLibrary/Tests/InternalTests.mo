within SafetyAssessmentLibrary.Tests;
package InternalTests "White-box event primitives"
  extends Modelica.Icons.ExamplesPackage;

  model StableEdgeCount
    Internal.Evaluation.ViolationCounter counter;
    Modelica.Blocks.Sources.BooleanConstant active(k=true);
    Modelica.Blocks.Sources.BooleanExpression inside(y=not ((time>=1 and time<2) or (time>=3 and time<4)));
  equation connect(active.y,counter.active); connect(inside.y,counter.inside);
    when terminal() then assert(counter.count==2 and abs(counter.firstTime-1)<1e-6,"Stable violation counting failed"); end when;
    annotation(experiment(StopTime=5,Interval=0.01));
  end StableEdgeCount;

  model SimultaneousRestart
    Internal.Evaluation.ViolationCounter counter;
    Modelica.Blocks.Sources.BooleanExpression active(y=time>=1);
    Modelica.Blocks.Sources.BooleanExpression inside(y=time<1);
  equation connect(active.y,counter.active); connect(inside.y,counter.inside);
    when terminal() then assert(counter.count==1 and abs(counter.firstTime-1)<1e-6,"Event restart produced a duplicate violation"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end SimultaneousRestart;
end InternalTests;