within SafetyAssessmentLibrary.Examples;
model A1_A8_Overview
  "Unified graphical overview of the eight independent safety assessment assets"
  Systems.NominalSystem M
    annotation(Placement(transformation(extent={{-406,82},{-366,122}})));
  Systems.FaultedSystem M_F
    annotation(Placement(transformation(extent={{-406,22},{-366,62}})));

  Modelica.Blocks.Sources.RealExpression a1SOC(y=M_F.batterySOC)
    annotation(Placement(transformation(extent={{-286,86},{-256,94}})));
  Modelica.Blocks.Sources.RealExpression a2FaultBus(y=M_F.busVoltage)
    annotation(Placement(transformation(extent={{-136,98},{-106,106}})));
  Modelica.Blocks.Sources.RealExpression a2NominalBus(y=M.busVoltage)
    annotation(Placement(transformation(extent={{-136,74},{-106,82}})));
  Modelica.Blocks.Sources.RealExpression a3RateX(y=M_F.bodyRateX)
    annotation(Placement(transformation(extent={{14,104},{44,112}})));
  Modelica.Blocks.Sources.RealExpression a3RateY(y=M_F.bodyRateY)
    annotation(Placement(transformation(extent={{14,92},{44,100}})));
  Modelica.Blocks.Sources.RealExpression a3RateZ(y=M_F.bodyRateZ)
    annotation(Placement(transformation(extent={{14,80},{44,88}})));
  Modelica.Blocks.Sources.BooleanExpression a3Trigger(y=M_F.maneuverTrigger)
    annotation(Placement(transformation(extent={{14,65},{44,73}})));

  Modelica.Blocks.Sources.RealExpression a4Measured(y=1.2*sin(0.4*time))
    annotation(Placement(transformation(extent={{164,117},{194,125}})));
  Modelica.Blocks.Sources.RealExpression a4LowerA(y=-0.5+0.1*sin(0.15*time))
    annotation(Placement(transformation(extent={{164,105.75},{194,113.75}})));
  Modelica.Blocks.Sources.RealExpression a4UpperA(y=0.5+0.1*sin(0.15*time))
    annotation(Placement(transformation(extent={{164,94.5},{194,102.5}})));
  Modelica.Blocks.Sources.RealExpression a4LowerB(y=-1+0.1*sin(0.15*time))
    annotation(Placement(transformation(extent={{164,83.25},{194,91.25}})));
  Modelica.Blocks.Sources.RealExpression a4UpperB(y=1+0.1*sin(0.15*time))
    annotation(Placement(transformation(extent={{164,72},{194,80}})));
  Modelica.Blocks.Sources.RealExpression a4LowerC(y=-1.5+0.1*sin(0.15*time))
    annotation(Placement(transformation(extent={{164,60.75},{194,68.75}})));
  Modelica.Blocks.Sources.RealExpression a4UpperC(y=1.5+0.1*sin(0.15*time))
    annotation(Placement(transformation(extent={{164,49.5},{194,57.5}})));

  Modelica.Blocks.Sources.RealExpression a5Signal(
    y=if (time>=2 and time<3) or (time>=6 and time<7) or (time>=10 and time<11) then 2 else 0)
    annotation(Placement(transformation(extent={{-286,-74},{-256,-66}})));
  Modelica.Blocks.Sources.RealExpression a6Signal(
    y=if time<5 then 0 else 0.6*exp(-(time-5)/1.5))
    annotation(Placement(transformation(extent={{-136,-65},{-106,-57}})));
  Modelica.Blocks.Sources.BooleanExpression a6Trigger(y=time>=5)
    annotation(Placement(transformation(extent={{-136,-89},{-106,-81}})));
  Modelica.Blocks.Sources.RealExpression a7Signal(
    y=if time>=4 and time<6 then 4 else if time>=10 and time<11 then 3.5 else 0.5)
    annotation(Placement(transformation(extent={{14,-74},{44,-66}})));
  Modelica.Blocks.Sources.RealExpression a8Value(y=0)
    annotation(Placement(transformation(extent={{164,-62},{194,-54}})));
  Modelica.Blocks.Sources.BooleanExpression a8Hazard(y=time>=12)
    annotation(Placement(transformation(extent={{164,-86},{194,-78}})));

  Assessments.A1_SOCSafety A1
    annotation(Placement(transformation(extent={{-250,60},{-170,120}})));
  Assessments.A2_BusDeviation A2
    annotation(Placement(transformation(extent={{-100,60},{-20,120}})));
  Assessments.A3_AttitudeRateSafety A3
    annotation(Placement(transformation(extent={{50,60},{130,120}})));
  Assessments.A4_DynamicLimitSafety A4
    annotation(Placement(transformation(extent={{200,40},{280,130}})));
  Assessments.A5_EventCountSafety A5
    annotation(Placement(transformation(extent={{-250,-100},{-170,-40}})));
  Assessments.A6_ResponseRecoverySafety A6
    annotation(Placement(transformation(extent={{-100,-100},{-20,-40}})));
  Assessments.A7_IntegratedExposureSafety A7
    annotation(Placement(transformation(extent={{50,-100},{130,-40}})));
  Assessments.A8_BooleanTopEventSafety A8
    annotation(Placement(transformation(extent={{200,-100},{280,-40}})));
equation
  connect(a1SOC.y,A1.SOC)
    annotation(Line(points={{-254.5,90},{-250,90}},color={0,0,127}));
  connect(a2FaultBus.y,A2.faultBusVoltage)
    annotation(Line(points={{-104.5,102},{-100,102}},color={0,0,127}));
  connect(a2NominalBus.y,A2.nominalBusVoltage)
    annotation(Line(points={{-104.5,78},{-100,78}},color={0,0,127}));
  connect(a3RateX.y,A3.bodyRateX)
    annotation(Line(points={{45.5,108},{50,108}},color={0,0,127}));
  connect(a3RateY.y,A3.bodyRateY)
    annotation(Line(points={{45.5,96},{50,96}},color={0,0,127}));
  connect(a3RateZ.y,A3.bodyRateZ)
    annotation(Line(points={{45.5,84},{50,84}},color={0,0,127}));
  connect(a3Trigger.y,A3.maneuverTrigger)
    annotation(Line(points={{45.5,69},{50,69}},color={255,0,255}));

  connect(a4Measured.y,A4.measured)
    annotation(Line(points={{195.5,121},{200,121}},color={0,0,127}));
  connect(a4LowerA.y,A4.lowerA)
    annotation(Line(points={{195.5,109.75},{200,109.75}},color={0,0,127}));
  connect(a4UpperA.y,A4.upperA)
    annotation(Line(points={{195.5,98.5},{200,98.5}},color={0,0,127}));
  connect(a4LowerB.y,A4.lowerB)
    annotation(Line(points={{195.5,87.25},{200,87.25}},color={0,0,127}));
  connect(a4UpperB.y,A4.upperB)
    annotation(Line(points={{195.5,76},{200,76}},color={0,0,127}));
  connect(a4LowerC.y,A4.lowerC)
    annotation(Line(points={{195.5,64.75},{200,64.75}},color={0,0,127}));
  connect(a4UpperC.y,A4.upperC)
    annotation(Line(points={{195.5,53.5},{200,53.5}},color={0,0,127}));

  connect(a5Signal.y,A5.value)
    annotation(Line(points={{-254.5,-70},{-250,-70}},color={0,0,127}));
  connect(a6Signal.y,A6.responseError)
    annotation(Line(points={{-104.5,-61},{-100,-61}},color={0,0,127}));
  connect(a6Trigger.y,A6.trigger)
    annotation(Line(points={{-104.5,-85},{-100,-85}},color={255,0,255}));
  connect(a7Signal.y,A7.value)
    annotation(Line(points={{45.5,-70},{50,-70}},color={0,0,127}));
  connect(a8Value.y,A8.value)
    annotation(Line(points={{195.5,-58},{200,-58}},color={0,0,127}));
  connect(a8Hazard.y,A8.independentHazard)
    annotation(Line(points={{195.5,-82},{200,-82}},color={255,0,255}));
  annotation(
    Diagram(coordinateSystem(extent={{-420,-150},{320,150}},grid={2,2}),graphics={
      Rectangle(extent={{-414,138},{-350,10}},lineColor={160,170,180},linePattern=LinePattern.Dash),
      Rectangle(extent={{-300,138},{294,28}},lineColor={160,170,180},linePattern=LinePattern.Dash),
      Rectangle(extent={{-300,-28},{294,-118}},lineColor={160,170,180},linePattern=LinePattern.Dash),
      Text(extent={{-414,148},{-350,138}},textString="M / M_F",textColor={70,70,70},textStyle={TextStyle.Bold}),
      Text(extent={{-300,148},{294,138}},textString="A1   A2   A3   A4",textColor={70,70,70},textStyle={TextStyle.Bold}),
      Text(extent={{-300,-118},{294,-130}},textString="A5   A6   A7   A8",textColor={70,70,70},textStyle={TextStyle.Bold}),
      Text(extent={{-414,-8},{-350,-24}},textString="read-only bindings",textColor={90,90,90})}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={
      Rectangle(extent={{-100,100},{100,-100}},lineColor={55,105,145},fillColor={235,244,250},fillPattern=FillPattern.Solid),
      Text(extent={{-86,48},{86,8}},textString="A1-A8",textColor={55,105,145},textStyle={TextStyle.Bold}),
      Text(extent={{-88,-8},{88,-44}},textString="OVERVIEW",textColor={70,70,70})}),
    experiment(StopTime=200,Interval=0.1,Tolerance=1e-6),
    Documentation(info="<html><p><b>Purpose:</b> provide one graphical canvas containing the existing A1 through A8 safety assessment assets.</p><p><b>Composition:</b> the upper row contains A1-A4 and the lower row contains A5-A8. Each asset retains its original parameters, interface, P-C-W-E-Q chain, and evaluation semantics. The adjacent RealExpression and BooleanExpression blocks reproduce the bindings used by the two existing executable Scenarios.</p><p><b>Read-only property:</b> no assessment result is connected back to M, M_F, or any source. A8 remains an independent Boolean safety-condition example; this model introduces no fault-tree concepts.</p><p><b>Expected result:</b> at 200 s A1-A8 resolve to B, C, D, C, D, B, C, A respectively; A3, A5, and the independent Boolean condition of A8 assert their existing top-event output.</p></html>"));
end A1_A8_Overview;
