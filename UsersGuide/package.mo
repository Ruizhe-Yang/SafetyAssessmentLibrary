within SafetyAssessmentLibrary;
package UsersGuide "User guide"
  extends Modelica.Icons.Information;

  class Overview "Purpose and scope"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><h4>Purpose</h4><p>SafetyAssessmentLibrary lets a safety analyst build one safety objective as one independent, input-only Modelica assessment A. The normal graphical workflow is Observation -&gt; Preprocessing -&gt; four A/B/C/D Criteria -&gt; Evaluation -&gt; Result, with a separate TimeWindow connected to Evaluation.</p><h4>Public boundary</h4><p>A accepts read-only signals, exposes no physical or command output connector, and publishes one compact Types.AssessmentResult record.</p><h4>Runtime boundary</h4><p>The library depends only on Modelica Standard Library 4.0.0.</p><h4>Design influences</h4><p>Executable-property blocks and event-aware monitoring from Modelica_Requirements, condition/time separation from FORM-L/ReqSysPro, and behavior/observer/binding separation from CRML informed the design. SafetyAssessmentLibrary is independently implemented and has no runtime dependency on those projects.</p></html>"));
  end Overview;

  class Architecture "M/M_F, binding, A, and Result responsibilities"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p><b>M/M_F -&gt; Observation Binding -&gt; A -&gt; AssessmentResult.</b></p><ul><li>M is nominal behavior.</li><li>M_F reuses behavior and introduces fault F.</li><li>The Scenario owns variable-path bindings.</li><li>Each A is a separate .mo file containing only inputs and visible assessment blocks.</li><li>Result is the compact conclusion stored by A.</li></ul><p>Inside A, only five public concepts appear: Preprocessing, TimeWindows, Criteria, Evaluation, and Results. Instantaneous monitoring, nesting details, and online statistics are implementation classes under Internal.</p></html>"));
  end Architecture;

  class SafetyAssessmentConcept "Executable safety evidence"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Preprocessing converts one or more observations and optional references into z. Four visible GradeInterval blocks define the progressively broader A/B/C/D acceptable ranges. Evaluation uses only the selected TimeWindow and accumulates evidence online before freezing a final decision. Result exposes state, grade, top event, display code, sampled margins/value, critical timing, and outer violation.</p><p>A legal assessment without usable window or reference evidence is Unresolved. An illegal configuration is Invalid. Severe observed behavior is Resolved D, with outerViolation only when the outer D interval itself was left.</p></html>"));
  end SafetyAssessmentConcept;

  class ReferenceComparison "Nominal reference ownership and binding"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>ReferenceMode.None uses only the observed trajectory. ParallelNominal means the outer Scenario instantiates M and M_F and connects both observations to a reference preprocessor. RecordedNominal reserves the same input convention for an externally supplied trace; this version performs no file reading.</p><p>A2_BusDeviation demonstrates ParallelNominal with RelativeDifference. If an advanced binding can become unavailable at run time, enable Evaluation.useDataValidityInput; unavailable data yields Unresolved, not Invalid.</p></html>"));
  end ReferenceComparison;

  class TimeWindowSemantics "Orthogonal time locators"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>TimeWindow blocks expose active and configurationValid and connect only to Evaluation. They never connect to each GradeInterval. Finite windows are [start,end): start inclusive and end exclusive. TriggeredDuration restarts on each rising edge; AfterFor is single-shot; stop has priority for simultaneous StartStop/AfterUntil edges.</p></html>"));
  end TimeWindowSemantics;

  class Grade4Semantics "Four visible intervals and final grade"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Place four GradeInterval blocks vertically and label them A, B, C, and D. Edit each lower/upper range and Open/Closed endpoints directly. Evaluation automatically checks A subset B subset C subset D and reports the first failed containment relation.</p><p>The final grade is the strictest passing level: A, otherwise B, otherwise C, otherwise D. Failure through D still saturates at D and is distinguished by outerViolation. Illegal nesting is Invalid and never reinterpreted as D.</p></html>"));
  end Grade4Semantics;

  class TopEventMapping "FTA-compatible top-event mapping"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>The same Assessment supports FMEA through grade and FTA through Boolean topEvent. The default threshold is D; threshold C maps final C or D to true. Critical margin and timing fields select the evidence level named by topEventThreshold.</p></html>"));
  end TopEventMapping;

  class GraphicalModeling "Drag, edit, connect, simulate"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><ol><li>Create one model extending the metadata-only Interfaces.PartialAssessment.</li><li>Add read-only input connectors.</li><li>Drag a Preprocessing block.</li><li>Drag four Criteria.GradeInterval blocks and edit their ranges.</li><li>Drag one TimeWindow and one Evaluation policy.</li><li>Connect the four criterion evidence lines and TimeWindow active/valid to Evaluation.</li><li>Connect Evaluation.evidence to Results.AssessmentResult and publish its compact record.</li><li>In the Scenario, bind M/M_F variables with RealExpression or BooleanExpression.</li></ol><p>All shipped white-box connects have explicit Line annotations with endpoints on their connector coordinates. Internal arrays are protected/HideResult; users normally inspect A.result.</p></html>"));
  end GraphicalModeling;

  class Examples "Three assessments and one coupled Scenario"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p><b>A1_SOCSafety:</b> Identity + four SOC intervals + Always + AllInside.</p><p><b>A2_BusDeviation:</b> RelativeDifference + four percentage intervals + FixedWindow + MaxOutsideDuration.</p><p><b>A3_AttitudeRateSafety:</b> three-axis EuclideanNorm + four rate intervals + TriggeredDuration + MaxConsecutiveOutside.</p><p>S_MultiObjectiveAssessment separates SYSTEM MODELS, OBSERVATION BINDINGS, and SAFETY ASSESSMENTS. Its coupled trajectories resolve A1=B, A2=C, A3=D, with A3 topEvent=true.</p></html>"));
  end Examples;

  class KnownLimitations "Version 1.2 boundaries"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Version 1.2 uses scalar, time-invariant grade intervals. Durations/transitions are event-aware; extrema are sampled at samplePeriod. RecordedNominal file ingestion is not included.</p><p>No Boolean-specialized objective, multidimensional/dynamic boundary, sequencing/deadline, integral/dose, RMS/moving window, FFT, probability, Monte Carlo, composite assessment, occurrence/FMECA calculation, automatic FTA, SysML/CRML integration, or external Python framework is included.</p></html>"));
  end KnownLimitations;

  annotation(Documentation(info="<html><p>SafetyAssessmentLibrary was informed by Modelica_Requirements, FORM-L / ReqSysPro, and CRML concepts for executable properties, time locators, condition/time separation, observers, and bindings.</p><p><b>SafetyAssessmentLibrary is an independent Modelica library for simulation-driven safety assessment and has no runtime dependency on these reference projects.</b></p></html>"));
end UsersGuide;
