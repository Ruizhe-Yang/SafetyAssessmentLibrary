within SafetyAssessmentLibrary.Examples.Assessments;
model A1_SOCSafety "Battery SOC: direct range assessment"
  extends BaseClasses.PartialAssessment(objectiveId="A1_SOC",objectiveName="Battery SOC safety",description="Battery SOC safety objective",inputSemantics="Read-only state of charge",units="1",observationClass=BaseClasses.ObservationClass.Operational,observationId="batterySOC",criterionSource="NISSA paper Section 3.3",referenceMode=BaseClasses.ReferenceMode.None);
  Modelica.Blocks.Interfaces.RealInput SOC annotation(Placement(transformation(extent={{-320,50},{-300,70}}),iconTransformation(extent={{-110,-10},{-90,10}})));
protected
  Preprocessing.Identity p annotation(Placement(transformation(extent={{-260,40},{-220,80}})));
  Criteria.GradedCriteria c(lower={0.58,0.39,0.30},upper={0.85,0.90,0.95}) annotation(Placement(transformation(origin={-143,60},
extent={{-23,-20},{23,20}})));
  TimeWindows.Always w annotation(Placement(transformation(extent={{-180,-100},{-120,-60}})));
  Evaluation.AllInside e(samplePeriod=0.1) annotation(Placement(transformation(extent={{-60,10},{40,90}})));
  Results.SafetyResult q(acceptableGrade=BaseClasses.SafetyGrade.C,topEventThreshold=BaseClasses.SafetyGrade.D) annotation(Placement(transformation(extent={{80,10},{180,90}})));
  Results.ConsoleReporter reporter(objectiveId=objectiveId,description=description,referenceMode=referenceMode) annotation(Placement(transformation(extent={{210,-70},{270,-30}})));
equation
  connect(SOC,p.xFault[1]) annotation(Line(points={{-310,60},{-270,60},{-270,68},{-260,68}},color={0,0,127}));
  connect(p.z,c.indicator) annotation(Line(points={{-220,60},{-180,60}},color={0,0,127}));
  connect(c.criteria,e.criteria) annotation(Line(points={{-120,60},{-80,60},{-80,66},{-60,66}},color={190,105,35},thickness=0.5));
  connect(w.window,e.window) annotation(Line(points={{-120,-80},{-10,-80},{-10,10}},color={105,75,155},thickness=0.5));
  connect(e.evaluation,q.evaluation) annotation(Line(points={{40,50},{80,50}},color={55,135,85},thickness=0.5));
  connect(q.result,result) annotation(Line(points={{180,50},{250,50},{250,0},{310,0}},color={160,75,65},thickness=0.5));
  connect(result,reporter.result) annotation(Line(points={{310,0},{290,0},{290,-50},{210,-50}},color={160,75,65},thickness=0.5));
  annotation(Icon(graphics={Text(extent={{-82,64},{82,28}},textString="A1 SOC",textColor={70,105,130},textStyle={TextStyle.Bold}),Text(extent={{-78,8},{78,-22}},textString="ALL IN",textColor={70,70,70})}),Diagram(coordinateSystem(extent={{-300,-130},{300,130}}),graphics={Text(extent={{-280,122},{-210,108}},textString="P",textColor={45,105,165}),Text(extent={{-180,122},{-110,108}},textString="C",textColor={190,105,35}),Text(extent={{-180,-108},{-110,-122}},textString="W",textColor={105,75,155}),Text(extent={{-50,122},{40,108}},textString="E",textColor={55,135,85}),Text(extent={{90,122},{180,108}},textString="Q",textColor={160,75,65})}),experiment(StopTime=200,Interval=0.1),Documentation(info="<html><p>Canonical A=&lt;P,C,W,E,Q,Des&gt; composition for one SOC trajectory. The Diagram exposes every semantic stage and the formal structured result connector at the right boundary.</p></html>"));
end A1_SOCSafety;