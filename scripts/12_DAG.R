# ==============================================================================
# Script: 12_DAG.R
# Objective: Define structural causal assumptions and calculate adjustment sets
# ==============================================================================

library(tidyverse)
library(dagitty)
library(ggdag)

# 1. Define the Structural Causal Model using dagitty syntax
cardio_dag <- dagitty('dag {
  Active [pos="-2,2"]
  Age [pos="-3,0"]
  BMI [pos="-2,-2"]
  Gender [pos="0,-3"]
  A [exposure,pos="-4,0"]
  Y [outcome,pos="4,0"]
  ap_hi [pos="1,1"]
  
  Age -> A
  Age -> Y
  Age -> ap_hi
  Gender -> A
  Gender -> Y
  BMI -> Y
  BMI -> ap_hi
  Active -> Y
  A -> ap_hi
  ap_hi -> Y
  A -> Y
}')

# 2. Mathematically identify the correct Adjustment Set to block backdoor paths
cat("--- MATHEMATICAL CAUSAL ADJUSTMENT SET ---\n")
adjustment_set <- adjustmentSets(cardio_dag, effect = "total")
print(adjustment_set)

# 3. Generate and render the plot safely using standard ggplot structures
cat("\nGenerating Figure 6: Causal Diagram Graph...\n")

# Convert the DAG into a tidy format to expose nodes and coordinates to ggplot
tidy_cardio_dag <- tidy_dagitty(cardio_dag)

dag_plot <- ggplot(tidy_cardio_dag, aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_edges(edge_color = "#34495e") +
  geom_dag_node(color = "#2c3e50", size = 14) + # Added size so text fits inside node
  geom_dag_text(aes(label = name), color = "white", fontface = "bold", size = 4) +
  theme_dag() +
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "#555555")
  ) +
  labs(
    title = "Structural Causal Architecture for Cardiovascular Study",
    subtitle = "Mapping Confounders vs. Blood Pressure Mediation Pathways"
  )

# Force the plot to print live to your RStudio Plots tab pane
print(dag_plot)

# Create directory if it doesn't exist, then save the plot securely
if(!dir.exists("data")) dir.create("data")
ggsave("data/figure6_causal_dag.png", plot = dag_plot, width = 7, height = 5, dpi = 300)
cat("DAG visual graph successfully saved inside the 'data/' folder!\n")
