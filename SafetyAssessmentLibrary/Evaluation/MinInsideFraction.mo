within SafetyAssessmentLibrary.Evaluation;
block MinInsideFraction "Require a minimum valid-time safety fraction"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Real minimumFraction[3]={1,0.99,0.95};
  parameter Modelica.Units.SI.Time minimumActiveDuration(min=0)=0;
protected
  Internal.Evaluation.MinInsideFractionComparator comparator(minimumFraction=minimumFraction,minimumActiveDuration=minimumActiveDuration) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="minInsideFraction",Icon(graphics={Text(extent={{-78,40},{78,-36}},textString="% IN",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> pass[g] = insideFraction[g] &gt;= minimumFraction[g], provided enough valid duration exists. Fractions use valid-data duration as denominator.</p><p>Required fractions shall lie in [0,1] and decrease monotonically from A to C.</p></html>"));
end MinInsideFraction;