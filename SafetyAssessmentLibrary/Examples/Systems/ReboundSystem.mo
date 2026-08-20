within SafetyAssessmentLibrary.Examples.Systems;
model ReboundSystem "Second design version with a changed internal observation path"
  PowerSubsystem power annotation(Placement(transformation(extent={{-40,-40},{40,40}})));
  annotation(Icon(graphics={Text(extent={{-82,38},{82,-24}}, textString="M v2", textColor={60,90,130})}), experiment(StopTime=120, Interval=0.1), Documentation(info="<html><p><b>Purpose:</b> change the SOC path from batterySOC to power.storage.SOC while preserving Real type, SOC meaning, and assessment thresholds.</p><p><b>Reuse:</b> only the Scenario binding changes; A1_SOCSafety remains unchanged.</p></html>"));
end ReboundSystem;