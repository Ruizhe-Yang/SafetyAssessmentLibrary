within SafetyAssessmentLibrary.Tests;
package OptionalConnectorTests "Enabled/disabled structural connector regressions"
  extends Modelica.Icons.ExamplesPackage;

  model ReferenceDisabled
    Preprocessing.ReferenceSelector selector(useReference=false);
    Modelica.Blocks.Sources.Constant observation(k=2);
  equation connect(observation.y,selector.observation);
    when terminal() then assert(abs(selector.y-2)<1e-9,"Disabled reference connector failed"); end when;
    annotation(experiment(StopTime=0.1));
  end ReferenceDisabled;

  model ReferenceEnabled
    Preprocessing.ReferenceSelector selector(useReference=true);
    Modelica.Blocks.Sources.Constant observation(k=2),reference(k=3);
  equation connect(observation.y,selector.observation); connect(reference.y,selector.reference);
    when terminal() then assert(abs(selector.y-3)<1e-9,"Enabled reference connector failed"); end when;
    annotation(experiment(StopTime=0.1));
  end ReferenceEnabled;

  model IntegralDefaults
    Preprocessing.Integral integral(useEnableInput=false,useResetInput=false);
    Modelica.Blocks.Sources.Constant u(k=1);
  equation connect(u.y,integral.u);
    when terminal() then assert(abs(integral.y-2)<0.01,"Integral disabled optional inputs failed"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end IntegralDefaults;

  model IntegralEnableReset
    Preprocessing.Integral integral(useEnableInput=true,useResetInput=true);
    Modelica.Blocks.Sources.Constant u(k=1);
    Modelica.Blocks.Sources.BooleanExpression enable(y=time>=0.5),reset(y=time>=1 and time<1.01);
  equation connect(u.y,integral.u); connect(enable.y,integral.enable); connect(reset.y,integral.reset);
    when terminal() then assert(abs(integral.y-1)<0.02,"Integral enabled optional inputs/reset failed"); end when;
    annotation(experiment(StopTime=2,Interval=0.01));
  end IntegralEnableReset;

  model CriterionValidityDisabled
    Criteria.BooleanCriterion c(useValidityInput=false);
    Modelica.Blocks.Sources.BooleanConstant condition(k=true);
  equation connect(condition.y,c.condition);
    when terminal() then assert(c.criteria.configurationValid and c.criteria.inside[1],"Disabled validity connector failed"); end when;
    annotation(experiment(StopTime=0.1));
  end CriterionValidityDisabled;

  model CriterionValidityEnabled
    Criteria.BooleanCriterion c(useValidityInput=true);
    Modelica.Blocks.Sources.BooleanConstant condition(k=true),validity(k=false);
  equation connect(condition.y,c.condition); connect(validity.y,c.validity);
    when terminal() then assert(not c.criteria.configurationValid and c.criteria.invalidReason==BaseClasses.InvalidReason.CriterionConfiguration,"Enabled validity connector failed"); end when;
    annotation(experiment(StopTime=0.1));
  end CriterionValidityEnabled;
end OptionalConnectorTests;