within SafetyAssessmentLibrary.Evaluation;
block MaxConsecutiveOutside "Limit the longest continuous violation"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Modelica.Units.SI.Time maxAllowed[3]={0,1,2};
protected
  Internal.Evaluation.MaxConsecutiveOutsideComparator comparator(maxAllowed=maxAllowed) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="maxConsecutiveOutside",Icon(graphics={Text(extent={{-80,40},{80,-36}},textString="MAX dt",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> pass[g] = longestOutsideDuration[g] &lt;= maxAllowed[g]. Separated excursions are evaluated independently.</p><p>Parameters shall be nonnegative and A/B/C-monotone.</p></html>"));
end MaxConsecutiveOutside;