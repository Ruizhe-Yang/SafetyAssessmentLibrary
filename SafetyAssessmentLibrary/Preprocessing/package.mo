within SafetyAssessmentLibrary;
package Preprocessing "Read-only scalar and vector safety-indicator transformations"
  extends Modelica.Icons.Package;

  block Identity "Pass one observed signal through as z"
    extends BaseClasses.PartialPreprocessor(final nFault=1, final nReference=0);
  equation
    z=xFault[1];
    annotation(Icon(graphics={Text(extent={{-65,42},{65,-42}}, textString="1", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> expose one observed signal as the safety indicator.</p><p><b>Input:</b> xFault[1]. <b>Output:</b> z=xFault[1].</p><p><b>Parameters:</b> none. <b>Usage:</b> direct range/limit objectives. <b>Limitation:</b> no scaling or unit conversion.</p></html>"));
  end Identity;

  block Difference "Observed value minus reference value"
    extends BaseClasses.PartialPreprocessor(final nFault=1, final nReference=1);
  equation
    z=xFault[1]-xReference[1];
    annotation(Icon(graphics={Text(extent={{-65,42},{65,-42}}, textString="Delta", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> compute signed deviation from an externally supplied nominal signal.</p><p><b>Inputs:</b> xFault[1], xReference[1]. <b>Output:</b> z=xFault-xReference.</p><p><b>Parameters:</b> none. <b>Usage:</b> parallel or recorded nominal comparison. <b>Limitation:</b> inputs must use compatible units.</p></html>"));
  end Difference;

  block AbsoluteDifference "Absolute observed/reference deviation"
    extends BaseClasses.PartialPreprocessor(final nFault=1, final nReference=1);
  equation
    z=abs(xFault[1]-xReference[1]);
    annotation(Icon(graphics={Text(extent={{-78,42},{78,-42}}, textString="|Delta|", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> remove the sign of a nominal deviation.</p><p><b>Inputs:</b> xFault[1], xReference[1]. <b>Output:</b> z=abs(xFault-xReference).</p><p><b>Parameters:</b> none. <b>Usage:</b> symmetric tolerance envelopes. <b>Limitation:</b> directional information is intentionally discarded.</p></html>"));
  end AbsoluteDifference;

  block RelativeDifference "Reference-normalized signed deviation"
    extends BaseClasses.PartialPreprocessor(final nFault=1, final nReference=1);
    parameter Real epsilon(min=Modelica.Constants.small)=1e-9 "Minimum reference magnitude";
  equation
    z=(xFault[1]-xReference[1])/max(abs(xReference[1]),epsilon);
    annotation(Icon(graphics={Text(extent={{-82,42},{82,-42}}, textString="Delta/ref", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> compute dimensionless signed deviation robustly near a zero reference.</p><p><b>Inputs:</b> xFault[1], xReference[1]. <b>Output:</b> z=(xFault-xReference)/max(abs(xReference),epsilon).</p><p><b>Parameter:</b> epsilon&gt;0. <b>Usage:</b> relative nominal envelopes. <b>Limitation:</b> when the reference is near zero the result is epsilon-scaled and should be interpreted accordingly.</p></html>"));
  end RelativeDifference;

  block Ratio "Observed/reference ratio with guarded denominator"
    extends BaseClasses.PartialPreprocessor(final nFault=1, final nReference=1);
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
    extends BaseClasses.PartialPreprocessor(final nFault=n, final nReference=0);
  equation
    z=sum(w[i]*xFault[i] for i in 1:n);
    annotation(Icon(graphics={Text(extent={{-65,42},{65,-42}}, textString="SUM", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> reduce multiple observed variables to one linear indicator.</p><p><b>Input:</b> xFault[n]. <b>Output:</b> z=sum(w[i]*xFault[i]).</p><p><b>Parameters:</b> n and weights w. <b>Usage:</b> engineering indices after explicit unit normalization. <b>Limitation:</b> the block does not check dimensional consistency.</p></html>"));
  end WeightedSum;

  block EuclideanNorm "Weighted Euclidean norm of observed signals"
    parameter Integer n(min=1)=2 "Vector size";
    parameter Real w[n]=fill(1.0,n) "Nonnegative squared-term weights";
    extends BaseClasses.PartialPreprocessor(final nFault=n, final nReference=0);
  initial equation
    assert(min(w) >= 0, "EuclideanNorm weights must be nonnegative");
  equation
    z=sqrt(sum(w[i]*xFault[i]^2 for i in 1:n));
    annotation(Icon(graphics={Text(extent={{-75,42},{75,-42}}, textString="||x||", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> compute a nonnegative vector magnitude.</p><p><b>Input:</b> xFault[n]. <b>Output:</b> z=sqrt(sum(w[i]*xFault[i]^2)).</p><p><b>Parameters:</b> n, nonnegative w. <b>Usage:</b> combined normalized indicators. <b>Limitation:</b> signals should be scaled before combining unlike units.</p></html>"));
  end EuclideanNorm;

  block NormDifference "Weighted Euclidean norm of vector deviation"
    parameter Integer n(min=1)=2 "Vector size";
    parameter Real w[n]=fill(1.0,n) "Nonnegative squared-term weights";
    extends BaseClasses.PartialPreprocessor(final nFault=n, final nReference=n);
  initial equation
    assert(min(w) >= 0, "NormDifference weights must be nonnegative");
  equation
    z=sqrt(sum(w[i]*(xFault[i]-xReference[i])^2 for i in 1:n));
    annotation(Icon(graphics={Text(extent={{-90,42},{90,-42}}, textString="||Delta x||", textColor={30,80,130})}), Documentation(info="<html><p><b>Purpose:</b> combine a vector difference into one nonnegative deviation.</p><p><b>Inputs:</b> xFault[n], xReference[n]. <b>Output:</b> z=sqrt(sum(w[i]*(xFault[i]-xReference[i])^2)).</p><p><b>Parameters:</b> n, nonnegative w. <b>Usage:</b> multi-signal nominal comparison. <b>Limitation:</b> vectors must be aligned and consistently scaled by the external scenario/binding.</p></html>"));
  end NormDifference;

  block ReferenceSelector "Select an observed trajectory or an optional reference trajectory"
    parameter Boolean useReference=false "Expose and select the reference input";
    Modelica.Blocks.Interfaces.RealInput observation annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.RealInput reference if useReference annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    y=if useReference then reference else observation;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Line(points={{-70,38},{0,38},{56,0}}, color={45,105,165}), Line(points={{-70,-38},{0,-38},{56,0}}, color={45,105,165}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}),
      Documentation(info="<html><p><b>Purpose:</b> demonstrate standard parameter-controlled reference selection without forcing a reference connector on reference-free uses.</p><p><b>Inputs:</b> observation is required. reference exists only when useReference=true.</p><p><b>Output:</b> y=reference when enabled, otherwise observation.</p><p><b>Limitations:</b> selection is structural and cannot change during simulation.</p></html>"));
  end ReferenceSelector;

  block Scale "Multiply a scalar trajectory by a constant"
    extends BaseClasses.PartialScalarTransform;
    parameter Real k=1;
  equation
    y=k*u;
    annotation(Icon(graphics={Text(extent={{-72,38},{72,-36}}, textString="x k", textColor={45,105,165}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p><b>Purpose:</b> apply unit conversion or nondimensional scaling.</p><p><b>Meaning:</b> y=k*u.</p><p><b>Limitations:</b> constant gain only.</p></html>"));
  end Scale;

  block Offset "Add a constant offset to a scalar trajectory"
    extends BaseClasses.PartialScalarTransform;
    parameter Real b=0;
  equation
    y=u+b;
    annotation(Icon(graphics={Text(extent={{-72,38},{72,-36}}, textString="+ b", textColor={45,105,165}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p><b>Purpose:</b> translate a scalar trajectory.</p><p><b>Meaning:</b> y=u+b.</p></html>"));
  end Offset;

  block ScaleOffset "Affine scalar trajectory transformation"
    extends BaseClasses.PartialScalarTransform;
    parameter Real k=1;
    parameter Real b=0;
  equation
    y=k*u+b;
    annotation(Icon(graphics={Text(extent={{-86,38},{86,-36}}, textString="k x + b", textColor={45,105,165}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p><b>Purpose:</b> combine constant scaling and offset in one elementary affine operation.</p><p><b>Meaning:</b> y=k*u+b.</p></html>"));
  end ScaleOffset;

  block Normalize "Center and normalize a scalar trajectory"
    extends BaseClasses.PartialScalarTransform;
    parameter Real center=0;
    parameter Real scale=1;
    parameter Real epsilon(min=Modelica.Constants.small)=1e-9;
    Modelica.Blocks.Interfaces.BooleanOutput configurationValid annotation(Placement(transformation(extent={{100,-70},{120,-50}}),iconTransformation(extent={{90,-70},{110,-50}})));
  equation
    configurationValid=abs(scale) >= epsilon;
    y=(u-center)/(if configurationValid then scale else if scale >= 0 then epsilon else -epsilon);
    annotation(Icon(graphics={Text(extent={{-88,38},{88,-36}}, textString="(x-c)/s", textColor={45,105,165}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p><b>Purpose:</b> create a dimensionless centered indicator.</p><p><b>Meaning:</b> y=(u-center)/scale with an epsilon denominator guard.</p><p><b>Validity:</b> configurationValid requires abs(scale)>=epsilon.</p></html>"));
  end Normalize;

  block Min "Minimum of an input trajectory vector"
    parameter Integer n(min=1)=2;
    Modelica.Blocks.Interfaces.RealInput u[n] annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    y=min(u);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-78,38},{78,-36}}, textString="MIN", textColor={45,105,165}, textStyle={TextStyle.Bold}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}), Documentation(info="<html><p><b>Purpose:</b> reduce n scalar trajectories to their instantaneous minimum.</p><p><b>Meaning:</b> y=min(u).</p></html>"));
  end Min;

  block Max "Maximum of an input trajectory vector"
    parameter Integer n(min=1)=2;
    Modelica.Blocks.Interfaces.RealInput u[n] annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    y=max(u);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-78,38},{78,-36}}, textString="MAX", textColor={45,105,165}, textStyle={TextStyle.Bold}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}), Documentation(info="<html><p><b>Purpose:</b> reduce n scalar trajectories to their instantaneous maximum.</p><p><b>Meaning:</b> y=max(u).</p></html>"));
  end Max;

  block DynamicIntervalMargin "Compute signed margin to time-varying lower and upper limits"
    Modelica.Blocks.Interfaces.RealInput value annotation(Placement(transformation(extent={{-120,50},{-100,70}}),iconTransformation(extent={{-110,50},{-90,70}})));
    Modelica.Blocks.Interfaces.RealInput lowerLimit annotation(Placement(transformation(extent={{-120,-10},{-100,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealInput upperLimit annotation(Placement(transformation(extent={{-120,-70},{-100,-50}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
    Modelica.Blocks.Interfaces.RealOutput margin annotation(Placement(transformation(extent={{100,20},{120,40}}),iconTransformation(extent={{90,20},{110,40}})));
    Modelica.Blocks.Interfaces.BooleanOutput configurationValid annotation(Placement(transformation(extent={{100,-40},{120,-20}}),iconTransformation(extent={{90,-40},{110,-20}})));
  equation
    configurationValid=lowerLimit <= upperLimit;
    margin=min(value-lowerLimit,upperLimit-value);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,78},{100,-78}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Line(points={{-70,42},{70,42}}, color={45,105,165}), Line(points={{-70,-42},{70,-42}}, color={45,105,165}), Ellipse(extent={{-8,8},{8,-8}}, lineColor={45,105,165}, fillColor={45,105,165}, fillPattern=FillPattern.Solid), Text(extent={{-96,102},{96,80}}, textString="%name", textColor={55,75,95})}),
      Documentation(info="<html><p><b>Purpose:</b> transform one value and one dynamic band into an instantaneous scalar margin.</p><p><b>Meaning:</b> margin=min(value-lowerLimit,upperLimit-value). Positive is inside and negative is outside.</p><p><b>Validity:</b> lowerLimit&lt;=upperLimit at the current time.</p><p><b>Usage:</b> intended only when margin itself is the engineering indicator. For graded time-varying physical bounds use Criteria.DynamicGradedCriteria so cross-grade nesting is verified directly.</p></html>"));
  end DynamicIntervalMargin;

  block RateOfChange "Continuous-time derivative of a scalar trajectory"
    extends BaseClasses.PartialScalarTransform;
  equation
    y=der(u);
    annotation(Icon(graphics={Text(extent={{-84,38},{84,-36}}, textString="dx/dt", textColor={45,105,165}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p><b>Purpose:</b> expose the continuous derivative as an assessment indicator.</p><p><b>Meaning:</b> y=der(u).</p><p><b>Limitations:</b> the upstream signal must be differentiable enough for the selected solver; discontinuities can generate events or impulses that this block does not filter.</p></html>"));
  end RateOfChange;

  block Integral "Online integral with optional enable and reset connectors"
    parameter Real initialValue=0;
    parameter Real resetValue=0;
    parameter Boolean useEnableInput=false;
    parameter Boolean useResetInput=false;
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.BooleanInput enable if useEnableInput annotation(Placement(transformation(extent={{-70,-120},{-50,-100}}),iconTransformation(extent={{-70,-110},{-50,-90}})));
    Modelica.Blocks.Interfaces.BooleanInput reset if useResetInput annotation(Placement(transformation(extent={{30,-120},{50,-100}}),iconTransformation(extent={{30,-110},{50,-90}})));
    Modelica.Blocks.Interfaces.RealOutput y(start=initialValue, fixed=true) annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    Modelica.Blocks.Interfaces.BooleanInput enableSignal;
    Modelica.Blocks.Interfaces.BooleanInput resetSignal;
    Modelica.Blocks.Sources.BooleanConstant defaultEnable(k=true) if not useEnableInput;
    Modelica.Blocks.Sources.BooleanConstant defaultReset(k=false) if not useResetInput;
  equation
    connect(enable,enableSignal) annotation(Line(points={{-60,-110},{-60,-80}}, color={255,0,255}));
    connect(defaultEnable.y,enableSignal) annotation(Line(points={{-70,-60},{-60,-60},{-60,-80}}, color={255,0,255}));
    connect(reset,resetSignal) annotation(Line(points={{40,-110},{40,-80}}, color={255,0,255}));
    connect(defaultReset.y,resetSignal) annotation(Line(points={{30,-60},{40,-60},{40,-80}}, color={255,0,255}));
    der(y)=if enableSignal then u else 0;
    when resetSignal then
      reinit(y,resetValue);
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,78},{100,-78}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-58,48},{58,-44}}, textString="int", textColor={45,105,165}, textStyle={TextStyle.Bold}), Text(extent={{-96,102},{96,80}}, textString="%name", textColor={55,75,95})}),
      Documentation(info="<html><p><b>Purpose:</b> integrate a trajectory online.</p><p><b>Optional inputs:</b> enable and reset are structural conditional connectors. Without enable the integrator is always enabled; without reset it never resets.</p><p><b>Meaning:</b> der(y)=u while enabled and 0 otherwise; a reset edge reinitializes y.</p><p><b>Limitations:</b> ideal integration without anti-windup.</p></html>"));
  end Integral;

  block BooleanAnd "Logical conjunction of n Boolean trajectories"
    parameter Integer n(min=1)=2;
    Modelica.Blocks.Interfaces.BooleanInput u[n] annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.BooleanOutput y annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    y=Modelica.Math.BooleanVectors.allTrue(u);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-76,36},{76,-34}}, textString="AND", textColor={45,105,165}, textStyle={TextStyle.Bold}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}), Documentation(info="<html><p>y is true exactly when every Boolean input is true.</p></html>"));
  end BooleanAnd;

  block BooleanOr "Logical disjunction of n Boolean trajectories"
    parameter Integer n(min=1)=2;
    Modelica.Blocks.Interfaces.BooleanInput u[n] annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.BooleanOutput y annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    y=Modelica.Math.BooleanVectors.anyTrue(u);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-76,36},{76,-34}}, textString="OR", textColor={45,105,165}, textStyle={TextStyle.Bold}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}), Documentation(info="<html><p>y is true when at least one Boolean input is true.</p></html>"));
  end BooleanOr;

  block BooleanNot "Logical inversion"
    Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.BooleanOutput y annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    y=not u;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-76,36},{76,-34}}, textString="NOT", textColor={45,105,165}, textStyle={TextStyle.Bold}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}), Documentation(info="<html><p>y=not u.</p></html>"));
  end BooleanNot;

  block BooleanToIndicator "Map Boolean trajectory to configurable Real values"
    parameter Real trueValue=1;
    parameter Real falseValue=0;
    Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    y=if u then trueValue else falseValue;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-84,36},{84,-34}}, textString="B -> R", textColor={45,105,165}, textStyle={TextStyle.Bold}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={55,75,95})}), Documentation(info="<html><p><b>Purpose:</b> form a Real indicator from a Boolean trajectory.</p><p><b>Meaning:</b> y=trueValue when u, otherwise falseValue.</p></html>"));
  end BooleanToIndicator;

  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={45,105,165}, fillColor={232,242,252}, fillPattern=FillPattern.Solid), Text(extent={{-90,30},{90,-30}}, textString="Trajectory\nProcessing", textColor={35,85,135})}), Documentation(info="<html><p>Small deterministic or single-purpose stateful P blocks. References are supplied from the Scenario only when required; no nominal plant or external file is instantiated here.</p></html>"));
end Preprocessing;