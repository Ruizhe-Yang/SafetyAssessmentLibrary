within SafetyAssessmentLibrary.Examples.Assessments;
model A7_IntegratedExposureSafety "Amplitude-times-duration violation assessment"
  extends BaseClasses.PartialAssessment(objectiveId="A7_EXPOSURE",objectiveName="Integrated exposure",description="Limit integrated negative safety margin",observationId="exposureSignal");
  Modelica.Blocks.Interfaces.RealInput value annotation(Placement(transformation(extent={{-320,50},{-300,70}}),iconTransformation(extent={{-110,-10},{-90,10}})));
protected
  Preprocessing.Identity p annotation(Placement(transformation(extent={{-260,40},{-220,80}})));
  Criteria.GradedCriteria c(lower={0,0,0},upper={1,2,3}) annotation(Placement(transformation(extent={{-180,30},{-120,90}})));
  TimeWindows.FixedWindow w(startTime=2,endTime=18) annotation(Placement(transformation(extent={{-180,-100},{-120,-60}})));
  Evaluation.MaxIntegratedViolation e(maxAllowed={0.2,1,3},samplePeriod=0.05) annotation(Placement(transformation(extent={{-60,10},{40,90}})));
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
  annotation(Icon(graphics={Text(extent={{-92,58},{92,18}},textString="A7 EXPOSURE",textColor={70,105,130},textStyle={TextStyle.Bold}),Text(extent={{-80,4},{80,-30}},textString="int V",textColor={70,70,70})}),Diagram(coordinateSystem(extent={{-300,-130},{300,130}})),experiment(StopTime=20,Interval=0.05),Documentation(info="<html><p>Violation exposure belongs to E: integratedViolation[g]=integral(max(0,-margin[g])) over valid active time. P remains a purely instantaneous identity transform.</p></html>"));
end A7_IntegratedExposureSafety;