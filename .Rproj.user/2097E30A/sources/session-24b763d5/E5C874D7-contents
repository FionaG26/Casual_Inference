# ==============================================================================
# Script: 11_model_diagnostics.R
# Objective: Check collinearity (VIF) and calculate classification performance (ROC/AUC)
# ==============================================================================

library(tidyverse)
library(car)   # For Variance Inflation Factors (VIF)
library(pROC)  # For ROC curve calculations and plotting

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# 2. Re-fit the fully adjusted multivariable logistic model from Script 10
adjusted_model <- glm(Y ~ A + age_years + bmi + Gender + ap_hi + Active, 
                      data = df, family = binomial(link = "logit"))

# 3. Check for Multi-collinearity using VIF
cat("--- MULTI-COLLINEARITY AUDIT (VIF) ---\n")
# VIF values > 5 or 10 indicate problematic collinearity
print(vif(adjusted_model))


# 4. Generate Predictions and Calculate Discriminatory Power
cat("\n--- COMPUTING DIAGNOSTIC DISCRIMINATION ---\n")
# Generate predicted probabilities of heart disease for every patient
df$pred_prob <- predict(adjusted_model, type = "response")

# Construct the formal ROC object
roc_curve <- roc(df$Y, df$pred_prob, quiet = TRUE)
cat("Calculated Model AUC Size:", round(auc(roc_curve), 4), "\n")


# 5. Generate Figure 5: Publication-Quality ROC Plot
cat("\nGenerating Figure 5: ROC Curve...\n")

png("data/figure5_roc_curve.png", width = 1800, height = 1500, res = 300)
plot(roc_curve, 
     col = "#e74c3c", 
     lwd = 4, 
     main = paste("Logistic Regression Diagnostic Performance\nAUC =", round(auc(roc_curve), 3)),
     col.main = "#2c3e50",
     cex.main = 1.1,
     xlab = "Specificity (True Negative Rate)",
     ylab = "Sensitivity (True Positive Rate)",
     identity.col = "#bdc3c7",
     identity.lwd = 2,
     identity.lty = 2)
dev.off()

cat("Diagnostic ROC plot successfully saved inside the 'data/' folder!\n")

