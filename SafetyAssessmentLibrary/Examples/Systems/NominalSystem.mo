within SafetyAssessmentLibrary.Examples.Systems;
model NominalSystem "Nominal behavioral asset M"
  extends CubeSatSystem(redeclare NoFault fault);
  annotation(Icon(graphics={Text(extent={{-70,70},{70,42}}, textString="NOMINAL", textColor={30,120,70})}), Documentation(info="<html><p>Nominal M obtained from CubeSatSystem by retaining the zero fault behavior.</p></html>"));
end NominalSystem;
