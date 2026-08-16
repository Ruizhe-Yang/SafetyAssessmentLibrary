within ;
package SafetyAssessmentLibrary
  "Executable safety evidence generation for NISSA scenarios"
  extends Modelica.Icons.Package;

  annotation(
    version="1.2.0",
    versionDate="2026-08-16",
    uses(Modelica(version="4.0.0")),
    preferredView="info",
    Documentation(info="<html>
<p><b>SafetyAssessmentLibrary</b> models one safety objective as one independent,
input-only, graphically composed Modelica assessment. The public white-box workflow is
Preprocessing / TimeWindows / Criteria / Evaluation / Results.</p>
<p>Legal objectives with insufficient active-window or reference evidence end
<b>Unresolved</b>; illegal objective definitions are <b>Invalid</b>; observed critical
behavior remains a resolved grade D result.</p>
<p>A Scenario owns M/M_F and explicit observation bindings. Assessments neither instantiate
the assessed system nor feed forces, flows, heat, power, or control commands back to it.</p>
<p>Runtime dependency: Modelica Standard Library 4.0.0 only.</p>
</html>"));
end SafetyAssessmentLibrary;
