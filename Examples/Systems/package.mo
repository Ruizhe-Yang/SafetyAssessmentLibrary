within SafetyAssessmentLibrary.Examples;
package Systems "Self-contained behavioral models used only by assessment Scenarios"
  extends Modelica.Icons.Package;
  annotation(Documentation(info="<html><p><b>Purpose:</b> provide compact, connector-free M and M_F behavioral examples.</p><p><b>Architecture:</b> FaultedSystem reuses CubeSatSystem and redeclares only its replaceable fault behavior, expressing M_F=M+F without duplicating the system equations.</p><p><b>Boundary:</b> these systems do not contain safety assessment assets or safety-analysis output connectors. Scenarios read public state variables through explicit observation bindings.</p></html>"));
end Systems;
