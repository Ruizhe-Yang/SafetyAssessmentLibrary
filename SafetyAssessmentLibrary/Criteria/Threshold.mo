within SafetyAssessmentLibrary.Criteria;
block Threshold "Three nested one-sided thresholds"
  parameter Real limit[3]={1,2,3};
  parameter Boolean upper=true;
  parameter BaseClasses.BoundaryType boundary[3]=fill(BaseClasses.BoundaryType.Closed,3);
  Modelica.Blocks.Interfaces.RealInput indicator annotation(Placement(transformation(extent={{-220,-10},{-200,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  BaseClasses.CriteriaResultOutput criteria annotation(Placement(transformation(extent={{200,-10},{220,10}}), iconTransformation(extent={{90,-10},{110,10}})));
protected
  GradedCriteria graded(lower=if upper then fill(-Modelica.Constants.inf,3) else limit,upper=if upper then limit else fill(Modelica.Constants.inf,3),lowerBoundary=if upper then fill(BaseClasses.BoundaryType.Open,3) else boundary,upperBoundary=if upper then boundary else fill(BaseClasses.BoundaryType.Open,3)) annotation(Placement(transformation(extent={{-60,-40},{20,40}})));
equation
  connect(indicator,graded.indicator) annotation(Line(points={{-210,0},{-60,0}}, color={0,0,127}));
  connect(graded.criteria,criteria) annotation(Line(points={{20,0},{210,0}}, color={190,105,35}, thickness=0.5));
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,80},{100,-80}}, radius=8, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid), Line(points={{-70,-36},{20,-36},{20,42},{70,42}}, color={155,75,20}), Text(extent={{-94,106},{94,84}}, textString="%name", textColor={80,65,55})}), Diagram(coordinateSystem(extent={{-200,-100},{200,100}})), Documentation(info="<html><p>Convenience C block for three nested upper or lower limits, delegating endpoint and nesting checks to GradedCriteria.</p></html>"));
end Threshold;