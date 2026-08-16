within SafetyAssessmentLibrary.Tests;
package ArchitectureTests "Assessment isolation, input-only boundaries, composition, and rebinding"
  extends Modelica.Icons.ExamplesPackage;

  model AssetIsolationTest "Exercise A1/A2/A3 without any behavioral system instance"
    Modelica.Blocks.Sources.Constant soc(k=0.62) annotation(Placement(transformation(extent={{-100,70},{-80,90}})));
    Modelica.Blocks.Sources.Constant faultBus(k=27.0) annotation(Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Sources.Constant nominalBus(k=28.0) annotation(Placement(transformation(extent={{-100,10},{-80,30}})));
    Modelica.Blocks.Sources.Constant rateX(k=0.12) annotation(Placement(transformation(extent={{-100,-20},{-80,0}})));
    Modelica.Blocks.Sources.Constant rateY(k=0.04) annotation(Placement(transformation(extent={{-100,-45},{-80,-25}})));
    Modelica.Blocks.Sources.Constant rateZ(k=0.02) annotation(Placement(transformation(extent={{-100,-70},{-80,-50}})));
    Modelica.Blocks.Sources.BooleanStep maneuver(startTime=1) annotation(Placement(transformation(extent={{-100,-100},{-80,-80}})));
    Examples.Assessments.A1_SOCSafety A1 annotation(Placement(transformation(extent={{30,60},{60,90}})));
    Examples.Assessments.A2_BusDeviation A2 annotation(Placement(transformation(extent={{30,10},{60,40}})));
    Examples.Assessments.A3_AttitudeRateSafety A3 annotation(Placement(transformation(extent={{30,-70},{60,-40}})));
  equation
    connect(soc.y,A1.SOC) annotation(Line(points={{-79,80},{28.5,80},{28.5,75}}, color={0,0,127}));
    connect(faultBus.y,A2.faultBusVoltage) annotation(Line(points={{-79,50},{18,50},{18,31},{28.5,31}}, color={0,0,127}));
    connect(nominalBus.y,A2.nominalBusVoltage) annotation(Line(points={{-79,20},{16,20},{16,19},{28.5,19}}, color={0,0,127}));
    connect(rateX.y,A3.bodyRateX) annotation(Line(points={{-79,-10},{12,-10},{12,-46},{28.5,-46}}, color={0,0,127}));
    connect(rateY.y,A3.bodyRateY) annotation(Line(points={{-79,-35},{10,-35},{10,-52},{28.5,-52}}, color={0,0,127}));
    connect(rateZ.y,A3.bodyRateZ) annotation(Line(points={{-79,-60},{8,-60},{8,-58},{28.5,-58}}, color={0,0,127}));
    connect(maneuver.y,A3.maneuverTrigger) annotation(Line(points={{-79,-90},{18,-90},{18,-65.5},{28.5,-65.5}}, color={255,0,255}));
    when terminal() then
      assert(A1.result.state == Types.AssessmentState.Resolved,"A1 did not resolve in isolation");
      assert(A2.result.state == Types.AssessmentState.Resolved,"A2 did not resolve in isolation");
      assert(A3.result.state == Types.AssessmentState.Resolved,"A3 did not resolve in isolation");
    end when;
    annotation(experiment(StopTime=200, Interval=0.1), Documentation(info="<html><p>Only signal sources and independent A assets are instantiated; no nominal, faulted, or spacecraft system is hidden in an assessment.</p></html>"));
  end AssetIsolationTest;

  model InputOnlyInterfaceTest "Compile the public input-only A boundary and result record"
    Modelica.Blocks.Sources.Constant soc(k=0.65) annotation(Placement(transformation(extent={{-60,-10},{-40,10}})));
    Examples.Assessments.A1_SOCSafety A1 annotation(Placement(transformation(extent={{20,-20},{60,20}})));
  equation
    connect(soc.y,A1.SOC) annotation(Line(points={{-39,0},{18,0}}, color={0,0,127}));
    when terminal() then assert(A1.result.displayCode >= 1 and A1.result.displayCode <= 4,"Compact result was not resolved"); end when;
    annotation(experiment(StopTime=2, Interval=0.05), Documentation(info="<html><p>A exposes read-only inputs and a nonconnector result record; no output connector can feed the behavioral model.</p></html>"));
  end InputOnlyInterfaceTest;

  model MultiObjectiveScenarioTest "Run the three distinct white-box assessments together"
    extends Examples.Scenarios.S_MultiObjectiveAssessment;
  equation
    when terminal() then
      assert(A1.result.state == Types.AssessmentState.Resolved and A1.result.grade == Types.SafetyGrade.B,"Scenario A1 expected B");
      assert(A2.result.state == Types.AssessmentState.Resolved and A2.result.grade == Types.SafetyGrade.C,"Scenario A2 expected C");
      assert(A3.result.state == Types.AssessmentState.Resolved and A3.result.grade == Types.SafetyGrade.D,"Scenario A3 expected D");
      assert(A3.result.topEvent,"Scenario A3 expected a D-threshold top event");
    end when;
    annotation(Documentation(info="<html><p>Confirms concurrent B/C/D results arise from the coupled trajectories and independent policy choices.</p></html>"));
  end MultiObjectiveScenarioTest;

  model RebindingReuseTest "Change only the binding for a redesigned system hierarchy"
    Examples.Systems.ReboundSystem M2 annotation(Placement(transformation(extent={{-90,-20},{-50,20}})));
    Modelica.Blocks.Sources.RealExpression obsSOC_v2(y=M2.power.storage.SOC)
      annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
    Examples.Assessments.A1_SOCSafety A1 annotation(Placement(transformation(extent={{30,-20},{70,20}})));
  equation
    connect(obsSOC_v2.y,A1.SOC) annotation(Line(points={{-9,0},{28,0}}, color={0,0,127}));
    when terminal() then assert(A1.result.state == Types.AssessmentState.Resolved,"Rebound A1 expected Resolved"); end when;
    annotation(experiment(StopTime=120, Interval=0.1), Documentation(info="<html><p>Only the RealExpression path changes from M_F.batterySOC to M2.power.storage.SOC; the identical A1 file is reused.</p></html>"));
  end RebindingReuseTest;

  annotation(Documentation(info="<html><p>Architecture regression for M/M_F - Observation Binding - independent white-box A - compact AssessmentResult.</p></html>"));
end ArchitectureTests;
