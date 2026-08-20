within SafetyAssessmentLibrary.Criteria;
block GradedCriteria "Static nested A/B/C envelopes"
  parameter Real lower[3]={-1,-2,-3};
  parameter Real upper[3]={1,2,3};
  parameter BaseClasses.BoundaryType lowerBoundary[3]=fill(BaseClasses.BoundaryType.Closed,3);
  parameter BaseClasses.BoundaryType upperBoundary[3]=fill(BaseClasses.BoundaryType.Closed,3);
  Modelica.Blocks.Interfaces.RealInput indicator annotation(Placement(transformation(extent={{-220,-10},{-200,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  BaseClasses.CriteriaResultOutput criteria annotation(Placement(transformation(extent={{200,-10},{220,10}}), iconTransformation(extent={{90,-10},{110,10}})));
protected
  Internal.Criteria.GradeInterval intervalA(lower=lower[1],upper=upper[1],lowerBoundary=lowerBoundary[1],upperBoundary=upperBoundary[1]) annotation(Placement(transformation(extent={{-130,70},{-70,110}})));
  Internal.Criteria.GradeInterval intervalB(lower=lower[2],upper=upper[2],lowerBoundary=lowerBoundary[2],upperBoundary=upperBoundary[2]) annotation(Placement(transformation(extent={{-130,-20},{-70,20}})));
  Internal.Criteria.GradeInterval intervalC(lower=lower[3],upper=upper[3],lowerBoundary=lowerBoundary[3],upperBoundary=upperBoundary[3]) annotation(Placement(transformation(extent={{-130,-110},{-70,-70}})));
  Internal.Criteria.NestingCheck nesting annotation(Placement(transformation(extent={{30,-45},{90,45}})));
equation
  connect(indicator,intervalA.indicator) annotation(Line(points={{-210,0},{-170,0},{-170,90},{-130,90}}, color={0,0,127}));
  connect(indicator,intervalB.indicator) annotation(Line(points={{-210,0},{-130,0}}, color={0,0,127}));
  connect(indicator,intervalC.indicator) annotation(Line(points={{-210,0},{-170,0},{-170,-90},{-130,-90}}, color={0,0,127}));
  connect(intervalA.level,nesting.levelA) annotation(Line(points={{-70,90},{10,90},{10,27},{30,27}}, color={190,105,35}, thickness=0.5));
  connect(intervalB.level,nesting.levelB) annotation(Line(points={{-70,0},{30,0}}, color={190,105,35}, thickness=0.5));
  connect(intervalC.level,nesting.levelC) annotation(Line(points={{-70,-90},{10,-90},{10,-27},{30,-27}}, color={190,105,35}, thickness=0.5));
  criteria.value=indicator;
  criteria.inside={intervalA.level.inside,intervalB.level.inside,intervalC.level.inside};
  criteria.margin={intervalA.level.signedMargin,intervalB.level.signedMargin,intervalC.level.signedMargin};
  criteria.configurationValid=nesting.configurationValid;
  criteria.invalidReason=nesting.invalidReason;
  criteria.isDynamic=false;
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,82},{100,-82}}, radius=8, lineColor={190,105,35}, fillColor={252,239,224}, fillPattern=FillPattern.Solid), Line(points={{-72,42},{72,42}}, color={155,75,20}), Line(points={{-52,4},{52,4}}, color={155,75,20}), Line(points={{-28,-34},{28,-34}}, color={155,75,20}), Text(extent={{-94,108},{94,86}}, textString="%name", textColor={80,65,55})}), Diagram(coordinateSystem(extent={{-200,-130},{200,130}})), Documentation(info="<html><p><b>Purpose:</b> canonical public C for static scalar objectives.</p><p><b>Input:</b> indicator. <b>Output:</b> one CriteriaResult.</p><p><b>Mathematics:</b> three endpoint-aware intervals and NestingCheck enforce I_A subset I_B subset I_C. Failure of C later maps to Grade D.</p></html>"));
end GradedCriteria;