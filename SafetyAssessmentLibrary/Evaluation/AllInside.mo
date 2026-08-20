within SafetyAssessmentLibrary.Evaluation;
block AllInside "Pass when no violation exposure occurs"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Modelica.Units.SI.Time tolerance(min=0)=1e-9 "Numerical tolerance on accumulated outside duration";
protected
  Internal.Evaluation.AllInsideComparator comparator(tolerance=tolerance) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="allInside",Icon(graphics={Text(extent={{-72,40},{72,-34}},textString="ALL\nIN",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Purpose:</b> pass level g iff its accumulated outside duration is not greater than <code>tolerance</code>.</p><p><b>Inputs:</b> typed C result and W state; optional data-validity and evaluation trigger inherited from the common E boundary.</p><p><b>Output:</b> one typed evaluation result containing pass[3], coverage, and traceable evidence.</p><p><b>Limitation:</b> short excursions are not ignored unless their accumulated duration lies within the numerical tolerance.</p></html>"));
end AllInside;