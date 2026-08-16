within SafetyAssessmentLibrary;
package Results "Compact result endpoints and terminal reporting"
  extends Modelica.Icons.Package;

  block AssessmentResult "Terminate an assessment pipeline with one compact public record"
    parameter String objectiveId="A_UNDEFINED";
    parameter String description="Independent safety assessment";
    parameter Types.ObservationClass observationClass=Types.ObservationClass.Physical;
    parameter String observationId="";
    parameter String observationDescription="";
    parameter Types.ReferenceMode referenceMode=Types.ReferenceMode.None;
    parameter Types.SafetyGrade topEventThreshold=Types.SafetyGrade.D;
    parameter Boolean printResult=true "Print one report at terminal()";
    Interfaces.AssessmentEvidenceInput evidence "Evidence from one Evaluation block"
      annotation(Placement(transformation(extent={{-120,-10},{-100,10}})));
    Types.AssessmentResult result "The only normal user-facing simulation result";
  protected
    final parameter Integer criticalIndex=Utilities.gradeEvidenceIndex(topEventThreshold);
    Types.AssessmentState state annotation(HideResult=true);
    Types.SafetyGrade grade annotation(HideResult=true);
    Boolean topEvent annotation(HideResult=true);
    Integer displayCode annotation(HideResult=true);
    Boolean outerViolation annotation(HideResult=true);
  equation
    state=if not evidence.configurationValid then Types.AssessmentState.Invalid
      elseif evidence.evaluated and not evidence.evidenceAvailableAtEvaluation then Types.AssessmentState.Unresolved
      elseif evidence.evaluated then Types.AssessmentState.Resolved
      elseif evidence.active then Types.AssessmentState.Monitoring else Types.AssessmentState.Inactive;
    grade=Utilities.gradeFromPass(evidence.pass);
    topEvent=state == Types.AssessmentState.Resolved and Utilities.gradeAtLeast(grade,topEventThreshold);
    displayCode=if state == Types.AssessmentState.Invalid then -1
      elseif state == Types.AssessmentState.Resolved then Utilities.gradeDisplayCode(grade) else 0;
    outerViolation=evidence.everOuterViolation or
      (state == Types.AssessmentState.Resolved and not evidence.pass[4]);

    result.state=state;
    result.grade=grade;
    result.topEvent=topEvent;
    result.displayCode=displayCode;
    result.sampledMinimumCriticalMargin=evidence.sampledMinimumMargin[criticalIndex];
    result.sampledWorstValue=evidence.sampledWorstValue;
    result.firstCriticalTime=evidence.firstOutsideTime[criticalIndex];
    result.criticalDuration=evidence.outsideDuration[criticalIndex];
    result.longestCriticalDuration=evidence.longestOutsideDuration[criticalIndex];
    result.outerViolation=outerViolation;
  algorithm
    when terminal() then
      if printResult then
        Modelica.Utilities.Streams.print("=================================================");
        Modelica.Utilities.Streams.print("Safety Assessment Result");
        Modelica.Utilities.Streams.print("ID            : " + objectiveId);
        Modelica.Utilities.Streams.print("Description   : " + description);
        Modelica.Utilities.Streams.print("Observation   : " + String(observationClass));
        Modelica.Utilities.Streams.print("ObservationID : " + observationId);
        if observationDescription <> "" then
          Modelica.Utilities.Streams.print("Observed as   : " + observationDescription);
        end if;
        Modelica.Utilities.Streams.print("");
        Modelica.Utilities.Streams.print("State         : " + Utilities.stateString(result.state));
        if result.state == Types.AssessmentState.Invalid then
          if evidence.invalidCode == 1 then
            Modelica.Utilities.Streams.print("Reason        : Grade A interval is not contained in Grade B.");
          elseif evidence.invalidCode == 2 then
            Modelica.Utilities.Streams.print("Reason        : Grade B interval is not contained in Grade C.");
          elseif evidence.invalidCode == 3 then
            Modelica.Utilities.Streams.print("Reason        : Grade C interval is not contained in Grade D.");
          elseif evidence.invalidCode == 4 then
            Modelica.Utilities.Streams.print("Reason        : One or more grade intervals are empty or reversed.");
          elseif evidence.invalidCode == 5 then
            Modelica.Utilities.Streams.print("Reason        : Time-window configuration is invalid.");
          elseif evidence.invalidCode == 6 then
            Modelica.Utilities.Streams.print("Reason        : Evaluation parameters are invalid.");
          elseif evidence.invalidCode == 7 then
            Modelica.Utilities.Streams.print("Reason        : Frozen A/B/C/D pass results are not monotone.");
          else
            Modelica.Utilities.Streams.print("Reason        : Assessment configuration is invalid.");
          end if;
        elseif result.state == Types.AssessmentState.Unresolved then
          Modelica.Utilities.Streams.print("Reason        : Insufficient active-window or observation/reference evidence.");
        elseif result.state == Types.AssessmentState.Resolved then
          Modelica.Utilities.Streams.print("Grade         : " + Utilities.gradeString(result.grade));
          Modelica.Utilities.Streams.print("Top Event     : " + String(result.topEvent));
          Modelica.Utilities.Streams.print("");
          Modelica.Utilities.Streams.print("Worst Value (sampled) : " + String(result.sampledWorstValue));
          Modelica.Utilities.Streams.print("Min Critical Margin   : " + String(result.sampledMinimumCriticalMargin));
          Modelica.Utilities.Streams.print("First Critical Time   : " + String(result.firstCriticalTime) + " s");
          Modelica.Utilities.Streams.print("Critical Duration     : " + String(result.criticalDuration) + " s");
          Modelica.Utilities.Streams.print("Longest Critical Dur. : " + String(result.longestCriticalDuration) + " s");
          Modelica.Utilities.Streams.print("Outer Violation       : " + String(result.outerViolation));
          Modelica.Utilities.Streams.print("");
          Modelica.Utilities.Streams.print("Reference     : " + String(referenceMode));
        end if;
        Modelica.Utilities.Streams.print("Result Code   : " + String(result.displayCode));
        Modelica.Utilities.Streams.print("=================================================");
      end if;
    end when;
    annotation(
      defaultComponentName="resultEndpoint",
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,88},{100,-88}}, radius=14, lineColor={25,90,135},
          fillColor={230,245,250}, fillPattern=FillPattern.Solid),
        Ellipse(extent={{-58,60},{58,-56}}, lineColor={25,90,135},
          fillColor={255,255,255}, fillPattern=FillPattern.Solid),
        Text(extent={{-48,42},{48,4}}, textString="SA", textColor={25,90,135},
          textStyle={TextStyle.Bold}),
        Text(extent={{-76,-18},{76,-50}}, textString="A/B/C/D", textColor={70,70,70}),
        Text(extent={{-96,112},{96,90}}, textString="%name", textColor={70,70,70})}),
      Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
      Documentation(info="<html><p><b>Purpose:</b> end a white-box assessment pipeline and expose one compact Types.AssessmentResult record.</p><p><b>Input:</b> one evidence connection from Evaluation. <b>Output:</b> no connector; inspect the public result record.</p><p><b>Parameters:</b> traceability metadata, reference mode, top-event threshold, and terminal print enable.</p><p><b>Meaning:</b> the strictest passing grade is selected; failure through D saturates at D with outerViolation. Illegal configuration is Invalid. Legal but missing evidence is Unresolved.</p><p><b>Usage:</b> place this as the rightmost endpoint and connect Evaluation.evidence. A concrete A may publish <code>result = resultEndpoint.result</code>.</p><p><b>Limitations:</b> detailed arrays remain inside the evidence connection and are hidden from the normal A result tree.</p></html>"));
  end AssessmentResult;

  annotation(Documentation(info="<html><p>Results turns compact evaluation evidence into the typed lifecycle, A/B/C/D conclusion, FTA-compatible top event, traceable dynamic metrics, and a read-only terminal report.</p></html>"));
end Results;
