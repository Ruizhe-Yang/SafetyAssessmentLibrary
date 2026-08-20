within SafetyAssessmentLibrary.Examples.Assessments;
model A6_ResponseRecoverySafety "First recovery and safe-dwell assessment"
  extends BaseClasses.PartialAssessment(objectiveId="A6_RECOVERY",objectiveName="Response recovery",description="Recovery from first violation with a safe-dwell requirement",observationId="responseError");
  Modelica.Blocks.Interfaces.RealInput responseError annotation(Placement(transformation(extent={{-320,50},{-300,70}}),iconTransformation(extent={{-110,20},{-90,40}})));
  Modelica.Blocks.Interfaces.BooleanInput trigger annotation(Placement(transformation(extent={{-320,-100},{-300,-80}}),iconTransformation(extent={{-110,-60},{-90,-40}})));
protected
  Preprocessing.Identity p annotation(Placement(transformation(extent={{-260,40},{-220,80}})));
  Criteria.GradedCriteria c(lower={-0.1,-0.2,-0.4},upper={0.1,0.2,0.4}) annotation(Placement(transformation(extent={{-180,30},{-120,90}})));
  TimeWindows.TriggeredDuration w(duration=20) annotation(Placement(transformation(extent={{-180,-110},{-120,-70}})));
  Evaluation.FirstRecoveryWithin e(maxRecoveryDuration={2,4,8},minimumSafeDwell={8,5,3},samplePeriod=0.05) annotation(Placement(transformation(extent={{-60,10},{40,90}})));
  Results.SafetyResult q annotation(Placement(transformation(extent={{80,10},{180,90}})));
  Results.ConsoleReporter reporter(objectiveId=objectiveId,description=description) annotation(Placement(transformation(extent={{210,-70},{270,-30}})));
equation
  connect(responseError,p.xFault[1]) annotation(Line(points={{-310,60},{-270,60},{-270,68},{-260,68}},color={0,0,127}));
  connect(p.z,c.indicator) annotation(Line(points={{-220,60},{-180,60}},color={0,0,127}));
  connect(c.criteria,e.criteria) annotation(Line(points={{-120,60},{-80,60},{-80,66},{-60,66}},color={190,105,35},thickness=0.5));
  connect(trigger,w.startTrigger) annotation(Line(points={{-310,-90},{-180,-90}},color={255,0,255}));
  connect(w.window,e.window) annotation(Line(points={{-120,-90},{-10,-90},{-10,10}},color={105,75,155},thickness=0.5));
  connect(e.evaluation,q.evaluation) annotation(Line(points={{40,50},{80,50}},color={55,135,85},thickness=0.5));
  connect(q.result,result) annotation(Line(points={{180,50},{250,50},{250,0},{310,0}},color={160,75,65},thickness=0.5));
  connect(result,reporter.result) annotation(Line(points={{310,0},{290,0},{290,-50},{210,-50}},color={160,75,65},thickness=0.5));
  annotation(Icon(graphics={Text(extent={{-90,60},{90,18}},textString="A6 RECOVERY",textColor={70,105,130},textStyle={TextStyle.Bold}),Text(extent={{-80,4},{80,-30}},textString="OUT->IN",textColor={70,70,70})}),Diagram(coordinateSystem(extent={{-300,-130},{300,130}})),experiment(StopTime=30,Interval=0.05),Documentation(info="<html><p>FirstRecoveryWithin measures first violation to first recovery, then checks safe dwell. It is deliberately distinct from TriggeredResponseWithin, which measures an external trigger to a safe response.</p></html>"));
end A6_ResponseRecoverySafety;