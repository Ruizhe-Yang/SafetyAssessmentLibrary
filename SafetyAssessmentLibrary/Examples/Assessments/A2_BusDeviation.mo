within SafetyAssessmentLibrary.Examples.Assessments;
model A2_BusDeviation "Faulted bus deviation from a parallel nominal trajectory"
  extends BaseClasses.PartialAssessment(objectiveId="A2_BUS_DEV",objectiveName="Bus-voltage deviation",description="Faulted bus voltage relative to the parallel nominal system",inputSemantics="Two read-only voltage trajectories",units="1",observationId="busVoltage",referenceMode=BaseClasses.ReferenceMode.ParallelNominal);
  Modelica.Blocks.Interfaces.RealInput faultBusVoltage annotation(Placement(transformation(extent={{-320,60},{-300,80}}),iconTransformation(extent={{-110,30},{-90,50}})));
  Modelica.Blocks.Interfaces.RealInput nominalBusVoltage annotation(Placement(transformation(extent={{-320,20},{-300,40}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
protected
  Preprocessing.RelativeDifference p(epsilon=1e-6) annotation(Placement(transformation(extent={{-260,30},{-220,70}})));
  Criteria.GradedCriteria c(lower={-0.02,-0.05,-0.10},upper={0.02,0.05,0.10}) annotation(Placement(transformation(extent={{-180,20},{-120,80}})));
  TimeWindows.FixedWindow w(startTime=40,endTime=190) annotation(Placement(transformation(extent={{-180,-100},{-120,-60}})));
  Evaluation.MaxOutsideDuration e(maxAllowed={0,5,60},samplePeriod=0.1) annotation(Placement(transformation(extent={{-60,0},{40,80}})));
  Results.SafetyResult q(acceptableGrade=BaseClasses.SafetyGrade.C) annotation(Placement(transformation(extent={{80,0},{180,80}})));
  Results.ConsoleReporter reporter(objectiveId=objectiveId,description=description,referenceMode=referenceMode) annotation(Placement(transformation(extent={{210,-70},{270,-30}})));
equation
  connect(faultBusVoltage,p.xFault[1]) annotation(Line(points={{-310,70},{-270,70},{-270,58},{-260,58}},color={0,0,127}));
  connect(nominalBusVoltage,p.xReference[1]) annotation(Line(points={{-310,30},{-270,30},{-270,42},{-260,42}},color={0,0,127}));
  connect(p.z,c.indicator) annotation(Line(points={{-220,50},{-180,50}},color={0,0,127}));
  connect(c.criteria,e.criteria) annotation(Line(points={{-120,50},{-80,50},{-80,56},{-60,56}},color={190,105,35},thickness=0.5));
  connect(w.window,e.window) annotation(Line(points={{-120,-80},{-10,-80},{-10,0}},color={105,75,155},thickness=0.5));
  connect(e.evaluation,q.evaluation) annotation(Line(points={{40,40},{80,40}},color={55,135,85},thickness=0.5));
  connect(q.result,result) annotation(Line(points={{180,40},{250,40},{250,0},{310,0}},color={160,75,65},thickness=0.5));
  connect(result,reporter.result) annotation(Line(points={{310,0},{290,0},{290,-50},{210,-50}},color={160,75,65},thickness=0.5));
  annotation(Icon(graphics={Text(extent={{-88,64},{88,28}},textString="A2 BUS DEV",textColor={70,105,130},textStyle={TextStyle.Bold}),Text(extent={{-88,8},{88,-22}},textString="SUM dt",textColor={70,70,70})}),Diagram(coordinateSystem(extent={{-300,-130},{300,130}})),experiment(StopTime=200,Interval=0.1),Documentation(info="<html><p>Demonstrates Scenario-owned parallel nominal comparison: P computes relative deviation; C defines nested consequence limits; W selects [40,190); E limits total exposure; Q resolves the safety result.</p></html>"));
end A2_BusDeviation;