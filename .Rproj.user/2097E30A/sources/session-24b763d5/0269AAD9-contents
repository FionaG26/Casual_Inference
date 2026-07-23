# ==============================================================================
# Script: 19_sensitivity_analysis.R
# Objective: Quantify vulnerability to hidden bias using linear sensitivity parameters
# ==============================================================================

library(tidyverse)
library(sensemakr) # Premier R platform for sensitivity analysis

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# Convert variables to pure numeric vectors for standard linear sensitivity arrays
df_sens <- df %>%
  mutate(
    A_num = as.numeric(as.character(A)),
    Y_num = as.numeric(as.character(Y))
  )

cat("--- EXECUTING CAUSAL SENSITIVITY ANALYSIS ---\n")

# 2. Fit a standard benchmark linear model for the sensemakr engine
# (Using our DAG-approved backdoor adjustment variables)
benchmark_model <- lm(Y_num ~ A_num + age_years + Gender, data = df_sens)

# 3. Run the sensitivity engine targeting our exposure variable 'A_num'
sensitivity_audit <- sensemakr(model = benchmark_model,
                               treatment = "A_num",
                               benchmark_covariates = "age_years",
                               kd = c(1, 2, 3)) # Test bounds at 1x, 2x, and 3x the strength of Age

# 4. Print the comprehensive text sensitivity matrix report
print(sensitivity_audit)

# 5. Generate Figure 9: Publication-Quality Contour Plot
cat("\nGenerating Figure 9: Sensitivity Contour Plot...\n")

png("data/figure9_sensitivity_contour.png", width = 1800, height = 1500, res = 300)
plot(sensitivity_audit, type = "contour")
dev.off()

cat("Sensitivity contour graph successfully saved inside the 'data/' folder!\n")
