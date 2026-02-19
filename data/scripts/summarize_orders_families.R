# Load packages
library(dplyr)
library(ggplot2)
library(readr)

# Read Table 2
taxa <- read_csv("data/global-survey/Table 2.csv")

# Count unique orders and families
summary_df <- tibble(
  level = c("Orders", "Families"),
  count = c(
    n_distinct(taxa$order),
    n_distinct(taxa$family)
  )
)

# Plot
p <- ggplot(summary_df, aes(x = level, y = count)) +
  geom_col(width = 0.6, fill = "darkgreen") +
  geom_text(aes(label = count), vjust = -0.4, size = 5) +
  labs(
    x = NULL,
    y = "Number represented in the database",
    title = "Current taxonomic coverage of vascular variants"
  ) +
  theme_minimal(base_size = 14)

# Save figure
ggsave(
  filename = "data/figures/taxonomic_coverage_orders_families.png",
  plot = p,
  width = 6,
  height = 4,
  dpi = 300
)

