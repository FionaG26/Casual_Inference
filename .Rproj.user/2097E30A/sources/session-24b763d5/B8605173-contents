# ==============================================================================
# Script: 08_correlation.R
# Objective: Generate a continuous variable correlation matrix and heatmap
# ==============================================================================

library(tidyverse)
library(ggcorrplot)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# 2. Isolate continuous biometric variables and convert factors to numeric markers
continuous_metrics <- df %>%
  select(age_years, height, weight, bmi, ap_hi, ap_lo)

# 3. Calculate Parametric (Pearson) vs Non-Parametric (Spearman) Matrix
cat("--- CORRELATION MATRIX (SPEARMAN RANK) ---\n")
cor_matrix_spearman <- cor(continuous_metrics, method = "spearman")
print(round(cor_matrix_spearman, 3))

# 4. Generate Figure 4: Publication-Quality Heatmap
cat("\nGenerating Figure 4: Correlation Heatmap...\n")

heatmap_plot <- ggcorrplot(
  cor_matrix_spearman, 
  hc.order = TRUE, 
  type = "lower",
  lab = TRUE, 
  lab_size = 4, 
  colors = c("#3498db", "#f1c40f", "#e74c3c"),
  title = "Biometric Correlation Matrix (Spearman's Rho)",
  ggtheme = theme_minimal()
)

print(heatmap_plot)

ggsave("data/figure4_correlation_heatmap.png", plot = heatmap_plot, width = 7, height = 5, dpi = 300)
cat("Heatmap saved inside the 'data/' folder successfully!\n")
