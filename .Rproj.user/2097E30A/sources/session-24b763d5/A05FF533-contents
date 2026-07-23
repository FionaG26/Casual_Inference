# ==============================================================================
# Script: 20_random_forest.R
# Objective: Train an ensemble Random Forest classifier and extract feature priority
# ==============================================================================

library(tidyverse)
library(randomForest)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# Ensure the target outcome Y is explicitly styled as a factor for classification
df_rf <- df %>%
  mutate(Y = factor(Y, levels = c(0, 1), labels = c("Healthy", "Cardio")))

cat("--- TRAINING RANDOM FOREST CLASSIFIER (OOB MODE) ---\n")

# 2. Train the Random Forest model
# We set ntree=100 for optimized execution speeds; mtry defaults to sqrt(total_features)
set.seed(321)
rf_model <- randomForest(Y ~ A + age_years + Gender + height + weight + bmi + ap_hi + ap_lo + Cholesterol + Glucose + Alcohol + Active,
                         data = df_rf,
                         ntree = 100,
                         importance = TRUE)

# Print the overall model performance and the OOB confusion matrix
print(rf_model)


# 3. Extract and Clean Variable Importance Data
cat("\n--- EXTRACTING FEATURE IMPORTANCE ---\n")
importance_matrix <- as.data.frame(importance(rf_model))
importance_matrix$Variable <- rownames(importance_matrix)

# Format for clean tidy plotting based on Mean Decrease Gini
importance_clean <- importance_matrix %>%
  select(Variable, MeanDecreaseGini) %>%
  arrange(desc(MeanDecreaseGini))

print(importance_clean)


# 4. Generate Figure 10: Publication-Quality Feature Importance Chart
cat("\nGenerating Figure 10: Feature Importance Plot...\n")

importance_plot <- ggplot(importance_clean, aes(x = reorder(Variable, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_bar(stat = "identity", fill = "#34495e", width = 0.7) +
  coord_flip() +
  labs(
    title = "Random Forest Variable Importance Metrics",
    subtitle = "Ranked via Mean Decrease in Gini Impurity Indexes",
    x = "Biometric Variable Profile",
    y = "Mean Decrease Gini (Classifier Priority)"
  ) +
  theme_minimal()

print(importance_plot)

ggsave("data/figure10_feature_importance.png", plot = importance_plot, width = 7, height = 5, dpi = 300)
cat("Feature Importance chart successfully saved inside the 'data/' folder!\n")
