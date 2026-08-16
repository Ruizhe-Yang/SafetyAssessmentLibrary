within SafetyAssessmentLibrary;
package Interfaces "Small signal contracts for white-box safety assessments"
  extends Modelica.Icons.InterfacesPackage;

  record GradeCriterionData "Data carried by one criterion connection"
    Real value "Scalar indicator evaluated by this interval";
    Real signedMargin "Positive inside, zero on a geometric endpoint, negative outside";
    Real lower "Lower interval endpoint";
    Real upper "Upper interval endpoint";
    Boolean lowerClosed "True when the lower endpoint is included";
    Boolean upperClosed "True when the upper endpoint is included";
    Boolean inside "Endpoint-aware membership";
    Boolean configurationValid "True for a nonempty ordered interval";
    annotation(Documentation(info="<html><p>One interval's scalar evidence and endpoint metadata. It is transported through causal signal connectors and contains no physical flow variable.</p></html>"));
  end GradeCriterionData;

  connector GradeCriterionInput = input GradeCriterionData "Criterion evidence input"
    annotation(defaultComponentName="criterion", Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={30,120,90}, fillColor={235,250,245}, fillPattern=FillPattern.Solid)}), Documentation(info="<html><p>Causal compound input used by Evaluation and its internal nesting checker.</p></html>"));
  connector GradeCriterionOutput = output GradeCriterionData "Criterion evidence output"
    annotation(defaultComponentName="criterion", Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={30,120,90}, fillColor={255,255,255}, fillPattern=FillPattern.Solid)}), Documentation(info="<html><p>Causal compound output from Criteria.GradeInterval.</p></html>"));

  record AssessmentEvidenceData "Data carried from Evaluation to Result"
    Boolean active "Current time-window state";
    Boolean evaluated "The selected evaluation instant has been reached";
    Boolean evidenceAvailableAtEvaluation "Usable active-window and data evidence was frozen";
    Boolean configurationValid "Intervals, nesting, time window, and policy are legal";
    Integer invalidCode "0 valid; 1 A/B; 2 B/C; 3 C/D; 4 interval; 5 window; 6 policy; 7 nonmonotone";
    Boolean pass[4] "Frozen pass flags ordered A/B/C/D";
    Real activeDuration "Accumulated active-window duration";
    Real outsideDuration[4] "Accumulated outside duration ordered A/B/C/D";
    Real insideFraction[4] "Active-time fraction inside each interval";
    Real longestOutsideDuration[4] "Longest consecutive outside duration";
    Integer outsideCount[4] "Stable outside-transition count";
    Real firstOutsideTime[4] "First outside time, or -1";
    Real sampledMinimumMargin[4] "Online sampled minimum margins";
    Real sampledWorstValue "Value at the smallest sampled Grade-A margin";
    Real timeOfSampledWorst "Time of sampledWorstValue";
    Boolean everOuterViolation "True when the valid D interval was violated";
    annotation(Documentation(info="<html><p>Internal evidence bundle between a public Evaluation policy and a Result endpoint. It keeps the white-box Diagram to one line while detailed grade arrays remain outside the normal A result tree.</p></html>"));
  end AssessmentEvidenceData;

  connector AssessmentEvidenceInput = input AssessmentEvidenceData "Result evidence input"
    annotation(defaultComponentName="evidence", Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Ellipse(extent={{-100,100},{100,-100}}, lineColor={40,100,170}, fillColor={235,245,255}, fillPattern=FillPattern.Solid)}), Documentation(info="<html><p>Causal compound input to Results.AssessmentResult.</p></html>"));
  connector AssessmentEvidenceOutput = output AssessmentEvidenceData "Evaluation evidence output"
    annotation(defaultComponentName="evidence", Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Ellipse(extent={{-100,100},{100,-100}}, lineColor={40,100,170}, fillColor={255,255,255}, fillPattern=FillPattern.Solid)}), Documentation(info="<html><p>Causal compound output from a public Evaluation policy.</p></html>"));

  partial block PartialAssessment "Metadata-only base class for one independent assessment"
    parameter String objectiveId="A_UNDEFINED" "Traceable safety-objective identifier";
    parameter String description="Independent safety assessment";
    parameter Types.ObservationClass observationClass=Types.ObservationClass.Physical;
    parameter String observationId="" "Scenario-independent observation meaning";
    parameter String observationDescription="";
    parameter Types.ReferenceMode referenceMode=Types.ReferenceMode.None;
    parameter Types.SafetyGrade topEventThreshold=Types.SafetyGrade.D;
    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, radius=14, lineColor={25,90,135},
          fillColor={230,245,250}, fillPattern=FillPattern.Solid),
        Ellipse(extent={{-56,60},{56,-52}}, lineColor={25,90,135},
          fillColor={255,255,255}, fillPattern=FillPattern.Solid),
        Text(extent={{-50,38},{50,-4}}, textString="A", textColor={25,90,135},
          textStyle={TextStyle.Bold}),
        Text(extent={{-72,-22},{72,-50}}, textString="A  B  C  D", textColor={70,70,70}),
        Text(extent={{-96,126},{96,102}}, textString="%name", textColor={70,70,70})}),
      Diagram(coordinateSystem(extent={{-200,-140},{200,140}})),
      Documentation(info="<html><p><b>Purpose:</b> standardize only the identity, observation provenance, reference provenance, and top-event threshold of an independent assessment A.</p><p><b>Contents:</b> metadata and common icon style only. No preprocessor, interval, time window, evaluator, result, reporter, behavioral model, or equations are inherited.</p><p><b>Usage:</b> a concrete A declares its read-only inputs, visible user blocks, connect equations, and compact result record directly in its own file.</p></html>"));
  end PartialAssessment;

  partial block PartialPreprocessor "Common vector observation/reference interface"
    parameter Integer nFault(min=1)=1 "Number of observed/faulted signals";
    parameter Integer nReference(min=0)=0 "Number of externally supplied reference signals";
    Modelica.Blocks.Interfaces.RealInput xFault[nFault] "Read-only observed/faulted signal vector"
      annotation(Placement(transformation(extent={{-120,30},{-100,50}})));
    Modelica.Blocks.Interfaces.RealInput xReference[nReference] "Optional read-only reference vector"
      annotation(Placement(transformation(extent={{-120,-50},{-100,-30}})));
    Modelica.Blocks.Interfaces.RealOutput z "Preprocessed scalar safety indicator"
      annotation(Placement(transformation(extent={{100,-10},{120,10}})));
    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,70},{100,-70}}, radius=8, lineColor={30,80,130},
          fillColor={235,245,255}, fillPattern=FillPattern.Solid),
        Text(extent={{-96,98},{96,74}}, textString="%name", textColor={70,70,70})}),
      Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
      Documentation(info="<html><p>Read-only observation/reference inputs are reduced to one scalar indicator z. Concrete preprocessors contain no external file or plant dependency.</p></html>"));
  end PartialPreprocessor;

  partial block PartialTimeWindow "Common Boolean time-locator interface"
    Modelica.Blocks.Interfaces.BooleanOutput active "True exactly in the monitoring time set"
      annotation(Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.BooleanOutput configurationValid "False for illegal time parameters"
      annotation(Placement(transformation(extent={{100,-70},{120,-50}})));
    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,70},{100,-70}}, radius=8, lineColor={90,70,140},
          fillColor={245,240,255}, fillPattern=FillPattern.Solid),
        Line(points={{-78,-28},{-40,-28},{-40,30},{38,30},{38,-28},{78,-28}},
          color={90,70,140}, thickness=1),
        Text(extent={{-96,98},{96,74}}, textString="%name", textColor={70,70,70})}),
      Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
      Documentation(info="<html><p>Time location is independent of numerical criteria. Finite windows are start-inclusive and end-exclusive.</p></html>"));
  end PartialTimeWindow;

  annotation(Documentation(info="<html><p>User-facing contracts are intentionally small: metadata-only PartialAssessment, preprocessing/time-window signal interfaces, and one compact connector at each Criteria/Evaluation and Evaluation/Result boundary.</p></html>"));
end Interfaces;
