# ==============================================================================
# Script: 06_probability.R
# Objective: Prove the Central Limit Theorem & compute confidence intervals
# ==============================================================================

library(tidyverse)

# 1. Load clean data
df <- readRDS("data/cleaned_cardio_data.rds")

# Extract the highly skewed raw BMI values as a baseline vector
raw_bmi <- df$bmi
pop_mean_bmi <- mean(raw_bmi)
pop_sd_bmi <- sd(raw_bmi)

cat("--- POPULATION BASELINE METRICS ---\n")
cat("True Population Mean BMI:", round(pop_mean_bmi, 3), "\n")
cat("True Population SD BMI:", round(pop_sd_bmi, 3), "\n\n")


# 2. Central Limit Theorem Simulation Loop
set.seed(42) # For complete mathematical replication
num_simulations <- 1000
sample_size <- 50

# Pre-allocate an empty vector to store our simulated sample means
simulated_means <- numeric(num_simulations)

for(i in 1:num_simulations) {
  # Randomly sample 50 patients from the population without replacement
  random_sample <- sample(raw_bmi, size = sample_size, replace = FALSE)
  # Store the mean of this single sample
  simulated_means[i] <- mean(random_sample)
}

# Convert simulation results to a data frame for plotting
sim_df <- data.frame(Sample_Mean_BMI = simulated_means)


# 3. Calculate Distribution Properties of the Sample Means
sim_skewness <- psych::skew(sim_df$Sample_Mean_BMI)
calculated_se <- pop_sd_bmi / sqrt(sample_size)
observed_se <- sd(sim_df$Sample_Mean_BMI)

cat("--- CLT SIMULATION RESULTS ---\n")
cat("Skewness of raw BMI data:", round(psych::skew(raw_bmi), 3), "\n")
cat("Skewness of the Sample Means:", round(sim_skewness, 3), "\n")
cat("Theoretical Standard Error (SD / sqrt(n)):", round(calculated_se, 3), "\n")
cat("Observed Standard Error (SD of sample means):", round(observed_se, 3), "\n\n")


# 4. Generate Figure 3: Visual Proof of the Central Limit Theorem
cat("Generating Figure 3: CLT Verification Plot...\n")

ggplot(sim_df, aes(x = Sample_Mean_BMI)) +
  # Updated here to use the modern after_stat(density) function
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "#9b59b6", color = "white", alpha = 0.8) +
  geom_density(color = "#2c3e50", linewidth = 1.2) +
  geom_vline(xintercept = pop_mean_bmi, color = "#e74c3c", linetype = "dashed", linewidth = 1.2) +
  labs(
    title = "The Central Limit Theorem in Action",
    subtitle = "Distribution of 1,000 Sample Means (n=50) from Skewed BMI Data",
    x = "Calculated Sample Mean BMI (kg/m²)",
    y = "Density"
  ) +
  theme_minimal(base_size = 12)

ggsave("data/figure3_clt_proof.png", width = 7, height = 5, dpi = 300)


# 5. Compute a 95% Confidence Interval for the True Population Mean
error_margin <- 1.96 * (pop_sd_bmi / sqrt(nrow(df)))
ci_lower <- pop_mean_bmi - error_margin
ci_upper <- pop_mean_bmi + error_margin

cat("--- 95% COHORT CONFIDENCE INTERVALS ---\n")
cat("We are 95% confident that the true population average BMI lies between:", 
    round(ci_lower, 3), "and", round(ci_upper, 3), "kg/m².\n")

