within SafetyAssessmentLibrary.Internal;
package Criteria "White-box criterion primitives"
  extends Modelica.Icons.InternalPackage;

  record LevelCriterionData
    Real value;
    Real signedMargin;
    Real lower;
    Real upper;
    Boolean lowerClosed;
    Boolean upperClosed;
    Boolean inside;
    Boolean configurationValid;
  end LevelCriterionData;
  connector LevelCriterionInput = input LevelCriterionData;
  connector LevelCriterionOutput = output LevelCriterionData;

  block GradeInterval "One static interval primitive"
    parameter Real lower=0;
    parameter Real upper=1;
    parameter BaseClasses.BoundaryType lowerBoundary=BaseClasses.BoundaryType.Closed;
    parameter BaseClasses.BoundaryType upperBoundary=BaseClasses.BoundaryType.Closed;
    Modelica.Blocks.Interfaces.RealInput indicator annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    LevelCriterionOutput level annotation(Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  equation
    level.value=indicator;
    level.lower=lower;
    level.upper=upper;
    level.lowerClosed=lowerBoundary == BaseClasses.BoundaryType.Closed;
    level.upperClosed=upperBoundary == BaseClasses.BoundaryType.Closed;
    level.configurationValid=Utilities.intervalValid(lower,upper,lowerBoundary,upperBoundary);
    level.inside=level.configurationValid and (if level.lowerClosed then indicator >= lower else indicator > lower) and (if level.upperClosed then indicator <= upper else indicator < upper);
    level.signedMargin=min(indicator-lower,upper-indicator);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid), Line(points={{-70,0},{70,0}}, color={155,75,20}), Text(extent={{-92,100},{92,76}}, textString="%name", textColor={80,65,55})}));
  end GradeInterval;

  block DynamicInterval "One time-varying interval primitive"
    parameter BaseClasses.BoundaryType lowerBoundary=BaseClasses.BoundaryType.Closed;
    parameter BaseClasses.BoundaryType upperBoundary=BaseClasses.BoundaryType.Closed;
    Modelica.Blocks.Interfaces.RealInput value annotation(Placement(transformation(extent={{-120,50},{-100,70}}), iconTransformation(extent={{-110,50},{-90,70}})));
    Modelica.Blocks.Interfaces.RealInput lower annotation(Placement(transformation(extent={{-120,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.RealInput upper annotation(Placement(transformation(extent={{-120,-70},{-100,-50}}), iconTransformation(extent={{-110,-70},{-90,-50}})));
    LevelCriterionOutput level annotation(Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  equation
    level.value=value;
    level.lower=lower;
    level.upper=upper;
    level.lowerClosed=lowerBoundary == BaseClasses.BoundaryType.Closed;
    level.upperClosed=upperBoundary == BaseClasses.BoundaryType.Closed;
    level.configurationValid=Utilities.intervalValid(lower,upper,lowerBoundary,upperBoundary);
    level.inside=level.configurationValid and (if level.lowerClosed then value >= lower else value > lower) and (if level.upperClosed then value <= upper else value < upper);
    level.signedMargin=min(value-lower,upper-value);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid), Line(points={{-70,-20},{-20,20},{20,-20},{70,20}}, color={155,75,20}), Text(extent={{-92,100},{92,76}}, textString="%name", textColor={80,65,55})}));
  end DynamicInterval;

  block NestingCheck "Endpoint-aware I_A subset I_B subset I_C"
    parameter Boolean dynamic=false;
    LevelCriterionInput levelA annotation(Placement(transformation(extent={{-120,50},{-100,70}}), iconTransformation(extent={{-110,50},{-90,70}})));
    LevelCriterionInput levelB annotation(Placement(transformation(extent={{-120,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    LevelCriterionInput levelC annotation(Placement(transformation(extent={{-120,-70},{-100,-50}}), iconTransformation(extent={{-110,-70},{-90,-50}})));
    Modelica.Blocks.Interfaces.BooleanOutput configurationValid annotation(Placement(transformation(extent={{100,20},{120,40}}), iconTransformation(extent={{90,20},{110,40}})));
    output BaseClasses.InvalidReason invalidReason;
  protected
    Boolean intervalsValid;
    Boolean nested;
  equation
    intervalsValid=levelA.configurationValid and levelB.configurationValid and levelC.configurationValid;
    nested=Utilities.intervalContained(levelA.lower,levelA.upper,if levelA.lowerClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open,if levelA.upperClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open,levelB.lower,levelB.upper,if levelB.lowerClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open,if levelB.upperClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open) 
      and Utilities.intervalContained(levelB.lower,levelB.upper,if levelB.lowerClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open,if levelB.upperClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open,levelC.lower,levelC.upper,if levelC.lowerClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open,if levelC.upperClosed then BaseClasses.BoundaryType.Closed else BaseClasses.BoundaryType.Open);
    configurationValid=intervalsValid and nested;
    invalidReason=if not intervalsValid then BaseClasses.InvalidReason.CriterionConfiguration else if not nested and dynamic then BaseClasses.InvalidReason.DynamicGradeNesting else if not nested then BaseClasses.InvalidReason.GradeNesting else BaseClasses.InvalidReason.None;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,76},{100,-76}}, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid), Line(points={{-72,42},{72,42}}, color={155,75,20}), Line(points={{-50,4},{50,4}}, color={155,75,20}), Line(points={{-24,-34},{24,-34}}, color={155,75,20}), Text(extent={{-92,100},{92,78}}, textString="%name", textColor={80,65,55})}));
  end NestingCheck;
end Criteria;