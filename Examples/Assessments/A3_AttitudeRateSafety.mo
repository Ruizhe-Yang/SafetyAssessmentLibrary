within SafetyAssessmentLibrary.Examples.Assessments;
model A3_AttitudeRateSafety "White-box vector attitude-rate assessment in a triggered window"
  extends Interfaces.PartialAssessment(
    final objectiveId="A3_BODY_RATE",
    final description="Post-maneuver body-rate persistence objective",
    final observationClass=Types.ObservationClass.Physical,
    final observationId="bodyRateNorm",
    final observationDescription="Euclidean norm of bodyRateX/bodyRateY/bodyRateZ",
    final referenceMode=Types.ReferenceMode.None,
    final topEventThreshold=Types.SafetyGrade.D);
  Modelica.Blocks.Interfaces.RealInput bodyRateX "Read-only body-rate x component"
    annotation(Placement(transformation(extent={{-220,70},{-200,90}}), iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput bodyRateY "Read-only body-rate y component"
    annotation(Placement(transformation(extent={{-220,42},{-200,62}}), iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput bodyRateZ "Read-only body-rate z component"
    annotation(Placement(transformation(extent={{-220,14},{-200,34}}), iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.BooleanInput maneuverTrigger "Start/restart the evaluation window"
    annotation(Placement(transformation(extent={{-220,-108},{-200,-88}}), iconTransformation(extent={{-120,-80},{-100,-60}})));
  Types.AssessmentResult result "Compact public result";
protected
  Preprocessing.EuclideanNorm preprocessing(n=3,w={1,1,1})
    annotation(Placement(transformation(extent={{-170,41},{-130,65}})), HideResult=true);
  Criteria.GradeInterval intervalA(final grade=Types.SafetyGrade.A,lower=0,upper=0.035)
    annotation(Placement(transformation(extent={{-80,38},{-20,60}})), HideResult=true);
  Criteria.GradeInterval intervalB(final grade=Types.SafetyGrade.B,lower=0,upper=0.060)
    annotation(Placement(transformation(extent={{-80,10},{-20,32}})), HideResult=true);
  Criteria.GradeInterval intervalC(final grade=Types.SafetyGrade.C,lower=0,upper=0.100)
    annotation(Placement(transformation(extent={{-80,-18},{-20,4}})), HideResult=true);
  Criteria.GradeInterval intervalD(final grade=Types.SafetyGrade.D,lower=0,upper=0.200)
    annotation(Placement(transformation(extent={{-80,-46},{-20,-24}})), HideResult=true);
  TimeWindows.TriggeredDuration window(duration=100)
    annotation(Placement(transformation(extent={{-20,-120},{20,-92}})), HideResult=true);
  Evaluation.MaxConsecutiveOutside evaluation(maxAllowed={0,3,10,30},samplePeriod=0.1)
    annotation(Placement(transformation(extent={{55,-70},{135,70}})), HideResult=true);
  Results.AssessmentResult resultEndpoint(
    final objectiveId=objectiveId,final description=description,
    final observationClass=observationClass,final observationId=observationId,
    final observationDescription=observationDescription,final referenceMode=referenceMode,
    final topEventThreshold=topEventThreshold)
    annotation(Placement(transformation(extent={{155,-32},{195,32}})), HideResult=true);
equation
  connect(bodyRateX,preprocessing.xFault[1])
    annotation(Line(points={{-210,80},{-184,80},{-184,57.8},{-172,57.8}}, color={0,0,127}));
  connect(bodyRateY,preprocessing.xFault[2])
    annotation(Line(points={{-210,52},{-188,52},{-188,57.8},{-172,57.8}}, color={0,0,127}));
  connect(bodyRateZ,preprocessing.xFault[3])
    annotation(Line(points={{-210,24},{-192,24},{-192,57.8},{-172,57.8}}, color={0,0,127}));
  connect(preprocessing.z,intervalA.z)
    annotation(Line(points={{-128,53},{-106,53},{-106,49},{-83,49}}, color={0,0,127}));
  connect(preprocessing.z,intervalB.z)
    annotation(Line(points={{-128,53},{-106,53},{-106,21},{-83,21}}, color={0,0,127}));
  connect(preprocessing.z,intervalC.z)
    annotation(Line(points={{-128,53},{-106,53},{-106,-7},{-83,-7}}, color={0,0,127}));
  connect(preprocessing.z,intervalD.z)
    annotation(Line(points={{-128,53},{-106,53},{-106,-35},{-83,-35}}, color={0,0,127}));
  connect(intervalA.criterion,evaluation.criterionA)
    annotation(Line(points={{-17,49},{51,49}}, color={30,120,90}, thickness=0.5));
  connect(intervalB.criterion,evaluation.criterionB)
    annotation(Line(points={{-17,21},{51,21}}, color={30,120,90}, thickness=0.5));
  connect(intervalC.criterion,evaluation.criterionC)
    annotation(Line(points={{-17,-7},{51,-7}}, color={30,120,90}, thickness=0.5));
  connect(intervalD.criterion,evaluation.criterionD)
    annotation(Line(points={{-17,-35},{51,-35}}, color={30,120,90}, thickness=0.5));
  connect(maneuverTrigger,window.startTrigger)
    annotation(Line(points={{-210,-98},{-62,-98},{-62,-106},{-22,-106}}, color={255,0,255}));
  connect(window.active,evaluation.active)
    annotation(Line(points={{22,-106},{38,-106},{38,-77},{71,-77}}, color={255,0,255}));
  connect(window.configurationValid,evaluation.windowValid)
    annotation(Line(points={{22,-114.4},{46,-114.4},{46,-77},{87,-77}}, color={255,0,255}));
  connect(evaluation.evidence,resultEndpoint.evidence)
    annotation(Line(points={{139,0},{153,0}}, color={40,100,170}, thickness=0.5));
  result=resultEndpoint.result;
  annotation(
    Icon(graphics={Text(extent={{-90,66},{90,30}}, textString="A3  BODY RATE", textColor={25,90,135}, textStyle={TextStyle.Bold}), Text(extent={{-90,12},{90,-18}}, textString="Triggered persistence", textColor={70,70,70})}),
    Diagram(coordinateSystem(extent={{-200,-140},{200,140}}), graphics={
      Text(extent={{-188,126},{-116,114}}, textString="VECTOR NORM", textColor={30,80,130}, textStyle={TextStyle.Bold}),
      Text(extent={{-84,126},{-16,114}}, textString="A/B/C/D CRITERIA", textColor={30,120,90}, textStyle={TextStyle.Bold}),
      Text(extent={{52,126},{138,114}}, textString="EVALUATION", textColor={40,100,170}, textStyle={TextStyle.Bold}),
      Text(extent={{150,126},{200,114}}, textString="RESULT", textColor={25,90,135}, textStyle={TextStyle.Bold}),
      Text(extent={{-32,-126},{32,-138}}, textString="TRIGGERED WINDOW", textColor={90,70,140}, textStyle={TextStyle.Bold})}),
    experiment(StopTime=200, Interval=0.1),
    Documentation(info="<html><p><b>Purpose:</b> demonstrate a multi-observation, trigger-located temporal safety assessment.</p><p><b>Inputs:</b> three read-only body-rate components and maneuverTrigger.</p><p><b>Graphical workflow:</b> EuclideanNorm forms one magnitude, four visible intervals define A/B/C/D, TriggeredDuration gates MaxConsecutiveOutside, and Result terminates the pipeline.</p><p><b>Parameters:</b> edit interval bounds, the window duration, or the four permitted consecutive durations directly on the blocks.</p><p><b>Expected scenario behavior:</b> the faulted attitude response persists outside Grade C long enough to produce D while remaining a valid assessment; the default D threshold raises Top Event.</p><p><b>Limitation:</b> rates and thresholds are illustrative dimensionless demo values.</p></html>"));
end A3_AttitudeRateSafety;
