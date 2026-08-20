within SafetyAssessmentLibrary;
package Internal "Implementation helpers behind public P-C-W-E-Q blocks"
  extends Modelica.Icons.InternalPackage;

  block StableEdge "Stable rising and falling event indicators"
    Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Blocks.Interfaces.BooleanOutput rising annotation(Placement(transformation(extent={{100,30},{120,50}}), iconTransformation(extent={{90,30},{110,50}})));
    Modelica.Blocks.Interfaces.BooleanOutput falling annotation(Placement(transformation(extent={{100,-50},{120,-30}}), iconTransformation(extent={{90,-50},{110,-30}})));
  initial equation
    pre(u)=u;
  equation
    rising=u and not pre(u);
    falling=not u and pre(u);
    annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,72},{100,-72}}, radius=8, lineColor={115,115,115}, fillColor={242,242,242}, fillPattern=FillPattern.Solid), Line(points={{-70,-30},{-20,-30},{-20,30},{65,30}}, color={90,90,90}), Text(extent={{-96,100},{96,76}}, textString="%name", textColor={80,80,80})}),
      Documentation(info="<html><p><b>Purpose:</b> isolate stable Boolean edge detection used by count and recovery statistics.</p><p><b>Meaning:</b> rising=u and not pre(u); falling=not u and pre(u). The initialization equation suppresses a spurious event-iteration edge at time zero.</p><p><b>Limitations:</b> initial true state is handled explicitly by the consuming statistic.</p></html>"));
  end StableEdge;

  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}}, lineColor={115,115,115}, fillColor={242,242,242}, fillPattern=FillPattern.Solid), Text(extent={{-86,24},{86,-24}}, textString="Internal", textColor={80,80,80})}),
    Documentation(info="<html><p>Internal contains Criteria, Evaluation, Results, utility, and event helpers opened only when inspecting a public white-box component.</p></html>"));
end Internal;