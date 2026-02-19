# Load packages
library(dplyr)
library(ggplot2)
library(readr)

# Read CSV
taxa <- read_csv("data/global-survey/Table 2.csv", show_col_types = FALSE)

# Trim column names
names(taxa) <- trimws(names(taxa))

# Make sure the required columns exist
if(!all(c("Order", "Family") %in% names(taxa))){
  stop("CSV must have columns named exactly 'Order' and 'Family'")
}

# Count unique entries
order_count <- n_distinct(taxa$Order)
family_count <- n_distinct(taxa$Family)

summary_df <- tibble(
  level = c("Order", "Family"),
  count = c(order_count, family_count)
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
  height = 6,
  dpi = 300
)
