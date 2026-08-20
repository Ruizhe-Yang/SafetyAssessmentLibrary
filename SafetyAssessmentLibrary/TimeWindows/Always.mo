within SafetyAssessmentLibrary.TimeWindows;
block Always "Whole simulation domain"
  extends BaseClasses.PartialTimeWindow;
equation
  window.active=true;
  window.configurationValid=true;
  window.invalidReason=BaseClasses.InvalidReason.None;
  annotation(Icon(graphics={Text(extent={{-70,54},{70,28}}, textString="ALL", textColor={90,70,140})}), Documentation(info="<html><p>Returns a valid WindowState with active=true for the complete simulation.</p></html>"));
end Always;