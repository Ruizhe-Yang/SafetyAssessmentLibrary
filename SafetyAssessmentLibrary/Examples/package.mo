within SafetyAssessmentLibrary;
package Examples "Independent A assets and executable NISSA Scenarios"
  extends Modelica.Icons.ExamplesPackage;
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={55,135,150}, fillColor={230,247,248}, fillPattern=FillPattern.Solid), Text(extent={{-88,26},{88,-26}}, textString="Examples", textColor={45,105,120})}), Documentation(info="<html><p><b>Organization:</b> Systems contains connector-free M/M_F behavior; Assessments contains eight independent input-only assets; Scenarios retains the two focused executable compositions; A1_A8_Overview places all eight unchanged assets and their established bindings on one 2-by-4 canvas.</p><p><b>NISSA relation:</b> S=M/M_F+ObservationBinding+one or more A, and R is the set of structured records produced by those assessments.</p></html>"));
end Examples;
