within SafetyAssessmentLibrary.Examples;
package Assessments "Independent, input-only Safety Assessment Assets"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={55,135,150}, fillColor={230,247,248}, fillPattern=FillPattern.Solid), Text(extent={{-88,28},{88,-28}}, textString="Assessment\nAssets", textColor={45,105,120})}), Documentation(info="<html><p>Each model is one independently stored A_j. It contains no behavioral plant and accepts only the read-only observations, references, or triggers required by that objective.</p></html>"));
end Assessments;