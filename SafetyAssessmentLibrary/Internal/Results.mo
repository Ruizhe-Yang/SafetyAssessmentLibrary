within SafetyAssessmentLibrary.Internal;
package Results "White-box implementation of the Q layer"
  extends Modelica.Icons.InternalPackage;

  connector AssessmentStateInput = input BaseClasses.AssessmentState;
  connector AssessmentStateOutput = output BaseClasses.AssessmentState;
  connector SafetyGradeInput = input BaseClasses.SafetyGrade;
  connector SafetyGradeOutput = output BaseClasses.SafetyGrade;
  connector VerdictInput = input BaseClasses.Verdict;
  connector VerdictOutput = output BaseClasses.Verdict;

  record ResultEvidenceData
    BaseClasses.InvalidReason invalidReason;
    Boolean pass[3];
    Modelica.Units.SI.Time windowActiveDuration;
    Modelica.Units.SI.Time validDataDuration;
    Modelica.Units.SI.Time invalidDataDuration;
    Real dataCoverage;
    Real minimumMarginByLevel[3];
    Real minimumMargin;
    Real worstValue;
    Modelica.Units.SI.Time timeOfWorst;
    Modelica.Units.SI.Time firstViolationTime;
    Modelica.Units.SI.Time firstRecoveryTime;
    Modelica.Units.SI.Time recoveryDuration;
    Modelica.Units.SI.Time violationDuration;
    Modelica.Units.SI.Time longestViolationDuration;
    Integer violationCount;
    Real integratedViolation;
  end ResultEvidenceData;
  connector ResultEvidenceInput = input ResultEvidenceData;
  connector ResultEvidenceOutput = output ResultEvidenceData;

  block LifecycleStateResolver
    BaseClasses.EvaluationResultInput evaluation annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    AssessmentStateOutput state annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    state=if not evaluation.configurationValid then BaseClasses.AssessmentState.Invalid 
      else if evaluation.evaluated and not evaluation.evidenceAvailable then BaseClasses.AssessmentState.Unresolved 
      else if evaluation.evaluated then BaseClasses.AssessmentState.Resolved 
      else if evaluation.currentWindowActive then BaseClasses.AssessmentState.Monitoring 
      else BaseClasses.AssessmentState.Inactive;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-80,36},{80,-32}},textString="STATE",textColor={75,75,75})}));
  end LifecycleStateResolver;

  block GradeResolver
    BaseClasses.EvaluationResultInput evaluation annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    SafetyGradeOutput grade annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    grade=Internal.Utilities.gradeFromPass(evaluation.pass);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-84,36},{84,-32}},textString="A B C D",textColor={75,75,75})}));
  end GradeResolver;

  block VerdictResolver
    parameter BaseClasses.SafetyGrade acceptableGrade=BaseClasses.SafetyGrade.C;
    AssessmentStateInput state annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    SafetyGradeInput grade annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    VerdictOutput verdict annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    verdict=if state<>BaseClasses.AssessmentState.Resolved then BaseClasses.Verdict.NotAvailable 
      else if Internal.Utilities.gradeSeverity(grade)<=Internal.Utilities.gradeSeverity(acceptableGrade) then BaseClasses.Verdict.Satisfied 
      else BaseClasses.Verdict.Violated;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-84,36},{84,-32}},textString="VERDICT",textColor={75,75,75})}));
  end VerdictResolver;

  block TopEventResolver
    parameter Boolean enabled=true;
    parameter Boolean useGradeThreshold=true;
    parameter BaseClasses.SafetyGrade threshold=BaseClasses.SafetyGrade.D;
    AssessmentStateInput state annotation(Placement(transformation(extent={{-120,50},{-100,70}}),iconTransformation(extent={{-110,50},{-90,70}})));
    SafetyGradeInput grade annotation(Placement(transformation(extent={{-120,-10},{-100,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.BooleanInput independentCondition if enabled and not useGradeThreshold annotation(Placement(transformation(extent={{-120,-70},{-100,-50}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
    Modelica.Blocks.Interfaces.BooleanOutput topEvent annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    Modelica.Blocks.Interfaces.BooleanInput independentSignal;
    Modelica.Blocks.Sources.BooleanConstant defaultIndependent(k=false) if not (enabled and not useGradeThreshold) annotation(Placement(transformation(extent={{-70,-90},{-50,-70}})));
  equation
    connect(independentCondition,independentSignal) annotation(Line(points={{-110,-60},{-40,-60}},color={255,0,255}));
    connect(defaultIndependent.y,independentSignal) annotation(Line(points={{-49,-80},{-40,-80},{-40,-60}},color={255,0,255}));
    topEvent=enabled and state==BaseClasses.AssessmentState.Resolved and (if useGradeThreshold then Internal.Utilities.gradeAtLeast(grade,threshold) else independentSignal);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-84,36},{84,-32}},textString="TOP",textColor={75,75,75})}));
  end TopEventResolver;

  block EvidenceAssembler
    BaseClasses.EvaluationResultInput evaluation annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    ResultEvidenceOutput evidence annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    evidence.invalidReason=evaluation.invalidReason;
    evidence.pass=evaluation.pass;
    evidence.windowActiveDuration=evaluation.windowActiveDuration;
    evidence.validDataDuration=evaluation.validDataDuration;
    evidence.invalidDataDuration=evaluation.invalidDataDuration;
    evidence.dataCoverage=evaluation.dataCoverage;
    evidence.minimumMarginByLevel=evaluation.minimumMargin;
    evidence.minimumMargin=evaluation.minimumMargin[3];
    evidence.worstValue=evaluation.worstValue;
    evidence.timeOfWorst=evaluation.timeOfWorst;
    evidence.firstViolationTime=evaluation.firstViolationTime[3];
    evidence.firstRecoveryTime=evaluation.firstRecoveryTime[3];
    evidence.recoveryDuration=evaluation.recoveryDuration[3];
    evidence.violationDuration=evaluation.outsideDuration[3];
    evidence.longestViolationDuration=evaluation.longestOutsideDuration[3];
    evidence.violationCount=evaluation.outsideCount[3];
    evidence.integratedViolation=evaluation.integratedViolation[3];
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-84,36},{84,-32}},textString="EVIDENCE",textColor={75,75,75})}));
  end EvidenceAssembler;

  block ResultAssembler
    AssessmentStateInput state annotation(Placement(transformation(extent={{-120,70},{-100,90}}),iconTransformation(extent={{-110,70},{-90,90}})));
    VerdictInput verdict annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    SafetyGradeInput grade annotation(Placement(transformation(extent={{-120,-10},{-100,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.BooleanInput topEvent annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    ResultEvidenceInput evidence annotation(Placement(transformation(extent={{-120,-90},{-100,-70}}),iconTransformation(extent={{-110,-90},{-90,-70}})));
    BaseClasses.AssessmentResultOutput result annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    result.state=state;
    result.verdict=verdict;
    result.grade=grade;
    result.topEvent=topEvent;
    result.invalidReason=evidence.invalidReason;
    result.pass=evidence.pass;
    result.windowActiveDuration=evidence.windowActiveDuration;
    result.validDataDuration=evidence.validDataDuration;
    result.invalidDataDuration=evidence.invalidDataDuration;
    result.dataCoverage=evidence.dataCoverage;
    result.minimumMarginByLevel=evidence.minimumMarginByLevel;
    result.minimumMargin=evidence.minimumMargin;
    result.worstValue=evidence.worstValue;
    result.timeOfWorst=evidence.timeOfWorst;
    result.firstViolationTime=evidence.firstViolationTime;
    result.firstRecoveryTime=evidence.firstRecoveryTime;
    result.recoveryDuration=evidence.recoveryDuration;
    result.violationDuration=evidence.violationDuration;
    result.longestViolationDuration=evidence.longestViolationDuration;
    result.violationCount=evidence.violationCount;
    result.integratedViolation=evidence.integratedViolation;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,82},{100,-82}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-84,36},{84,-32}},textString="ASSEMBLE",textColor={75,75,75})}));
  end ResultAssembler;
end Results;