# ==============================================================================
# Script: 10_logistic_regression.R
# Objective: Run binary logistic regression and compute adjusted Odds Ratios
# ==============================================================================

library(tidyverse)
library(broom)

# Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# Model 1: Crude/Unadjusted (Only looking at Smoking 'A')
cat("--- MODEL 1: CRUDE LOGISTIC REGRESSION ---\n")
crude_model <- glm(Y ~ A, data = df, family = binomial(link = "logit"))

print(tidy(crude_model) %>% 
        mutate(Odds_Ratio = exp(estimate)))

# Model 2: Fully Adjusted Model (Controlling for Age, BMI, Gender, BP, and Activity)
cat("\n--- MODEL 2: FULLY ADJUSTED MULTIVARIABLE LOGISTIC REGRESSION ---\n")
adjusted_model <- glm(Y ~ A + age_years + bmi + Gender + ap_hi + Active, 
                      data = df, family = binomial(link = "logit"))

print(tidy(adjusted_model) %>% 
        mutate(
          Odds_Ratio = exp(estimate),
          CI_Lower   = exp(estimate - 1.96 * std.error),
          CI_Upper   = exp(estimate + 1.96 * std.error)
        ) %>%
        select(term, estimate, std.error, p.value, Odds_Ratio, CI_Lower, CI_Upper))

