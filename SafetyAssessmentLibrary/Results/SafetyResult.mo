within SafetyAssessmentLibrary.Results;
block SafetyResult "Resolve E evidence into one structured Q result"
  parameter BaseClasses.SafetyGrade acceptableGrade=BaseClasses.SafetyGrade.C "Highest grade satisfying the objective";
  parameter Boolean topEventEnabled=true;
  parameter Boolean useGradeTopEvent=true "False selects the independent Boolean mapping";
  parameter BaseClasses.SafetyGrade topEventThreshold=BaseClasses.SafetyGrade.D;
  BaseClasses.EvaluationResultInput evaluation annotation(Placement(transformation(extent={{-220,-10},{-200,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.BooleanInput independentTopEvent if topEventEnabled and not useGradeTopEvent annotation(Placement(transformation(extent={{-220,-90},{-200,-70}}),iconTransformation(extent={{-110,-80},{-90,-60}})));
  BaseClasses.AssessmentResultOutput result annotation(Placement(transformation(extent={{200,-10},{220,10}}),iconTransformation(extent={{90,-10},{110,10}})));
protected
  Internal.Results.LifecycleStateResolver lifecycle annotation(Placement(transformation(extent={{-150,65},{-110,105}})));
  Internal.Results.GradeResolver gradeResolver annotation(Placement(transformation(extent={{-150,5},{-110,45}})));
  Internal.Results.VerdictResolver verdictResolver(acceptableGrade=acceptableGrade) annotation(Placement(transformation(extent={{-60,55},{-20,95}})));
  Internal.Results.TopEventResolver topEventResolver(enabled=topEventEnabled,useGradeThreshold=useGradeTopEvent,threshold=topEventThreshold) annotation(Placement(transformation(extent={{-60,-5},{-20,35}})));
  Internal.Results.EvidenceAssembler evidenceAssembler annotation(Placement(transformation(extent={{-60,-75},{-20,-35}})));
  Internal.Results.ResultAssembler assembler annotation(Placement(transformation(extent={{70,-40},{130,40}})));
equation
  connect(evaluation,lifecycle.evaluation) annotation(Line(points={{-210,0},{-180,0},{-180,85},{-150,85}},color={55,135,85},thickness=0.5));
  connect(evaluation,gradeResolver.evaluation) annotation(Line(points={{-210,0},{-180,0},{-180,25},{-150,25}},color={55,135,85},thickness=0.5));
  connect(evaluation,evidenceAssembler.evaluation) annotation(Line(points={{-210,0},{-90,0},{-90,-55},{-60,-55}},color={55,135,85},thickness=0.5));
  connect(lifecycle.state,verdictResolver.state) annotation(Line(points={{-110,85},{-82,85},{-82,83},{-60,83}},color={160,75,65}));
  connect(gradeResolver.grade,verdictResolver.grade) annotation(Line(points={{-110,25},{-82,25},{-82,67},{-60,67}},color={160,75,65}));
  connect(lifecycle.state,topEventResolver.state) annotation(Line(points={{-110,85},{-76,85},{-76,27},{-60,27}},color={160,75,65}));
  connect(gradeResolver.grade,topEventResolver.grade) annotation(Line(points={{-110,25},{-76,25},{-76,15},{-60,15}},color={160,75,65}));
  connect(independentTopEvent,topEventResolver.independentCondition) annotation(Line(points={{-210,-80},{-92,-80},{-92,3},{-60,3}},color={255,0,255}));
  connect(lifecycle.state,assembler.state) annotation(Line(points={{-110,85},{20,85},{20,32},{70,32}},color={160,75,65}));
  connect(verdictResolver.verdict,assembler.verdict) annotation(Line(points={{-20,75},{28,75},{28,16},{70,16}},color={160,75,65}));
  connect(gradeResolver.grade,assembler.grade) annotation(Line(points={{-110,25},{36,25},{36,0},{70,0}},color={160,75,65}));
  connect(topEventResolver.topEvent,assembler.topEvent) annotation(Line(points={{-20,15},{44,15},{44,-16},{70,-16}},color={255,0,255}));
  connect(evidenceAssembler.evidence,assembler.evidence) annotation(Line(points={{-20,-55},{52,-55},{52,-32},{70,-32}},color={160,75,65},thickness=0.5));
  connect(assembler.result,result) annotation(Line(points={{130,0},{210,0}},color={160,75,65},thickness=0.5));
  annotation(defaultComponentName="safetyResult",Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,88},{100,-88}},radius=12,lineColor={160,75,65},fillColor={248,232,228},fillPattern=FillPattern.Solid),Text(extent={{-84,48},{84,6}},textString="Q",textColor={125,55,45},textStyle={TextStyle.Bold}),Text(extent={{-88,-4},{88,-48}},textString="SA RESULT",textColor={125,55,45}),Text(extent={{-96,112},{96,90}},textString="%name",textColor={90,65,60})}),Diagram(coordinateSystem(extent={{-200,-120},{200,120}})),Documentation(info="<html><p><b>Purpose:</b> map a frozen typed E result to lifecycle state, A/B/C/D grade, normative verdict, Boolean top-event output, and traceable evidence.</p><p><b>Grade:</b> A if pass[1], else B if pass[2], else C if pass[3], else D. A D result is a saturated critical consequence, not an invalid configuration.</p><p><b>Evidence:</b> Q preserves the A/B/C inside fractions, longest inside durations, violation and recovery times, post-recovery dwell, and trigger/response timing already computed by E; Q does not recompute temporal semantics.</p><p><b>State:</b> illegal configuration gives Invalid; insufficient coverage or a missing required trigger gives Unresolved; only available frozen evidence gives Resolved.</p><p><b>Top event:</b> gated by Resolved state and independently configured either from a grade threshold or from <code>independentTopEvent</code>. This Boolean mapping does not make SafetyAssessmentLibrary a fault-tree library.</p><p><b>Limitation:</b> this block does not alter the assessed model and does not infer occurrence probabilities.</p></html>"));
end SafetyResult;
