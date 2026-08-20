within SafetyAssessmentLibrary.Internal;
package Utilities "Pure scalar helpers"
  extends Modelica.Icons.UtilitiesPackage;

  function gradeSeverity
    input BaseClasses.SafetyGrade grade;
    output Integer severity;
  algorithm
    severity := if grade == BaseClasses.SafetyGrade.A then 1 else if grade == BaseClasses.SafetyGrade.B then 2 else if grade == BaseClasses.SafetyGrade.C then 3 else 4;
    annotation(Inline=true);
  end gradeSeverity;

  function gradeFromPass
    input Boolean pass[3];
    output BaseClasses.SafetyGrade grade;
  algorithm
    grade := if pass[1] then BaseClasses.SafetyGrade.A else if pass[2] then BaseClasses.SafetyGrade.B else if pass[3] then BaseClasses.SafetyGrade.C else BaseClasses.SafetyGrade.D;
    annotation(Inline=true);
  end gradeFromPass;

  function gradeAtLeast
    input BaseClasses.SafetyGrade grade;
    input BaseClasses.SafetyGrade threshold;
    output Boolean reached;
  algorithm
    reached := gradeSeverity(grade) >= gradeSeverity(threshold);
    annotation(Inline=true);
  end gradeAtLeast;

  function intervalValid
    input Real lower;
    input Real upper;
    input BaseClasses.BoundaryType lowerBoundary;
    input BaseClasses.BoundaryType upperBoundary;
    output Boolean valid;
  algorithm
    valid := lower < upper or (lower == upper and lowerBoundary == BaseClasses.BoundaryType.Closed and upperBoundary == BaseClasses.BoundaryType.Closed);
    annotation(Inline=true);
  end intervalValid;

  function intervalContained
    input Real innerLower;
    input Real innerUpper;
    input BaseClasses.BoundaryType innerLowerBoundary;
    input BaseClasses.BoundaryType innerUpperBoundary;
    input Real outerLower;
    input Real outerUpper;
    input BaseClasses.BoundaryType outerLowerBoundary;
    input BaseClasses.BoundaryType outerUpperBoundary;
    output Boolean contained;
  algorithm
    contained := intervalValid(innerLower,innerUpper,innerLowerBoundary,innerUpperBoundary) 
      and intervalValid(outerLower,outerUpper,outerLowerBoundary,outerUpperBoundary) 
      and (innerLower > outerLower or (innerLower == outerLower and not (innerLowerBoundary == BaseClasses.BoundaryType.Closed and outerLowerBoundary == BaseClasses.BoundaryType.Open))) 
      and (innerUpper < outerUpper or (innerUpper == outerUpper and not (innerUpperBoundary == BaseClasses.BoundaryType.Closed and outerUpperBoundary == BaseClasses.BoundaryType.Open)));
    annotation(Inline=true);
  end intervalContained;

  function gradeString
    input BaseClasses.SafetyGrade grade;
    output String text;
  algorithm
    text := if grade == BaseClasses.SafetyGrade.A then "A" else if grade == BaseClasses.SafetyGrade.B then "B" else if grade == BaseClasses.SafetyGrade.C then "C" else "D";
    annotation(Inline=true);
  end gradeString;

  function stateString
    input BaseClasses.AssessmentState state;
    output String text;
  algorithm
    text := if state == BaseClasses.AssessmentState.Inactive then "Inactive" else if state == BaseClasses.AssessmentState.Monitoring then "Monitoring" else if state == BaseClasses.AssessmentState.Resolved then "Resolved" else if state == BaseClasses.AssessmentState.Unresolved then "Unresolved" else "Invalid";
    annotation(Inline=true);
  end stateString;

  function verdictString
    input BaseClasses.Verdict verdict;
    output String text;
  algorithm
    text := if verdict == BaseClasses.Verdict.Satisfied then "Satisfied" else if verdict == BaseClasses.Verdict.Violated then "Violated" else "NotAvailable";
    annotation(Inline=true);
  end verdictString;

  function invalidReasonString
    input BaseClasses.InvalidReason reason;
    output String text;
  algorithm
    text := if reason == BaseClasses.InvalidReason.None then "None" 
      else if reason == BaseClasses.InvalidReason.CriterionConfiguration then "CriterionConfiguration" 
      else if reason == BaseClasses.InvalidReason.GradeNesting then "GradeNesting" 
      else if reason == BaseClasses.InvalidReason.DynamicGradeNesting then "DynamicGradeNesting" 
      else if reason == BaseClasses.InvalidReason.TimeWindowConfiguration then "TimeWindowConfiguration" 
      else if reason == BaseClasses.InvalidReason.EvaluationConfiguration then "EvaluationConfiguration" 
      else if reason == BaseClasses.InvalidReason.MissingObservation then "MissingObservation" 
      else if reason == BaseClasses.InvalidReason.MissingReference then "MissingReference" 
      else if reason == BaseClasses.InvalidReason.MissingTrigger then "MissingTrigger" 
      else "InsufficientDataCoverage";
    annotation(Inline=true);
  end invalidReasonString;
end Utilities;