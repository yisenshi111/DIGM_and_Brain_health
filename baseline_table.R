# #### Baseline Table Creation using the tableone Package #####

# If the tableone package is not installed, uncomment and run the following line:
# install.packages("tableone")

# Load the tableone package, which is used for creating descriptive statistics tables
library(tableone)

# Create a descriptive statistics table
# - data: The dataset you are using
# - vars: The variables to include in the table
# - factorVars: Specifies which variables are categorical (factors)
# - addOverall: Adds an overall summary column when set to TRUE
tab_s <- CreateTableOne(
  data = data, 
  vars = c("var1", "var2_nonnormal", "var3_factor"),
  factorVars = c("var3_factor"),
  addOverall = TRUE
)

# Print the descriptive statistics table
# - showAllLevels: If TRUE, shows all levels of categorical variables
# - printToggle: If FALSE, the table is stored in a variable instead of being printed directly
# - pDigits: Number of decimal places for p-values
# - nonnormal: Specifies variables that do not follow a normal distribution
tab_sv <- print(
  tab_s, 
  showAllLevels = TRUE,
  printToggle = FALSE,  # Set to FALSE to store the output in tab_sv instead of printing
  pDigits = 3,          # Display p-values with 3 decimal places
  nonnormal = c("var2_nonnormal")  # Specify that var2_nonnormal is non-normally distributed
)

# View the stored table
print(tab_sv)