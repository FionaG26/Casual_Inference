# ==============================================================================
# Script: 22_shap.R
# Objective: Calculate Shapley values to explain the black box XGBoost model
# ==============================================================================

library(tidyverse)
library(xgboost)
library(SHAPforxgboost)

# 1. Load the matrices and trained model from our XGBoost script
load("data/xgboost_matrices.RData")
xgb_model <- xgb.load("data/xgboost_cardio_model.model")

cat("--- COMPUTING SHAPLEY VALUES FOR THE COHORT ---\n")

# 2. Calculate SHAP values
shap_values <- shap.values(xgb_model = xgb_model, X_train = X_matrix)

# 3. Format the data for structured plotting
shap_long <- shap.prep(xgb_model = xgb_model, X_train = X_matrix)

cat("\nGenerating Figure 12: SHAP Summary Plot...\n")

# 4. Generate and store the plot as a standard object
shap_plot <- shap.plot.summary(shap_long, scientific = FALSE) +
  theme_minimal() +
  labs(
    title = "SHAP Explanation of the Cardiovascular XGBoost Model",
    subtitle = "Isolating directional biometric impacts across individual patient records"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(size = 9)
  )

# Force the plot to render directly to your RStudio Plots tab pane
print(shap_plot)

# Save the plot safely via ggsave to completely prevent white canvas errors
ggsave("data/figure12_shap_summary_plot.png", plot = shap_plot, width = 8, height = 6, dpi = 300)

cat("SHAP diagnostic visualization successfully saved inside the 'data/' folder!\n")
