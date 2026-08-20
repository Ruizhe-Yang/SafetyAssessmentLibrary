within SafetyAssessmentLibrary.Examples.Assessments;
model A3_AttitudeRateSafety "Triggered three-axis body-rate persistence assessment"
  extends BaseClasses.PartialAssessment(objectiveId="A3_BODY_RATE",objectiveName="Body-rate safety",description="Three-axis rate norm after maneuver trigger",inputSemantics="Three read-only angular-rate trajectories and one event",units="rad/s",observationId="bodyRate",referenceMode=BaseClasses.ReferenceMode.None);
  Modelica.Blocks.Interfaces.RealInput bodyRateX annotation(Placement(transformation(extent={{-320,80},{-300,100}}),iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealInput bodyRateY annotation(Placement(transformation(extent={{-320,50},{-300,70}}),iconTransformation(extent={{-110,10},{-90,30}})));
  Modelica.Blocks.Interfaces.RealInput bodyRateZ annotation(Placement(transformation(extent={{-320,20},{-300,40}}),iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Blocks.Interfaces.BooleanInput maneuverTrigger annotation(Placement(transformation(extent={{-320,-100},{-300,-80}}),iconTransformation(extent={{-110,-80},{-90,-60}})));
protected
  Preprocessing.EuclideanNorm p(n=3) annotation(Placement(transformation(extent={{-260,40},{-220,80}})));
  Criteria.GradedCriteria c(lower={0,0,0},upper={0.035,0.060,0.100}) annotation(Placement(transformation(extent={{-180,30},{-120,90}})));
  TimeWindows.TriggeredDuration w(duration=100) annotation(Placement(transformation(extent={{-180,-110},{-120,-70}})));
  Evaluation.MaxConsecutiveOutside e(maxAllowed={0,3,10},samplePeriod=0.1) annotation(Placement(transformation(extent={{-60,10},{40,90}})));
  Results.SafetyResult q annotation(Placement(transformation(extent={{80,10},{180,90}})));
  Results.ConsoleReporter reporter(objectiveId=objectiveId,description=description) annotation(Placement(transformation(extent={{210,-70},{270,-30}})));
equation
  connect(bodyRateX,p.xFault[1]) annotation(Line(points={{-310,90},{-280,90},{-280,68},{-260,68}},color={0,0,127}));
  connect(bodyRateY,p.xFault[2]) annotation(Line(points={{-310,60},{-290,60},{-290,68},{-260,68}},color={0,0,127}));
  connect(bodyRateZ,p.xFault[3]) annotation(Line(points={{-310,30},{-270,30},{-270,68},{-260,68}},color={0,0,127}));
  connect(p.z,c.indicator) annotation(Line(points={{-220,60},{-180,60}},color={0,0,127}));
  connect(c.criteria,e.criteria) annotation(Line(points={{-120,60},{-80,60},{-80,66},{-60,66}},color={190,105,35},thickness=0.5));
  connect(maneuverTrigger,w.startTrigger) annotation(Line(points={{-310,-90},{-180,-90}},color={255,0,255}));
  connect(w.window,e.window) annotation(Line(points={{-120,-90},{-10,-90},{-10,10}},color={105,75,155},thickness=0.5));
  connect(e.evaluation,q.evaluation) annotation(Line(points={{40,50},{80,50}},color={55,135,85},thickness=0.5));
  connect(q.result,result) annotation(Line(points={{180,50},{250,50},{250,0},{310,0}},color={160,75,65},thickness=0.5));
  connect(result,reporter.result) annotation(Line(points={{310,0},{290,0},{290,-50},{210,-50}},color={160,75,65},thickness=0.5));
  annotation(Icon(graphics={Text(extent={{-90,64},{90,28}},textString="A3 BODY RATE",textColor={70,105,130},textStyle={TextStyle.Bold}),Text(extent={{-90,8},{90,-22}},textString="MAX dt",textColor={70,70,70})}),Diagram(coordinateSystem(extent={{-300,-130},{300,130}})),experiment(StopTime=200,Interval=0.1),Documentation(info="<html><p>P combines three axes, W starts a finite domain at the maneuver event, E limits continuous rather than total violation duration, and Q produces Grade D when C also fails without misclassifying the objective as Invalid.</p></html>"));
end A3_AttitudeRateSafety;