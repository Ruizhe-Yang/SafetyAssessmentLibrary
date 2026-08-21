# SafetyAssessmentLibrary

SafetyAssessmentLibrary is an independent Modelica 4.0.0 library for executable, simulation-driven NISSA safety evidence. A Safety Assessment Asset reads Scenario-bound trajectories and produces one typed, structured result without feeding any physical or control quantity back to the assessed system.

The only public modeling syntax is:

```text
Scenario trajectory -> P -> C ---------> E -> Q -> result
                                      ^
                                      |
                                      W
```

- P — `Preprocessing`: trajectory to scalar assessment indicator.
- C — `Criteria`: nested A/B/C membership, signed margins, and validity.
- W — `TimeWindows`: active evaluation domain only.
- E — `Evaluation`: online duration, count, fraction, recovery, response, dwell, exposure, and pass decisions.
- Q — `Results.SafetyResult`: lifecycle, verdict, A/B/C/D grade, Boolean top-event output, and evidence.
- Des — metadata inherited from `BaseClasses.PartialAssessment`.
- S — the external NISSA Scenario that owns system instances and observation binding.

## Dependency

The runtime dependency is only Modelica Standard Library 4.0.0. The package has no runtime dependency on Modelica_Requirements, CRML, ReqSysPro, Python, C/C++, external DLLs, or driver scripts.

## Public packages

- `Preprocessing`: Identity, Difference, AbsoluteDifference, RelativeDifference, Ratio, WeightedSum, EuclideanNorm, NormDifference, and small scalar/vector transforms.
- `Criteria`: GradedCriteria, DynamicGradedCriteria, Threshold, BooleanCriterion.
- `TimeWindows`: Always, FixedWindow, During, After, AfterFor, TriggeredDuration, BetweenEvents.
- `Evaluation`: AllInside, CheckAtEnd, MaxOutsideDuration, MaxConsecutiveOutside, MinInsideFraction, MaxOutsideCount, FirstRecoveryWithin, TriggeredResponseWithin, MinConsecutiveInside, MaxIntegratedViolation.
- `Results`: SafetyResult and ConsoleReporter.

`BaseClasses` contains advanced typed records, connectors, enumerations, and partial contracts. `Internal` contains the reopenable white-box implementation used by C, E, and Q.

## Minimal asset

```modelica
model SOCObjective
  extends SafetyAssessmentLibrary.BaseClasses.PartialAssessment(
    objectiveId="A_SOC",
    units="1");
  Modelica.Blocks.Interfaces.RealInput SOC;
protected
  SafetyAssessmentLibrary.Preprocessing.Identity p;
  SafetyAssessmentLibrary.Criteria.GradedCriteria c(
    lower={0.58,0.39,0.30}, upper={0.85,0.90,0.95});
  SafetyAssessmentLibrary.TimeWindows.Always w;
  SafetyAssessmentLibrary.Evaluation.AllInside e;
  SafetyAssessmentLibrary.Results.SafetyResult q;
equation
  connect(SOC,p.xFault[1]);
  connect(p.z,c.indicator);
  connect(c.criteria,e.criteria);
  connect(w.window,e.window);
  connect(e.evaluation,q.evaluation);
  connect(q.result,result);
end SOCObjective;
```

At simulation end, Q returns `state`, `verdict`, `grade`, `topEvent`, typed `invalidReason`, `pass[3]`, data coverage, A/B/C margins and inside fractions, longest-inside duration, first violation/recovery, post-recovery dwell, trigger/response timing, violation duration/count, integrated violation, and worst-value evidence.

## Examples

- A1–A3 demonstrate direct range, parallel nominal comparison, and triggered persistence.
- A4–A8 demonstrate dynamic envelopes, event count, first recovery, integrated violation, and independent Boolean Top Event mapping.
- `S_MultiObjectiveAssessment` and `S_AdvancedAssessmentExamples` bind all eight assets outside the assessed systems.
- `A1_A8_Overview` places the same eight unchanged assets and their established bindings on one 2-by-4 Diagram.

SafetyAssessmentLibrary is not a Fault Tree library. In particular, A8 is an existing Boolean safety-condition mapping and introduces no basic-event, gate, or cut-set model.

See `UsersGuide` for modeling guidance, `DESIGN.md` for the internal architecture, and `VALIDATION_REPORT.md` for backend and graphics validation status.
