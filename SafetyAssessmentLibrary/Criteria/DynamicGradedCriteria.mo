within SafetyAssessmentLibrary.Criteria;
block DynamicGradedCriteria "Time-varying nested A/B/C envelopes"
  parameter BaseClasses.BoundaryType lowerBoundary[3]=fill(BaseClasses.BoundaryType.Closed,3);
  parameter BaseClasses.BoundaryType upperBoundary[3]=fill(BaseClasses.BoundaryType.Closed,3);
  Modelica.Blocks.Interfaces.RealInput value annotation(Placement(transformation(extent={{-220,90},{-200,110}}), iconTransformation(extent={{-110,60},{-90,80}})));
  Modelica.Blocks.Interfaces.RealInput lowerA annotation(Placement(transformation(extent={{-220,50},{-200,70}}), iconTransformation(extent={{-110,35},{-90,55}})));
  Modelica.Blocks.Interfaces.RealInput upperA annotation(Placement(transformation(extent={{-220,20},{-200,40}}), iconTransformation(extent={{-110,15},{-90,35}})));
  Modelica.Blocks.Interfaces.RealInput lowerB annotation(Placement(transformation(extent={{-220,-10},{-200,10}}), iconTransformation(extent={{-110,-5},{-90,15}})));
  Modelica.Blocks.Interfaces.RealInput upperB annotation(Placement(transformation(extent={{-220,-40},{-200,-20}}), iconTransformation(extent={{-110,-25},{-90,-5}})));
  Modelica.Blocks.Interfaces.RealInput lowerC annotation(Placement(transformation(extent={{-220,-70},{-200,-50}}), iconTransformation(extent={{-110,-45},{-90,-25}})));
  Modelica.Blocks.Interfaces.RealInput upperC annotation(Placement(transformation(extent={{-220,-100},{-200,-80}}), iconTransformation(extent={{-110,-75},{-90,-55}})));
  BaseClasses.CriteriaResultOutput criteria annotation(Placement(transformation(extent={{200,-10},{220,10}}), iconTransformation(extent={{90,-10},{110,10}})));
protected
  Internal.Criteria.DynamicInterval intervalA(lowerBoundary=lowerBoundary[1],upperBoundary=upperBoundary[1]) annotation(Placement(transformation(extent={{-120,60},{-60,110}})));
  Internal.Criteria.DynamicInterval intervalB(lowerBoundary=lowerBoundary[2],upperBoundary=upperBoundary[2]) annotation(Placement(transformation(extent={{-120,-25},{-60,25}})));
  Internal.Criteria.DynamicInterval intervalC(lowerBoundary=lowerBoundary[3],upperBoundary=upperBoundary[3]) annotation(Placement(transformation(extent={{-120,-110},{-60,-60}})));
  Internal.Criteria.NestingCheck nesting(dynamic=true) annotation(Placement(transformation(extent={{30,-45},{90,45}})));
equation
  connect(value,intervalA.value) annotation(Line(points={{-210,100},{-160,100},{-160,100},{-120,100}}, color={0,0,127}));
  connect(lowerA,intervalA.lower) annotation(Line(points={{-210,60},{-170,60},{-170,85},{-120,85}}, color={0,0,127}));
  connect(upperA,intervalA.upper) annotation(Line(points={{-210,30},{-150,30},{-150,70},{-120,70}}, color={0,0,127}));
  connect(value,intervalB.value) annotation(Line(points={{-210,100},{-180,100},{-180,15},{-120,15}}, color={0,0,127}));
  connect(lowerB,intervalB.lower) annotation(Line(points={{-210,0},{-120,0}}, color={0,0,127}));
  connect(upperB,intervalB.upper) annotation(Line(points={{-210,-30},{-150,-30},{-150,-15},{-120,-15}}, color={0,0,127}));
  connect(value,intervalC.value) annotation(Line(points={{-210,100},{-190,100},{-190,-70},{-120,-70}}, color={0,0,127}));
  connect(lowerC,intervalC.lower) annotation(Line(points={{-210,-60},{-170,-60},{-170,-85},{-120,-85}}, color={0,0,127}));
  connect(upperC,intervalC.upper) annotation(Line(points={{-210,-90},{-120,-90},{-120,-100}}, color={0,0,127}));
  connect(intervalA.level,nesting.levelA) annotation(Line(points={{-60,85},{10,85},{10,27},{30,27}}, color={190,105,35}, thickness=0.5));
  connect(intervalB.level,nesting.levelB) annotation(Line(points={{-60,0},{30,0}}, color={190,105,35}, thickness=0.5));
  connect(intervalC.level,nesting.levelC) annotation(Line(points={{-60,-85},{10,-85},{10,-27},{30,-27}}, color={190,105,35}, thickness=0.5));
  criteria.value=value;
  criteria.inside={intervalA.level.inside,intervalB.level.inside,intervalC.level.inside};
  criteria.margin={intervalA.level.signedMargin,intervalB.level.signedMargin,intervalC.level.signedMargin};
  criteria.configurationValid=nesting.configurationValid;
  criteria.invalidReason=nesting.invalidReason;
  criteria.isDynamic=true;
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,86},{100,-86}}, radius=8, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid), Line(points={{-72,44},{-30,32},{20,48},{72,34}}, color={155,75,20}), Line(points={{-72,4},{-30,-8},{20,8},{72,-6}}, color={155,75,20}), Line(points={{-72,-36},{-30,-48},{20,-32},{72,-46}}, color={155,75,20}), Text(extent={{-94,112},{94,90}}, textString="%name", textColor={80,65,55})}), Diagram(coordinateSystem(extent={{-200,-130},{200,130}})), Documentation(info="<html><p><b>Purpose:</b> correctly judge time-varying A/B/C envelopes.</p><p><b>Validity:</b> each interval is valid and L_C&lt;=L_B&lt;=L_A with U_A&lt;=U_B&lt;=U_C. E latches DynamicGradeNesting only while W is active.</p></html>"));
end DynamicGradedCriteria;