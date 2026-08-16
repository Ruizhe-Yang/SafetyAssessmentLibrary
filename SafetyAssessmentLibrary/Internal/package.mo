within SafetyAssessmentLibrary;
package Internal "Non-user-facing monitoring and online evidence machinery"
  extends Modelica.Icons.InternalPackage;

  block GradeNestingCheck "Validate A subset B subset C subset D"
    Interfaces.GradeCriterionInput criterionA annotation(Placement(transformation(extent={{-120,60},{-100,80}})));
    Interfaces.GradeCriterionInput criterionB annotation(Placement(transformation(extent={{-120,20},{-100,40}})));
    Interfaces.GradeCriterionInput criterionC annotation(Placement(transformation(extent={{-120,-20},{-100,0}})));
    Interfaces.GradeCriterionInput criterionD annotation(Placement(transformation(extent={{-120,-60},{-100,-40}})));
    Modelica.Blocks.Interfaces.BooleanOutput configurationValid annotation(Placement(transformation(extent={{100,20},{120,40}})));
    Modelica.Blocks.Interfaces.IntegerOutput invalidCode annotation(Placement(transformation(extent={{100,-40},{120,-20}})));
  protected
    Boolean intervalsValid;
    Boolean aInB;
    Boolean bInC;
    Boolean cInD;
  equation
    intervalsValid=criterionA.configurationValid and criterionB.configurationValid
      and criterionC.configurationValid and criterionD.configurationValid;
    aInB=Utilities.intervalContained(
      criterionA.lower,criterionA.upper,
      if criterionA.lowerClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      if criterionA.upperClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      criterionB.lower,criterionB.upper,
      if criterionB.lowerClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      if criterionB.upperClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open);
    bInC=Utilities.intervalContained(
      criterionB.lower,criterionB.upper,
      if criterionB.lowerClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      if criterionB.upperClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      criterionC.lower,criterionC.upper,
      if criterionC.lowerClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      if criterionC.upperClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open);
    cInD=Utilities.intervalContained(
      criterionC.lower,criterionC.upper,
      if criterionC.lowerClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      if criterionC.upperClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      criterionD.lower,criterionD.upper,
      if criterionD.lowerClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open,
      if criterionD.upperClosed then Types.BoundaryType.Closed else Types.BoundaryType.Open);
    configurationValid=intervalsValid and aInB and bInC and cInD;
    invalidCode=if not intervalsValid then 4 elseif not aInB then 1 elseif not bInC then 2 elseif not cInD then 3 else 0;
    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,78},{100,-78}}, radius=8, lineColor={110,110,110},
          fillColor={245,245,245}, fillPattern=FillPattern.Solid),
        Text(extent={{-86,36},{86,-28}}, textString="A subset B\nsubset C subset D", textColor={80,80,80}),
        Text(extent={{-96,102},{96,80}}, textString="%name", textColor={80,80,80})}),
      Documentation(info="<html><p>Internal endpoint-aware nesting validation. invalidCode identifies an illegal interval or the first failed containment relation so the Result endpoint can print an explicit diagnostic. A valid trajectory outside D never changes this configuration result.</p></html>"));
  end GradeNestingCheck;

  block Grade4Monitor "Internal instantaneous membership and ternary decision"
    Interfaces.GradeCriterionInput criterionA annotation(Placement(transformation(extent={{-120,60},{-100,80}})));
    Interfaces.GradeCriterionInput criterionB annotation(Placement(transformation(extent={{-120,20},{-100,40}})));
    Interfaces.GradeCriterionInput criterionC annotation(Placement(transformation(extent={{-120,-20},{-100,0}})));
    Interfaces.GradeCriterionInput criterionD annotation(Placement(transformation(extent={{-120,-60},{-100,-40}})));
    Modelica.Blocks.Interfaces.BooleanInput active;
    Modelica.Blocks.Interfaces.IntegerOutput decision[4];
    Modelica.Blocks.Interfaces.BooleanOutput inside[4];
    Modelica.Blocks.Interfaces.RealOutput margin[4];
    Modelica.Blocks.Interfaces.BooleanOutput outerViolation;
    Modelica.Blocks.Interfaces.BooleanOutput configurationValid;
  equation
    inside={criterionA.inside,criterionB.inside,criterionC.inside,criterionD.inside};
    margin={criterionA.signedMargin,criterionB.signedMargin,criterionC.signedMargin,criterionD.signedMargin};
    configurationValid=criterionA.configurationValid and criterionB.configurationValid
      and criterionC.configurationValid and criterionD.configurationValid;
    for i in 1:4 loop
      decision[i]=if not active then 0 elseif inside[i] then 1 else -1;
    end for;
    outerViolation=active and configurationValid and not inside[4];
    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,78},{100,-78}}, radius=8, lineColor={130,100,70},
          fillColor={250,245,235}, fillPattern=FillPattern.Solid),
        Text(extent={{-82,34},{82,-18}}, textString="IN / OUT", textColor={130,100,70})}),
      Documentation(info="<html><p>Internal instantaneous semantics: decision is 0 when inactive, +1 inside, and -1 outside. Typed membership and margin remain the calculation basis; the integer vector is retained only for regression/export compatibility.</p></html>"));
  end Grade4Monitor;

  block OnlineStatistics "Accumulate durations and stable transition/extreme evidence online"
    parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small)=0.05 "Sampling period for continuous extrema";
    parameter Modelica.Units.SI.Time durationEpsilon(min=0)=1e-12 "Zero-duration guard";
    parameter Modelica.Units.SI.Time evidenceTolerance(min=0)=1e-9 "Minimum active duration required for evaluable evidence";
    Modelica.Blocks.Interfaces.BooleanInput active;
    Modelica.Blocks.Interfaces.RealInput z;
    Modelica.Blocks.Interfaces.BooleanInput inside[4];
    Modelica.Blocks.Interfaces.RealInput margin[4];
    Modelica.Blocks.Interfaces.RealOutput activeDuration(start=0, fixed=true);
    Modelica.Blocks.Interfaces.RealOutput insideDuration[4](each start=0, each fixed=true);
    Modelica.Blocks.Interfaces.RealOutput outsideDuration[4](each start=0, each fixed=true);
    Modelica.Blocks.Interfaces.RealOutput insideFraction[4];
    Modelica.Blocks.Interfaces.RealOutput longestOutsideDuration[4];
    Modelica.Blocks.Interfaces.IntegerOutput outsideCount[4];
    Modelica.Blocks.Interfaces.RealOutput firstOutsideTime[4];
    Modelica.Blocks.Interfaces.RealOutput sampledMinimumMargin[4];
    Modelica.Blocks.Interfaces.RealOutput sampledWorstValue;
    Modelica.Blocks.Interfaces.RealOutput timeOfSampledWorst;
    Modelica.Blocks.Interfaces.BooleanOutput evidenceAvailable;
    Modelica.Blocks.Interfaces.BooleanOutput lastInside[4];
    Modelica.Blocks.Interfaces.BooleanOutput everOuterViolation;
  protected
    Boolean outsideNow[4];
    discrete Modelica.Units.SI.Time segmentStart[4];
    discrete Modelica.Units.SI.Time completedLongest[4];
    discrete Real storedMinimumMargin[4];
    discrete Real storedWorstMargin;
    discrete Real storedWorstValue;
    discrete Modelica.Units.SI.Time storedWorstTime;
  initial equation
    pre(active)=active;
    pre(inside)=inside;
    pre(outsideNow)=outsideNow;
  equation
    der(activeDuration)=if active then 1 else 0;
    evidenceAvailable=noEvent(activeDuration > evidenceTolerance);
    sampledWorstValue=storedWorstValue;
    timeOfSampledWorst=storedWorstTime;
    for i in 1:4 loop
      der(insideDuration[i])=if active and inside[i] then 1 else 0;
      der(outsideDuration[i])=if active and not inside[i] then 1 else 0;
      insideFraction[i]=noEvent(if activeDuration > durationEpsilon then insideDuration[i]/activeDuration else 0);
      outsideNow[i]=active and not inside[i];
      longestOutsideDuration[i]=max(completedLongest[i],if outsideNow[i] then time-segmentStart[i] else 0);
      sampledMinimumMargin[i]=if storedMinimumMargin[i] >= Modelica.Constants.inf/2 then 0
        else min(storedMinimumMargin[i],if active then margin[i] else storedMinimumMargin[i]);

      when {initial(),change(outsideNow[i])} then
        if initial() then
          outsideCount[i]=if outsideNow[i] then 1 else 0;
          firstOutsideTime[i]=if outsideNow[i] then time else -1;
          segmentStart[i]=time;
          completedLongest[i]=0;
        else
          outsideCount[i]=pre(outsideCount[i]) + (if outsideNow[i] and not pre(outsideNow[i]) then 1 else 0);
          firstOutsideTime[i]=if pre(firstOutsideTime[i]) < 0 and outsideNow[i] and not pre(outsideNow[i]) then time else pre(firstOutsideTime[i]);
          segmentStart[i]=if outsideNow[i] and not pre(outsideNow[i]) then time else pre(segmentStart[i]);
          completedLongest[i]=if not outsideNow[i] and pre(outsideNow[i]) then max(pre(completedLongest[i]),time-pre(segmentStart[i])) else pre(completedLongest[i]);
        end if;
      end when;

      when {initial(),change(active),change(inside[i])} then
        if initial() then
          lastInside[i]=if active then inside[i] else true;
        else
          lastInside[i]=if active then inside[i] else pre(lastInside[i]);
        end if;
      end when;
    end for;

    everOuterViolation=outsideCount[4] > 0 or outsideNow[4];

    when {initial(),sample(0,samplePeriod),change(active),terminal()} then
      if initial() then
        for i in 1:4 loop
          storedMinimumMargin[i]=if active then margin[i] else Modelica.Constants.inf;
        end for;
        storedWorstMargin=if active then margin[1] else Modelica.Constants.inf;
        storedWorstValue=if active then z else 0;
        storedWorstTime=if active then time else -1;
      else
        for i in 1:4 loop
          storedMinimumMargin[i]=if active or pre(active) then min(pre(storedMinimumMargin[i]),margin[i]) else pre(storedMinimumMargin[i]);
        end for;
        storedWorstMargin=if (active or pre(active)) and margin[1] < pre(storedWorstMargin) then margin[1] else pre(storedWorstMargin);
        storedWorstValue=if (active or pre(active)) and margin[1] < pre(storedWorstMargin) then z else pre(storedWorstValue);
        storedWorstTime=if (active or pre(active)) and margin[1] < pre(storedWorstMargin) then time else pre(storedWorstTime);
      end if;
    end when;

    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,82},{100,-82}}, radius=8, lineColor={100,100,100},
          fillColor={245,245,245}, fillPattern=FillPattern.Solid),
        Text(extent={{-78,48},{78,-4}}, textString="online", textColor={80,80,80}),
        Text(extent={{-82,-16},{82,-52}}, textString="T / count / %", textColor={80,80,80})}),
      Documentation(info="<html><p><b>Internal algorithm.</b> Durations are continuous integrals of active membership. Counts, first times, and longest segments use stable transitions; simultaneous window closure and boundary crossing cannot create a false violation. Extrema are accumulated online at samplePeriod, window changes, and terminal(), so no result-file postprocessing is required.</p></html>"));
  end OnlineStatistics;

  annotation(Documentation(info="<html><p>Internal contains implementation machinery intentionally absent from normal assessment Diagrams. Public users work with Criteria and Evaluation; they do not wire monitoring decisions or statistics arrays.</p></html>"));
end Internal;
