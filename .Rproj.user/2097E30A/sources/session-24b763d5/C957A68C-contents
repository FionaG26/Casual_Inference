# ==============================================================================
# Script: 15_doubly_robust_estimation.R
# Objective: Execute Doubly Robust Estimation using an AIPW framework
# ==============================================================================

library(tidyverse)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# Convert variables to clean numeric metrics for formula processing
df_dr <- df %>%
  mutate(
    A_num = as.numeric(as.character(A)),
    Y_num = as.numeric(as.character(Y))
  )

cat("--- EXECUTING DOUBLY ROBUST ESTIMATION (AIPW) ---\n")

# Step A: Fit the Propensity Score Model (Treatment Assignment)
ps_model <- glm(A_num ~ age_years + Gender, data = df_dr, family = binomial(link = "logit"))
df_dr$ps   <- predict(ps_model, type = "response")

# Step B: Fit the Outcome Regression Model
out_model <- glm(Y_num ~ A_num + age_years + Gender, data = df_dr, family = binomial(link = "logit"))

# Step C: Generate Counterfactual Predictions for everyone
# What would their risk be if we FORCED everyone to be a non-smoker (A=0)?
df_dr$pred_y0 <- predict(out_model, newdata = transform(df_dr, A_num = 0), type = "response")
# What would their risk be if we FORCED everyone to be a smoker (A=1)?
df_dr$pred_y1 <- predict(out_model, newdata = transform(df_dr, A_num = 1), type = "response")


# Step D: Apply the Augmented IPW Causal Extractor Formula
df_dr <- df_dr %>%
  mutate(
    dr_y1 = pred_y1 + (A_num * (Y_num - pred_y1)) / ps,
    dr_y0 = pred_y0 + ((1 - A_num) * (Y_num - pred_y0)) / (1 - ps)
  )

# Calculate the Doubly Robust Average Treatment Effect (Risk Difference)
mean_dr_y1 <- mean(df_dr$dr_y1)
mean_dr_y0 = mean(df_dr$dr_y0)
dr_risk_difference <- mean_dr_y1 - mean_dr_y0

# Convert the stable risk probabilities back into a standard Causal Odds Ratio
dr_odds_y1 <- mean_dr_y1 / (1 - mean_dr_y1)
dr_odds_y0 <- mean_dr_y0 / (1 - mean_dr_y0)
doubly_robust_or <- dr_odds_y1 / dr_odds_y0

cat("Doubly Robust Expected Sample Risk if Everyone Smoked:", round(mean_dr_y1 * 100, 2), "%\n")
cat("Doubly Robust Expected Sample Risk if Nobody Smoked:", round(mean_dr_y0 * 100, 2), "%\n")
cat("The Doubly Robust Causal Odds Ratio is:", round(doubly_robust_or, 3), "\n")
