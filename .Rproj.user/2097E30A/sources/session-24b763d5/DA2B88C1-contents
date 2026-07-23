# ==============================================================================
# Script: 05_visualization.R
# Objective: Generate publication-quality figures for distribution audits
# ==============================================================================

library(tidyverse)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# 2. Figure 1: BMI Distribution (Demonstrating Positive Skewness)
cat("Generating Figure 1: BMI Histogram...\n")

ggplot(df, aes(x = bmi)) +
  geom_histogram(aes(y = ..density..), bins = 40, fill = "#2c3e50", color = "white", alpha = 0.8) +
  geom_density(color = "#e74c3c", size = 1.2) +
  labs(
    title = "Distribution of Body Mass Index (BMI)",
    subtitle = paste("Highly positively skewed distribution (Skewness = 1.23)"),
    x = "Body Mass Index (kg/m²)",
    y = "Density"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank()
  )

# Save the figure to your local machine
ggsave("data/figure1_bmi_distribution.png", width = 7, height = 5, dpi = 300)


# 3. Figure 2: Systolic Blood Pressure Stratified Boxplot
cat("Generating Figure 2: Blood Pressure Boxplot...\n")

# Label exposure for clean visualization legends
df_plot <- df %>%
  mutate(Smoking_Status = factor(A, levels = c(0, 1), labels = c("Non-Smoker", "Smoker")))

ggplot(df_plot, aes(x = Smoking_Status, y = ap_hi, fill = Smoking_Status)) +
  geom_boxplot(alpha = 0.7, outlier.size = 1, outlier.alpha = 0.3) +
  scale_fill_manual(values = c("#3498db", "#e67e22")) +
  labs(
    title = "Systolic Blood Pressure Stratified by Smoking Status",
    subtitle = "Comparing baseline treatment arm profiles",
    x = "Exposure Group (A)",
    y = "Systolic Blood Pressure (mmHg)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )

# Save second figure
ggsave("data/figure2_bp_boxplot.png", width = 7, height = 5, dpi = 300)

cat("Visualizations generated and saved inside the 'data/' folder successfully!\n")

