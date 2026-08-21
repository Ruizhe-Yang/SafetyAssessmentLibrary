within SafetyAssessmentLibrary.Evaluation;
block FirstRecoveryWithin "Limit first violation-to-recovery duration"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Modelica.Units.SI.Time maxRecoveryDuration[3]={0,1,2};
  parameter Modelica.Units.SI.Time minimumSafeDwell[3]=fill(0,3);
protected
  Internal.Evaluation.FirstRecoveryWithinComparator comparator(maxRecoveryDuration=maxRecoveryDuration,minimumSafeDwell=minimumSafeDwell) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,10}},color={55,135,85},thickness=0.5));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="firstRecoveryWithin",Icon(graphics={Text(extent={{-82,40},{82,-36}},textString="OUT->IN",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> after the first violation of each level, recovery shall occur within <code>maxRecoveryDuration</code>; an optional minimum continuous safe dwell may also be required.</p><p><b>Dwell origin:</b> <code>minimumSafeDwell</code> is compared with the uninterrupted safe segment beginning at the first recovery. Safe time before the first violation is deliberately excluded, and the segment closes at the next violation or when effective observation activity ends.</p><p>This is violation-to-recovery semantics. For external trigger-to-response semantics use <code>TriggeredResponseWithin</code>.</p></html>"));
end FirstRecoveryWithin;
