within SafetyAssessmentLibrary;
package Criteria "Editable A/B/C/D numerical criteria"
  extends Modelica.Icons.Package;

  block GradeInterval "One independently editable grade interval"
    parameter Types.SafetyGrade grade=Types.SafetyGrade.A "Grade shown on the icon";
    parameter Real lower=0 "Lower endpoint";
    parameter Real upper=1 "Upper endpoint";
    parameter Types.BoundaryType lowerBoundary=Types.BoundaryType.Closed "Lower endpoint inclusion";
    parameter Types.BoundaryType upperBoundary=Types.BoundaryType.Closed "Upper endpoint inclusion";
    final parameter String gradeLabel=Utilities.gradeString(grade);
    Modelica.Blocks.Interfaces.RealInput z "Preprocessed scalar indicator"
      annotation(Placement(transformation(extent={{-120,-20},{-100,20}})));
    Interfaces.GradeCriterionOutput criterion "Compact interval evidence"
      annotation(Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    criterion.value=z;
    criterion.lower=lower;
    criterion.upper=upper;
    criterion.lowerClosed=lowerBoundary == Types.BoundaryType.Closed;
    criterion.upperClosed=upperBoundary == Types.BoundaryType.Closed;
    criterion.configurationValid=Utilities.intervalValid(lower,upper,lowerBoundary,upperBoundary);
    criterion.inside=criterion.configurationValid
      and (if criterion.lowerClosed then z >= lower else z > lower)
      and (if criterion.upperClosed then z <= upper else z < upper);
    criterion.signedMargin=min(z-lower,upper-z);
    annotation(
      defaultComponentName="intervalA",
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,76},{100,-76}}, radius=8, lineColor={30,120,90},
          fillColor={235,250,245}, fillPattern=FillPattern.Solid),
        Text(extent={{-82,62},{82,20}}, textString="%gradeLabel", textColor={25,90,65},
          textStyle={TextStyle.Bold}),
        Text(extent={{-94,12},{-4,-42}}, textString="%lower", textColor={50,50,50}),
        Text(extent={{-18,12},{18,-42}}, textString="..", textColor={50,50,50}),
        Text(extent={{4,12},{94,-42}}, textString="%upper", textColor={50,50,50}),
        Text(extent={{-96,102},{96,80}}, textString="%name", textColor={70,70,70})}),
      Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
      Documentation(info="<html><p><b>Purpose:</b> define one scalar Grade A, B, C, or D interval as a directly editable Diagram component.</p><p><b>Input:</b> z. <b>Output:</b> one compact criterion connector carrying endpoint-aware membership and signed margin.</p><p><b>Parameters:</b> grade label, lower/upper endpoints, and independent Open/Closed endpoint types.</p><p><b>Meaning:</b> signedMargin=min(z-lower,upper-z). Positive values are inside, negative values are outside, and zero is a geometric endpoint; the separate membership field preserves Open/Closed semantics exactly.</p><p><b>Usage:</b> place four blocks vertically, set grade=A/B/C/D, connect the same preprocessed z, then connect one line from each block to an Evaluation policy.</p><p><b>Limitations:</b> scalar, time-invariant boundaries only. Cross-grade nesting is checked automatically inside Evaluation.</p></html>"));
  end GradeInterval;

  annotation(Documentation(info="<html><p>Criteria contains the only user-facing numerical safety-condition block. Four GradeInterval instances make the A/B/C/D limits visible and independently editable without splitting each interval into separate lower/upper blocks.</p></html>"));
end Criteria;
