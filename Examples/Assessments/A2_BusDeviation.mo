within SafetyAssessmentLibrary.Examples.Assessments;
model A2_BusDeviation "White-box faulted-versus-nominal bus deviation assessment"
  extends Interfaces.PartialAssessment(
    final objectiveId="A2_BUS_DEV",
    final description="Faulted bus voltage deviation from parallel nominal",
    final observationClass=Types.ObservationClass.Physical,
    final observationId="busVoltageDeviation",
    final observationDescription="Relative difference of faulted and nominal bus voltage",
    final referenceMode=Types.ReferenceMode.ParallelNominal,
    final topEventThreshold=Types.SafetyGrade.D);
  Modelica.Blocks.Interfaces.RealInput faultBusVoltage "Read-only bus voltage from M_F"
    annotation(Placement(transformation(extent={{-220,62},{-200,82}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput nominalBusVoltage "Read-only bus voltage from M"
    annotation(Placement(transformation(extent={{-220,26},{-200,46}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Types.AssessmentResult result "Compact public result";
protected
  Preprocessing.RelativeDifference preprocessing(epsilon=1e-6)
    annotation(Placement(transformation(extent={{-170,41},{-130,65}})), HideResult=true);
  Criteria.GradeInterval intervalA(final grade=Types.SafetyGrade.A,lower=-0.02,upper=0.02)
    annotation(Placement(transformation(extent={{-80,38},{-20,60}})), HideResult=true);
  Criteria.GradeInterval intervalB(final grade=Types.SafetyGrade.B,lower=-0.05,upper=0.05)
    annotation(Placement(transformation(extent={{-80,10},{-20,32}})), HideResult=true);
  Criteria.GradeInterval intervalC(final grade=Types.SafetyGrade.C,lower=-0.10,upper=0.10)
    annotation(Placement(transformation(extent={{-80,-18},{-20,4}})), HideResult=true);
  Criteria.GradeInterval intervalD(final grade=Types.SafetyGrade.D,lower=-0.20,upper=0.20)
    annotation(Placement(transformation(extent={{-80,-46},{-20,-24}})), HideResult=true);
  TimeWindows.FixedWindow window(startTime=40,endTime=190)
    annotation(Placement(transformation(extent={{-20,-120},{20,-92}})), HideResult=true);
  Evaluation.MaxOutsideDuration evaluation(maxAllowed={0,5,60,140},samplePeriod=0.1)
    annotation(Placement(transformation(extent={{55,-70},{135,70}})), HideResult=true);
  Results.AssessmentResult resultEndpoint(
    final objectiveId=objectiveId,final description=description,
    final observationClass=observationClass,final observationId=observationId,
    final observationDescription=observationDescription,final referenceMode=referenceMode,
    final topEventThreshold=topEventThreshold)
    annotation(Placement(transformation(extent={{155,-32},{195,32}})), HideResult=true);
equation
  connect(faultBusVoltage,preprocessing.xFault[1])
    annotation(Line(points={{-210,72},{-186,72},{-186,57.8},{-172,57.8}}, color={0,0,127}));
  connect(nominalBusVoltage,preprocessing.xReference[1])
    annotation(Line(points={{-210,36},{-184,36},{-184,48.2},{-172,48.2}}, color={0,0,127}));
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
  connect(window.active,evaluation.active)
    annotation(Line(points={{22,-106},{38,-106},{38,-77},{71,-77}}, color={255,0,255}));
  connect(window.configurationValid,evaluation.windowValid)
    annotation(Line(points={{22,-114.4},{46,-114.4},{46,-77},{87,-77}}, color={255,0,255}));
  connect(evaluation.evidence,resultEndpoint.evidence)
    annotation(Line(points={{139,0},{153,0}}, color={40,100,170}, thickness=0.5));
  result=resultEndpoint.result;
  annotation(
    Icon(graphics={Text(extent={{-88,66},{88,30}}, textString="A2  BUS DEV", textColor={25,90,135}, textStyle={TextStyle.Bold}), Text(extent={{-88,12},{88,-18}}, textString="Max outside T", textColor={70,70,70})}),
    Diagram(coordinateSystem(extent={{-200,-140},{200,140}}), graphics={
      Text(extent={{-188,126},{-116,114}}, textString="RELATIVE DEVIATION", textColor={30,80,130}, textStyle={TextStyle.Bold}),
      Text(extent={{-84,126},{-16,114}}, textString="A/B/C/D CRITERIA", textColor={30,120,90}, textStyle={TextStyle.Bold}),
      Text(extent={{52,126},{138,114}}, textString="EVALUATION", textColor={40,100,170}, textStyle={TextStyle.Bold}),
      Text(extent={{150,126},{200,114}}, textString="RESULT", textColor={25,90,135}, textStyle={TextStyle.Bold}),
      Text(extent={{-26,-126},{26,-138}}, textString="FIXED WINDOW", textColor={90,70,140}, textStyle={TextStyle.Bold})}),
    experiment(StopTime=200, Interval=0.1),
    Documentation(info="<html><p><b>Purpose:</b> compare a faulted bus trajectory with a parallel nominal trajectory while allowing bounded temporary deviation.</p><p><b>Inputs:</b> faultBusVoltage and nominalBusVoltage. The assessment instantiates neither source model.</p><p><b>Graphical workflow:</b> RelativeDifference feeds four editable percentage intervals; FixedWindow feeds MaxOutsideDuration; Result is the endpoint.</p><p><b>Parameters:</b> edit interval limits directly, start/end time on FixedWindow, and the four allowed durations on Evaluation.</p><p><b>Expected scenario behavior:</b> the post-fault deviation exceeds Grade B for too long but remains in Grade C, producing final C with traceable critical duration and margin.</p><p><b>Limitation:</b> reference availability is assumed by this demonstration binding; advanced users may enable Evaluation.useDataValidityInput.</p></html>"));
end A2_BusDeviation;
