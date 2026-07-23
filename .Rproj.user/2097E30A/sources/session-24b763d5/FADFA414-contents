# ==============================================================================
# Script: 13_propensity_score_matching.R
# Objective: Calculate propensity scores, execute 1:1 matching, and check balance
# ==============================================================================

library(tidyverse)
library(MatchIt)
library(cobalt) # Gold-standard library for balance visualization (Love Plots)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# Convert treatment variables to pure numerical arrays for the engine matrix
df_match <- df %>%
  mutate(
    A_num = as.numeric(as.character(A)),
    Y_num = as.numeric(as.character(Y))
  )

cat("--- EXECUTING PROPENSITY SCORE MATCHING ---\n")
# 2. Fit the matching architecture using only our DAG-derived adjustment set
match_model <- matchit(A_num ~ age_years + Gender, 
                       data = df_match, 
                       method = "nearest", 
                       distance = "glm")

# Print structural summary of the matching results
print(summary(match_model))

# 3. Extract the clean, balanced pseudo-population dataset
balanced_data <- match.data(match_model)
saveRDS(balanced_data, "data/propensity_matched_data.rds")


# 4. Generate Figure 7: Covariate Balance Love Plot Using ggsave
cat("\nGenerating Figure 7: Covariate Balance Love Plot...\n")

my_love_plot <- love.plot(match_model, 
                          thresholds = c(m = .1), 
                          binary = "std",
                          abs = TRUE,
                          line = TRUE,
                          colors = c("#e74c3c", "#2ecc71"),
                          title = "Covariate Balance Across Causal Adjustment Sets",
                          sample.names = c("Unadjusted Raw Cohort", "Propensity Matched Cohort")) +
  theme_minimal()

# Force the plot to render directly to your RStudio Plots tab pane
print(my_love_plot)

# Save the plot safely via ggsave to prevent white canvas errors
ggsave("data/figure7_balance_love_plot.png", plot = my_love_plot, width = 7, height = 5, dpi = 300)

cat("Love Plot figure successfully saved inside the 'data/' folder!\n")


# 5. Compute the True Total Causal Effect on the Balanced Population
cat("\n--- ESTIMATING THE TRUE CAUSAL TOTAL EFFECT ---\n")
causal_outcome_model <- glm(Y_num ~ A_num, data = balanced_data, family = binomial(link = "logit"))

# Calculate the true causal Odds Ratio
causal_or <- exp(coef(causal_outcome_model)["A_num"])
cat("The true, unconfounded Causal Odds Ratio of Smoking is:", round(causal_or, 3), "\n")
