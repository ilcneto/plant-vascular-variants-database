# Load packages
library(dplyr)
library(ggplot2)
library(readr)

# Read CSV
taxa <- read_csv("data/global-survey/Table 2.csv", show_col_types = FALSE)

# Trim column names to avoid hidden spaces
names(taxa) <- trimws(names(taxa))

# Define columns to summarize
level <- c("Order", "Family")

# Count unique entries
summary_df <- tibble(
  level = level,
  count = sapply(level, function(lv) n_distinct(taxa[[lv]]))
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
