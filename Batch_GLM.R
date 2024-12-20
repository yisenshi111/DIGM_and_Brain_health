##### Batch GLM Models #####

# Extract the names of variables from the data frame `df`, starting from the second column up to the nth column
avars <- names(df[, 2:n])

# Initialize an empty object to store the results of each GLM
Result <- c()

# Loop through each variable in `avars` to perform individual GLM analyses
for (i in 1:length(avars)) {
  
  # Dynamically create the formula for the GLM
  # The response variable is the current variable in `avars`
  # The predictors include "DIGM", "Age", "Sex", "Ethnic", "TDI", "Smoking", "Alcohol", "PA", "Education", and "Living_alone"
  formula <- substitute(
    x ~ DIGM + Age + Sex + Ethnic + TDI + Smoking + Alcohol + PA + Education + Living_alone,
    list(x = as.name(avars[i]))
  )
  
  # Fit the GLM using the Gaussian family (i.e., linear regression)
  fit <- glm(formula, data = df, family = gaussian())
  
  # Obtain a summary of the fitted GLM
  fitSum <- summary(fit)
  
  # Initialize an empty object to store coefficients and related statistics
  result1 <- c()
  
  # Extract the coefficients table from the summary and bind it to `result1`
  result1 <- rbind(result1, fitSum$coef)
  
  # Extract the estimated coefficients (beta values) from the summary
  beta <- fitSum$coef[, 'Estimate']
  
  # Combine the coefficients table with the beta estimates and their confidence intervals
  # `confint(fit)` computes the confidence intervals for the model parameters
  result1 <- data.frame(cbind(result1, cbind(beta, confint(fit))))
  
  # Add a new column "Characteristics" to `result1` with the name of the current variable
  result1$Characteristics <- avars[i]   # Add variable name
  
  # Append the results to the `Result` object, excluding the intercept (constant term)
  # `result1[-1, ]` removes the first row, which typically corresponds to the intercept
  Result <- rbind(Result, result1[-1, ])  # Remove the intercept
}

# Identify rows in `Result` that correspond to control variables to be excluded
# `grep` searches for patterns matching control variable names in the row names of `result_log`
# Note: It seems there might be a typo here. Assuming `result_log` should be `Result`
drop_columns <- grep("Age|SexMale|Ethnic.White|TDI|Smoking|Alcohol|PD|Education|Living_alone", 
                     rownames(Result), value = FALSE)

# Create a new data frame `selected_rows.Result` by excluding the identified control variable rows
selected_rows.Result <- Result[-drop_columns, ]

# Optional: View the final selected results
# print(selected_rows.Result)
