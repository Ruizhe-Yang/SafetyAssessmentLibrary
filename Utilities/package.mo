within SafetyAssessmentLibrary;
package Utilities "Side-effect-free utility functions"
  extends Modelica.Icons.UtilitiesPackage;

  function gradeSeverity "Map A/B/C/D to increasing severity 1/2/3/4"
    input Types.SafetyGrade grade;
    output Integer severity;
  algorithm
    severity := if grade == Types.SafetyGrade.A then 1 elseif grade == Types.SafetyGrade.B then 2 elseif grade == Types.SafetyGrade.C then 3 else 4;
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> provide an explicit numeric ordering for comparisons. The returned integer is not the public display code.</p></html>"));
  end gradeSeverity;

  function gradeDisplayCode "Map A/B/C/D to plotting codes 4/3/2/1"
    input Types.SafetyGrade grade;
    output Integer code;
  algorithm
    code := if grade == Types.SafetyGrade.A then 4 elseif grade == Types.SafetyGrade.B then 3 elseif grade == Types.SafetyGrade.C then 2 else 1;
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> derive the specified plot/export code. Invalid (-1) and unresolved (0) are assigned by result blocks because they depend on state.</p></html>"));
  end gradeDisplayCode;

  function gradeFromPass "Select the strictest passing envelope"
    input Boolean pass[4] "Pass vector ordered A,B,C,D";
    output Types.SafetyGrade grade;
  algorithm
    grade := if pass[1] then Types.SafetyGrade.A elseif pass[2] then Types.SafetyGrade.B elseif pass[3] then Types.SafetyGrade.C else Types.SafetyGrade.D;
    annotation(Inline=true, Documentation(info="<html><p><b>Mathematical meaning:</b> A if pass(A); else B if pass(B); else C if pass(C); else D. Failure of D remains saturated at D and must be distinguished with outerViolation.</p></html>"));
  end gradeFromPass;

  function currentGradeFromInside "Select instantaneous grade from nested membership"
    input Boolean inside[4] "Membership ordered A,B,C,D";
    output Types.SafetyGrade grade;
  algorithm
    grade := if inside[1] then Types.SafetyGrade.A elseif inside[2] then Types.SafetyGrade.B elseif inside[3] then Types.SafetyGrade.C else Types.SafetyGrade.D;
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> provide a provisional grade while monitoring. Outside D maps to D; outerViolation carries the additional fact.</p></html>"));
  end currentGradeFromInside;

  function gradeAtLeast "Test whether a grade reaches a severity threshold"
    input Types.SafetyGrade grade;
    input Types.SafetyGrade threshold;
    output Boolean reached;
  algorithm
    reached := gradeSeverity(grade) >= gradeSeverity(threshold);
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> map a grade to an FTA-compatible Boolean threshold, for example C/D when threshold=C.</p></html>"));
  end gradeAtLeast;

  function gradeEvidenceIndex "Map a grade label to its A/B/C/D evidence-array index"
    input Types.SafetyGrade grade;
    output Integer index;
  algorithm
    index := gradeSeverity(grade);
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> select grade-specific margin and temporal evidence arrays ordered 1=A, 2=B, 3=C, 4=D.</p></html>"));
  end gradeEvidenceIndex;

  function intervalValid "Validate a scalar interval"
    input Real lower;
    input Real upper;
    input Types.BoundaryType lowerBoundary;
    input Types.BoundaryType upperBoundary;
    output Boolean valid;
  algorithm
    valid := lower < upper or (lower == upper and lowerBoundary == Types.BoundaryType.Closed and upperBoundary == Types.BoundaryType.Closed);
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> reject reversed and empty open intervals. A zero-width closed interval is valid and contains one point.</p></html>"));
  end intervalValid;

  function intervalContained "Check endpoint-aware containment of inner in outer"
    input Real innerLower;
    input Real innerUpper;
    input Types.BoundaryType innerLowerBoundary;
    input Types.BoundaryType innerUpperBoundary;
    input Real outerLower;
    input Real outerUpper;
    input Types.BoundaryType outerLowerBoundary;
    input Types.BoundaryType outerUpperBoundary;
    output Boolean contained;
  algorithm
    contained := intervalValid(innerLower, innerUpper, innerLowerBoundary, innerUpperBoundary)
      and intervalValid(outerLower, outerUpper, outerLowerBoundary, outerUpperBoundary)
      and (innerLower > outerLower or (innerLower == outerLower and not (innerLowerBoundary == Types.BoundaryType.Closed and outerLowerBoundary == Types.BoundaryType.Open)))
      and (innerUpper < outerUpper or (innerUpper == outerUpper and not (innerUpperBoundary == Types.BoundaryType.Closed and outerUpperBoundary == Types.BoundaryType.Open)));
    annotation(Inline=true, Documentation(info="<html><p><b>Mathematical meaning:</b> every member of the inner interval must also be a member of the outer interval, including coincident open/closed endpoints.</p></html>"));
  end intervalContained;

  function gradeString "Return a stable printable grade label"
    input Types.SafetyGrade grade;
    output String text;
  algorithm
    text := if grade == Types.SafetyGrade.A then "A" elseif grade == Types.SafetyGrade.B then "B" elseif grade == Types.SafetyGrade.C then "C" else "D";
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> cross-tool printable A/B/C/D label.</p></html>"));
  end gradeString;

  function stateString "Return a stable printable assessment-state label"
    input Types.AssessmentState state;
    output String text;
  algorithm
    text := if state == Types.AssessmentState.Inactive then "Inactive" elseif state == Types.AssessmentState.Monitoring then "Monitoring" elseif state == Types.AssessmentState.Resolved then "Resolved" elseif state == Types.AssessmentState.Unresolved then "Unresolved" else "Invalid";
    annotation(Inline=true, Documentation(info="<html><p><b>Purpose:</b> cross-tool printable lifecycle label.</p></html>"));
  end stateString;

  annotation(Documentation(info="<html><p>Pure functions shared by Criteria, Internal, Evaluation, and Results. No function performs file I/O or modifies the simulated system.</p></html>"));
end Utilities;
