# ================================
# 02_analysis.R
# COVID-19 Testing Final Project
# ================================

library(tidyverse)
library(here)
library(broom)

# Read cleaned data
covid_analysis <- read_csv(
  here("data", "covid_analysis_clean.csv")
)

# Descriptive statistics
summary_table <- covid_analysis %>%
  summarise(
    n_observations = n(),
    n_counties = n_distinct(county),
    start_date = min(test_date, na.rm = TRUE),
    end_date = max(test_date, na.rm = TRUE),
    mean_tests = mean(total_number_of_tests_performed, na.rm = TRUE),
    median_tests = median(total_number_of_tests_performed, na.rm = TRUE),
    sd_tests = sd(total_number_of_tests_performed, na.rm = TRUE),
    mean_new_positives = mean(new_positives, na.rm = TRUE),
    median_new_positives = median(new_positives, na.rm = TRUE),
    sd_new_positives = sd(new_positives, na.rm = TRUE)
  )

write_csv(
  summary_table,
  here("outputs", "tables", "summary_table.csv")
)

# Scatterplot with regression line
scatter_plot <- ggplot(
  covid_analysis,
  aes(
    x = total_number_of_tests_performed,
    y = new_positives
  )
) +
  geom_point(alpha = 0.35) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Association Between COVID-19 Testing Volume and New Positive Cases",
    subtitle = "New York State counties, 2023",
    x = "Total Number of Tests Performed",
    y = "New Positive Cases",
    caption = "Data source: New York State Department of Health COVID-19 testing data."
  ) +
  theme_minimal()

scatter_plot

ggsave(
  filename = here("outputs", "figures", "scatter_tests_positives.png"),
  plot = scatter_plot,
  width = 8,
  height = 5,
  dpi = 300
)

# Linear regression model
model <- lm(
  new_positives ~ total_number_of_tests_performed,
  data = covid_analysis
)

summary(model)

# Save regression results
model_results <- tidy(model)
model_fit <- glance(model)

write_csv(
  model_results,
  here("outputs", "tables", "regression_results.csv")
)

write_csv(
  model_fit,
  here("outputs", "tables", "model_fit_statistics.csv")
)

# Correlation test
correlation_result <- cor.test(
  covid_analysis$total_number_of_tests_performed,
  covid_analysis$new_positives,
  method = "spearman"
)

correlation_result
