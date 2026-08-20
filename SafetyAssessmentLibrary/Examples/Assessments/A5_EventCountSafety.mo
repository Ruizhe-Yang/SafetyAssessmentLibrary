within SafetyAssessmentLibrary.Examples.Assessments;
model A5_EventCountSafety "Violation-entry count assessment"
  extends BaseClasses.PartialAssessment(objectiveId="A5_EVENT_COUNT",objectiveName="Violation-entry count",description="Limit repeated entries into A/B/C violation",observationId="resetError");
  Modelica.Blocks.Interfaces.RealInput value annotation(Placement(transformation(extent={{-320,50},{-300,70}}),iconTransformation(extent={{-110,-10},{-90,10}})));
protected
  Preprocessing.Identity p annotation(Placement(transformation(extent={{-260,40},{-220,80}})));
  Criteria.GradedCriteria c(lower={-0.5,-1,-1.5},upper={0.5,1,1.5}) annotation(Placement(transformation(extent={{-180,30},{-120,90}})));
  TimeWindows.Always w annotation(Placement(transformation(extent={{-180,-100},{-120,-60}})));
  Evaluation.MaxOutsideCount e(maxAllowed={0,1,2},samplePeriod=0.05) annotation(Placement(transformation(extent={{-60,10},{40,90}})));
  Results.SafetyResult q annotation(Placement(transformation(extent={{80,10},{180,90}})));
  Results.ConsoleReporter reporter(objectiveId=objectiveId,description=description) annotation(Placement(transformation(extent={{210,-70},{270,-30}})));
equation
  connect(value,p.xFault[1]) annotation(Line(points={{-310,60},{-270,60},{-270,68},{-260,68}},color={0,0,127}));
  connect(p.z,c.indicator) annotation(Line(points={{-220,60},{-180,60}},color={0,0,127}));
  connect(c.criteria,e.criteria) annotation(Line(points={{-120,60},{-80,60},{-80,66},{-60,66}},color={190,105,35},thickness=0.5));
  connect(w.window,e.window) annotation(Line(points={{-120,-80},{-10,-80},{-10,10}},color={105,75,155},thickness=0.5));
  connect(e.evaluation,q.evaluation) annotation(Line(points={{40,50},{80,50}},color={55,135,85},thickness=0.5));
  connect(q.result,result) annotation(Line(points={{180,50},{250,50},{250,0},{310,0}},color={160,75,65},thickness=0.5));
  connect(result,reporter.result) annotation(Line(points={{310,0},{290,0},{290,-50},{210,-50}},color={160,75,65},thickness=0.5));
  annotation(Icon(graphics={Text(extent={{-90,58},{90,18}},textString="A5 COUNT",textColor={70,105,130},textStyle={TextStyle.Bold}),Text(extent={{-80,4},{80,-30}},textString="N max",textColor={70,70,70})}),Diagram(coordinateSystem(extent={{-300,-130},{300,130}})),experiment(StopTime=20,Interval=0.05),Documentation(info="<html><p>E counts stable entries into violation; event-iteration transients are filtered by the internal stable-edge primitive.</p></html>"));
end A5_EventCountSafety;