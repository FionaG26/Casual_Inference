# ==============================================================================
# Script: 21_xgboost.R
# Objective: Prepare numerical feature matrices and train a modern XGBoost classifier
# ==============================================================================

library(tidyverse)
library(xgboost)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

cat("--- PREPARING NUMERICAL MATRIX FOR XGBOOST ---\n")

# Transform text categories into precise numerical features
df_numeric <- df %>%
  mutate(
    Y_num = as.numeric(as.character(Y)),
    A_num = as.numeric(as.character(A)),
    Gender_num = ifelse(Gender == "Male", 1, 0),
    Chol_num   = as.numeric(as.character(Cholesterol)),
    Gluc_num   = as.numeric(as.character(Glucose)),
    Alco_num   = as.numeric(as.character(Alcohol)),
    Act_num    = as.numeric(as.character(Active))
  ) %>%
  select(Y_num, A_num, age_years, Gender_num, height, weight, bmi, ap_hi, ap_lo, Chol_num, Gluc_num, Alco_num, Act_num)

# Separate into Feature Matrix (X) and Label Vector (Y)
X_matrix <- as.matrix(df_numeric %>% select(-Y_num))
Y_vector <- df_numeric$Y_num

# Save matrix objects internally for Chapter 11 Part 3 (SHAP visualizations)
save(X_matrix, Y_vector, file = "data/xgboost_matrices.RData")


cat("--- TRAINING EXTREME GRADIENT BOOSTING CLASSIFIER ---\n")

# 3. Train using modern API naming rules (x and y replaces data and label)
# Objective parameters are stored within a list block to avoid type mismatch errors
xgb_model <- xgboost(x = X_matrix, 
                     y = Y_vector, 
                     nrounds = 50, 
                     params = list(objective = "binary:logistic"),
                     print_every_n = 10)

# Save the trained model file securely to disk
xgb.save(xgb_model, "data/xgboost_cardio_model.model")


# 4. Generate Figure 11: XGBoost Feature Importance Array via ggsave
cat("\nGenerating Figure 11: XGBoost Importance Plot...\n")

importance_xgb <- xgb.importance(feature_names = colnames(X_matrix), model = xgb_model)
print(importance_xgb)

# Rebuild plotting syntax to avoid graphic canvas clipping
xgb_importance_df <- as.data.frame(importance_xgb)

xgb_plot <- ggplot(xgb_importance_df, aes(x = reorder(Feature, Gain), y = Gain)) +
  geom_bar(stat = "identity", fill = "#2ecc71", width = 0.7) +
  coord_flip() +
  labs(
    title = "XGBoost Machine Learning Feature Importance",
    subtitle = "Ranked via Fractional Contribution (Gain Metric)",
    x = "Biometric Variable Profile",
    y = "Gain Score (Predictive Split Dominance)"
  ) +
  theme_minimal()

print(xgb_plot)
ggsave("data/figure11_xgboost_importance.png", plot = xgb_plot, width = 7, height = 5, dpi = 300)

cat("XGBoost importance graph successfully saved inside the 'data/' folder!\n")
