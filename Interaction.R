###### Interaction Analysis #####

# Load the necessary survival analysis package
library(survival)

# Construct a Cox proportional hazards model including the interaction term
# Here, the interaction between DIGM_Score and Alcohol is included in the model
fit.inter <- coxph(
  Surv(disease_time, disease_status_cox > 0) ~ DIGM_Score * Alcohol + 
    Age +
    Sex + 
    Ethnic + 
    Education + 
    Townsend.deprivation.index.at.recruitment + 
    smoke + 
    PA + 
    Living_alone,
  data = data
)

# Construct a Cox proportional hazards model without the interaction term
# This model includes only the main effects without considering the interaction between DIGM_Score and Alcohol
fit <- coxph(
  Surv(disease_time, disease_status_cox > 0) ~ DIGM_Score + 
    Alcohol +
    Age +
    Sex + 
    Ethnic + 
    Education + 
    Townsend.deprivation.index.at.recruitment + 
    smoke + 
    PA + 
    Living_alone,
  data = data
)

# Perform a Likelihood Ratio Test to compare the two models
# This test evaluates whether adding the interaction term significantly improves the model fit
lmtest::lrtest(fit.inter, fit)