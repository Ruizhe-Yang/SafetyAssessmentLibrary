within SafetyAssessmentLibrary.Examples.Assessments;
model A4_DynamicLimitSafety "Dynamic nested-envelope assessment"
  extends BaseClasses.PartialAssessment(objectiveId="A4_DYNAMIC_LIMIT",objectiveName="Dynamic limit safety",description="Time-varying nested A/B/C envelope",inputSemantics="Read-only value and six boundary trajectories",observationId="dynamicBandValue");
  Modelica.Blocks.Interfaces.RealInput measured annotation(Placement(transformation(extent={{-320,90},{-300,110}}),iconTransformation(extent={{-110,70},{-90,90}})));
  Modelica.Blocks.Interfaces.RealInput lowerA annotation(Placement(transformation(extent={{-320,55},{-300,75}}),iconTransformation(extent={{-110,45},{-90,65}})));
  Modelica.Blocks.Interfaces.RealInput upperA annotation(Placement(transformation(extent={{-320,25},{-300,45}}),iconTransformation(extent={{-110,20},{-90,40}})));
  Modelica.Blocks.Interfaces.RealInput lowerB annotation(Placement(transformation(extent={{-320,-5},{-300,15}}),iconTransformation(extent={{-110,-5},{-90,15}})));
  Modelica.Blocks.Interfaces.RealInput upperB annotation(Placement(transformation(extent={{-320,-35},{-300,-15}}),iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Blocks.Interfaces.RealInput lowerC annotation(Placement(transformation(extent={{-320,-65},{-300,-45}}),iconTransformation(extent={{-110,-55},{-90,-35}})));
  Modelica.Blocks.Interfaces.RealInput upperC annotation(Placement(transformation(extent={{-320,-95},{-300,-75}}),iconTransformation(extent={{-110,-80},{-90,-60}})));
protected
  Preprocessing.Identity p annotation(Placement(transformation(extent={{-270,70},{-230,110}})));
  Criteria.DynamicGradedCriteria c annotation(Placement(transformation(extent={{-200,-70},{-100,90}})));
  TimeWindows.Always w annotation(Placement(transformation(extent={{-190,-120},{-130,-80}})));
  Evaluation.AllInside e(samplePeriod=0.05) annotation(Placement(transformation(extent={{-60,0},{40,80}})));
  Results.SafetyResult q annotation(Placement(transformation(extent={{80,0},{180,80}})));
  Results.ConsoleReporter reporter(objectiveId=objectiveId,description=description) annotation(Placement(transformation(extent={{210,-70},{270,-30}})));
equation
  connect(measured,p.xFault[1]) annotation(Line(points={{-310,100},{-280,100},{-280,98},{-270,98}},color={0,0,127}));
  connect(p.z,c.value) annotation(Line(points={{-230,90},{-220,90},{-220,66},{-200,66}},color={0,0,127}));
  connect(lowerA,c.lowerA) annotation(Line(points={{-310,65},{-220,65},{-220,46},{-200,46}},color={0,0,127}));
  connect(upperA,c.upperA) annotation(Line(points={{-310,35},{-230,35},{-230,30},{-200,30}},color={0,0,127}));
  connect(lowerB,c.lowerB) annotation(Line(points={{-310,5},{-240,5},{-240,14},{-200,14}},color={0,0,127}));
  connect(upperB,c.upperB) annotation(Line(points={{-310,-25},{-230,-25},{-230,-2},{-200,-2}},color={0,0,127}));
  connect(lowerC,c.lowerC) annotation(Line(points={{-310,-55},{-220,-55},{-220,-18},{-200,-18}},color={0,0,127}));
  connect(upperC,c.upperC) annotation(Line(points={{-310,-85},{-210,-85},{-210,-42},{-200,-42}},color={0,0,127}));
  connect(c.criteria,e.criteria) annotation(Line(points={{-100,10},{-80,10},{-80,56},{-60,56}},color={190,105,35},thickness=0.5));
  connect(w.window,e.window) annotation(Line(points={{-130,-100},{-10,-100},{-10,0}},color={105,75,155},thickness=0.5));
  connect(e.evaluation,q.evaluation) annotation(Line(points={{40,40},{80,40}},color={55,135,85},thickness=0.5));
  connect(q.result,result) annotation(Line(points={{180,40},{250,40},{250,0},{310,0}},color={160,75,65},thickness=0.5));
  connect(result,reporter.result) annotation(Line(points={{310,0},{290,0},{290,-50},{210,-50}},color={160,75,65},thickness=0.5));
  annotation(Icon(graphics={Text(extent={{-90,62},{90,20}},textString="A4 DYNAMIC",textColor={70,105,130},textStyle={TextStyle.Bold}),Text(extent={{-84,8},{84,-26}},textString="LIMIT",textColor={70,70,70})}),Diagram(coordinateSystem(extent={{-300,-130},{300,130}})),experiment(StopTime=40,Interval=0.05),Documentation(info="<html><p>The dynamic physical bounds are judged directly by C. E latches malformed cross-grade nesting only when W is active, so dynamic-envelope validity is no longer delegated to the Scenario or hidden in margin space.</p></html>"));
end A4_DynamicLimitSafety;