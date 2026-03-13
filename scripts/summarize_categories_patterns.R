# This script generates table summary statistics for taxonomic coverage
# Outputs: summary/vascular_variant_category_summary.csv & summary/vascular_variant_pattern_summary.csv
# Code developed by Israel L. Cunha-Neto, with assistance from ChatGPT (OpenAI).

library(dplyr)
library(readr)

# Path to CSV
csv_path <- file.path("data", "global-survey", "Table 2.csv")
if(!file.exists(csv_path)) stop(paste("CSV not found at", csv_path))

# Read table
taxa <- read_csv(csv_path, show_col_types = FALSE)

# Clean column names and whitespace
names(taxa) <- trimws(names(taxa))
taxa <- taxa %>% mutate(across(everything(), trimws))

cat("Rows:", nrow(taxa), "Columns:", ncol(taxa), "\n")

# ------------------------------------
# CATEGORY SUMMARY
# ------------------------------------

category_summary <- taxa %>%
  distinct(`Vascular Variant Category`, Order, Family) %>%
  group_by(`Vascular Variant Category`) %>%
  summarise(
    Orders = n_distinct(Order),
    Families = n_distinct(Family),
    .groups = "drop"
  )

# Force logical order
category_summary$`Vascular Variant Category` <- factor(
  category_summary$`Vascular Variant Category`,
  levels = c("Procambial variants", "Cambial variants", "Ectopic cambia")
)

category_summary <- category_summary %>%
  arrange(`Vascular Variant Category`)

cat("\nCATEGORY SUMMARY\n")
print(category_summary)

# ------------------------------------
# PATTERN SUMMARY
# ------------------------------------

pattern_summary <- taxa %>%
  distinct(`Vascular Variant Category`,
           `Vascular Variant Pattern`,
           Order,
           Family) %>%
  group_by(`Vascular Variant Category`,
           `Vascular Variant Pattern`) %>%
  summarise(
    Orders = n_distinct(Order),
    Families = n_distinct(Family),
    .groups = "drop"
  )

# Maintain category order
pattern_summary$`Vascular Variant Category` <- factor(
  pattern_summary$`Vascular Variant Category`,
  levels = c("Procambial variants", "Cambial variants", "Ectopic cambia")
)

pattern_summary <- pattern_summary %>%
  arrange(`Vascular Variant Category`,
          `Vascular Variant Pattern`)

cat("\nPATTERN SUMMARY\n")
print(pattern_summary)

# ------------------------------------
# SAVE TABLES
# ------------------------------------

category_summary <- category_summary %>%
  arrange(`Vascular Variant Category`)

pattern_summary <- pattern_summary %>%
  arrange(`Vascular Variant Category`, `Vascular Variant Pattern`)

output_dir <- file.path("data", "global-survey")
output_dir <- file.path("/Users/israelneto/Library/CloudStorage/OneDrive-FloridaInternationalUniversity/Work/Research/VV Database/GitHub/Testing_scripts")

write_csv(
  category_summary,
  file.path(output_dir, "vascular_variant_category_summary.csv")
)

write_csv(
  pattern_summary,
  file.path(output_dir, "vascular_variant_pattern_summary.csv")
)

cat("\nSummary tables saved successfully in data/global-survey/\n")

# End of code
