# This script generates summary statistics and figures for taxonomic coverage
# Output: figures/taxonomic_coverage_orders_families.png
# Code developed by Israel L. Cunha-Neto, with assistance from ChatGPT (OpenAI).

# Load packages
library(dplyr)
library(ggplot2)
library(readr)
library(scales)  # for nice number formatting (optional)

# Path to CSV
csv_path <- "data/global-survey/Table 2.csv"
if (!file.exists(csv_path)) stop(paste("CSV not found at", csv_path))

# Read table
taxa <- read_csv(csv_path, show_col_types = FALSE)
names(taxa) <- trimws(names(taxa))

cat("CSV read successfully. Rows:", nrow(taxa), "Columns:", ncol(taxa), "\n")
cat("Columns:", paste(colnames(taxa), collapse = ", "), "\n")

# ------------------------------------
# SUMMARIES
# ------------------------------------
order_count  <- n_distinct(taxa$Order)
family_count <- n_distinct(taxa$Family)

cat("Orders:", order_count, "Families:", family_count, "\n")

summary_df <- tibble(
  level = factor(c("Order", "Family"), levels = c("Family", "Order")), # controls vertical order
  count = c(order_count, family_count)
)

# ---- Plot (two horizontal bars with totals at the end) ----
p <- ggplot(summary_df, aes(y = level, x = count)) +
  geom_col(fill = "grey") +
  geom_text(
    aes(label = comma(count)),
    hjust = -0.15, size = 5
  ) +
  labs(
    x = "Number represented in the database",
    y = NULL,
    title = "Current taxonomic coverage of vascular variants"
  ) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.10)), labels = comma) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

# ------------------------------------
# SAVE FIGURE
# ------------------------------------
ggsave("summary/taxonomic_coverage_orders_families.png"),
       plot = p, width = 7, height = 4, dpi = 300)
cat("Figure saved successfully!\n")
``
#End of code
