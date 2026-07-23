# ==============================================================================
# Script: 14_inverse_probability_weighting.R
# Objective: Execute Inverse Probability Weighting (IPW) and estimate causal effects
# ==============================================================================

library(tidyverse)
library(WeightIt)
library(survey) # Required to handle cluster-robust standard errors in weighted data

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# Convert treatment variables to pure numerical representations
df_ipw <- df %>%
  mutate(
    A_num = as.numeric(as.character(A)),
    Y_num = as.numeric(as.character(Y))
  )

cat("--- EXECUTING INVERSE PROBABILITY WEIGHTING (IPW) ---\n")

# 2. Estimate Causal Weights using WeightIt
# We use a standard Generalized Linear Model (logistic) to estimate the weights
weight_model <- weightit(A_num ~ age_years + Gender,
                         data = df_ipw,
                         method = "ps",
                         estimator = "ATE") # Average Treatment Effect on the Population

print(weight_model)

# 3. Append the calculated structural weights to our dataset
df_ipw$weights <- weight_model$weights


# 4. Fit a Weighted Causal Outcome Model using robust standard errors
cat("\n--- ESTIMATING IPW CAUSAL OUTCOME REGRESSION ---\n")

# In weighted populations, standard errors must be adjusted using a sandwich estimator
# We initialize a survey design object using our calculated weights
design_object <- svydesign(ids = ~1, weights = ~weights, data = df_ipw)

# Run a design-weighted logistic regression model
ipw_outcome_model <- svyglm(Y_num ~ A_num, design = design_object, family = binomial(link = "logit"))

# Cleanly extract and interpret the Causal Odds Ratio
ipw_or <- exp(coef(ipw_outcome_model)["A_num"])
cat("The calculated IPW Causal Odds Ratio of Smoking is:", round(ipw_or, 3), "\n")
