within SafetyAssessmentLibrary.Examples.Systems;
model StorageUnit "Alternative nested storage path for rebinding demonstration"
  Real SOC(start=0.78, fixed=true) "Same observation semantics under a different internal path";
equation
  der(SOC)=-0.00105*(0.72 + (if time >= 40 then 0.32 else 0));
  annotation(Documentation(info="<html><p>Nested storage state used only to demonstrate path rebinding without changing A1_SOCSafety.</p></html>"));
end StorageUnit;