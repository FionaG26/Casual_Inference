# ==============================================================================
# Script: 03_data_cleaning.R
# Objective: Eliminate duplicates, filter outliers, and save clean dataset
# ==============================================================================

library(tidyverse)

# Load the raw data from our data directory
load("data/raw_data.RData")

cleaned_data <- raw_data %>%
  # 1. Eliminate structural duplicate entries
  distinct() %>%
  
  # 2. Convert age from days to precise clinical years
  mutate(age_years = age / 365.25) %>%
  
  # 3. Calculate Body Mass Index (BMI = kg / m^2)
  mutate(bmi = weight / ((height / 100)^2)) %>%
  
  # 4. Enforce strict physiological boundaries to remove entry errors
  filter(height >= 130 & height <= 220) %>%
  filter(weight >= 40 & weight <= 200) %>%
  filter(ap_hi >= 80 & ap_hi <= 240) %>%
  filter(ap_lo >= 40 & ap_lo <= 140) %>%
  
  # 5. Enforce mathematical truth: Systolic must be higher than Diastolic
  filter(ap_hi > ap_lo) %>%
  
  # 6. Restructure columns into explicit statistical roles
  mutate(
    Y = as.factor(cardio),               # Primary Outcome
    A = as.factor(smoke),                # Exposure / Treatment
    Gender = factor(gender, levels = c(1, 2), labels = c("Female", "Male")),
    Cholesterol = factor(cholesterol, ordered = TRUE),
    Glucose = factor(gluc, ordered = TRUE),
    Alcohol = as.factor(alco),
    Active = as.factor(active)
  ) %>%
  
  # 7. Retain only clean, parsed variables for modeling
  select(Y, A, age_years, Gender, height, weight, bmi, ap_hi, ap_lo, Cholesterol, Glucose, Alcohol, Active)

# Save clean working dataset inside your data folder for subsequent chapters
saveRDS(cleaned_data, "data/cleaned_cardio_data.rds")

# Print filtering summary metrics
cat("--- DATA CLEANING SUMMARY ---\n")
cat("Observations remaining after cleaning:", nrow(cleaned_data), "\n")
cat("Total anomalous rows dropped:", nrow(raw_data) - nrow(cleaned_data), "\n")

