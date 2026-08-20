within SafetyAssessmentLibrary.Examples.Systems;
model FaultedSystem "Faulted behavioral asset M_F=M+F"
  extends CubeSatSystem(redeclare ScheduledFault fault);
  annotation(Icon(graphics={Text(extent={{-70,70},{70,42}}, textString="FAULTED", textColor={180,40,40})}), Documentation(info="<html><p>Faulted M_F reuses every CubeSatSystem equation and redeclares only ScheduledFault. This is the executable M_F=M+F relation used by the Scenario.</p></html>"));
end FaultedSystem;