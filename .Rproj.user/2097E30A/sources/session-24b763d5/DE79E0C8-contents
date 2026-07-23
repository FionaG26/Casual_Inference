############################################################
# 01_INSTALL_PACKAGES.R
# Cardiovascular Disease Causal Inference Project
############################################################


# List of required packages

packages <- c(
  
  # Data manipulation
  "tidyverse",
  "dplyr",
  "tidyr",
  
  # Data visualization
  "ggplot2",
  "ggcorrplot",
  
  # Statistics
  "psych",
  "car",
  "MASS",
  
  # Regression
  "broom",
  "lmtest",
  
  # Causal inference
  "MatchIt",
  "cobalt",
  "dagitty",
  "WeightIt",
  
  # Machine learning
  "caret",
  "randomForest",
  "xgboost",
  "pROC",
  
  # Explainable AI
  "SHAPforxgboost",
  
  # Reports
  "knitr",
  "rmarkdown"
)



# Install missing packages

installed_packages <- rownames(installed.packages())


for(package in packages){
  
  if(!(package %in% installed_packages)){
    
    install.packages(package)
    
  }
  
}



print("All packages installed successfully")

