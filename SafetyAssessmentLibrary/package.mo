package SafetyAssessmentLibrary
  "Executable safety evidence generation for NISSA scenarios"
  extends Modelica.Icons.Package;

  annotation(
    version="2.1.0",
    versionDate="2026-08-20",
    uses(Modelica(version="4.0.0")),
    preferredView="info",
    Documentation(info="<html>
<p><b>SafetyAssessmentLibrary</b> implements reusable, input-only Safety Assessment Assets
for finite-horizon, simulation-observable, trajectory-based NISSA objectives.</p>
<p>The unique public workflow is scenario-bound trajectories -&gt; Preprocessing (P) -&gt;
Criteria (C); Criteria plus TimeWindow (W) -&gt; Evaluation (E) -&gt; SafetyResult (Q).</p>
<p>Legal objectives with insufficient active-window or reference evidence end
<b>Unresolved</b>; illegal objective definitions are <b>Invalid</b>; observed critical
behavior remains a resolved grade D result.</p>
<p>Three nested acceptable envelopes I_A subset I_B subset I_C produce A/B/C; failure of C
produces critical Grade D. State, Verdict, Grade, and Top Event remain independent.</p>
<p>A Scenario owns M/M_F and explicit observation bindings. Assessments neither instantiate
the assessed system nor feed forces, flows, heat, power, or control commands back to it.</p>
<p>Runtime dependency: Modelica Standard Library 4.0.0 only.</p>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={70,105,130}, fillColor={236,242,246}, fillPattern=FillPattern.Solid), Text(extent={{-84,44},{84,4}}, textString="SA", textColor={70,105,130}, textStyle={TextStyle.Bold}), Text(extent={{-90,-12},{90,-46}}, textString="NISSA Assets", textColor={70,80,90})}));
end SafetyAssessmentLibrary;