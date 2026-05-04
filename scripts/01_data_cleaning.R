# ================================
# 01_data_cleaning.R
# COVID-19 Testing Final Project
# ================================

library(tidyverse)
library(here)
library(janitor)

# Read raw data
covid_raw <- read_csv(
  here("data", "raw", "NYS_Statewide_COVID-19_Testing_2023.csv")
)

# Check variable names
names(covid_raw)

# Clean variable names
covid_clean <- covid_raw %>%
  clean_names()

# Check cleaned variable names
names(covid_clean)

# Keep variables needed for the final project
covid_analysis <- covid_clean %>%
  select(
    test_date,
    county,
    new_positives,
    total_number_of_tests_performed
  ) %>%
  mutate(
    test_date = as.Date(test_date, format = "%m/%d/%Y"),
    new_positives = as.numeric(new_positives),
    total_number_of_tests_performed = as.numeric(gsub(",", "", total_number_of_tests_performed))
  ) %>%
  filter(
    test_date >= as.Date("2023-01-01"),
    test_date <= as.Date("2023-12-31"),
    !is.na(test_date),
    !is.na(new_positives),
    !is.na(total_number_of_tests_performed),
    total_number_of_tests_performed >= 0,
    new_positives >= 0
  )

# Save cleaned data
write_csv(
  covid_analysis,
  here("data", "covid_analysis_clean.csv")
)

# Quick check
glimpse(covid_analysis)
summary(covid_analysis)
