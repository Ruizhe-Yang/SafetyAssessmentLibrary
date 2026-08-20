within SafetyAssessmentLibrary.TimeWindows;
block During "Domain supplied by an external mode condition"
  extends BaseClasses.PartialTimeWindow;
  Modelica.Blocks.Interfaces.BooleanInput condition annotation(Placement(transformation(extent={{-120,-20},{-100,20}}), iconTransformation(extent={{-110,-10},{-90,10}})));
equation
  window.active=condition;
  window.configurationValid=true;
  window.invalidReason=BaseClasses.InvalidReason.None;
  annotation(Icon(graphics={Text(extent={{-72,54},{72,28}}, textString="DURING", textColor={90,70,140})}), Documentation(info="<html><p>Forwards a read-only mission mode or external phase condition into WindowState.</p></html>"));
end During;