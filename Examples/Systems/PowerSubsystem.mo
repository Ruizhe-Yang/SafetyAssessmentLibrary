within SafetyAssessmentLibrary.Examples.Systems;
model PowerSubsystem "Alternative hierarchy containing the storage observation"
  StorageUnit storage annotation(Placement(transformation(extent={{-40,-40},{40,40}})));
  annotation(Icon(graphics={Rectangle(extent={{-100,70},{100,-70}}, lineColor={80,100,130}), Text(extent={{-80,28},{80,-24}}, textString="POWER", textColor={80,100,130})}), Documentation(info="<html><p>Intermediate hierarchy for ReboundSystem.power.storage.SOC.</p></html>"));
end PowerSubsystem;
