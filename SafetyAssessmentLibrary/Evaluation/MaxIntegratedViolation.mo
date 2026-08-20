within SafetyAssessmentLibrary.Evaluation;
block MaxIntegratedViolation "Limit the time integral of negative margin"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Real maxAllowed[3]={0,1,2};
protected
  Internal.Evaluation.MaxIntegratedViolationComparator comparator(maxAllowed=maxAllowed) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="maxIntegratedViolation",Icon(graphics={Text(extent={{-78,40},{78,-36}},textString="int V",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> pass[g] when integral(max(0,-margin[g])) over valid active time is not greater than <code>maxAllowed[g]</code>.</p><p>Units equal indicator units multiplied by seconds; users shall configure consistent limits.</p></html>"));
end MaxIntegratedViolation;