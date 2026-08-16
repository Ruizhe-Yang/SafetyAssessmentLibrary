within SafetyAssessmentLibrary;
package Evaluation "User-facing temporal evaluation policies"
  extends Modelica.Icons.Package;

  partial block PartialGrade4Evaluation "Shared compact interface and hidden evidence engine"
    parameter Types.EvaluationMode evaluationMode=Types.EvaluationMode.AtSimulationEnd "Result freeze policy";
    parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small)=0.05 "Sampling period for extrema";
    parameter Modelica.Units.SI.Time evidenceTolerance(min=0)=1e-9 "Minimum active duration for evidence";
    parameter Boolean useDataValidityInput=false "Expose dataValid for a dynamically unavailable observation/reference";
    Interfaces.GradeCriterionInput criterionA annotation(Placement(transformation(extent={{-120,60},{-100,80}})));
    Interfaces.GradeCriterionInput criterionB annotation(Placement(transformation(extent={{-120,20},{-100,40}})));
    Interfaces.GradeCriterionInput criterionC annotation(Placement(transformation(extent={{-120,-20},{-100,0}})));
    Interfaces.GradeCriterionInput criterionD annotation(Placement(transformation(extent={{-120,-60},{-100,-40}})));
    Modelica.Blocks.Interfaces.BooleanInput active "TimeWindow.active" 
      annotation(Placement(transformation(extent={{-70,-120},{-50,-100}})));
    Modelica.Blocks.Interfaces.BooleanInput windowValid "TimeWindow.configurationValid" 
      annotation(Placement(transformation(extent={{-30,-120},{-10,-100}})));
    Modelica.Blocks.Interfaces.BooleanInput dataValid if useDataValidityInput
      "False means a legal assessment had no usable observation/reference" 
      annotation(Placement(transformation(extent={{20,-120},{40,-100}})));
    Modelica.Blocks.Interfaces.BooleanInput evaluateTrigger 
      if evaluationMode == Types.EvaluationMode.OnTrigger "First true event freezes the result" 
      annotation(Placement(transformation(extent={{60,-120},{80,-100}})));
    Interfaces.AssessmentEvidenceOutput evidence "Compact output consumed by Results.AssessmentResult" 
      annotation(Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Internal.GradeNestingCheck nesting 
      annotation(Placement(transformation(origin={20,70},
extent={{-20,-50},{20,50}})), HideResult=true);
    Internal.Grade4Monitor monitor 
      annotation(Placement(transformation(origin={20,-25},
extent={{-20,-50},{20,50}})), HideResult=true);
    Internal.OnlineStatistics statistics(
      samplePeriod=samplePeriod,evidenceTolerance=evidenceTolerance) 
      annotation(Placement(transformation(origin={70,20},
extent={{-20,-50},{20,50}})), HideResult=true);
    Boolean inside[4] annotation(HideResult=true);
    Real margin[4] annotation(HideResult=true);
    Boolean criterion[4] "Current concrete policy result" annotation(HideResult=true);
    Boolean parameterValid "Concrete policy parameter validity" annotation(HideResult=true);
    Boolean baseConfigurationValid annotation(HideResult=true);
    Boolean monotoneFrozen annotation(HideResult=true);
    discrete Boolean pass[4](each start=false, each fixed=true) annotation(HideResult=true);
    discrete Boolean evaluated(start=false, fixed=true) annotation(HideResult=true);
    discrete Boolean evidenceAvailableAtEvaluation(start=false, fixed=true) annotation(HideResult=true);
    Modelica.Blocks.Interfaces.BooleanInput dataSignal annotation(Placement(transformation(extent={{-30,-95},{-10,-75}})));
    Modelica.Blocks.Interfaces.BooleanInput triggerSignal annotation(Placement(transformation(extent={{20,-95},{40,-75}})));
    Modelica.Blocks.Sources.BooleanConstant defaultData(k=true) if not useDataValidityInput 
      annotation(Placement(transformation(extent={{-70,-95},{-50,-75}})), HideResult=true);
    Modelica.Blocks.Sources.BooleanConstant defaultEvaluateTrigger(k=false) 
      if evaluationMode == Types.EvaluationMode.AtSimulationEnd 
      annotation(Placement(transformation(extent={{-10,-95},{10,-75}})), HideResult=true);
  equation
    connect(criterionA,nesting.criterionA) 
      annotation(Line(origin={0,0},
points={{-110,70},{-78,70},{-78,105},{-2,105}},
color={30,120,90},
thickness=0.5));
    connect(criterionB,nesting.criterionB) 
      annotation(Line(origin={0,0},
points={{-110,30},{-72,30},{-72,85},{-2,85}},
color={30,120,90},
thickness=0.5));
    connect(criterionC,nesting.criterionC) 
      annotation(Line(origin={0,0},
points={{-110,-10},{-72,-10},{-72,65},{-2,65}},
color={30,120,90},
thickness=0.5));
    connect(criterionD,nesting.criterionD) 
      annotation(Line(origin={0,0},
points={{-110,-50},{-78,-50},{-78,45},{-2,45}},
color={30,120,90},
thickness=0.5));
    connect(criterionA,monitor.criterionA) 
      annotation(Line(origin={0,0},
points={{-110,70},{-62,70},{-62,3},{-6,3},{-6,10},{-2,10}},
color={30,120,90},
thickness=0.5));
    connect(criterionB,monitor.criterionB) 
      annotation(Line(origin={0,0},
points={{-110,30},{-62,30},{-62,-10},{-2,-10}},
color={30,120,90},
thickness=0.5));
    connect(criterionC,monitor.criterionC) 
      annotation(Line(origin={0,0},
points={{-110,-10},{-64,-10},{-64,-30},{-2,-30}},
color={30,120,90},
thickness=0.5));
    connect(criterionD,monitor.criterionD) 
      annotation(Line(origin={0,0},
points={{-110,-50},{-2,-50}},
color={30,120,90},
thickness=0.5));
    connect(dataValid,dataSignal) 
      annotation(Line(points={{30,-110},{-20,-110},{-20,-85}}, color={255,0,255}));
    connect(defaultData.y,dataSignal) 
      annotation(Line(points={{-49,-85},{-20,-85}}, color={255,0,255}));
    connect(evaluateTrigger,triggerSignal) 
      annotation(Line(points={{70,-110},{30,-110},{30,-85}}, color={255,0,255}));
    connect(defaultEvaluateTrigger.y,triggerSignal) 
      annotation(Line(points={{11,-85},{30,-85}}, color={255,0,255}));

    monitor.active=active;
    inside=monitor.inside;
    margin=monitor.margin;
    statistics.active=active;
    statistics.z=criterionA.value;
    statistics.inside=inside;
    statistics.margin=margin;
    baseConfigurationValid=nesting.configurationValid and windowValid and parameterValid;
    monotoneFrozen=not evaluated or ((not pass[1] or pass[2]) and (not pass[2] or pass[3]) and (not pass[3] or pass[4]));

    evidence.active=active;
    evidence.evaluated=evaluated;
    evidence.evidenceAvailableAtEvaluation=evidenceAvailableAtEvaluation;
    evidence.configurationValid=baseConfigurationValid and monotoneFrozen;
    evidence.invalidCode=if nesting.invalidCode <> 0 then nesting.invalidCode else if not windowValid then 5 
      else if not parameterValid then 6 else if not monotoneFrozen then 7 else 0;
    evidence.pass=pass;
    evidence.activeDuration=statistics.activeDuration;
    evidence.outsideDuration=statistics.outsideDuration;
    evidence.insideFraction=statistics.insideFraction;
    evidence.longestOutsideDuration=statistics.longestOutsideDuration;
    evidence.outsideCount=statistics.outsideCount;
    evidence.firstOutsideTime=statistics.firstOutsideTime;
    evidence.sampledMinimumMargin=statistics.sampledMinimumMargin;
    evidence.sampledWorstValue=statistics.sampledWorstValue;
    evidence.timeOfSampledWorst=statistics.timeOfSampledWorst;
    evidence.everOuterViolation=statistics.everOuterViolation;
  algorithm
    when {terminal(),triggerSignal} then
      if not pre(evaluated) and 
          ((evaluationMode == Types.EvaluationMode.AtSimulationEnd and terminal()) or 
           (evaluationMode == Types.EvaluationMode.OnTrigger and triggerSignal)) then
        pass := if baseConfigurationValid and statistics.evidenceAvailable and dataSignal then criterion else fill(false,4);
        evaluated := true;
        evidenceAvailableAtEvaluation := statistics.evidenceAvailable and dataSignal;
        if statistics.evidenceAvailable and dataSignal then
          assert((not criterion[1] or criterion[2]) and (not criterion[2] or criterion[3]) and 
            (not criterion[3] or criterion[4]),
            "Evaluation result is not monotone from Grade A to Grade D", level=AssertionLevel.warning);
        end if;
      else
        pass := pre(pass);
        evaluated := pre(evaluated);
        evidenceAvailableAtEvaluation := pre(evidenceAvailableAtEvaluation);
      end if;
    end when;
    annotation(
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,82},{100,-82}}, radius=9, lineColor={40,100,170},
          fillColor={235,245,255}, fillPattern=FillPattern.Solid),
        Text(extent={{-96,104},{96,84}}, textString="%name", textColor={70,70,70})}),
      Diagram(coordinateSystem(extent={{-120,-120},{120,100}})),
      Documentation(info="<html><p><b>Purpose:</b> provide the common compact interface for all public temporal policies.</p><p><b>Inputs:</b> four GradeInterval evidence lines, TimeWindow active/valid, and optional data/evaluation signals.</p><p><b>Output:</b> one compact line to Results.AssessmentResult.</p><p><b>Hidden work:</b> endpoint-aware A/B/C/D nesting validation, stable online accumulation, evidence availability, final freeze, and pass monotonicity checking.</p><p><b>Usage:</b> instantiate a concrete policy; this partial block is not placed directly.</p></html>"));
  end PartialGrade4Evaluation;

  block AllInside "Require containment for the complete active window"
    extends PartialGrade4Evaluation;
    parameter Modelica.Units.SI.Time tolerance(min=0)=1e-9 "Numerical zero-duration tolerance";
  equation
    parameterValid=tolerance >= 0;
    for i in 1:4 loop
      criterion[i]=statistics.outsideDuration[i] <= tolerance;
    end for;
    annotation(Icon(graphics={Text(extent={{-82,48},{82,-30}}, textString="ALL\nIN", textColor={40,100,170}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p>Pass each grade only when its total outside duration is no greater than tolerance. Use for strict whole-window containment.</p></html>"));
  end AllInside;

  block CheckAtEnd "Check membership at the last active instant"
    extends PartialGrade4Evaluation;
    parameter Modelica.Units.SI.Time minimumActiveDuration(min=0)=0 "Required evidence duration";
  equation
    parameterValid=minimumActiveDuration >= 0;
    for i in 1:4 loop
      criterion[i]=statistics.activeDuration > minimumActiveDuration and statistics.lastInside[i];
    end for;
    annotation(Icon(graphics={Text(extent={{-84,40},{84,-24}}, textString="END", textColor={40,100,170}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p>Pass each grade when sufficient active evidence exists and the last membership observed in the window is inside. Earlier excursions remain traceable but do not determine the grade.</p></html>"));
  end CheckAtEnd;

  block MaxOutsideDuration "Limit accumulated outside duration"
    extends PartialGrade4Evaluation;
    parameter Modelica.Units.SI.Time maxAllowed[4]={0,1,2,4} "A/B/C/D total outside-duration limits";
  equation
    parameterValid=min(maxAllowed) >= 0 and maxAllowed[1] <= maxAllowed[2] 
      and maxAllowed[2] <= maxAllowed[3] and maxAllowed[3] <= maxAllowed[4];
    for i in 1:4 loop
      criterion[i]=statistics.outsideDuration[i] <= maxAllowed[i];
    end for;
    annotation(Icon(graphics={Text(extent={{-90,46},{90,-28}}, textString="Tmax\nSUM", textColor={40,100,170}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p>Pass each grade when the sum of all outside intervals is no greater than its editable A/B/C/D limit. This policy allows configured short deviations but accumulates repeated excursions.</p></html>"));
  end MaxOutsideDuration;

  block MaxConsecutiveOutside "Limit the longest continuous outside interval"
    extends PartialGrade4Evaluation;
    parameter Modelica.Units.SI.Time maxAllowed[4]={0,1,2,4} "A/B/C/D consecutive outside limits";
  equation
    parameterValid=min(maxAllowed) >= 0 and maxAllowed[1] <= maxAllowed[2] 
      and maxAllowed[2] <= maxAllowed[3] and maxAllowed[3] <= maxAllowed[4];
    for i in 1:4 loop
      criterion[i]=statistics.longestOutsideDuration[i] <= maxAllowed[i];
    end for;
    annotation(Icon(graphics={Text(extent={{-92,46},{92,-28}}, textString="DeltaTmax", textColor={40,100,170}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p>Pass each grade when no single continuous outside segment exceeds its limit. Repeated short excursions can pass; their total duration and count remain in the compact evidence used by Result.</p></html>"));
  end MaxConsecutiveOutside;

  block MinInsideFraction "Require a minimum fraction of active time inside"
    extends PartialGrade4Evaluation;
    parameter Real minimumFraction[4]={1.0,0.99,0.95,0.90} "A/B/C/D minimum fractions";
    parameter Modelica.Units.SI.Time minimumActiveDuration(min=0)=0 "Required evidence duration";
  equation
    parameterValid=min(minimumFraction) >= 0 and max(minimumFraction) <= 1 
      and minimumFraction[1] >= minimumFraction[2] and minimumFraction[2] >= minimumFraction[3] 
      and minimumFraction[3] >= minimumFraction[4] and minimumActiveDuration >= 0;
    for i in 1:4 loop
      criterion[i]=statistics.activeDuration > minimumActiveDuration 
        and statistics.insideFraction[i] >= minimumFraction[i];
    end for;
    annotation(Icon(graphics={Text(extent={{-84,44},{84,-28}}, textString="% IN", textColor={40,100,170}, textStyle={TextStyle.Bold})}), Documentation(info="<html><p>Pass each grade when its inside fraction reaches the configured threshold after sufficient active evidence.</p></html>"));
  end MinInsideFraction;

  annotation(Documentation(info="<html><p>Evaluation is the user-facing black-box algorithm layer. The analyst connects four visible Criteria blocks and one TimeWindow; online monitoring/statistics remain internal. All policies emit the same single evidence connection to Result.</p></html>"));
end Evaluation;