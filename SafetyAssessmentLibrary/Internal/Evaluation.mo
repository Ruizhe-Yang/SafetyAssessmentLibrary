within SafetyAssessmentLibrary.Internal;
package Evaluation "Fine-grained temporal implementation behind public E blocks"
  extends Modelica.Icons.InternalPackage;

  record LiveEvidenceData
    Boolean currentWindowActive;
    Boolean configurationValid;
    BaseClasses.InvalidReason invalidReason;
    Boolean evidenceAvailable;
    Modelica.Units.SI.Time windowActiveDuration;
    Modelica.Units.SI.Time validDataDuration;
    Modelica.Units.SI.Time invalidDataDuration;
    Real dataCoverage;
    Boolean currentInside[3];
    Real currentMargin[3];
    Boolean lastInside[3];
    Modelica.Units.SI.Time outsideDuration[3];
    Modelica.Units.SI.Time longestOutsideDuration[3];
    Modelica.Units.SI.Time longestInsideDuration[3];
    Real insideFraction[3];
    Integer outsideCount[3];
    Modelica.Units.SI.Time firstViolationTime[3];
    Modelica.Units.SI.Time firstRecoveryTime[3];
    Modelica.Units.SI.Time recoveryDuration[3];
    Real integratedViolation[3];
    Real minimumMargin[3];
    Real worstValue;
    Modelica.Units.SI.Time timeOfWorst;
  end LiveEvidenceData;
  connector LiveEvidenceInput = input LiveEvidenceData;
  connector LiveEvidenceOutput = output LiveEvidenceData;

  record CandidateData
    Boolean pass[3];
    Boolean parameterValid;
    Boolean semanticEvidenceAvailable;
    BaseClasses.InvalidReason unresolvedReason;
    Modelica.Units.SI.Time triggerTime;
    Modelica.Units.SI.Time responseTime[3];
    Modelica.Units.SI.Time responseDuration[3];
  end CandidateData;
  connector CandidateInput = input CandidateData;
  connector CandidateOutput = output CandidateData;

  block ActiveDuration
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealOutput duration(start=0,fixed=true) annotation(Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  equation
    der(duration)=if active then 1 else 0;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-80,34},{80,-30}},textString="T",textColor={40,105,65})}));
  end ActiveDuration;

  block OutsideDuration
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.BooleanInput inside annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.RealOutput duration(start=0,fixed=true) annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    der(duration)=if active and not inside then 1 else 0;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-82,34},{82,-30}},textString="T out",textColor={40,105,65})}));
  end OutsideDuration;

  block InsideFraction
    parameter Real epsilon=1e-12;
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,50},{-100,70}}),iconTransformation(extent={{-110,50},{-90,70}})));
    Modelica.Blocks.Interfaces.BooleanInput inside annotation(Placement(transformation(extent={{-120,-10},{-100,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealInput activeDuration annotation(Placement(transformation(extent={{-120,-70},{-100,-50}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
    Modelica.Blocks.Interfaces.RealOutput fraction annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    Real insideDuration(start=0,fixed=true);
  equation
    der(insideDuration)=if active and inside then 1 else 0;
    fraction=noEvent(if activeDuration > epsilon then insideDuration/activeDuration else 0);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-82,34},{82,-30}},textString="% in",textColor={40,105,65})}));
  end InsideFraction;

  block ConsecutiveDuration
    parameter Boolean trackInside=false;
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.BooleanInput inside annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.RealOutput longest annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    Boolean tracking;
    discrete Modelica.Units.SI.Time segmentStart(start=0,fixed=true);
    discrete Modelica.Units.SI.Time completedLongest(start=0,fixed=true);
  initial equation
    pre(tracking)=tracking;
  equation
    tracking=active and (if trackInside then inside else not inside);
    longest=max(completedLongest,if tracking then time-segmentStart else 0);
  algorithm
    when {initial(),change(tracking)} then
      if initial() then
        segmentStart:=time;
        completedLongest:=0;
      else
        segmentStart:=if tracking and not pre(tracking) then time else pre(segmentStart);
        completedLongest:=if not tracking and pre(tracking) then max(pre(completedLongest),time-pre(segmentStart)) else pre(completedLongest);
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-84,34},{84,-30}},textString="max dt",textColor={40,105,65})}));
  end ConsecutiveDuration;

  block ViolationCounter
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.BooleanInput inside annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.IntegerOutput count annotation(Placement(transformation(extent={{100,30},{120,50}}),iconTransformation(extent={{90,30},{110,50}})));
    Modelica.Blocks.Interfaces.RealOutput firstTime annotation(Placement(transformation(extent={{100,-50},{120,-30}}),iconTransformation(extent={{90,-50},{110,-30}})));
  protected
    Boolean outsideNow;
    SafetyAssessmentLibrary.Internal.StableEdge edgeDetector annotation(Placement(transformation(extent={{-20,-20},{20,20}})));
  equation
    outsideNow=active and not inside;
    edgeDetector.u=outsideNow;
  algorithm
    when {initial(),edgeDetector.rising} then
      if initial() then
        count:=if outsideNow then 1 else 0;
        firstTime:=if outsideNow then time else -1;
      else
        count:=pre(count)+1;
        firstTime:=if pre(firstTime)<0 then time else pre(firstTime);
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-70,36},{70,-32}},textString="N",textColor={40,105,65})}));
  end ViolationCounter;

  block RecoveryTiming
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.BooleanInput inside annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.RealOutput firstViolationTime annotation(Placement(transformation(extent={{100,50},{120,70}}),iconTransformation(extent={{90,50},{110,70}})));
    Modelica.Blocks.Interfaces.RealOutput firstRecoveryTime annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealOutput recoveryDuration annotation(Placement(transformation(extent={{100,-70},{120,-50}}),iconTransformation(extent={{90,-70},{110,-50}})));
  protected
    Boolean outsideNow;
    SafetyAssessmentLibrary.Internal.StableEdge edgeDetector annotation(Placement(transformation(extent={{-20,-20},{20,20}})));
    discrete Real storedViolation(start=-1,fixed=true);
    discrete Real storedRecovery(start=-1,fixed=true);
  equation
    outsideNow=active and not inside;
    edgeDetector.u=outsideNow;
    firstViolationTime=storedViolation;
    firstRecoveryTime=storedRecovery;
    recoveryDuration=if storedViolation>=0 and storedRecovery>=0 then storedRecovery-storedViolation else -1;
  algorithm
    when {initial(),edgeDetector.rising,edgeDetector.falling} then
      if initial() then
        storedViolation:=if outsideNow then time else -1;
        storedRecovery:=-1;
      else
        storedViolation:=if edgeDetector.rising and pre(storedViolation)<0 then time else pre(storedViolation);
        storedRecovery:=if edgeDetector.falling and active and inside and pre(storedViolation)>=0 and pre(storedRecovery)<0 then time else pre(storedRecovery);
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-84,34},{84,-30}},textString="REC",textColor={40,105,65})}));
  end RecoveryTiming;

  block IntegratedViolation
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.RealInput margin annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.RealOutput integral(start=0,fixed=true) annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    der(integral)=if active then max(0,-margin) else 0;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-84,36},{84,-32}},textString="int V",textColor={40,105,65})}));
  end IntegratedViolation;

  block MinimumMargin
    parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small)=0.05;
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.RealInput margin annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.RealOutput minimumMargin annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    discrete Real stored(start=Modelica.Constants.inf,fixed=true);
  initial equation
    pre(active)=active;
  equation
    minimumMargin=if stored>=Modelica.Constants.inf/2 then 0 else stored;
  algorithm
    when {initial(),sample(0,samplePeriod),change(active),terminal()} then
      if initial() then
        stored:=if active then margin else Modelica.Constants.inf;
      else
        stored:=if active or pre(active) then min(pre(stored),margin) else pre(stored);
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-84,34},{84,-30}},textString="min m",textColor={40,105,65})}));
  end MinimumMargin;

  block LastMembership
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,30},{-100,50}}),iconTransformation(extent={{-110,30},{-90,50}})));
    Modelica.Blocks.Interfaces.BooleanInput inside annotation(Placement(transformation(extent={{-120,-50},{-100,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.BooleanOutput lastInside annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  initial equation
    pre(active)=active;
    pre(inside)=inside;
  algorithm
    when {initial(),change(active),change(inside)} then
      if initial() then lastInside:=if active then inside else true;
      else lastInside:=if active then inside else pre(lastInside);
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-84,34},{84,-30}},textString="LAST",textColor={40,105,65})}));
  end LastMembership;

  record LevelEvidenceData
    Boolean currentInside;
    Real currentMargin;
    Boolean lastInside;
    Modelica.Units.SI.Time outsideDuration;
    Modelica.Units.SI.Time longestOutsideDuration;
    Modelica.Units.SI.Time longestInsideDuration;
    Real insideFraction;
    Integer outsideCount;
    Modelica.Units.SI.Time firstViolationTime;
    Modelica.Units.SI.Time firstRecoveryTime;
    Modelica.Units.SI.Time recoveryDuration;
    Real integratedViolation;
    Real minimumMargin;
  end LevelEvidenceData;
  connector LevelEvidenceOutput = output LevelEvidenceData;

  block LevelStatistics "One A/B/C temporal lane"
    parameter Modelica.Units.SI.Time samplePeriod=0.05;
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-220,70},{-200,90}}),iconTransformation(extent={{-110,50},{-90,70}})));
    Modelica.Blocks.Interfaces.BooleanInput inside annotation(Placement(transformation(extent={{-220,20},{-200,40}}),iconTransformation(extent={{-110,10},{-90,30}})));
    Modelica.Blocks.Interfaces.RealInput margin annotation(Placement(transformation(extent={{-220,-30},{-200,-10}}),iconTransformation(extent={{-110,-30},{-90,-10}})));
    Modelica.Blocks.Interfaces.RealInput activeDuration annotation(Placement(transformation(extent={{-220,-90},{-200,-70}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
    LevelEvidenceOutput level annotation(Placement(transformation(extent={{200,-10},{220,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    OutsideDuration outside annotation(Placement(transformation(extent={{-150,70},{-110,110}})));
    ConsecutiveDuration consecutiveOutside annotation(Placement(transformation(extent={{-70,70},{-30,110}})));
    ConsecutiveDuration consecutiveInside(trackInside=true) annotation(Placement(transformation(extent={{10,70},{50,110}})));
    InsideFraction fraction annotation(Placement(transformation(extent={{90,70},{130,110}})));
    ViolationCounter counter annotation(Placement(transformation(extent={{-150,-10},{-110,30}})));
    RecoveryTiming recovery annotation(Placement(transformation(extent={{-70,-10},{-30,30}})));
    IntegratedViolation integrated annotation(Placement(transformation(extent={{10,-10},{50,30}})));
    MinimumMargin minimum(samplePeriod=samplePeriod) annotation(Placement(transformation(extent={{90,-10},{130,30}})));
    LastMembership last annotation(Placement(transformation(extent={{10,-80},{50,-40}})));
  equation
    connect(active,outside.active) annotation(Line(points={{-210,80},{-180,80},{-180,98},{-152,98}},color={255,0,255}));
    connect(inside,outside.inside) annotation(Line(points={{-210,30},{-188,30},{-188,82},{-152,82}},color={255,0,255}));
    connect(active,consecutiveOutside.active) annotation(Line(points={{-210,80},{-72,80},{-72,98}},color={255,0,255}));
    connect(inside,consecutiveOutside.inside) annotation(Line(points={{-210,30},{-84,30},{-84,82},{-72,82}},color={255,0,255}));
    connect(active,consecutiveInside.active) annotation(Line(points={{-210,80},{8,80},{8,98}},color={255,0,255}));
    connect(inside,consecutiveInside.inside) annotation(Line(points={{-210,30},{-4,30},{-4,82},{8,82}},color={255,0,255}));
    connect(active,fraction.active) annotation(Line(points={{-210,80},{88,80},{88,102}},color={255,0,255}));
    connect(inside,fraction.inside) annotation(Line(points={{-210,30},{74,30},{74,90},{88,90}},color={255,0,255}));
    connect(activeDuration,fraction.activeDuration) annotation(Line(points={{-210,-80},{70,-80},{70,78},{88,78}},color={0,0,127}));
    connect(active,counter.active) annotation(Line(points={{-210,80},{-180,80},{-180,18},{-152,18}},color={255,0,255}));
    connect(inside,counter.inside) annotation(Line(points={{-210,30},{-166,30},{-166,2},{-152,2}},color={255,0,255}));
    connect(active,recovery.active) annotation(Line(points={{-210,80},{-100,80},{-100,18},{-72,18}},color={255,0,255}));
    connect(inside,recovery.inside) annotation(Line(points={{-210,30},{-86,30},{-86,2},{-72,2}},color={255,0,255}));
    connect(active,integrated.active) annotation(Line(points={{-210,80},{-20,80},{-20,18},{8,18}},color={255,0,255}));
    connect(margin,integrated.margin) annotation(Line(points={{-210,-20},{-6,-20},{-6,2},{8,2}},color={0,0,127}));
    connect(active,minimum.active) annotation(Line(points={{-210,80},{60,80},{60,18},{88,18}},color={255,0,255}));
    connect(margin,minimum.margin) annotation(Line(points={{-210,-20},{74,-20},{74,2},{88,2}},color={0,0,127}));
    connect(active,last.active) annotation(Line(points={{-210,80},{-20,80},{-20,-52},{8,-52}},color={255,0,255}));
    connect(inside,last.inside) annotation(Line(points={{-210,30},{-6,30},{-6,-68},{8,-68}},color={255,0,255}));
    level.currentInside=inside;
    level.currentMargin=margin;
    level.lastInside=last.lastInside;
    level.outsideDuration=outside.duration;
    level.longestOutsideDuration=consecutiveOutside.longest;
    level.longestInsideDuration=consecutiveInside.longest;
    level.insideFraction=fraction.fraction;
    level.outsideCount=counter.count;
    level.firstViolationTime=counter.firstTime;
    level.firstRecoveryTime=recovery.firstRecoveryTime;
    level.recoveryDuration=recovery.recoveryDuration;
    level.integratedViolation=integrated.integral;
    level.minimumMargin=minimum.minimumMargin;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,82},{100,-82}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-86,38},{86,-34}},textString="T / N / %",textColor={40,105,65})}),Diagram(coordinateSystem(extent={{-200,-120},{200,130}})));
  end LevelStatistics;

  block WorstValue
    parameter Modelica.Units.SI.Time samplePeriod=0.05;
    Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(extent={{-120,50},{-100,70}}),iconTransformation(extent={{-110,50},{-90,70}})));
    Modelica.Blocks.Interfaces.RealInput value annotation(Placement(transformation(extent={{-120,-10},{-100,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealInput margin annotation(Placement(transformation(extent={{-120,-70},{-100,-50}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
    Modelica.Blocks.Interfaces.RealOutput worstValue annotation(Placement(transformation(extent={{100,20},{120,40}}),iconTransformation(extent={{90,20},{110,40}})));
    Modelica.Blocks.Interfaces.RealOutput timeOfWorst annotation(Placement(transformation(extent={{100,-40},{120,-20}}),iconTransformation(extent={{90,-40},{110,-20}})));
  protected
    discrete Real storedMargin(start=Modelica.Constants.inf,fixed=true);
    discrete Real storedValue(start=0,fixed=true);
    discrete Real storedTime(start=-1,fixed=true);
  initial equation pre(active)=active;
  equation worstValue=storedValue; timeOfWorst=storedTime;
  algorithm
    when {initial(),sample(0,samplePeriod),change(active),terminal()} then
      if initial() then
        storedMargin:=if active then margin else Modelica.Constants.inf;
        storedValue:=if active then value else 0;
        storedTime:=if active then time else -1;
      else
        storedValue:=if (active or pre(active)) and margin<pre(storedMargin) then value else pre(storedValue);
        storedTime:=if (active or pre(active)) and margin<pre(storedMargin) then time else pre(storedTime);
        storedMargin:=if active or pre(active) then min(pre(storedMargin),margin) else pre(storedMargin);
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,70},{100,-70}},lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-84,34},{84,-30}},textString="WORST",textColor={40,105,65})}));
  end WorstValue;

  block EvidenceCore "effectiveActive statistics and data coverage"
    parameter Modelica.Units.SI.Time samplePeriod=0.05;
    parameter Modelica.Units.SI.Time evidenceTolerance=1e-9;
    parameter Real minimumDataCoverage(min=0,max=1)=1;
    parameter Boolean useDataValidityInput=false;
    BaseClasses.CriteriaResultInput criteria annotation(Placement(transformation(extent={{-220,70},{-200,90}}),iconTransformation(extent={{-110,40},{-90,60}})));
    BaseClasses.WindowStateInput window annotation(Placement(transformation(extent={{-20,-160},{20,-120}}),iconTransformation(extent={{-10,-110},{10,-90}})));
    Modelica.Blocks.Interfaces.BooleanInput dataValid if useDataValidityInput annotation(Placement(transformation(extent={{-220,-90},{-200,-70}}),iconTransformation(extent={{-110,-60},{-90,-40}})));
    LiveEvidenceOutput evidence annotation(Placement(transformation(extent={{200,-10},{220,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    Modelica.Blocks.Interfaces.BooleanInput dataSignal;
    Modelica.Blocks.Sources.BooleanConstant defaultData(k=true) if not useDataValidityInput annotation(Placement(transformation(extent={{-180,-120},{-160,-100}})));
    Boolean effectiveActive;
    Boolean validActive;
    Boolean invalidActive;
    discrete Boolean dynamicInvalidSeen(start=false,fixed=true);
    discrete BaseClasses.InvalidReason dynamicInvalidReason(start=BaseClasses.InvalidReason.None,fixed=true);
    ActiveDuration windowDuration annotation(Placement(transformation(extent={{-160,-70},{-120,-30}})));
    ActiveDuration validDuration annotation(Placement(transformation(extent={{-100,-70},{-60,-30}})));
    ActiveDuration invalidDuration annotation(Placement(transformation(extent={{-40,-70},{0,-30}})));
    LevelStatistics laneA(samplePeriod=samplePeriod) annotation(Placement(transformation(extent={{-80,65},{20,105}})));
    LevelStatistics laneB(samplePeriod=samplePeriod) annotation(Placement(transformation(extent={{-80,15},{20,55}})));
    LevelStatistics laneC(samplePeriod=samplePeriod) annotation(Placement(transformation(extent={{-80,-35},{20,5}})));
    WorstValue worst(samplePeriod=samplePeriod) annotation(Placement(transformation(extent={{80,-30},{130,20}})));
  equation
    connect(dataValid,dataSignal) annotation(Line(points={{-210,-80},{-190,-80},{-190,-110}},color={255,0,255}));
    connect(defaultData.y,dataSignal) annotation(Line(points={{-159,-110},{-150,-110},{-150,-80},{-190,-80}},color={255,0,255}));
    validActive=window.active and dataSignal;
    invalidActive=window.active and not dataSignal;
    effectiveActive=validActive and criteria.configurationValid;
    windowDuration.active=window.active;
    validDuration.active=validActive;
    invalidDuration.active=invalidActive;
    laneA.active=effectiveActive; laneA.inside=criteria.inside[1]; laneA.margin=criteria.margin[1]; laneA.activeDuration=validDuration.duration;
    laneB.active=effectiveActive; laneB.inside=criteria.inside[2]; laneB.margin=criteria.margin[2]; laneB.activeDuration=validDuration.duration;
    laneC.active=effectiveActive; laneC.inside=criteria.inside[3]; laneC.margin=criteria.margin[3]; laneC.activeDuration=validDuration.duration;
    worst.active=effectiveActive; worst.value=criteria.value; worst.margin=criteria.margin[3];
    evidence.currentWindowActive=window.active;
    evidence.windowActiveDuration=windowDuration.duration;
    evidence.validDataDuration=validDuration.duration;
    evidence.invalidDataDuration=invalidDuration.duration;
    evidence.dataCoverage=noEvent(if windowDuration.duration>evidenceTolerance then validDuration.duration/windowDuration.duration else 0);
    evidence.configurationValid=window.configurationValid and (if criteria.isDynamic then not dynamicInvalidSeen else criteria.configurationValid) and samplePeriod>0 and evidenceTolerance>=0 and minimumDataCoverage>=0 and minimumDataCoverage<=1;
    evidence.invalidReason=if not window.configurationValid then window.invalidReason else if criteria.isDynamic and dynamicInvalidSeen then dynamicInvalidReason else if not criteria.isDynamic and not criteria.configurationValid then criteria.invalidReason else if samplePeriod<=0 or evidenceTolerance<0 or minimumDataCoverage<0 or minimumDataCoverage>1 then BaseClasses.InvalidReason.EvaluationConfiguration else BaseClasses.InvalidReason.None;
    evidence.evidenceAvailable=noEvent(validDuration.duration>evidenceTolerance and evidence.dataCoverage+evidenceTolerance>=minimumDataCoverage);
    evidence.currentInside=criteria.inside;
    evidence.currentMargin=criteria.margin;
    evidence.lastInside={laneA.level.lastInside,laneB.level.lastInside,laneC.level.lastInside};
    evidence.outsideDuration={laneA.level.outsideDuration,laneB.level.outsideDuration,laneC.level.outsideDuration};
    evidence.longestOutsideDuration={laneA.level.longestOutsideDuration,laneB.level.longestOutsideDuration,laneC.level.longestOutsideDuration};
    evidence.longestInsideDuration={laneA.level.longestInsideDuration,laneB.level.longestInsideDuration,laneC.level.longestInsideDuration};
    evidence.insideFraction={laneA.level.insideFraction,laneB.level.insideFraction,laneC.level.insideFraction};
    evidence.outsideCount={laneA.level.outsideCount,laneB.level.outsideCount,laneC.level.outsideCount};
    evidence.firstViolationTime={laneA.level.firstViolationTime,laneB.level.firstViolationTime,laneC.level.firstViolationTime};
    evidence.firstRecoveryTime={laneA.level.firstRecoveryTime,laneB.level.firstRecoveryTime,laneC.level.firstRecoveryTime};
    evidence.recoveryDuration={laneA.level.recoveryDuration,laneB.level.recoveryDuration,laneC.level.recoveryDuration};
    evidence.integratedViolation={laneA.level.integratedViolation,laneB.level.integratedViolation,laneC.level.integratedViolation};
    evidence.minimumMargin={laneA.level.minimumMargin,laneB.level.minimumMargin,laneC.level.minimumMargin};
    evidence.worstValue=worst.worstValue;
    evidence.timeOfWorst=worst.timeOfWorst;
  algorithm
    when initial() then
      dynamicInvalidSeen:=criteria.isDynamic and window.active and not criteria.configurationValid;
      dynamicInvalidReason:=if criteria.isDynamic and window.active and not criteria.configurationValid then criteria.invalidReason else BaseClasses.InvalidReason.None;
    elsewhen window.active and not criteria.configurationValid then
      dynamicInvalidSeen:=true;
      dynamicInvalidReason:=if pre(dynamicInvalidSeen) then pre(dynamicInvalidReason) else criteria.invalidReason;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,86},{100,-86}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,40},{88,-36}},textString="E evidence",textColor={75,75,75})}),Diagram(coordinateSystem(extent={{-200,-140},{200,130}})),Documentation(info="<html><p>All observation-dependent statistics use effectiveActive=window.active and dataValid and criteria.configurationValid. Window, valid, invalid durations and Coverage=Tvalid/Twindow are accumulated separately.</p></html>"));
  end EvidenceCore;

  block EvaluationAssembler "Freeze one EvaluationResult"
    parameter BaseClasses.EvaluationMode evaluationMode=BaseClasses.EvaluationMode.AtSimulationEnd;
    LiveEvidenceInput evidence annotation(Placement(transformation(extent={{-220,40},{-200,60}}),iconTransformation(extent={{-110,30},{-90,50}})));
    CandidateInput candidate annotation(Placement(transformation(extent={{-220,-60},{-200,-40}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.BooleanInput evaluateTrigger if evaluationMode==BaseClasses.EvaluationMode.OnTrigger annotation(Placement(transformation(extent={{-20,-140},{20,-120}}),iconTransformation(extent={{-10,-110},{10,-90}})));
    BaseClasses.EvaluationResultOutput evaluation annotation(Placement(transformation(extent={{200,-10},{220,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    Modelica.Blocks.Interfaces.BooleanInput triggerSignal;
    Modelica.Blocks.Sources.BooleanConstant defaultTrigger(k=false) if evaluationMode==BaseClasses.EvaluationMode.AtSimulationEnd annotation(Placement(transformation(extent={{-40,-100},{-20,-80}})));
    discrete Boolean evaluatedStored(start=false,fixed=true);
    discrete Boolean configurationStored(start=true,fixed=true);
    discrete Boolean evidenceStored(start=false,fixed=true);
    discrete Boolean passStored[3](each start=false,each fixed=true);
    discrete BaseClasses.InvalidReason reasonStored(start=BaseClasses.InvalidReason.None,fixed=true);
    Boolean rawMonotone;
    Boolean currentConfiguration;
    BaseClasses.InvalidReason currentReason;
  equation
    connect(evaluateTrigger,triggerSignal) annotation(Line(points={{0,-130},{0,-90}},color={255,0,255}));
    connect(defaultTrigger.y,triggerSignal) annotation(Line(points={{-19,-90},{0,-90}},color={255,0,255}));
    rawMonotone=(not candidate.pass[1] or candidate.pass[2]) and (not candidate.pass[2] or candidate.pass[3]);
    currentConfiguration=evidence.configurationValid and candidate.parameterValid;
    currentReason=if not evidence.configurationValid then evidence.invalidReason else if not candidate.parameterValid then BaseClasses.InvalidReason.EvaluationConfiguration else BaseClasses.InvalidReason.None;
    evaluation.currentWindowActive=evidence.currentWindowActive;
    evaluation.evaluated=evaluatedStored;
    evaluation.configurationValid=if evaluatedStored then configurationStored else currentConfiguration;
    evaluation.evidenceAvailable=if evaluatedStored then evidenceStored else evidence.evidenceAvailable and candidate.semanticEvidenceAvailable;
    evaluation.pass=passStored;
    evaluation.invalidReason=if evaluatedStored then reasonStored else currentReason;
  algorithm
    when {initial(),terminal(),triggerSignal} then
      if initial() then
        evaluatedStored:=false; configurationStored:=true; evidenceStored:=false; passStored:=fill(false,3); reasonStored:=BaseClasses.InvalidReason.None;
        evaluation.windowActiveDuration:=0; evaluation.validDataDuration:=0; evaluation.invalidDataDuration:=0; evaluation.dataCoverage:=0;
        evaluation.currentInside:=fill(false,3); evaluation.currentMargin:=fill(0,3); evaluation.lastInside:=fill(true,3);
        evaluation.outsideDuration:=fill(0,3); evaluation.longestOutsideDuration:=fill(0,3); evaluation.longestInsideDuration:=fill(0,3); evaluation.insideFraction:=fill(0,3); evaluation.outsideCount:=fill(0,3);
        evaluation.firstViolationTime:=fill(-1,3); evaluation.firstRecoveryTime:=fill(-1,3); evaluation.recoveryDuration:=fill(-1,3); evaluation.integratedViolation:=fill(0,3); evaluation.minimumMargin:=fill(0,3);
        evaluation.worstValue:=0; evaluation.timeOfWorst:=-1; evaluation.triggerTime:=-1; evaluation.responseTime:=fill(-1,3); evaluation.responseDuration:=fill(-1,3);
      elseif not pre(evaluatedStored) and ((evaluationMode==BaseClasses.EvaluationMode.AtSimulationEnd and terminal()) or (evaluationMode==BaseClasses.EvaluationMode.OnTrigger and triggerSignal)) then
        evaluatedStored:=true;
        configurationStored:=currentConfiguration and rawMonotone;
        evidenceStored:=evidence.evidenceAvailable and candidate.semanticEvidenceAvailable;
        passStored:=if currentConfiguration and rawMonotone and evidence.evidenceAvailable and candidate.semanticEvidenceAvailable then candidate.pass else fill(false,3);
        reasonStored:=if not evidence.configurationValid then evidence.invalidReason else if not candidate.parameterValid or not rawMonotone then BaseClasses.InvalidReason.EvaluationConfiguration else if not candidate.semanticEvidenceAvailable then candidate.unresolvedReason else if not evidence.evidenceAvailable then BaseClasses.InvalidReason.InsufficientDataCoverage else BaseClasses.InvalidReason.None;
        evaluation.windowActiveDuration:=evidence.windowActiveDuration; evaluation.validDataDuration:=evidence.validDataDuration; evaluation.invalidDataDuration:=evidence.invalidDataDuration; evaluation.dataCoverage:=evidence.dataCoverage;
        evaluation.currentInside:=evidence.currentInside; evaluation.currentMargin:=evidence.currentMargin; evaluation.lastInside:=evidence.lastInside;
        evaluation.outsideDuration:=evidence.outsideDuration; evaluation.longestOutsideDuration:=evidence.longestOutsideDuration; evaluation.longestInsideDuration:=evidence.longestInsideDuration; evaluation.insideFraction:=evidence.insideFraction; evaluation.outsideCount:=evidence.outsideCount;
        evaluation.firstViolationTime:=evidence.firstViolationTime; evaluation.firstRecoveryTime:=evidence.firstRecoveryTime; evaluation.recoveryDuration:=evidence.recoveryDuration; evaluation.integratedViolation:=evidence.integratedViolation; evaluation.minimumMargin:=evidence.minimumMargin;
        evaluation.worstValue:=evidence.worstValue; evaluation.timeOfWorst:=evidence.timeOfWorst; evaluation.triggerTime:=candidate.triggerTime; evaluation.responseTime:=candidate.responseTime; evaluation.responseDuration:=candidate.responseDuration;
      elseif not pre(evaluatedStored) and evaluationMode==BaseClasses.EvaluationMode.OnTrigger and terminal() then
        evaluatedStored:=true; configurationStored:=currentConfiguration; evidenceStored:=false; passStored:=fill(false,3); reasonStored:=BaseClasses.InvalidReason.MissingTrigger;
        evaluation.windowActiveDuration:=evidence.windowActiveDuration; evaluation.validDataDuration:=evidence.validDataDuration; evaluation.invalidDataDuration:=evidence.invalidDataDuration; evaluation.dataCoverage:=evidence.dataCoverage;
        evaluation.currentInside:=evidence.currentInside; evaluation.currentMargin:=evidence.currentMargin; evaluation.lastInside:=evidence.lastInside;
        evaluation.outsideDuration:=evidence.outsideDuration; evaluation.longestOutsideDuration:=evidence.longestOutsideDuration; evaluation.longestInsideDuration:=evidence.longestInsideDuration; evaluation.insideFraction:=evidence.insideFraction; evaluation.outsideCount:=evidence.outsideCount;
        evaluation.firstViolationTime:=evidence.firstViolationTime; evaluation.firstRecoveryTime:=evidence.firstRecoveryTime; evaluation.recoveryDuration:=evidence.recoveryDuration; evaluation.integratedViolation:=evidence.integratedViolation; evaluation.minimumMargin:=evidence.minimumMargin;
        evaluation.worstValue:=evidence.worstValue; evaluation.timeOfWorst:=evidence.timeOfWorst; evaluation.triggerTime:=candidate.triggerTime; evaluation.responseTime:=candidate.responseTime; evaluation.responseDuration:=candidate.responseDuration;
      else
        evaluatedStored:=pre(evaluatedStored); configurationStored:=pre(configurationStored); evidenceStored:=pre(evidenceStored); passStored:=pre(passStored); reasonStored:=pre(reasonStored);
        evaluation.windowActiveDuration:=pre(evaluation.windowActiveDuration); evaluation.validDataDuration:=pre(evaluation.validDataDuration); evaluation.invalidDataDuration:=pre(evaluation.invalidDataDuration); evaluation.dataCoverage:=pre(evaluation.dataCoverage);
        evaluation.currentInside:=pre(evaluation.currentInside); evaluation.currentMargin:=pre(evaluation.currentMargin); evaluation.lastInside:=pre(evaluation.lastInside);
        evaluation.outsideDuration:=pre(evaluation.outsideDuration); evaluation.longestOutsideDuration:=pre(evaluation.longestOutsideDuration); evaluation.longestInsideDuration:=pre(evaluation.longestInsideDuration); evaluation.insideFraction:=pre(evaluation.insideFraction); evaluation.outsideCount:=pre(evaluation.outsideCount);
        evaluation.firstViolationTime:=pre(evaluation.firstViolationTime); evaluation.firstRecoveryTime:=pre(evaluation.firstRecoveryTime); evaluation.recoveryDuration:=pre(evaluation.recoveryDuration); evaluation.integratedViolation:=pre(evaluation.integratedViolation); evaluation.minimumMargin:=pre(evaluation.minimumMargin);
        evaluation.worstValue:=pre(evaluation.worstValue); evaluation.timeOfWorst:=pre(evaluation.timeOfWorst); evaluation.triggerTime:=pre(evaluation.triggerTime); evaluation.responseTime:=pre(evaluation.responseTime); evaluation.responseDuration:=pre(evaluation.responseDuration);
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,82},{100,-82}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-86,38},{86,-34}},textString="FREEZE",textColor={75,75,75})}),Diagram(coordinateSystem(extent={{-200,-120},{200,120}})));
  end EvaluationAssembler;

  partial block PartialEvaluation "Shared public E boundary and white-box evidence/freeze chain"
    parameter BaseClasses.EvaluationMode evaluationMode=BaseClasses.EvaluationMode.AtSimulationEnd;
    parameter Boolean useDataValidityInput=false;
    parameter Modelica.Units.SI.Time samplePeriod=0.05;
    parameter Modelica.Units.SI.Time evidenceTolerance=1e-9;
    parameter Real minimumDataCoverage(min=0,max=1)=1;
    BaseClasses.CriteriaResultInput criteria annotation(Placement(transformation(extent={{-220,50},{-200,70}}),iconTransformation(extent={{-110,30},{-90,50}})));
    BaseClasses.WindowStateInput window annotation(Placement(transformation(extent={{-20,-140},{20,-120}}),iconTransformation(extent={{-10,-110},{10,-90}})));
    Modelica.Blocks.Interfaces.BooleanInput dataValid if useDataValidityInput annotation(Placement(transformation(extent={{-220,-50},{-200,-30}}),iconTransformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Blocks.Interfaces.BooleanInput evaluateTrigger if evaluationMode==BaseClasses.EvaluationMode.OnTrigger annotation(Placement(transformation(extent={{80,-140},{120,-120}}),iconTransformation(extent={{50,-110},{70,-90}})));
    BaseClasses.EvaluationResultOutput evaluation annotation(Placement(transformation(extent={{200,-10},{220,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  protected
    EvidenceCore core(samplePeriod=samplePeriod,evidenceTolerance=evidenceTolerance,minimumDataCoverage=minimumDataCoverage,useDataValidityInput=useDataValidityInput) annotation(Placement(transformation(extent={{-150,-30},{-50,70}})));
    EvaluationAssembler assembler(evaluationMode=evaluationMode) annotation(Placement(transformation(extent={{90,-50},{170,50}})));
  equation
    connect(criteria,core.criteria) annotation(Line(points={{-210,60},{-150,60},{-150,40}},color={190,105,35},thickness=0.5));
    connect(window,core.window) annotation(Line(points={{0,-130},{-100,-130},{-100,-30}},color={105,75,155},thickness=0.5));
    connect(dataValid,core.dataValid) annotation(Line(points={{-210,-40},{-170,-40},{-170,0},{-150,0}},color={255,0,255}));
    connect(core.evidence,assembler.evidence) annotation(Line(points={{-50,20},{20,20},{90,20}},color={55,135,85},thickness=0.5));
    connect(evaluateTrigger,assembler.evaluateTrigger) annotation(Line(points={{100,-130},{130,-130},{130,-50}},color={255,0,255}));
    connect(assembler.evaluation,evaluation) annotation(Line(points={{170,0},{210,0}},color={55,135,85},thickness=0.5));
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,84},{100,-84}},radius=8,lineColor={55,135,85},fillColor={232,247,237},fillPattern=FillPattern.Solid),Text(extent={{-96,110},{96,88}},textString="%name",textColor={55,85,65})}),Diagram(coordinateSystem(extent={{-200,-120},{200,120}})));
  end PartialEvaluation;

  partial block PartialComparator
    LiveEvidenceInput evidence annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
    CandidateOutput candidate annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
  equation
    candidate.semanticEvidenceAvailable=true;
    candidate.unresolvedReason=BaseClasses.InvalidReason.None;
    candidate.triggerTime=-1;
    candidate.responseTime=fill(-1,3);
    candidate.responseDuration=fill(-1,3);
  end PartialComparator;

  block AllInsideComparator
    extends PartialComparator;
    parameter Modelica.Units.SI.Time tolerance=1e-9;
  equation candidate.parameterValid=tolerance>=0; for i in 1:3 loop candidate.pass[i]=evidence.outsideDuration[i]<=tolerance; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-82,36},{82,-32}},textString="ALL IN",textColor={75,75,75})}));
  end AllInsideComparator;
  block CheckAtEndComparator
    extends PartialComparator;
    parameter Modelica.Units.SI.Time minimumActiveDuration=0;
  equation candidate.parameterValid=minimumActiveDuration>=0; for i in 1:3 loop candidate.pass[i]=evidence.validDataDuration>minimumActiveDuration and evidence.lastInside[i]; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-82,36},{82,-32}},textString="END",textColor={75,75,75})}));
  end CheckAtEndComparator;
  block MaxOutsideDurationComparator
    extends PartialComparator;
    parameter Modelica.Units.SI.Time maxAllowed[3]={0,1,2};
  equation candidate.parameterValid=min(maxAllowed)>=0 and maxAllowed[1]<=maxAllowed[2] and maxAllowed[2]<=maxAllowed[3]; for i in 1:3 loop candidate.pass[i]=evidence.outsideDuration[i]<=maxAllowed[i]; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,36},{88,-32}},textString="SUM T",textColor={75,75,75})}));
  end MaxOutsideDurationComparator;
  block MaxConsecutiveOutsideComparator
    extends PartialComparator;
    parameter Modelica.Units.SI.Time maxAllowed[3]={0,1,2};
  equation candidate.parameterValid=min(maxAllowed)>=0 and maxAllowed[1]<=maxAllowed[2] and maxAllowed[2]<=maxAllowed[3]; for i in 1:3 loop candidate.pass[i]=evidence.longestOutsideDuration[i]<=maxAllowed[i]; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,36},{88,-32}},textString="MAX T",textColor={75,75,75})}));
  end MaxConsecutiveOutsideComparator;
  block MinInsideFractionComparator
    extends PartialComparator;
    parameter Real minimumFraction[3]={1,0.99,0.95};
    parameter Modelica.Units.SI.Time minimumActiveDuration=0;
  equation candidate.parameterValid=min(minimumFraction)>=0 and max(minimumFraction)<=1 and minimumFraction[1]>=minimumFraction[2] and minimumFraction[2]>=minimumFraction[3] and minimumActiveDuration>=0; for i in 1:3 loop candidate.pass[i]=evidence.validDataDuration>minimumActiveDuration and evidence.insideFraction[i]>=minimumFraction[i]; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,36},{88,-32}},textString="% IN",textColor={75,75,75})}));
  end MinInsideFractionComparator;
  block MaxOutsideCountComparator
    extends PartialComparator;
    parameter Integer maxAllowed[3]={0,1,2};
  equation candidate.parameterValid=min(maxAllowed)>=0 and maxAllowed[1]<=maxAllowed[2] and maxAllowed[2]<=maxAllowed[3]; for i in 1:3 loop candidate.pass[i]=evidence.outsideCount[i]<=maxAllowed[i]; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,36},{88,-32}},textString="N MAX",textColor={75,75,75})}));
  end MaxOutsideCountComparator;
  block FirstRecoveryWithinComparator
    extends PartialComparator;
    parameter Modelica.Units.SI.Time maxRecoveryDuration[3]={0,1,2};
    parameter Modelica.Units.SI.Time minimumSafeDwell[3]=fill(0,3);
  equation
    candidate.parameterValid=min(maxRecoveryDuration)>=0 and maxRecoveryDuration[1]<=maxRecoveryDuration[2] and maxRecoveryDuration[2]<=maxRecoveryDuration[3] and min(minimumSafeDwell)>=0 and minimumSafeDwell[1]>=minimumSafeDwell[2] and minimumSafeDwell[2]>=minimumSafeDwell[3];
    for i in 1:3 loop candidate.pass[i]=evidence.firstViolationTime[i]<0 or (evidence.recoveryDuration[i]>=0 and evidence.recoveryDuration[i]<=maxRecoveryDuration[i] and evidence.longestInsideDuration[i]>=minimumSafeDwell[i]); end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,36},{88,-32}},textString="REC dt",textColor={75,75,75})}));
  end FirstRecoveryWithinComparator;
  block MinConsecutiveInsideComparator
    extends PartialComparator;
    parameter Modelica.Units.SI.Time minimumDuration[3]={10,8,5};
  equation candidate.parameterValid=min(minimumDuration)>=0 and minimumDuration[1]>=minimumDuration[2] and minimumDuration[2]>=minimumDuration[3]; for i in 1:3 loop candidate.pass[i]=evidence.longestInsideDuration[i]>=minimumDuration[i]; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,36},{88,-32}},textString="DWELL",textColor={75,75,75})}));
  end MinConsecutiveInsideComparator;
  block MaxIntegratedViolationComparator
    extends PartialComparator;
    parameter Real maxAllowed[3]={0,1,2};
  equation candidate.parameterValid=min(maxAllowed)>=0 and maxAllowed[1]<=maxAllowed[2] and maxAllowed[2]<=maxAllowed[3]; for i in 1:3 loop candidate.pass[i]=evidence.integratedViolation[i]<=maxAllowed[i]; end for;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-88,36},{88,-32}},textString="INT V",textColor={75,75,75})}));
  end MaxIntegratedViolationComparator;

  block TriggeredResponseComparator "Explicit trigger to first inside response"
    parameter Modelica.Units.SI.Time maxResponseDuration[3]={1,2,4};
    LiveEvidenceInput evidence annotation(Placement(transformation(extent={{-120,20},{-100,60}}),iconTransformation(extent={{-110,10},{-90,50}})));
    CandidateOutput candidate annotation(Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.BooleanInput trigger annotation(Placement(transformation(extent={{-120,-80},{-100,-60}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
  protected
    discrete Boolean triggerSeen(start=false,fixed=true);
    discrete Modelica.Units.SI.Time storedTrigger(start=-1,fixed=true);
    discrete Modelica.Units.SI.Time storedResponse[3](each start=-1,each fixed=true);
  initial equation
    pre(trigger)=trigger;
    for i in 1:3 loop pre(evidence.currentInside[i])=evidence.currentInside[i]; end for;
  equation
    candidate.parameterValid=min(maxResponseDuration)>=0 and maxResponseDuration[1]<=maxResponseDuration[2] and maxResponseDuration[2]<=maxResponseDuration[3];
    candidate.semanticEvidenceAvailable=triggerSeen;
    candidate.unresolvedReason=BaseClasses.InvalidReason.MissingTrigger;
    candidate.triggerTime=storedTrigger;
    candidate.responseTime=storedResponse;
    for i in 1:3 loop
      candidate.responseDuration[i]=if storedTrigger>=0 and storedResponse[i]>=0 then storedResponse[i]-storedTrigger else -1;
      candidate.pass[i]=triggerSeen and candidate.responseDuration[i]>=0 and candidate.responseDuration[i]<=maxResponseDuration[i];
    end for;
  algorithm
    when {initial(),edge(trigger),change(evidence.currentInside[1]),change(evidence.currentInside[2]),change(evidence.currentInside[3])} then
      if initial() then
        triggerSeen:=trigger;
        storedTrigger:=if trigger then time else -1;
        for i in 1:3 loop storedResponse[i]:=if trigger and evidence.currentInside[i] then time else -1; end for;
      else
        triggerSeen:=pre(triggerSeen) or edge(trigger);
        storedTrigger:=if edge(trigger) and not pre(triggerSeen) then time else pre(storedTrigger);
        for i in 1:3 loop
          storedResponse[i]:=if edge(trigger) and not pre(triggerSeen) and evidence.currentInside[i] then time else if pre(triggerSeen) and evidence.currentInside[i] and not pre(evidence.currentInside[i]) and pre(storedResponse[i])<0 then time else pre(storedResponse[i]);
        end for;
      end if;
    end when;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,80},{100,-80}},lineColor={115,115,115},fillColor={242,242,242},fillPattern=FillPattern.Solid),Text(extent={{-92,38},{92,-34}},textString="TRIG->RESP",textColor={75,75,75})}));
  end TriggeredResponseComparator;
end Evaluation;