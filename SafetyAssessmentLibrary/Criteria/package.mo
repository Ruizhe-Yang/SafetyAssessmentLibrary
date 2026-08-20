within SafetyAssessmentLibrary;
package Criteria "C: graded safety judgement"
  extends Modelica.Icons.Package;
  annotation(
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid),
      Text(extent={{-86,30},{86,-30}}, textString="Criteria", textColor={145,75,25})}),
    Documentation(info="<html><p>C converts one indicator into a single CriteriaResult containing A/B/C membership, margins, typed validity, and no D interval.</p></html>"));
end Criteria;