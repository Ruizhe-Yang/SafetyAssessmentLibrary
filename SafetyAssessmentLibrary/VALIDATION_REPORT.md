# SafetyAssessmentLibrary validation report

Date: 2026-08-16  
Library version: 1.2.0  
Tool: OpenModelica 1.25.5, backend `omc.exe` only  
Modelica dependency: 4.0.0

## Summary

| Verification item | Result |
|---|---|
| Load library with MSL 4.0.0 | Pass, no load errors/warnings |
| `checkModel` for public Criteria/Evaluation/Result blocks | Pass |
| `checkModel` for A1/A2/A3 and main Scenario | Pass |
| `checkModel` for all 30 regression models | 30/30 pass |
| Simulate all 30 regression models | 30/30 pass |
| Main Scenario initialization and simulation to 200 s | Pass |
| Event-iteration stability case | Pass |
| A/B/C/D/Invalid final categories | Pass |
| No-evidence and missing-reference lifecycle | Pass |
| Open/Closed endpoint and endpoint-aware nesting | Pass |
| Visible `connect()` annotations | 96/96 (100%) |
| Third-party runtime dependencies | None |

OpenModelica originally identified six redundant initial equations on frozen Evaluation variables. The duplicate explicit `initial equation` assignments were removed; their `start/fixed` attributes remain. A diagnostic rerun completed with no initialization warning.

## Public model checks

| Model | Equations | Variables | Result |
|---|---:|---:|---|
| `Criteria.GradeInterval` | 8 | 8 | Pass |
| `Evaluation.AllInside` | 213 | 213 | Pass |
| `Results.AssessmentResult` | 15 | 15 | Pass |
| `Examples.Assessments.A1_SOCSafety` | 349 | 349 | Pass |
| `Examples.Assessments.A2_BusDeviation` | 350 | 350 | Pass |
| `Examples.Assessments.A3_AttitudeRateSafety` | 354 | 354 | Pass |
| `Examples.Scenarios.S_MultiObjectiveAssessment` | 1100 | 1100 | Pass |

Counts above include causal compound-connector scalarization and may vary slightly between tool versions; equality of equation and variable counts is the acceptance point.

## Main Scenario result

The coupled behavior was simulated from 0 to 200 s with 0.1 s output interval.

| Assessment | Preprocessing | TimeWindow | Evaluation | Expected | Actual | Top Event |
|---|---|---|---|---|---|---|
| `A1_SOCSafety` | Identity | Always | AllInside | B | B | false |
| `A2_BusDeviation` | RelativeDifference | FixedWindow [40,190) | MaxOutsideDuration | C | C | false |
| `A3_AttitudeRateSafety` | EuclideanNorm(3) | TriggeredDuration 100 s | MaxConsecutiveOutside | D | D | true |

Selected actual evidence:

- A1 sampled worst SOC: approximately `0.413925`; final code `3`.
- A2 sampled worst relative deviation: approximately `-0.0891051`; final code `2`.
- A3 sampled worst rate norm: approximately `0.152973`; final code `1`; D threshold Top Event true.
- No assessment left its valid D interval in the main Scenario, so `outerViolation=false` for all three. A3 is D because the Grade-C consecutive-duration policy fails, demonstrating that final D and outside-D are distinct.

## Regression inventory

| Package | Models | Coverage | Simulation |
|---|---:|---|---|
| `CriteriaTests` | 4 | normal nesting, Open/Closed endpoint, illegal nesting, outside D | Pass |
| `TimeWindowTests` | 4 | fixed, triggered duration, start/stop, terminal | Pass |
| `InternalTests` | 1 | inactive 0, inside +1, outside -1, outer violation | Pass |
| `EvaluationTests` | 6 | no violation, repeated short, consecutive, final instant, event iteration, OnTrigger | Pass |
| `ObjectiveTests` | 5 | final A, B, C, D, Invalid | Pass |
| `SemanticTests` | 6 | no evidence, missing data, Invalid nesting, outside D, transient/final, threshold evidence | Pass |
| `ArchitectureTests` | 4 | A isolation, input-only interface, multi-A Scenario, rebinding | Pass |
| **Total** | **30** | | **30/30** |

## Structural and graphical audit

- Root public workflow packages are `Preprocessing`, `TimeWindows`, `Criteria`, `Evaluation`, and `Results`; `Internal` contains non-user machinery.
- Obsolete public `Envelopes`, `Monitoring`, `Objectives`, `Templates`, and `Reporting` packages were removed after migration; static reference search is clean.
- A1/A2/A3 each extend only metadata-only `Interfaces.PartialAssessment` and directly declare the visible workflow blocks.
- A1 has one input; A2 has faulted/nominal inputs; A3 has three rate inputs plus one trigger. None has an output connector.
- Each A publishes the unchanged ten-field `Types.AssessmentResult result` record.
- Every Modelica `connect()` in the delivered package has an `annotation(Line(...))`: 96 connects and 96 Line annotations.
- Connector transformations and first/last line points were recalculated for A1, A2, A3, the main Scenario, Evaluation internals, and graphical regression fixtures. Lines terminate on connector coordinates, not block borders.
- The main Scenario Diagram explicitly separates SYSTEM MODELS, OBSERVATION BINDINGS, and SAFETY ASSESSMENTS.

## Independence audit

Executable Modelica code contains no reference to Modelica_Requirements, CRML, ReqSysPro, Python, C/C++, `ExternalObject`, external functions, DLLs, or runtime scripts. References to the design-influence projects occur only in documentation.

## Known limitations

- Grade intervals are scalar and time invariant.
- Extrema are sampled online at `samplePeriod`; durations and transition times are event based.
- RecordedNominal is interface/documentation provenance only; no result-file reader is included.
- The coupled CubeSat-like system and thresholds are demonstrators, not a flight design or certification artifact.
- Advanced probability, Monte Carlo, automatic FTA/FMEA occurrence, SysML/CRML integration, and external postprocessing remain intentionally out of scope.
