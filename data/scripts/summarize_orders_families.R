library(dplyr)
library(ggplot2)
library(readr)

csv_path <- "data/global-survey/Table 2.csv"
if(!file.exists(csv_path)) stop(paste("CSV not found at", csv_path))

taxa <- read_csv(csv_path, show_col_types = FALSE)
names(taxa) <- trimws(names(taxa))

cat("CSV read successfully. Rows:", nrow(taxa), "Columns:", ncol(taxa), "\n")
cat("Columns:", paste(colnames(taxa), collapse=", "), "\n")

order_count <- n_distinct(taxa$Order)
family_count <- n_distinct(taxa$Family)

cat("Orders:", order_count, "Families:", family_count, "\n")

summary_df <- tibble(
  level = c("Order", "Family"),
  count = c(order_count, family_count)
)

p <- ggplot(summary_df, aes(x = level, y = count)) +
  geom_col(width = 0.6, fill = "darkgreen") +
  geom_text(aes(label = count), vjust = -0.4, size = 5) +
  labs(
    x = NULL,
    y = "Number represented in the database",
    title = "Current taxonomic coverage of vascular variants"
  ) +
  theme_minimal(base_size = 14)

ggsave("data/figures/taxonomic_coverage_orders_families.png", plot = p,
       width = 6, height = 6, dpi = 300)

cat("Figure saved successfully!\n")
