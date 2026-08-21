within SafetyAssessmentLibrary.Tests;
package ArchitectureTests "Executable architecture demonstrations"
  extends Modelica.Icons.ExamplesPackage;
  model MainScenario
    extends Examples.Scenarios.S_MultiObjectiveAssessment;
  equation when terminal() then assert(A1.result.state==BaseClasses.AssessmentState.Resolved and A2.result.state==BaseClasses.AssessmentState.Resolved and A3.result.state==BaseClasses.AssessmentState.Resolved,"Main Scenario did not resolve all A assets"); assert(A1.result.grade==BaseClasses.SafetyGrade.B and A2.result.grade==BaseClasses.SafetyGrade.C and A3.result.grade==BaseClasses.SafetyGrade.D and A3.result.topEvent,"Main Scenario B/C/D engineering result changed"); end when;
    annotation(experiment(StopTime=200,Interval=0.1));
  end MainScenario;
  model AdvancedScenario
    extends Examples.Scenarios.S_AdvancedAssessmentExamples;
  equation when terminal() then assert(A4.result.state==BaseClasses.AssessmentState.Resolved and A5.result.state==BaseClasses.AssessmentState.Resolved and A6.result.state==BaseClasses.AssessmentState.Resolved and A7.result.state==BaseClasses.AssessmentState.Resolved and A8.result.state==BaseClasses.AssessmentState.Resolved,"Advanced Scenario did not resolve all A assets"); assert(A4.result.grade==BaseClasses.SafetyGrade.C and A5.result.grade==BaseClasses.SafetyGrade.D and A6.result.grade==BaseClasses.SafetyGrade.B and A7.result.grade==BaseClasses.SafetyGrade.C and A8.result.grade==BaseClasses.SafetyGrade.A and A8.result.topEvent,"Advanced Scenario C/D/B/C/A engineering result changed"); end when;
    annotation(experiment(StopTime=30,Interval=0.05));
  end AdvancedScenario;
  model UnifiedOverview
    extends Examples.A1_A8_Overview;
  equation
    when terminal() then
      assert(A1.result.state==BaseClasses.AssessmentState.Resolved and A2.result.state==BaseClasses.AssessmentState.Resolved and A3.result.state==BaseClasses.AssessmentState.Resolved and A4.result.state==BaseClasses.AssessmentState.Resolved and A5.result.state==BaseClasses.AssessmentState.Resolved and A6.result.state==BaseClasses.AssessmentState.Resolved and A7.result.state==BaseClasses.AssessmentState.Resolved and A8.result.state==BaseClasses.AssessmentState.Resolved,"Unified A1-A8 Overview did not resolve every safety asset");
      assert(A1.result.grade==BaseClasses.SafetyGrade.B and A2.result.grade==BaseClasses.SafetyGrade.C and A3.result.grade==BaseClasses.SafetyGrade.D and A4.result.grade==BaseClasses.SafetyGrade.C and A5.result.grade==BaseClasses.SafetyGrade.D and A6.result.grade==BaseClasses.SafetyGrade.B and A7.result.grade==BaseClasses.SafetyGrade.C and A8.result.grade==BaseClasses.SafetyGrade.A,"Unified A1-A8 Overview changed an established grade");
      assert(A3.result.topEvent and A5.result.topEvent and A8.result.topEvent,"Unified A1-A8 Overview changed an established Boolean result");
    end when;
    annotation(experiment(StopTime=200,Interval=0.1));
  end UnifiedOverview;
end ArchitectureTests;
