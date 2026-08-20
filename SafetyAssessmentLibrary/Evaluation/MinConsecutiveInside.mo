within SafetyAssessmentLibrary.Evaluation;
block MinConsecutiveInside "Require a continuous safe dwell"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Modelica.Units.SI.Time minimumDuration[3]={10,8,5};
protected
  Internal.Evaluation.MinConsecutiveInsideComparator comparator(minimumDuration=minimumDuration) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="minConsecutiveInside",Icon(graphics={Text(extent={{-78,40},{78,-36}},textString="SAFE dt",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> pass[g] when the longest continuous valid-and-inside interval reaches <code>minimumDuration[g]</code>.</p><p>Required A/B/C dwell times shall decrease monotonically.</p></html>"));
end MinConsecutiveInside;