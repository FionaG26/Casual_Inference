# ==============================================================================
# Script: 17_difference_in_differences.R
# Objective: Structural longitudinal simulation and Difference-in-Differences estimation
# ==============================================================================

library(tidyverse)
library(broom)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

set.seed(456)
n_rows <- nrow(df)

# 2. Simulate a Longitudinal Panel Environment
# We assign half the cohort to a Treatment Group (City A) and half to a Control Group (City B).
# We also clone the rows to represent data collected across two time periods (Pre vs Post).
df_pre <- df %>%
  mutate(
    Group = rbinom(n_rows, 1, 0.5), # 1 = Treatment Group, 0 = Control Group
    Time  = 0,                      # 0 = Pre-Treatment Era
    Y_num = as.numeric(as.character(Y))
  )

df_post <- df_pre %>%
  mutate(
    Time = 1,                       # 1 = Post-Treatment Era
    # Control group naturally shifts slightly over time due to aging background trends
    Y_num = ifelse(Group == 0 & runif(n_rows) < 0.02, 1, Y_num),
    
    # Treatment group encounters a powerful policy intervention (e.g. smoking ban)
    # causing an absolute reduction in cardiovascular disease rates
    Y_num = ifelse(Group == 1 & runif(n_rows) < 0.06, 0, Y_num)
  )

# Combine both periods into a unified panel dataset
df_did <- bind_rows(df_pre, df_post)

cat("--- EXECUTING DIFFERENCE-IN-DIFFERENCES (DiD) REGRESSION ---\n")

# 3. Fit the Causal Interaction Model
# The '*' operator in R automatically includes main effects and their interaction: Group + Time + Group:Time
did_model <- lm(Y_num ~ Group * Time + age_years + Gender, data = df_did)

# Display tidy regression results
print(tidy(did_model))

# 4. Extract the true DiD coefficient
did_coefficient <- coef(did_model)["Group:Time"]
cat("\n--- CAUSAL INTERPRETATION ---\n")
cat("The calculated DiD Causal Interaction Estimate is:", round(did_coefficient, 4), "\n")
cat("This proves that the policy intervention caused an absolute drop in heart disease\n")
cat("rates of exactly:", round(abs(did_coefficient) * 100, 2), "percentage points compared to the control trend.\n")
