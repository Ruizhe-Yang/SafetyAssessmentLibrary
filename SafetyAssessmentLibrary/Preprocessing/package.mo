within SafetyAssessmentLibrary;
package Preprocessing "Read-only scalar and vector safety-indicator transformations"
  extends Modelica.Icons.Package;

  block Identity "Pass one observed signal through as z"
    extends Interfaces.PartialPreprocessor(final nFault=1, final nReference=0);
  equation
    z=xFault[1];
    annotation(Icon(graphics={Text(extent={{-65,42},{65,-42}}, textString="1", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> expose one observed signal as the safety indicator.</p><p><b>Input:</b> xFault[1]. <b>Output:</b> z=xFault[1].</p><p><b>Parameters:</b> none. <b>Usage:</b> direct range/limit objectives. <b>Limitation:</b> no scaling or unit conversion.</p></html>"));
  end Identity;

  block Difference "Observed value minus reference value"
    extends Interfaces.PartialPreprocessor(final nFault=1, final nReference=1);
  equation
    z=xFault[1]-xReference[1];
    annotation(Icon(graphics={Text(extent={{-65,42},{65,-42}}, textString="Delta", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> compute signed deviation from an externally supplied nominal signal.</p><p><b>Inputs:</b> xFault[1], xReference[1]. <b>Output:</b> z=xFault-xReference.</p><p><b>Parameters:</b> none. <b>Usage:</b> parallel or recorded nominal comparison. <b>Limitation:</b> inputs must use compatible units.</p></html>"));
  end Difference;

  block AbsoluteDifference "Absolute observed/reference deviation"
    extends Interfaces.PartialPreprocessor(final nFault=1, final nReference=1);
  equation
    z=abs(xFault[1]-xReference[1]);
    annotation(Icon(graphics={Text(extent={{-78,42},{78,-42}}, textString="|Delta|", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> remove the sign of a nominal deviation.</p><p><b>Inputs:</b> xFault[1], xReference[1]. <b>Output:</b> z=abs(xFault-xReference).</p><p><b>Parameters:</b> none. <b>Usage:</b> symmetric tolerance envelopes. <b>Limitation:</b> directional information is intentionally discarded.</p></html>"));
  end AbsoluteDifference;

  block RelativeDifference "Reference-normalized signed deviation"
    extends Interfaces.PartialPreprocessor(final nFault=1, final nReference=1);
    parameter Real epsilon(min=Modelica.Constants.small)=1e-9 "Minimum reference magnitude";
  equation
    z=(xFault[1]-xReference[1])/max(abs(xReference[1]),epsilon);
    annotation(Icon(graphics={Text(extent={{-82,42},{82,-42}}, textString="Delta/ref", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> compute dimensionless signed deviation robustly near a zero reference.</p><p><b>Inputs:</b> xFault[1], xReference[1]. <b>Output:</b> z=(xFault-xReference)/max(abs(xReference),epsilon).</p><p><b>Parameter:</b> epsilon&gt;0. <b>Usage:</b> relative nominal envelopes. <b>Limitation:</b> when the reference is near zero the result is epsilon-scaled and should be interpreted accordingly.</p></html>"));
  end RelativeDifference;

  block Ratio "Observed/reference ratio with guarded denominator"
    extends Interfaces.PartialPreprocessor(final nFault=1, final nReference=1);
    parameter Real epsilon(min=Modelica.Constants.small)=1e-9 "Minimum denominator magnitude";
  protected
    Real denominator;
  equation
    denominator=if abs(xReference[1]) >= epsilon then xReference[1] else if xReference[1] >= 0 then epsilon else -epsilon;
    z=xFault[1]/denominator;
    annotation(Icon(graphics={Text(extent={{-65,42},{65,-42}}, textString="/", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> compute an observed/reference ratio without division by zero.</p><p><b>Inputs:</b> xFault[1], xReference[1]. <b>Output:</b> z=xFault/guardedReference.</p><p><b>Parameter:</b> epsilon&gt;0. <b>Usage:</b> multiplicative tolerance objectives. <b>Limitation:</b> ratios near a zero reference are regularized, not physically reconstructed.</p></html>"));
  end Ratio;

  block WeightedSum "Weighted linear combination of observed signals"
    parameter Integer n(min=1)=2 "Vector size";
    parameter Real w[n]=fill(1.0,n) "Weights";
    extends Interfaces.PartialPreprocessor(final nFault=n, final nReference=0);
  equation
    z=sum(w[i]*xFault[i] for i in 1:n);
    annotation(Icon(graphics={Text(extent={{-65,42},{65,-42}}, textString="SUM", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> reduce multiple observed variables to one linear indicator.</p><p><b>Input:</b> xFault[n]. <b>Output:</b> z=sum(w[i]*xFault[i]).</p><p><b>Parameters:</b> n and weights w. <b>Usage:</b> engineering indices after explicit unit normalization. <b>Limitation:</b> the block does not check dimensional consistency.</p></html>"));
  end WeightedSum;

  block EuclideanNorm "Weighted Euclidean norm of observed signals"
    parameter Integer n(min=1)=2 "Vector size";
    parameter Real w[n]=fill(1.0,n) "Nonnegative squared-term weights";
    extends Interfaces.PartialPreprocessor(final nFault=n, final nReference=0);
  initial equation
    assert(min(w) >= 0, "EuclideanNorm weights must be nonnegative");
  equation
    z=sqrt(sum(w[i]*xFault[i]^2 for i in 1:n));
    annotation(Icon(graphics={Text(extent={{-75,42},{75,-42}}, textString="||x||", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> compute a nonnegative vector magnitude.</p><p><b>Input:</b> xFault[n]. <b>Output:</b> z=sqrt(sum(w[i]*xFault[i]^2)).</p><p><b>Parameters:</b> n, nonnegative w. <b>Usage:</b> combined normalized indicators. <b>Limitation:</b> signals should be scaled before combining unlike units.</p></html>"));
  end EuclideanNorm;

  block NormDifference "Weighted Euclidean norm of vector deviation"
    parameter Integer n(min=1)=2 "Vector size";
    parameter Real w[n]=fill(1.0,n) "Nonnegative squared-term weights";
    extends Interfaces.PartialPreprocessor(final nFault=n, final nReference=n);
  initial equation
    assert(min(w) >= 0, "NormDifference weights must be nonnegative");
  equation
    z=sqrt(sum(w[i]*(xFault[i]-xReference[i])^2 for i in 1:n));
    annotation(Icon(graphics={Text(extent={{-90,42},{90,-42}}, textString="||Delta x||", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> combine a vector difference into one nonnegative deviation.</p><p><b>Inputs:</b> xFault[n], xReference[n]. <b>Output:</b> z=sqrt(sum(w[i]*(xFault[i]-xReference[i])^2)).</p><p><b>Parameters:</b> n, nonnegative w. <b>Usage:</b> multi-signal nominal comparison. <b>Limitation:</b> vectors must be aligned and consistently scaled by the external scenario/binding.</p></html>"));
  end NormDifference;

  annotation(Documentation(info="<html><p>Small deterministic preprocessing blocks. References are always supplied from outside the library; no nominal plant is instantiated here.</p></html>"));
end Preprocessing;
