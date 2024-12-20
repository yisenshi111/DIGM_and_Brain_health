# =========================================
# Cox Proportional Hazards Model Tutorial
# =========================================

# This script demonstrates how to perform survival analysis using the
# Cox Proportional Hazards (`coxph`) model in R. It includes detailed
# comments to aid understanding and best practices for model fitting,
# interpretation, and diagnostics.

# -----------------------------
# Load Necessary Libraries
# -----------------------------
# The `survival` package is essential for survival analysis in R.
# Install it if not already installed.

if (!require("survival")) {
  install.packages("survival")
}
library(survival)

# -----------------------------
# Data Preparation
# -----------------------------
# Assume 'data' is a dataframe that contains the following columns:
# - time: Follow-up time until the event or censoring
# - status: Event indicator (typically 1 for event occurred, 0 for censored)
# - exposure: The main independent variable of interest
# - var1, var2: Covariates or additional independent variables

# For demonstration purposes, let's create a sample dataset
set.seed(123)  # For reproducibility

# Number of observations
n <- 200

# Simulate follow-up times using an exponential distribution
data <- data.frame(
  time = rexp(n, rate = 0.1),  # Follow-up time
  status = sample(0:1, n, replace = TRUE, prob = c(0.3, 0.7)),  # Event indicator
  exposure = rbinom(n, 1, 0.5),  # Binary exposure variable
  var1 = rnorm(n, mean = 50, sd = 10),  # Continuous covariate
  var2 = sample(c("Low", "Medium", "High"), n, replace = TRUE)  # Categorical covariate
)

# Convert var2 to a factor since it's categorical
data$var2 <- as.factor(data$var2)

# Inspect the first few rows of the dataset
head(data)




# -----------------------------
# Cox Proportional Hazards Model
# -----------------------------
# The Cox model assesses the effect of covariates on the hazard rate.

# Fit the Cox Proportional Hazards model
cox_model <- coxph(
  Surv(time, status) ~ exposure + var1 + var2,  # Model formula
  data = data,                                   # Dataset
)

# Display the summary of the Cox model
summary(cox_model)

# -----------------------------
# Interpretation of Results
# -----------------------------
# The summary provides the following key components:
# - Coefficients: Log hazard ratios for each predictor
# - exp(coef): Hazard ratios (HR) which are easier to interpret
# - p-values: Significance of each predictor
# - Confidence intervals: Range within which the true HR lies with 95% confidence

# Extract and display the coefficients and hazard ratios
coefficients <- coef(cox_model)
hazard_ratios <- exp(coefficients)

# Create a table of results
results <- data.frame(
  Coefficient = coefficients,
  Hazard_Ratio = hazard_ratios,
  `p-value` = summary(cox_model)$coefficients[, "Pr(>|z|)"],
  `CI Lower` = exp(confint(cox_model)[, 1]),
  `CI Upper` = exp(confint(cox_model)[, 2])
)

print("Cox Proportional Hazards Model Results:")
print(round(results, 3))

# -----------------------------
# Proportional Hazards Assumption
# -----------------------------
# The Cox model assumes that the hazard ratios are constant over time.
# We can test this assumption using the `cox.zph` function.

# Test proportional hazards assumption
ph_test <- cox.zph(cox_model)

# Display the test results
print("Proportional Hazards Assumption Test:")
print(ph_test)
