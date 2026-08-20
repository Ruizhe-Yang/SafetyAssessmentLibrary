within SafetyAssessmentLibrary.Tests;
package ObjectiveTests "Formal A/B/C/D/Invalid acceptance tests"
  extends Modelica.Icons.ExamplesPackage;
  model GradeA extends Support.StaticAllInside(signalValue=0); equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and q.result.grade==BaseClasses.SafetyGrade.A and not q.result.topEvent,"A result failed"); end when; annotation(experiment(StopTime=1)); end GradeA;
  model GradeB extends Support.StaticAllInside(signalValue=1.5); equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and q.result.grade==BaseClasses.SafetyGrade.B and q.result.pass[2],"B result failed"); end when; annotation(experiment(StopTime=1)); end GradeB;
  model GradeC extends Support.StaticAllInside(signalValue=2.5); equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and q.result.grade==BaseClasses.SafetyGrade.C and q.result.pass[3],"C result failed"); end when; annotation(experiment(StopTime=1)); end GradeC;
  model GradeD extends Support.StaticAllInside(signalValue=4); equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Resolved and q.result.grade==BaseClasses.SafetyGrade.D and q.result.topEvent and not q.result.pass[3],"D saturation/top event failed"); end when; annotation(experiment(StopTime=1)); end GradeD;
  model Invalid
    extends Support.StaticAllInside(signalValue=0,lower={-1,-0.5,-3},upper={1,0.5,3});
  equation when terminal() then assert(q.result.state==BaseClasses.AssessmentState.Invalid and q.result.invalidReason==BaseClasses.InvalidReason.GradeNesting and not q.result.topEvent,"Invalid configuration/result separation failed"); end when;
    annotation(experiment(StopTime=1));
  end Invalid;
end ObjectiveTests;