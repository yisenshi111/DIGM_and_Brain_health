#### Batch Cox Regression #####

# Load the ezcox package, which is used for performing Cox regression analyses
library(ezcox)

# Extract the column names from the data frame `df`, starting from the second column up to the nth column
# These columns are considered as covariates for the Cox regression
column_names <- colnames(df[, 2:n])

# Perform Cox regression using the ezcox function
# - df: The input data frame containing the data
# - covariates: The main variables of interest included in the model
# - controls: Control variables used to adjust for potential confounding factors
# - time: The variable representing survival time
# - status: The variable indicating the event status (e.g., event occurred or censored)
res <- ezcox(
  df,
  covariates = c(column_names),
  controls = c("DIGM", "Age", "Sex", "Ethnic", "TDI", "Smoking", "Alcohol", "PA", "Education", "Living_alone"),
  time = "disease_time_cox",
  status = "disease_status_cox"
)

# Create a logical vector `a` to identify specific levels of the `contrast_level` variable
# This includes levels like "Age", "Male", "White", etc.
a <- res$contrast_level == "Age" |
  res$contrast_level == "Male" |
  res$contrast_level == "White" |
  res$contrast_level == "TDI" |
  res$contrast_level == "Never" |
  res$contrast_level == "Previous" |
  res$contrast_level == "Yes" |
  res$contrast_level == "lower_secondary" |
  res$contrast_level == "Other" |
  res$contrast_level == "upper_secondary" |
  res$contrast_level == "DIGM"

# Filter out the rows in `res` where the `contrast_level` matches any of the specified levels in `a`
# The resulting data frame `res.new` contains only the rows that do not meet these conditions
res.new <- res %>% filter(!a)

# Optional: View the filtered results
# print(res.new)
