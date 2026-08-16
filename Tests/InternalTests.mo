within SafetyAssessmentLibrary.Tests;
package InternalTests "Retained instantaneous monitoring semantics"
  extends Modelica.Icons.ExamplesPackage;

  model DecisionSemantics
    Criteria.GradeInterval intervalA(lower=-1,upper=1) annotation(Placement(transformation(extent={{-80,50},{-50,70}})));
    Criteria.GradeInterval intervalB(lower=-2,upper=2) annotation(Placement(transformation(extent={{-80,20},{-50,40}})));
    Criteria.GradeInterval intervalC(lower=-3,upper=3) annotation(Placement(transformation(extent={{-80,-10},{-50,10}})));
    Criteria.GradeInterval intervalD(lower=-4,upper=4) annotation(Placement(transformation(extent={{-80,-40},{-50,-20}})));
    Internal.Grade4Monitor monitor annotation(Placement(transformation(extent={{20,-40},{50,70}})));
  equation
    intervalA.z=if time < 0.5 then 0 else 5;
    intervalB.z=intervalA.z; intervalC.z=intervalA.z; intervalD.z=intervalA.z;
    monitor.active=time < 1;
    connect(intervalA.criterion,monitor.criterionA) annotation(Line(points={{-48.5,60},{3,60},{3,53.5},{18.5,53.5}}, color={30,120,90}));
    connect(intervalB.criterion,monitor.criterionB) annotation(Line(points={{-48.5,30},{6,30},{6,31.5},{18.5,31.5}}, color={30,120,90}));
    connect(intervalC.criterion,monitor.criterionC) annotation(Line(points={{-48.5,0},{6,0},{6,9.5},{18.5,9.5}}, color={30,120,90}));
    connect(intervalD.criterion,monitor.criterionD) annotation(Line(points={{-48.5,-30},{3,-30},{3,-12.5},{18.5,-12.5}}, color={30,120,90}));
    when time >= 0.25 then assert(monitor.decision[1] == 1 and monitor.decision[4] == 1,"Inside must produce +1"); end when;
    when time >= 0.75 then assert(monitor.decision[1] == -1 and monitor.decision[4] == -1 and monitor.outerViolation,"Outside D must produce -1 and outerViolation"); end when;
    when terminal() then assert(monitor.decision[1] == 0 and monitor.decision[4] == 0 and not monitor.outerViolation,"Inactive must produce 0"); end when;
    annotation(experiment(StopTime=1.5), Documentation(info="<html><p>The old ternary export convention remains correct inside Internal while no longer cluttering user assessment Diagrams.</p></html>"));
  end DecisionSemantics;

  annotation(Documentation(info="<html><p>Internal regression models preserve established monitor/event semantics after the public package cleanup.</p></html>"));
end InternalTests;
