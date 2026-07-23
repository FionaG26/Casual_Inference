# ==============================================================================
# Script: 18_regression_discontinuity.R
# Objective: Centered threshold simulation and Regression Discontinuity Design (RDD)
# ==============================================================================

library(tidyverse)
library(rdrobust) # Gold-standard package for local non-parametric RDD estimation

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

set.seed(789)
n_rows <- nrow(df)

# 2. Simulate an RDD Clinical Environment
# Let's assume a clinical rule: Patients with a Systolic BP (ap_hi) >= 140 mmHg
# are immediately placed on a high-intensity blood pressure medication.
cutoff_threshold <- 140

df_rdd <- df %>%
  mutate(
    # Running variable: ap_hi (Systolic Blood Pressure)
    Running_Var = ap_hi,
    
    # Strict Assignment Rule
    Treatment = ifelse(Running_Var >= cutoff_threshold, 1, 0),
    Y_num     = as.numeric(as.character(Y))
  ) %>%
  # We simulate that the medication successfully drops their subsequent
  # absolute risk of experiencing a cardiovascular event right at the boundary
  mutate(
    Y_num = ifelse(Treatment == 1 & Running_Var < 145 & runif(n_rows) < 0.12, 0, Y_num)
  )

cat("--- EXECUTING REGRESSION DISCONTINUITY DESIGN (RDD) ---\n")

# 3. Fit the Non-Parametric Local Linear RDD Model
# rdrobust automatically calculates optimal bandwidths and robust standard errors
rdd_analysis <- rdrobust(y = df_rdd$Y_num, x = df_rdd$Running_Var, c = cutoff_threshold)

# Print clean RDD summary tables
print(summary(rdd_analysis))


# 4. Generate Figure 8: Publication-Quality RDD Plot
cat("\nGenerating Figure 8: RDD Discontinuity Plot...\n")

# rdplot uses data-driven binning to visually expose the local jump at the boundary
png("data/figure8_rdd_plot.png", width = 1800, height = 1200, res = 300)
rdplot(y = df_rdd$Y_num, x = df_rdd$Running_Var, c = cutoff_threshold,
       title = "Regression Discontinuity: Treatment Threshold at 140 mmHg",
       x.label = "Systolic Blood Pressure Running Variable (mmHg)",
       y.label = "Probability of Cardiovascular Disease (Y)")
dev.off()

cat("RDD diagnostic plot successfully saved inside the 'data/' folder!\n")
