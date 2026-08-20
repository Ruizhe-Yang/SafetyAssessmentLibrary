within SafetyAssessmentLibrary.Criteria;
block BooleanCriterion "Boolean condition as one graded C result"
  parameter Boolean useValidityInput=false;
  Modelica.Blocks.Interfaces.BooleanInput condition annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.BooleanInput validity if useValidityInput annotation(Placement(transformation(extent={{-20,-120},{20,-100}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  BaseClasses.CriteriaResultOutput criteria annotation(Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{90,-10},{110,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput validitySignal;
  Modelica.Blocks.Sources.BooleanConstant defaultValidity(k=true) if not useValidityInput annotation(Placement(transformation(extent={{-30,-70},{-10,-50}})));
equation
  connect(validity,validitySignal) annotation(Line(points={{0,-110},{0,-80}}, color={255,0,255}));
  connect(defaultValidity.y,validitySignal) annotation(Line(points={{-9,-60},{0,-60},{0,-80}}, color={255,0,255}));
  criteria.value=if condition then 1 else 0;
  criteria.inside=fill(validitySignal and condition,3);
  criteria.margin=fill(if condition then 0.5 else -0.5,3);
  criteria.configurationValid=validitySignal;
  criteria.invalidReason=if validitySignal then BaseClasses.InvalidReason.None else BaseClasses.InvalidReason.CriterionConfiguration;
  criteria.isDynamic=true;
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,80},{100,-80}}, radius=8, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid), Text(extent={{-78,34},{78,-30}}, textString="TRUE?", textColor={155,75,20}, textStyle={TextStyle.Bold}), Text(extent={{-94,106},{94,84}}, textString="%name", textColor={80,65,55})}), Documentation(info="<html><p>True maps to all A/B/C memberships and +0.5 margin; false maps to all failures and -0.5. Optional validity is structural.</p></html>"));
end BooleanCriterion;