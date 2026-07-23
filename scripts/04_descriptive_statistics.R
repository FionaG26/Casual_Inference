# ==============================================================================
# Script: 04_descriptive_statistics.R
# Objective: Cohort demographics and baseline characteristics
# ==============================================================================

library(tidyverse)
library(psych)

# Load cleaned data
df <- readRDS("../data/cleaned_cardio_data.rds")

# Global descriptive statistics
cat("--- GLOBAL COHORT DESCRIPTIVES ---\n")
global_stats <- df %>%
  summarise(
    N          = n(),
    Mean_Age   = mean(age_years),
    SD_Age     = sd(age_years),
    Median_BMI = median(bmi),       # Changed to lowercase 'bmi'
    IQR_BMI    = IQR(bmi),          # Changed to lowercase 'bmi'
    Mean_SysBP = mean(ap_hi),
    SD_SysBP   = sd(ap_hi)
  )
print(global_stats)

# Smoking distribution
cat("\n--- SMOKING DISTRIBUTION ---\n")
smoking_distribution <- df %>%
  count(A) %>%                     # Group by our clean exposure variable 'A'
  mutate(Percentage = n / sum(n) * 100)
print(smoking_distribution)

# Table 1 by exposure
cat("\n--- BASELINE CHARACTERISTICS BY SMOKING ---\n")
table1 <- df %>%
  group_by(A) %>%                  # Stratify by 0 (Non-smoker) and 1 (Smoker)
  summarise(
    Patients   = n(),
    Mean_Age   = mean(age_years),
    SD_Age     = sd(age_years),
    Mean_BMI   = mean(bmi),        # Changed to lowercase 'bmi'
    SD_BMI     = sd(bmi),          # Changed to lowercase 'bmi'
    Mean_SysBP = mean(ap_hi),
    SD_SysBP   = sd(ap_hi)
  )
print(table1)

# Skewness
cat("\n--- SKEWNESS ---\n")
skewness_results <- df %>%
  summarise(
    Age            = psych::skew(age_years),
    BMI            = psych::skew(bmi),        # Changed to lowercase 'bmi'
    Blood_pressure = psych::skew(ap_hi)
  )
print(skewness_results)
