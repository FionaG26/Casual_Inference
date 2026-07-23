# ==============================================================================
# Script: 09_linear_regression.R
# Objective: Run continuous linear regression predicting blood pressure
# ==============================================================================

library(tidyverse)
library(broom)

# Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

cat("--- LINEAR REGRESSION: PREDICTING SYSTOLIC BLOOD PRESSURE ---\n")
# Modeling ap_hi based on Smoking, Age, BMI, and Gender
linear_model <- lm(ap_hi ~ A + age_years + bmi + Gender, data = df)

# Cleanly format output using the broom package
print(tidy(linear_model))
