within SafetyAssessmentLibrary.Evaluation;
block TriggeredResponseWithin "Limit trigger-to-first-safe-response duration"
  extends Internal.Evaluation.PartialEvaluation;
  parameter Modelica.Units.SI.Time maxResponseDuration[3]={1,2,4};
  Modelica.Blocks.Interfaces.BooleanInput trigger annotation(Placement(transformation(extent={{-220,-100},{-200,-80}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
protected
  Internal.Evaluation.TriggeredResponseComparator comparator(maxResponseDuration=maxResponseDuration) annotation(Placement(transformation(extent={{-10,-20},{50,40}})));
equation
  connect(core.evidence,comparator.evidence) annotation(Line(points={{-50,20},{-10,20},{-10,19}},color={55,135,85},thickness=0.5));
  connect(trigger,comparator.trigger) annotation(Line(points={{-210,-90},{-20,-90},{-20,-8},{-10,-8}},color={255,0,255}));
  connect(comparator.candidate,assembler.candidate) annotation(Line(points={{50,10},{70,10},{70,-20},{90,-20}},color={55,135,85},thickness=0.5));
  annotation(defaultComponentName="triggeredResponseWithin",Icon(graphics={Text(extent={{-86,40},{86,-36}},textString="TRIG->IN",textColor={40,105,65},textStyle={TextStyle.Bold})}),Documentation(info="<html><p><b>Meaning:</b> measure from the first rising edge of <code>trigger</code> to the first subsequent safe membership of each level. Pass when that response duration does not exceed the A/B/C limit.</p><p><b>Observation validity:</b> a response is eligible only while <code>effectiveActive = window.active and dataValid and criteria.configurationValid</code>. An inside value outside W, during invalid data, or under an invalid criterion configuration is not latched as a response.</p><p>If no trigger occurs, the evaluation is Unresolved with reason MissingTrigger.</p></html>"));
end TriggeredResponseWithin;
