within SafetyAssessmentLibrary;
package Evaluation "Engineering temporal evaluation semantics"
  extends Modelica.Icons.Package;
  annotation(Documentation(info="<html><p>Public evaluation blocks implement one explicit engineering question each. They consume a typed criteria result and a typed time-window state, accumulate evidence online, and emit one typed evaluation result. Fine-grained statistics remain visible in <code>Internal.Evaluation</code> for white-box inspection.</p></html>"));
end Evaluation;