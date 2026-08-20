within SafetyAssessmentLibrary.Evaluation;
block MaxOutsideDuration "Limit total violation exposure"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Modelica.Units.SI.Time maxAllowed[3]={0,1,2} "A/B/C total outside-duration limits";
protected
  Internal.Evaluation.MaxOutsideDurationComparator comparator(maxAllowed=maxAllowed) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="maxOutsideDuration",Icon(graphics={Text(extent={{-78,40},{78,-36}},textString="SUM dt",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> pass[g] = outsideDuration[g] &lt;= maxAllowed[g]. Parameters shall be nonnegative and monotone from A to C.</p><p>Only valid observations inside W contribute to exposure; coverage is reported separately.</p></html>"));
end MaxOutsideDuration;