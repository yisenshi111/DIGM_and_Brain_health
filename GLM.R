# =========================================
# Generalized Linear Model (GLM) Tutorial
# =========================================

# This script demonstrates how to fit Generalized Linear Models (GLMs)
# for both continuous and binary outcomes using the `glm` function in R.
# It includes detailed comments to aid understanding and best practices
# for model fitting and interpretation.



# -----------------------------
# Data Preparation
# -----------------------------
# Assume 'data' is a dataframe that contains the following columns:
# - outcome: The dependent variable (continuous or binary)
# - exposure: The main independent variable of interest
# - var1, var2: Covariates or additional independent variables

# For demonstration purposes, let's create a sample dataset
set.seed(123)  # For reproducibility
data <- data.frame(
  outcome = rnorm(100, mean = 50, sd = 10),             # Continuous outcome
  exposure = rbinom(100, 1, 0.5),                       # Binary exposure
  var1 = rnorm(100, mean = 5, sd = 2),                  # Continuous covariate
  var2 = sample(letters[1:3], 100, replace = TRUE)      # Categorical covariate
)

# Convert var2 to a factor if it's categorical
data$var2 <- as.factor(data$var2)

# -----------------------------
# GLM for Continuous Outcome
# -----------------------------
# Use Gaussian family for continuous outcomes

# Fit the GLM
glm_continuous <- glm(
  outcome ~ exposure + var1 + var2,  # Model formula
  data = data,                        # Dataset
  family = gaussian()                 # Gaussian family for continuous outcomes
)

# Display the summary of the model
summary(glm_continuous)

# Extract and display the coefficients
coefficients_continuous <- coef(glm_continuous)
print("Model Coefficients (Continuous Outcome):")
print(coefficients_continuous)

# Calculate and display the 95% confidence intervals for the coefficients
confint_continuous <- confint(glm_continuous)
print("95% Confidence Intervals (Continuous Outcome):")
print(confint_continuous)

# -----------------------------
# GLM for Binary Outcome
# -----------------------------
# For binary outcomes, use the Binomial family with a logit link

# First, ensure that the outcome is binary
# Here, we'll create a binary outcome for demonstration
data$binary_outcome <- ifelse(data$outcome > 50, 1, 0)

# Fit the GLM
glm_binary <- glm(
  binary_outcome ~ exposure + var1 + var2,  # Model formula
  data = data,                               # Dataset
  family = binomial(link = "logit")          # Binomial family with logit link
)

# Display the summary of the model
summary(glm_binary)

# Extract and display the coefficients
coefficients_binary <- coef(glm_binary)
print("Model Coefficients (Binary Outcome):")
print(coefficients_binary)

# Exponentiate the coefficients to obtain Odds Ratios
odds_ratios <- exp(coefficients_binary)
print("Odds Ratios (Binary Outcome):")
print(odds_ratios)

# Calculate and display the 95% confidence intervals for the coefficients
confint_binary <- confint(glm_binary)
odds_ratios_confint <- exp(confint_binary)
print("95% Confidence Intervals for Odds Ratios (Binary Outcome):")
print(odds_ratios_confint)