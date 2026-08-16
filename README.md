# SafetyAssessmentLibrary

**Version: v1.2.0 — Validated Research Prototype**

A Modelica library for independent, read-only safety assessment of dynamic simulation trajectories in NISSA scenarios.

> 核心思想：不修改被评估系统，只在场景 `S` 中将系统动态轨迹连接到独立安全评估 `A`，并通过预处理、A/B/C/D 分级准则、时间窗口和时间评价策略生成可追溯的安全评估结果。

## Overview

SafetyAssessmentLibrary provides reusable **Safety Assessment Assets (`A`)** for the NISSA framework.

A NISSA safety assessment is organized around:

```text
M + selected F assets + selected A assets + one Scenario S
                              ↓
                         Simulation
                              ↓
                    Dynamic safety evidence
```

`M` is the nominal executable model, `F` represents selected fault behavior, and each independent `A` evaluates one safety objective. The Scenario `S` owns the concrete composition: it selects the models and assessment assets, configures the analysis, and binds the required system trajectories to the inputs of each `A`.

SafetyAssessmentLibrary focuses on the **assessment side** of this composition. An assessment reads simulation variables but does not feed force, flow, heat, power, or control commands back into the assessed system.

The standard workflow inside one assessment is:

```text
Observation / Reference
          ↓
     Preprocessing
          ↓
   A / B / C / D Criteria
          ↓
      Evaluation  ←  TimeWindow
          ↓
        Result
```

The final grade is computed from the simulated trajectory and temporal evaluation policy rather than assigned as a constant.

## Current Scope

The public workflow is organized into five main packages:

- `Preprocessing`  
  Identity, Difference, AbsoluteDifference, RelativeDifference, Ratio, WeightedSum, EuclideanNorm, and NormDifference.

- `Criteria`  
  Four independently editable `GradeInterval` blocks define nested A/B/C/D safety envelopes.

- `TimeWindows`  
  Always, FixedWindow, During, After, AfterFor, AfterUntil, TriggeredDuration, and StartStop.

- `Evaluation`  
  AllInside, CheckAtEnd, MaxOutsideDuration, MaxConsecutiveOutside, and MinInsideFraction.

- `Results`  
  Converts accumulated dynamic evidence into a typed `AssessmentResult`, including the final grade, Top Event state, safety margin, timing, duration, and outer-envelope violation.

Internal monitoring, nesting checks, event handling, duration accumulation, and sampled extrema are implemented in `Internal`.

## Safety Grade Model

Each assessment uses four ordered safety envelopes:

```text
A ⊆ B ⊆ C ⊆ D
```

where `A` represents the strictest/nominal safety region and `D` the most severe assessment grade.

For a scalar assessment variable `z`, each `GradeInterval` evaluates its admissible interval and signed safety margin. The selected `Evaluation` policy then combines this criterion evidence with the active `TimeWindow`.

The final result is the strictest grade whose temporal condition is satisfied:

```text
A → B → C → D
```

A final grade `D` does not necessarily mean that the trajectory exceeded the outer `D` envelope. The separate `outerViolation` field preserves this distinction.

## Build an Assessment

A user-defined assessment is an independent Modelica model with read-only inputs.

Typical graphical construction:

1. Extend `Interfaces.PartialAssessment`.
2. Add the required observation/reference inputs.
3. Add one `Preprocessing` block.
4. Add four `Criteria.GradeInterval` blocks for A/B/C/D.
5. Add one `TimeWindow`.
6. Add one `Evaluation` policy.
7. Connect the evaluation evidence to `Results.AssessmentResult`.

The supplied assessment models are intentionally white-box and graphically editable. Their main equation sections use visible `connect()` relationships, with only the compact result-record forwarding equation added at the endpoint.

## Scenario Example

The Scenario owns the connection between system variables and assessment inputs.

```modelica
model SafetyScenario
  SafetyAssessmentLibrary.Examples.Systems.FaultedSystem M_F;
  SafetyAssessmentLibrary.Examples.Assessments.A1_SOCSafety A1;

  Modelica.Blocks.Sources.RealExpression obsSOC(
    y=M_F.batterySOC);

equation
  connect(obsSOC.y, A1.SOC);
end SafetyScenario;
```

Here, `A1` does not know which system produced `SOC`. The Scenario `S` establishes that binding, so the same assessment asset can be reused with another compatible system realization without modifying the internal assessment logic.

The full demonstration is:

```text
SafetyAssessmentLibrary.Examples.Scenarios.S_MultiObjectiveAssessment
```

It runs nominal/faulted system behavior and three independent assessment assets in one Scenario:

- `A1_SOCSafety` — Identity + Always + AllInside
- `A2_BusDeviation` — RelativeDifference + FixedWindow + MaxOutsideDuration
- `A3_AttitudeRateSafety` — EuclideanNorm + TriggeredDuration + MaxConsecutiveOutside

The expected and validated final grades are:

```text
A1 = B
A2 = C
A3 = D
```

`A3` also reaches the default D-grade Top Event threshold.

## Assessment Result

Each assessment publishes one compact `Types.AssessmentResult` record.

Typical fields include:

- `state`
- `grade`
- `topEvent`
- `displayCode`
- `sampledMinimumCriticalMargin`
- `sampledWorstValue`
- `firstCriticalTime`
- `criticalDuration`
- `longestCriticalDuration`
- `outerViolation`

Legal objectives without sufficient usable evidence resolve as `Unresolved`. Illegal interval, nesting, time-window, or evaluation configurations resolve as `Invalid`.

## Dependency

Runtime dependency:

- **Modelica Standard Library 4.0.0 only**

The library has no runtime dependency on Modelica_Requirements, CRML, ReqSysPro, Python, C/C++, external DLLs, or `.mos` scripts.

## Validation Status

Version `v1.2.0` has been validated with:

- **Modelica Standard Library 4.0.0**
- **OpenModelica 1.25.5**

Current verification includes:

- 30/30 regression models passing `checkModel`
- 30/30 regression simulations passing
- Public Criteria, Evaluation, Result, A1/A2/A3, and main Scenario passing `checkModel`
- Main Scenario successfully simulated from 0 to 200 s
- A/B/C/D/Invalid result categories verified
- No-evidence and missing-reference lifecycle behavior verified
- Open/Closed endpoint and endpoint-aware nesting verified
- Event-iteration stability case verified
- 96/96 graphical `connect()` statements with explicit line annotations
- No third-party runtime dependencies

See `VALIDATION_REPORT.md` for the detailed verification record.

## Project Status

`v1.2.0` is a **validated research prototype** intended for simulation-driven safety-assessment research and engineering experiments.

The current library provides a stable basic workflow for constructing independent safety assessment assets and composing multiple assessments in a NISSA Scenario.

Current limitations include:

- grade intervals are scalar and time invariant;
- extrema are sampled at the configured `samplePeriod`;
- the included CubeSat-like system and thresholds are demonstrators rather than flight-qualified or certification artifacts.

## Intended Use

SafetyAssessmentLibrary is intended for research on:

- non-intrusive simulation-driven safety assessment;
- executable safety criteria;
- trajectory-based safety evidence;
- temporal safety-envelope evaluation;
- reusable safety assessment assets;
- iterative system-design safety reassessment;
- collaboration between system simulation and safety engineering.

## Companion Library

For reusable Modelica fault behavior based on component replacement, see:

**FaultReplacementLibrary**  
https://github.com/Ruizhe-Yang/FaultReplacementLibrary

The two libraries represent complementary NISSA asset classes:

```text
FaultReplacementLibrary   → F : changes non-nominal behavior
SafetyAssessmentLibrary   → A : reads trajectories and evaluates safety
```

---

SafetyAssessmentLibrary is developed as part of the NISSA research framework.