within SafetyAssessmentLibrary.Examples.Systems;
partial model PartialFaultBehavior "Replaceable fault contribution to the example system"
  output Boolean active "Fault activity";
  output Real voltageDrop(unit="V") "Additional bus-voltage loss";
  output Real dischargeMultiplier "Additional relative battery depletion";
  output Real heatAddition(unit="K") "Additional thermal equilibrium rise";
  output Real rateDisturbance(unit="rad/s") "Attitude-rate disturbance introduced by the fault";
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,70},{100,-70}}, lineColor={160,50,50}, fillColor={255,240,240}, fillPattern=FillPattern.Solid), Text(extent={{-80,34},{80,-26}}, textString="F", textColor={160,50,50}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p><b>Purpose:</b> define the replaceable F part of M_F=M+F.</p><p><b>Outputs:</b> internal behavioral contributions, not safety-analysis interfaces.</p><p><b>Limitation:</b> illustrative equations only.</p></html>"));
end PartialFaultBehavior;
