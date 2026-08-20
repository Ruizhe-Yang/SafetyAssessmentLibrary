within SafetyAssessmentLibrary;
package UsersGuide "Safety Assessment Asset user guide"
  extends Modelica.Icons.Information;

  class Overview "Purpose, scope, and independence"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>SafetyAssessmentLibrary builds executable, read-only evidence for finite-horizon, simulation-observable NISSA safety objectives. Each asset consumes Scenario-bound trajectories and emits one structured result. It is not a general requirements language.</p><p>Runtime dependency: Modelica Standard Library 4.0.0 only. Ideas from Modelica_Requirements, FORM-L / ReqSysPro, and CRML informed executable monitoring, condition/time separation, and binding, but this is an independent library with no runtime dependency on those projects.</p></html>"));
  end Overview;

  class Architecture "A = P + C + W + E + Q + Des"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p><b>Chain:</b> Scenario trajectory -&gt; P -&gt; C; C and W -&gt; E -&gt; Q -&gt; result.</p><p>P computes the indicator; C defines safe values; W defines the active domain; E accumulates temporal evidence and pass[3]; Q resolves state, verdict, grade, Top Event, and evidence. Des is metadata. Scenario S owns the model and variable binding and is outside A.</p></html>"));
  end Architecture;

  class SafetyAssessmentConcept "Read-only executable safety evidence"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>An asset reads Real and Boolean trajectories. It has no physical ports or control outputs, and cannot alter the assessed system. Inactive, Monitoring, Resolved, Unresolved, and Invalid lifecycle states remain distinct from A/B/C/D consequence grade. A legal trajectory outside C is a resolved Grade D, never an Invalid configuration.</p></html>"));
  end SafetyAssessmentConcept;

  class ReferenceComparison "Optional Scenario-owned references"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Use Identity when no reference is needed. Difference, RelativeDifference, Ratio, and NormDifference receive references from the Scenario. ReferenceMode documents None, RecordedNominal, or ParallelNominal provenance; the asset never instantiates a nominal plant or reads a nominal file.</p></html>"));
  end ReferenceComparison;

  class TimeWindowSemantics "Orthogonal W semantics"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Always, FixedWindow, During, After, AfterFor, TriggeredDuration, and BetweenEvents output one WindowState. Fixed domains use [start,end). BetweenEvents is the canonical replacement for the former duplicate AfterUntil and StartStop entries. Duration, count, response, recovery, and exposure belong to E, not W.</p></html>"));
  end TimeWindowSemantics;

  class GradeSemantics "Nested A/B/C acceptance and saturated D"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Criteria.GradedCriteria enforces I_A subset I_B subset I_C. Pass A gives A; otherwise pass B gives B; otherwise pass C gives C; otherwise D. D has no fourth interval. DynamicGradedCriteria applies the same nesting relation to time-varying physical bounds and E latches active-domain violations.</p></html>"));
  end GradeSemantics;

  class TopEventMapping "FTA-compatible Boolean"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Results.SafetyResult maps a resolved grade through a configurable threshold, or accepts an independent Boolean condition. Threshold D maps only D; threshold C maps C/D. Top Event, consequence grade, and normative verdict are independent result fields.</p></html>"));
  end TopEventMapping;

  class GraphicalModeling "Drag-and-connect workflow"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><ol><li>Extend BaseClasses.PartialAssessment and fill Des metadata.</li><li>Add only required observation/reference/trigger inputs.</li><li>Place P and connect its scalar indicator to one GradedCriteria.</li><li>Place one W.</li><li>Connect the typed C result and typed W state to one public E block.</li><li>Connect the typed E result to Results.SafetyResult and its structured result to the inherited right-side connector.</li><li>Optionally attach ConsoleReporter.</li></ol><p>Open C, E, or Q to inspect their fine-grained white-box implementation.</p></html>"));
  end GraphicalModeling;

  class Examples "Eight assets and two scenarios"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>A1: direct SOC range. A2: parallel-nominal bus deviation. A3: triggered body-rate persistence. A4: dynamic graded bounds. A5: violation count. A6: first recovery plus safe dwell. A7: integrated negative margin. A8: independent Boolean Top Event.</p><p>S_MultiObjectiveAssessment binds A1-A3 to nominal/faulted systems; S_AdvancedAssessmentExamples binds A4-A8 to representative trajectories.</p></html>"));
  end Examples;

  class KnownLimitations "Version 2.1.0 boundaries"
    extends Modelica.Icons.Information;
    annotation(Documentation(info="<html><p>Extrema and minimum margins use a configurable sampling period and may miss inter-sample peaks. RecordedNominal file ingestion is not implemented. TriggeredResponseWithin records only the first trigger/response episode; FirstRecoveryWithin records first violation/recovery. No parser/compiler, automatic FTA/FMEA probability calculation, Monte Carlo orchestrator, FMI/SSP, SysML integration, or external postprocessor is included.</p></html>"));
  end KnownLimitations;

  annotation(Documentation(info="<html><p><b>SafetyAssessmentLibrary is an independent Modelica library for simulation-driven safety assessment and has no runtime dependency on the reference projects that informed its design.</b></p></html>"));
end UsersGuide;