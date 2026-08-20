within SafetyAssessmentLibrary.Results;
block ConsoleReporter "Read-only terminal report"
  parameter Boolean enabled=true;
  parameter String objectiveId="A_UNDEFINED";
  parameter String description="Independent safety assessment";
  parameter BaseClasses.ReferenceMode referenceMode=BaseClasses.ReferenceMode.None;
  BaseClasses.AssessmentResultInput result annotation(Placement(transformation(extent={{-120,-20},{-100,20}}),iconTransformation(extent={{-110,-10},{-90,10}})));
algorithm
  when terminal() then
    if enabled then
      Modelica.Utilities.Streams.print("=================================================");
      Modelica.Utilities.Streams.print("Safety Assessment Result");
      Modelica.Utilities.Streams.print("ID            : "+objectiveId);
      Modelica.Utilities.Streams.print("Description   : "+description);
      Modelica.Utilities.Streams.print("State         : "+Internal.Utilities.stateString(result.state));
      Modelica.Utilities.Streams.print("Verdict       : "+Internal.Utilities.verdictString(result.verdict));
      Modelica.Utilities.Streams.print("Reason        : "+Internal.Utilities.invalidReasonString(result.invalidReason));
      if result.state==BaseClasses.AssessmentState.Resolved then
        Modelica.Utilities.Streams.print("Grade         : "+Internal.Utilities.gradeString(result.grade));
        Modelica.Utilities.Streams.print("Top Event     : "+String(result.topEvent));
        Modelica.Utilities.Streams.print("Coverage      : "+String(result.dataCoverage));
        Modelica.Utilities.Streams.print("Worst Value   : "+String(result.worstValue));
        Modelica.Utilities.Streams.print("Minimum Margin: "+String(result.minimumMargin));
        Modelica.Utilities.Streams.print("First Violate : "+String(result.firstViolationTime)+" s");
        Modelica.Utilities.Streams.print("First Recovery: "+String(result.firstRecoveryTime)+" s");
        Modelica.Utilities.Streams.print("Recovery Dur. : "+String(result.recoveryDuration)+" s");
        Modelica.Utilities.Streams.print("Violation Dur.: "+String(result.violationDuration)+" s");
      end if;
      Modelica.Utilities.Streams.print("Reference     : "+String(referenceMode));
      Modelica.Utilities.Streams.print("=================================================");
    end if;
  end when;
  annotation(defaultComponentName="reporter",Icon(coordinateSystem(extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-100,76},{100,-76}},radius=8,lineColor={160,75,65},fillColor={248,232,228},fillPattern=FillPattern.Solid),Text(extent={{-82,38},{82,-36}},textString="REPORT",textColor={125,55,45},textStyle={TextStyle.Bold}),Text(extent={{-96,102},{96,80}},textString="%name",textColor={90,65,60})}),Documentation(info="<html><p><b>Purpose:</b> print one human-readable terminal summary from the structured Q result.</p><p><b>Side effects:</b> console text only. The reporter has no physical or control output and cannot influence the assessed system.</p><p><b>Limitations:</b> no file export, database, or external runtime dependency.</p></html>"));
end ConsoleReporter;