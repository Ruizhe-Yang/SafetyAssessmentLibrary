within SafetyAssessmentLibrary;
package BaseClasses "Advanced types, connectors, and partial contracts"
  extends Modelica.Icons.BasesPackage;

  type AssessmentState = enumeration(
      Inactive "Valid objective outside its current time domain",
      Monitoring "Collecting evidence in the time domain",
      Resolved "A final evaluation is available",
      Unresolved "The run did not provide sufficient evidence",
      Invalid "The assessment configuration is illegal");

  type Verdict = enumeration(
      NotAvailable "No normative conclusion is available",
      Satisfied "The acceptable consequence threshold is met",
      Violated "The acceptable consequence threshold is exceeded");

  type SafetyGrade = enumeration(
      A "Nominal or negligible consequence",
      B "Minor consequence",
      C "Major consequence",
      D "Critical consequence");

  type CriterionLevel = enumeration(A, B, C);
  type BoundaryType = enumeration(Open, Closed);
  type EvaluationMode = enumeration(AtSimulationEnd, OnTrigger);
  type ReferenceMode = enumeration(None, RecordedNominal, ParallelNominal);
  type ObservationClass = enumeration(Physical, Operational);

  type InvalidReason = enumeration(
      None "No invalid or unresolved reason",
      CriterionConfiguration "An individual criterion is malformed",
      GradeNesting "Static A/B/C envelopes are not nested",
      DynamicGradeNesting "Dynamic A/B/C envelopes were not nested in the active domain",
      TimeWindowConfiguration "The time-domain configuration is illegal",
      EvaluationConfiguration "An evaluation parameter or pass ordering is illegal",
      MissingObservation "A required observation was unavailable",
      MissingReference "A required reference was unavailable",
      MissingTrigger "A configured trigger did not occur",
      InsufficientDataCoverage "Valid observation coverage is below the required minimum")
    "Typed propagation reason; insufficient evidence is Unresolved, not Invalid";

  record CriteriaResultData "Complete instantaneous C-layer result"
    Real value "Assessment indicator judged by C";
    Boolean inside[3] "A/B/C membership";
    Real margin[3] "A/B/C signed margins";
    Boolean configurationValid;
    InvalidReason invalidReason;
    Boolean isDynamic "True when validity must be accumulated only in active time";
  end CriteriaResultData;
  connector CriteriaResultInput = input CriteriaResultData;
  connector CriteriaResultOutput = output CriteriaResultData;

  record WindowStateData "Complete instantaneous W-layer result"
    Boolean active;
    Boolean configurationValid;
    InvalidReason invalidReason;
  end WindowStateData;
  connector WindowStateInput = input WindowStateData;
  connector WindowStateOutput = output WindowStateData;

  record EvaluationResultData "Frozen E-layer conclusion and temporal evidence"
    Boolean currentWindowActive;
    Boolean evaluated;
    Boolean configurationValid;
    Boolean evidenceAvailable;
    Boolean pass[3];
    InvalidReason invalidReason;
    Modelica.Units.SI.Time windowActiveDuration;
    Modelica.Units.SI.Time validDataDuration;
    Modelica.Units.SI.Time invalidDataDuration;
    Real dataCoverage;
    Boolean currentInside[3];
    Real currentMargin[3];
    Boolean lastInside[3];
    Modelica.Units.SI.Time outsideDuration[3];
    Modelica.Units.SI.Time longestOutsideDuration[3];
    Modelica.Units.SI.Time longestInsideDuration[3];
    Real insideFraction[3];
    Integer outsideCount[3];
    Modelica.Units.SI.Time firstViolationTime[3];
    Modelica.Units.SI.Time firstRecoveryTime[3];
    Modelica.Units.SI.Time recoveryDuration[3];
    Modelica.Units.SI.Time postRecoverySafeDwell[3]
      "Continuous safe dwell beginning at the first recovery";
    Real integratedViolation[3];
    Real minimumMargin[3];
    Real worstValue;
    Modelica.Units.SI.Time timeOfWorst;
    Modelica.Units.SI.Time triggerTime;
    Modelica.Units.SI.Time responseTime[3];
    Modelica.Units.SI.Time responseDuration[3];
  end EvaluationResultData;
  connector EvaluationResultInput = input EvaluationResultData;
  connector EvaluationResultOutput = output EvaluationResultData;

  record AssessmentResult "Structured Q-layer safety result"
    AssessmentState state;
    Verdict verdict;
    SafetyGrade grade;
    Boolean topEvent;
    InvalidReason invalidReason;
    Boolean pass[3] "Frozen A/B/C evaluation conclusion";
    Modelica.Units.SI.Time windowActiveDuration;
    Modelica.Units.SI.Time validDataDuration;
    Modelica.Units.SI.Time invalidDataDuration;
    Real dataCoverage;
    Real insideFraction[3] "A/B/C valid-observation inside fractions";
    Modelica.Units.SI.Time longestInsideDuration[3]
      "A/B/C longest continuous inside durations";
    Modelica.Units.SI.Time firstViolationTimeByLevel[3];
    Modelica.Units.SI.Time firstRecoveryTimeByLevel[3];
    Modelica.Units.SI.Time recoveryDurationByLevel[3];
    Modelica.Units.SI.Time postRecoverySafeDwell[3];
    Modelica.Units.SI.Time triggerTime;
    Modelica.Units.SI.Time responseTime[3];
    Modelica.Units.SI.Time responseDuration[3];
    Real minimumMarginByLevel[3] "A/B/C trace for grade explanation";
    Real minimumMargin "Outer-C minimum margin";
    Real worstValue;
    Modelica.Units.SI.Time timeOfWorst;
    Modelica.Units.SI.Time firstViolationTime;
    Modelica.Units.SI.Time firstRecoveryTime;
    Modelica.Units.SI.Time recoveryDuration;
    Modelica.Units.SI.Time violationDuration;
    Modelica.Units.SI.Time longestViolationDuration;
    Integer violationCount;
    Real integratedViolation;
  end AssessmentResult;
  connector AssessmentResultInput = input AssessmentResult;
  connector AssessmentResultOutput = output AssessmentResult;

  partial block PartialAssessment "Metadata and common right-side result boundary"
    parameter String objectiveId="A_UNDEFINED";
    parameter String objectiveName="Unnamed safety objective";
    parameter String description="Independent safety assessment";
    parameter String inputSemantics="Scenario-bound read-only trajectory";
    parameter String units="1";
    parameter ObservationClass observationClass=ObservationClass.Physical;
    parameter String observationId="";
    parameter String criterionSource="";
    parameter String requirementId="";
    parameter String gradeSemantics="A negligible; B minor; C major; D critical";
    parameter String assetVersion="2.1.0";
    parameter ReferenceMode referenceMode=ReferenceMode.None;
    AssessmentResultOutput result "Read-only structured result" 
      annotation(Placement(
        transformation(extent={{300,-10},{320,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, radius=12, lineColor={70,105,130}, fillColor={232,241,247}, fillPattern=FillPattern.Solid),
        Text(extent={{-82,52},{82,12}}, textString="A", textColor={70,105,130}, textStyle={TextStyle.Bold}),
        Text(extent={{-86,-4},{86,-42}}, textString="P-C-W-E-Q", textColor={70,70,70}),
        Text(extent={{-96,126},{96,102}}, textString="%name", textColor={70,70,70})}),
      Diagram(coordinateSystem(extent={{-300,-140},{300,140}})),
      Documentation(info="<html><p><b>Purpose:</b> hold Des metadata and enforce one right-side result connector. It contains no safety computation and no system feedback.</p></html>"));
  end PartialAssessment;

  partial block PartialReferenceAssessment
    extends PartialAssessment;
    Modelica.Blocks.Interfaces.RealInput reference 
      annotation(Placement(
        transformation(extent={{-320,-50},{-300,-30}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));
  end PartialReferenceAssessment;

  partial block PartialTriggeredAssessment
    extends PartialAssessment;
    Modelica.Blocks.Interfaces.BooleanInput trigger 
      annotation(Placement(
        transformation(extent={{-320,-90},{-300,-70}}),
        iconTransformation(extent={{-110,-80},{-90,-60}})));
  end PartialTriggeredAssessment;

  partial block PartialPreprocessor "Vector trajectory to scalar indicator"
    parameter Integer nFault(min=1)=1;
    parameter Integer nReference(min=0)=0;
    Modelica.Blocks.Interfaces.RealInput xFault[nFault] 
      annotation(Placement(transformation(extent={{-120,30},{-100,50}}), iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.RealInput xReference[nReference] 
      annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}), iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.RealOutput z 
      annotation(Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{90,-10},{110,10}})));
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid),
      Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}));
  end PartialPreprocessor;

  partial block PartialScalarTransform "One Real trajectory transformed to one Real trajectory"
    Modelica.Blocks.Interfaces.RealInput u 
      annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealOutput y 
      annotation(Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{90,-10},{110,10}})));
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid),
      Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}));
  end PartialScalarTransform;

  partial block PartialTimeWindow "Canonical W-layer contract"
    WindowStateOutput window 
      annotation(Placement(
        transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={105,75,155}, fillColor={242,236,250}, fillPattern=FillPattern.Solid),
      Line(points={{-78,-28},{-40,-28},{-40,30},{38,30},{38,-28},{78,-28}}, color={105,75,155}, thickness=1),
      Text(extent={{-96,100},{96,76}}, textString="%name", textColor={70,60,90})}));
  end PartialTimeWindow;

  annotation(
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={110,110,110}, fillColor={242,242,242}, fillPattern=FillPattern.Solid),
      Text(extent={{-88,26},{88,-26}}, textString="Base\nClasses", textColor={75,75,75})}),
    Documentation(info="<html><p>Advanced contracts supporting the public P-C-W-E-Q palette. Ordinary users do not need to place these classes.</p></html>"));
end BaseClasses;
