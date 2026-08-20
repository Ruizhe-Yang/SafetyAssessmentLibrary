within SafetyAssessmentLibrary.Examples.Systems;
model NoFault "Nominal zero fault behavior"
  extends PartialFaultBehavior;
equation
  active=false;
  voltageDrop=0;
  dischargeMultiplier=0;
  heatAddition=0;
  rateDisturbance=0;
  annotation(Documentation(info="<html><p>Zero fault contribution used by the nominal behavioral model M.</p></html>"));
end NoFault;