within SafetyAssessmentLibrary.Examples;
package Scenarios "Executable NISSA Scenarios S=M/M_F+bindings+one or more A"
  extends Modelica.Icons.ExamplesPackage;
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={55,135,150}, fillColor={230,247,248}, fillPattern=FillPattern.Solid), Text(extent={{-88,28},{88,-28}}, textString="Executable\nScenarios", textColor={45,105,120})}), Documentation(info="<html><p>A Scenario owns behavioral assets or source trajectories and explicit observation bindings, then attaches one or more independent assessment assets. Its result set is R={A1.result,A2.result,...}; no result feeds system behavior.</p></html>"));
end Scenarios;