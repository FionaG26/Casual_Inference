# ==============================================================================
# Script: 02_import_data.R
# Objective: Read raw data from the data directory and inspect dimensions
# ==============================================================================

library(tidyverse)

# Correct path pointing to your new data folder structure
data_file <- "data/cardio_train.csv"

if (!file.exists(data_file)) {
  stop("Error: 'cardio_train.csv' not found inside the 'data/' folder! Please check your directory structure.")
}

# Read using the correct semicolon delimiter
raw_data <- read_delim(data_file, delim = ";", show_col_types = FALSE)

# Structural Inspection
cat("--- RAW DATA SUMMARY ---\n")
cat("Total Rows (Observations):", nrow(raw_data), "\n")
cat("Total Columns (Variables):", ncol(raw_data), "\n\n")

print(glimpse(raw_data))

# Save the raw R object into a data storage environment file
save(raw_data, file = "data/raw_data.RData")

