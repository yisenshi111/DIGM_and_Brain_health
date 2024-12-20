##### Restricted Cubic Spline Example #####

# Load necessary libraries
library(rms)        # Provides advanced regression modeling functions, particularly useful for survival analysis
library(ggplot2)    # A powerful plotting system for creating complex graphics
library(extrafont)  # Manages and uses different fonts, enhancing the readability and aesthetics of plots

# Ensure fonts are imported (uncomment if running for the first time)
# font_import() 

# Load the fonts
loadfonts()

# Set up data distribution descriptions
ddist <- datadist(data)  # Create a data distribution object for the dataset
refvalue <- 0            # Define a reference value
ddist$limits$DIGM_Score[2] <- refvalue  # Set the lower limit of DIGM_Score to the reference value

# Set global options to use the data distribution object
options(datadist = "ddist")

# Define the survival object
# S: Survival time and event status
# bipolar_affective_time_cox: Survival time variable
# bipolar_affective_status_cox == 1: Event status (e.g., event occurred = 1, event not occurred = 0)
S <- Surv(data$disease_time_cox, data$disease_status_cox == 1)

# Build the Cox Proportional Hazards model
# Use restricted cubic splines (rcs) for DIGM_Score with 5 knots to capture non-linear relationships
# Adjust for other covariates such as Age, Sex, Ethnicity, Education level, etc.
fit.LnAl <- cph(
  S ~ rcs(DIGM_Score, 5) + 
    Age + 
    Sex + 
    Ethnic.White + 
    Education_lower_secondary + 
    Education_Other + 
    Education_upper_secondary + 
    Townsend.deprivation.index.at.recruitment + 
    smoke_Current + 
    smoke_Previous + 
    Alcohol_Current + 
    Alcohol_Previous + 
    PA + 
    Living_alone,
  data = data)

# Check the proportional hazards assumption of the model
cox_zph <- cox.zph(fit.LnAl)
print(cox_zph)  # Output the results to check if the proportional hazards assumption holds for each variable

# Perform analysis of variance on the model
anova_fit <- anova(fit.LnAl)
print(anova_fit)  # Output the ANOVA results to help in model selection or comparison

# Predict the Hazard Ratios (HR) for DIGM_Score and calculate 95% confidence intervals
# fun=exp: Exponentiate to obtain HR
# type="predictions": Obtain predicted values
# ref.zero=TRUE: Use zero as the reference point
# conf.int=0.95: 95% confidence interval
# digits=2: Round results to two decimal places
Pre_HR.LnAl <- Predict(
  fit.LnAl,
  DIGM_Score,
  fun = exp,
  type = "predictions",
  ref.zero = TRUE,
  conf.int = 0.95,
  digits = 2
)

# Plot the HR curve and its confidence interval using ggplot2
ggplot() +
  # Plot the HR line
  geom_line(
    data = Pre_HR.LnAl,
    aes(x = DIGM_Score, y = yhat),
    linetype = "solid",
    size = 1,
    alpha = 0.8,
    colour = "orange"
  ) +
  # Add the confidence interval ribbon
  geom_ribbon(
    data = Pre_HR.LnAl,
    aes(x = DIGM_Score, ymin = lower, ymax = upper),
    alpha = 0.1,
    fill = "darkorange"
  ) +
  # Apply a classic theme to the plot
  theme_classic() +
  # Add a horizontal line at HR=1 for reference
  geom_hline(yintercept = 1, linetype = "dashed", size = 1) +
  # Add annotation texts for p-values
  geom_text(
    aes(x = 6, y = 25, label = "P for nonlinear = xxx"),
    size = 5,
    family = "Times New Roman"
  ) +
  geom_text(
    aes(x = 5.8, y = 20, label = "P for overall = xxx"),
    size = 5,
    family = "Times New Roman"
  ) +
  # Set axis labels
  labs(
    title = "DI-GM Score and the Hazard Ratio for disease Incident",
    x = "DI-GM Score",
    y = "HR for Incident of disease (95% CI)"
  ) +
  # Customize theme elements for better readability and aesthetics
  theme(
    axis.text.x = element_text(
      size = 14,
      face = "bold",
      color = "black",
      family = "Times New Roman"
    ),   # Customize x-axis text
    axis.text.y = element_text(
      size = 14,
      face = "bold",
      color = "black",
      family = "Times New Roman"
    ),   # Customize y-axis text
    plot.title = element_text(
      size = 16,
      color = "black",
      family = "Times New Roman",
      face = "bold",
      hjust = 0.5  # Center the title
    ),   # Customize plot title
    axis.title.x = element_text(
      size = 14,
      color = "black",
      family = "Times New Roman"
    ),  # Customize x-axis title
    axis.title.y = element_text(
      size = 14,
      color = "black",
      family = "Times New Roman"
    )   # Customize y-axis title
  )
