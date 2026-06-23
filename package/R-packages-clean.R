# dlookr
# ------------------------------------------------------------------------------
# Key features:
# - Diagnose missing values
# - Detect outliers
# - Check distributions
# - Validate business rules
# ------------------------------------------------------------------------------

library(data.table)
library(dlookr)

dt <- data.table::data.table(
  age = c(20, 35, NA, 999),
  income = c(30000, 50000, 45000, -100)
)

# Diagnose overview
dlookr::diagnose(dt)

# Diagnose numeric variables
dlookr::diagnose_numeric(dt)

# Detect outliers
dlookr::diagnose_outlier(dt)

# validate
# ------------------------------------------------------------------------------
# Key features
# - Define validation rules once
# - Apply across dataset
# - Identify all violations
# ------------------------------------------------------------------------------

library(data.table)
library(validate)

dt <- data.table::data.table(
  age = c(25, -5, 200, 30, NA, 150),
  income = c(30000, -1000, 50000, NA, 40000, 60000)
)

rules <- validate::validator(
  age >= 0,
  age <= 120,
  income >= 0
)

results <- validate::confront(dt, rules)

summary(results)
validate::values(results)
validate::plot(results)

# assertr
# ------------------------------------------------------------------------------
# Key features
# - Assert conditions on data
# - Chain assertions for multiple checks
# - Stop execution on failure
# ------------------------------------------------------------------------------

library(data.table)
library(assertr)

dt <- data.table::data.table(age = c(25, -1, 40))

assertr::verify(dt, age >= 0)

# janitor
# ------------------------------------------------------------------------------
# Key features
# - Clean column names
# - Remove empty rows and columns
# - Identify duplicates
# ------------------------------------------------------------------------------
library(data.table)
library(janitor)

dt <- data.table::data.table(
  "Age (years)" = c(20, 30),
  Gender = c("M", "F")
)

# Clean variable names
names(dt)
dt <- as.data.table(janitor::clean_names(dt))

# Frequency tables
janitor::tabyl(dt$gender)
