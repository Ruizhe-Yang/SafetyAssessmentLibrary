within SafetyAssessmentLibrary.Examples.Scenarios;
model S_MultiObjectiveAssessment "Coupled M/M_F behavior, explicit bindings, and three white-box assessments"
  Systems.NominalSystem M 
    annotation(Placement(transformation(extent={{-146,35},{-106,75}})));
  Systems.FaultedSystem M_F 
    annotation(Placement(transformation(extent={{-146,-65},{-106,-25}})));

  Modelica.Blocks.Sources.RealExpression obsFaultSOC(y=M_F.batterySOC) 
    annotation(Placement(transformation(origin={20,80},
extent={{-18,-7},{18,7}})));
  Modelica.Blocks.Sources.RealExpression obsFaultBus(y=M_F.busVoltage) 
    annotation(Placement(transformation(origin={20,35},
extent={{-18,-7},{18,7}})));
  Modelica.Blocks.Sources.RealExpression obsNominalBus(y=M.busVoltage) 
    annotation(Placement(transformation(origin={20,15},
extent={{-18,-7},{18,7}})));
  Modelica.Blocks.Sources.RealExpression obsBodyRateX(y=M_F.bodyRateX) 
    annotation(Placement(transformation(origin={20,-55},
extent={{-18,-7},{18,7}})));
  Modelica.Blocks.Sources.RealExpression obsBodyRateY(y=M_F.bodyRateY) 
    annotation(Placement(transformation(origin={20,-65},
extent={{-18,-7},{18,7}})));
  Modelica.Blocks.Sources.RealExpression obsBodyRateZ(y=M_F.bodyRateZ) 
    annotation(Placement(transformation(origin={20,-75},
extent={{-18,-7},{18,7}})));
  Modelica.Blocks.Sources.BooleanExpression obsManeuverTrigger(y=M_F.maneuverTrigger) 
    annotation(Placement(transformation(origin={20,-88},
extent={{-18,-7},{18,7}})));
  Modelica.Blocks.Sources.BooleanExpression obsFaultTrigger(y=M_F.faultTrigger) 
    annotation(Placement(transformation(origin={20,-104},
extent={{-18,-7},{18,7}})));

  Assessments.A1_SOCSafety A1 
    annotation(Placement(transformation(extent={{90,60},{140,100}})));
  Assessments.A2_BusDeviation A2 
    annotation(Placement(transformation(extent={{90,5},{140,45}})));
  Assessments.A3_AttitudeRateSafety A3 
    annotation(Placement(transformation(extent={{90,-95},{140,-45}})));
equation
  connect(obsFaultSOC.y,A1.SOC) 
    annotation(Line(points={{39,80},{90,80}}, color={0,0,127}));
  connect(obsFaultBus.y,A2.faultBusVoltage) 
    annotation(Line(points={{39,35},{66,35},{66,33},{90,33}}, color={0,0,127}));
  connect(obsNominalBus.y,A2.nominalBusVoltage) 
    annotation(Line(points={{39,15},{66,15},{66,17},{90,17}}, color={0,0,127}));
  connect(obsBodyRateX.y,A3.bodyRateX) 
    annotation(Line(points={{39,-55},{90,-55}}, color={0,0,127}));
  connect(obsBodyRateY.y,A3.bodyRateY) 
    annotation(Line(points={{39,-65},{90,-65}}, color={0,0,127}));
  connect(obsBodyRateZ.y,A3.bodyRateZ) 
    annotation(Line(points={{39,-75},{90,-75}}, color={0,0,127}));
  connect(obsManeuverTrigger.y,A3.maneuverTrigger) 
    annotation(Line(points={{39,-88},{66,-88},{66,-87.5},{90,-87.5}}, color={255,0,255}));
  annotation(
    Diagram(coordinateSystem(extent={{-160,-120},{160,120}}, grid={2,2}), graphics={
      Rectangle(extent={{-154,108},{-96,-108}}, lineColor={170,170,170}, linePattern=LinePattern.Dash),
      Rectangle(extent={{-4,108},{54,-116}}, lineColor={170,170,170}, linePattern=LinePattern.Dash),
      Rectangle(extent={{80,108},{150,-108}}, lineColor={170,170,170}, linePattern=LinePattern.Dash),
      Text(extent={{-154,118},{-96,108}}, textString="SYSTEM MODELS", textColor={70,70,70}, textStyle={TextStyle.Bold}),
      Text(extent={{-6,118},{56,108}}, textString="OBSERVATION BINDINGS", textColor={70,70,70}, textStyle={TextStyle.Bold}),
      Text(extent={{80,118},{150,108}}, textString="SAFETY ASSESSMENTS", textColor={70,70,70}, textStyle={TextStyle.Bold}),
      Text(extent={{-150,20},{-102,8}}, textString="same mission task", textColor={90,90,90}),
      Text(extent={{8,-112},{54,-120}}, textString="fault trigger retained as trace", textColor={90,90,90})}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={60,90,130},
        fillColor={245,248,252}, fillPattern=FillPattern.Solid),
      Text(extent={{-84,42},{84,4}}, textString="S", textColor={60,90,130}, textStyle={TextStyle.Bold}),
      Text(extent={{-90,-12},{90,-42}}, textString="M/MF -> A1,A2,A3", textColor={70,70,70})}),
    experiment(StopTime=200, Interval=0.1, Tolerance=1e-6),
    Documentation(info="<html><h4>Purpose</h4><p>Main white-box NISSA demonstration: nominal M, faulted M_F=M+F, explicit observation bindings, and three independent assessment files.</p><h4>Behavior</h4><p>Both systems execute the same maneuver and load profile. M_F redeclares only ScheduledFault, whose voltage, discharge, heat, and attitude effects propagate through the shared coupled equations.</p><h4>Binding</h4><p>RealExpression and BooleanExpression isolate ordinary system-variable paths from stable A interfaces. No assessment-specific connector is added to M or M_F.</p><h4>Assessments</h4><p>A1 evaluates SOC with AllInside; A2 compares faulted and nominal bus voltage with a FixedWindow and MaxOutsideDuration; A3 evaluates a three-axis rate norm with TriggeredDuration and MaxConsecutiveOutside.</p><h4>Expected results</h4><p>The dynamic run is tuned to resolve A1=B, A2=C, and A3=D. A3 reaches its D top-event threshold. These outcomes are computed from trajectories, not assigned constants.</p><h4>Graphical layout</h4><p>The Diagram has three explicit zones: SYSTEM MODELS, OBSERVATION BINDINGS, and SAFETY ASSESSMENTS. Every connect equation has an explicit line ending at the corresponding connector.</p></html>"));
end S_MultiObjectiveAssessment;