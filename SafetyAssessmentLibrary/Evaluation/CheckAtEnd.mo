within SafetyAssessmentLibrary.Evaluation;
block CheckAtEnd "Evaluate the last valid membership state"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Modelica.Units.SI.Time minimumActiveDuration(min=0)=0;
protected
  Internal.Evaluation.CheckAtEndComparator comparator(minimumActiveDuration=minimumActiveDuration) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="checkAtEnd",Icon(graphics={Text(extent={{-76,38},{76,-34}},textString="END",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> pass level g when valid evidence lasts longer than <code>minimumActiveDuration</code> and the last valid sample is inside level g.</p><p>The last value is captured online. This block does not read a result file after simulation.</p></html>"));
end CheckAtEnd;