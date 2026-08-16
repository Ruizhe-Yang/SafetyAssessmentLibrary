within SafetyAssessmentLibrary;
package Types "Public safety-assessment type definitions"
  extends Modelica.Icons.TypesPackage;

  type AssessmentState = enumeration(
      Inactive "The objective is valid but its time window is not active",
      Monitoring "The objective is collecting temporal evidence",
      Resolved "The configured evaluator has frozen a final result",
      Unresolved "The objective is valid but the run supplied insufficient evidence",
      Invalid "The objective configuration is invalid")
    "Lifecycle state; deliberately independent of consequence grade"
    annotation(Documentation(info="<html><p><b>Purpose:</b> represent assessment lifecycle and validity without overloading the safety grade or display code.</p><p><b>Semantics:</b> Unresolved means that a legal objective could not obtain sufficient evidence (for example, an inactive window or unavailable required reference). Invalid is reserved for an illegal objective configuration. A trajectory outside the D envelope is neither Unresolved nor Invalid.</p></html>"));

  type SafetyGrade = enumeration(
      A "Minor / lowest consequence",
      B "Small consequence",
      C "Major consequence",
      D "Critical / saturated highest consequence")
    "Ordered consequence grade"
    annotation(Documentation(info="<html><p><b>Mathematical meaning:</b> the final grade is the strictest passing nested envelope: A if pass[1], otherwise B if pass[2], otherwise C if pass[3], otherwise D.</p><p>D is saturated; failure of the D criterion is represented by grade D plus outerViolation=true.</p></html>"));

  type ReferenceMode = enumeration(
      None "Only the observed/faulted trajectory is used",
      RecordedNominal "A nominal trajectory is supplied by an external binding",
      ParallelNominal "A nominal model runs alongside the faulted model")
    "Origin of an optional reference signal"
    annotation(Documentation(info="<html><p><b>Purpose:</b> document how reference inputs are supplied. The library never instantiates a complete nominal system and version 1.0 does not read recorded files.</p></html>"));

  type BoundaryType = enumeration(
      Open "Endpoint is excluded",
      Closed "Endpoint is included")
    "Interval endpoint inclusion"
    annotation(Documentation(info="<html><p><b>Purpose:</b> configure lower and upper interval membership independently. Signed margin remains zero at either endpoint; membership distinguishes Open from Closed.</p></html>"));

  type EvaluationMode = enumeration(
      AtSimulationEnd "Freeze results at terminal()",
      OnTrigger "Freeze results at the first evaluateTrigger edge")
    "Time at which online evidence is frozen"
    annotation(Documentation(info="<html><p><b>Purpose:</b> select terminal evaluation or explicit early evaluation. OnTrigger freezes once and ignores later samples.</p></html>"));

  type ObservationClass = enumeration(
      Physical "A physical state exposed by the simulated system",
      Operational "A state available through the system's operational observation path")
    "NISSA observation provenance class"
    annotation(Documentation(info="<html><p><b>Purpose:</b> distinguish physical state evidence from operationally observable evidence without introducing domain-specific terms such as sensor or telemetry.</p><p><b>Usage:</b> combine with observationId and observationDescription on a high-level objective.</p></html>"));

  record AssessmentResult "Compact public result of one independent safety assessment asset"
    AssessmentState state "Lifecycle and validity state";
    SafetyGrade grade "Final temporal grade; formal only when state is Resolved";
    Boolean topEvent "FTA-compatible final threshold event";
    Integer displayCode "-1 Invalid, 0 not resolved, 1 D, 2 C, 3 B, 4 A";
    Real sampledMinimumCriticalMargin "Smallest sampled margin for topEventThreshold";
    Real sampledWorstValue "Observed value at the smallest sampled A-envelope margin";
    Modelica.Units.SI.Time firstCriticalTime "First outside time for topEventThreshold, or -1";
    Modelica.Units.SI.Time criticalDuration "Accumulated outside duration for topEventThreshold";
    Modelica.Units.SI.Time longestCriticalDuration "Longest continuous outside segment for topEventThreshold";
    Boolean outerViolation "True if D was violated during the assessed evidence";
    annotation(Documentation(info="<html><p><b>Purpose:</b> provide the single compact public result interface of one Safety Assessment Asset A.</p><p><b>Semantics:</b> state and grade remain distinct. Grade is a formal final conclusion only in Resolved state. A D-envelope violation is Resolved + D + outerViolation, not Invalid.</p><p><b>Evidence:</b> critical fields select the evidence level configured by topEventThreshold; extrema are sampled by the internal online statistics block.</p><p><b>Usage:</b> inspect <code>A.result</code>; the record is a variable, not a connector and cannot feed behavior back to the assessed system.</p><p><b>Limitation:</b> grade-specific internal arrays remain available only inside the asset implementation.</p></html>"));
  end AssessmentResult;

  annotation(Documentation(info="<html><p>Types keeps lifecycle, consequence, observation provenance, reference provenance, interval boundary, and evaluation timing as separate semantics. AssessmentResult is the compact public boundary of an independent A asset. Integer display codes are derived only at reporting boundaries.</p></html>"));
end Types;
