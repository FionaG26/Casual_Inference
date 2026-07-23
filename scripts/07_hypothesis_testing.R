# ==============================================================================
# Script: 07_hypothesis_testing.R
# Objective: Evaluate baseline and outcome significance using t-tests and Chi-Square
# ==============================================================================

library(tidyverse)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# 2. Continuous Testing: Two-Sample Welch's t-Test
# Testing if true mean BMI differs between Non-Smokers (A=0) and Smokers (A=1)
cat("--- CONTINUOUS HYPOTHESIS TESTING (t-Test) ---\n")

bmi_ttest <- t.test(bmi ~ A, data = df)
print(bmi_ttest)


# 3. Categorical Testing: Chi-Square Test of Independence
# Creating a 2x2 contingency table: Exposure (A) by Outcome (Y)
cat("\n--- CATEGORICAL CONTINGENCY TABLE (A x Y) ---\n")

contingency_table <- table(df$A, df$Y)
rownames(contingency_table) <- c("Non-Smoker", "Smoker")
colnames(contingency_table) <- c("No Cardio Disease", "Cardio Disease")
print(contingency_table)

cat("\n--- CATEGORICAL HYPOTHESIS TESTING (Chi-Square) ---\n")
cardio_chisq <- chisq.test(contingency_table)
print(cardio_chisq)

