# ============================================================
# Shiny App: COVID-19 Testing Volume and New Positive Cases
# VTPEH 6270 Final Project
# Author: Jiaru Wei
# ============================================================

library(shiny)
library(tidyverse)
library(bslib)
library(DT)
library(broom)
library(here)

# -----------------------------
# Read data
# -----------------------------

covid_analysis <- read_csv(
  here("data", "covid_analysis_clean.csv"),
  show_col_types = FALSE
)

covid_analysis <- covid_analysis %>%
  mutate(
    test_date = as.Date(test_date),
    county = as.character(county)
  )

# -----------------------------
# User Interface
# -----------------------------

ui <- page_navbar(
  title = "COVID-19 Testing and Positive Cases",
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = "#2C7FB8",
    base_font = font_google("Source Sans 3"),
    heading_font = font_google("Source Sans 3")
  ),
  header = tags$head(
    tags$style(HTML("
      body {
        background-color: #F7FAFC;
      }

      .navbar {
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      }

      .card {
        border-radius: 16px;
        border: 1px solid #E5E7EB;
        box-shadow: 0 4px 14px rgba(0,0,0,0.06);
        margin-bottom: 18px;
      }

      .card-header {
        background-color: #FFFFFF;
        font-weight: 700;
        font-size: 18px;
        border-bottom: 1px solid #E5E7EB;
      }

      .sidebar {
        background-color: #FFFFFF;
        border-radius: 16px;
      }

      h1, h2, h3, h4 {
        font-weight: 700;
      }

      .value-text {
        font-size: 18px;
        line-height: 1.6;
      }

      .small-note {
        color: #64748B;
        font-size: 14px;
      }

      a {
        font-weight: 600;
      }
    "))
  ),
  
  nav_panel(
    "Overview",
    
    card(
      card_body(
        h2("COVID-19 Testing and Positive Cases in New York State"),
        p(
          "An interactive dashboard exploring whether testing volume is associated with newly reported positive COVID-19 cases across New York State counties in 2023.",
          class = "value-text"
        ),
        p(
          "Use the tabs above to explore time trends, compare counties, and review regression and correlation results.",
          class = "small-note"
        )
      )
    ),
    
    layout_columns(
      col_widths = c(7, 5),
      
      card(
        card_header("Project Overview"),
        p("This Shiny app examines whether COVID-19 testing volume is associated with newly reported positive COVID-19 cases across New York State counties in 2023."),
        p(strong("Research question:")),
        p("Is COVID-19 testing volume associated with newly reported positive cases across New York State counties in 2023?"),
        p("The app allows users to explore county-level testing data, visualize trends, and examine the association between total tests performed and newly reported positive cases.")
      ),
      
      card(
        card_header("Project Information"),
        p(strong("Author:"), "Jiaru Wei"),
        p(strong("Course:"), "VTPEH 6270"),
        p(strong("Data source:"), "New York State Department of Health statewide COVID-19 testing data."),
        p(strong("Observation period:"), "January 1, 2023 to August 30, 2023"),
        p(strong("Unit of analysis:"), "County-date observation"),
        tags$a(
          "GitHub Repository",
          href = "https://github.com/Elara125/VTPEH6270-Final-Project",
          target = "_blank"
        )
      )
    ),
    
    card(
      card_header("App Goals"),
      tags$ul(
        tags$li("Explore COVID-19 testing and newly reported positive cases by county and date."),
        tags$li("Visualize time trends in testing volume and positive cases."),
        tags$li("Examine the association between total tests performed and newly reported positive cases using regression and correlation results.")
      )
    )
  ),
  
  nav_panel(
    "Data Explorer",
    layout_sidebar(
      sidebar = sidebar(
        selectInput(
          inputId = "county_filter",
          label = "Select county:",
          choices = c("All counties", sort(unique(covid_analysis$county))),
          selected = "All counties"
        ),
        
        dateRangeInput(
          inputId = "date_filter",
          label = "Select date range:",
          start = min(covid_analysis$test_date, na.rm = TRUE),
          end = max(covid_analysis$test_date, na.rm = TRUE),
          min = min(covid_analysis$test_date, na.rm = TRUE),
          max = max(covid_analysis$test_date, na.rm = TRUE)
        ),
        
        selectInput(
          inputId = "trend_variable",
          label = "Choose variable for trend plot:",
          choices = c(
            "New positive cases" = "new_positives",
            "Total tests performed" = "total_number_of_tests_performed"
          ),
          selected = "new_positives"
        ),
        
        helpText("Use the filters to explore trends for all counties or a selected county.")
      ),
      
      card(
        card_header("Summary Statistics"),
        DTOutput("summary_table", height = "auto")
      ),
      
      card(
        card_header("Time Trend"),
        plotOutput("trend_plot", height = "420px"),
        p("This figure helps show whether testing volume or newly reported positive cases changed across the available 2023 observation period. When all counties are selected, values are summed across counties for each date.")
      )
    )
  ),
  
  nav_panel(
    "Association Analysis",
    layout_sidebar(
      sidebar = sidebar(
        selectInput(
          inputId = "county_scatter",
          label = "Select county:",
          choices = c("All counties", sort(unique(covid_analysis$county))),
          selected = "All counties"
        ),
        
        checkboxInput(
          inputId = "show_smooth",
          label = "Show linear regression line",
          value = TRUE
        ),
        
        helpText("Select a county to see whether the testing-case association changes across counties.")
      ),
      
      card(
        card_header("Testing Volume and Newly Reported Positive Cases"),
        plotOutput("scatter_plot", height = "500px"),
        p("This scatterplot examines whether county-date observations with higher testing volume also tend to report more newly positive COVID-19 cases.")
      ),
      
      card(
        card_header("Interpretation"),
        textOutput("scatter_interpretation")
      )
    )
  ),
  
  nav_panel(
    "Regression Summary",
    layout_columns(
      col_widths = c(6, 6),
      
      card(
        card_header("Linear Regression Results"),
        DTOutput("regression_table"),
        p("The regression model estimates the association between total tests performed and newly reported positive cases.")
      ),
      
      card(
        card_header("Model Fit and Correlation"),
        DTOutput("model_fit_table"),
        verbatimTextOutput("correlation_text")
      )
    ),
    
    card(
      card_header("Main Interpretation"),
      textOutput("regression_interpretation")
    )
  ),
  
  nav_panel(
    "Methods & Links",
    card(
      card_header("Methods"),
      p("The analysis uses descriptive statistics, scatterplots, a simple linear regression model, and a Spearman correlation test."),
      p("The outcome variable is newly reported positive COVID-19 cases. The explanatory variable is total number of COVID-19 tests performed."),
      p("Because this is an observational analysis using surveillance data, the results should be interpreted as an association rather than evidence of causation."),
      p("The data are limited to the available 2023 observation period from January 1, 2023 through August 30, 2023.")
    ),
    
    card(
      card_header("Reproducibility and AI Disclosure"),
      p("All code and data files are available in the GitHub repository."),
      tags$a(
        "View GitHub Repository",
        href = "https://github.com/Elara125/VTPEH6270-Final-Project",
        target = "_blank"
      ),
      br(),
      br(),
      p("AI-based tools were used to help organize the app structure, debug R code, and improve wording. All analysis decisions, interpretation of results, and final edits were reviewed by the author.")
    )
  )
)

# -----------------------------
# Server
# -----------------------------

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    data <- covid_analysis %>%
      filter(
        test_date >= input$date_filter[1],
        test_date <= input$date_filter[2]
      )
    
    if (input$county_filter != "All counties") {
      data <- data %>%
        filter(county == input$county_filter)
    }
    
    data
  })
  
  scatter_data <- reactive({
    data <- covid_analysis
    
    if (input$county_scatter != "All counties") {
      data <- data %>%
        filter(county == input$county_scatter)
    }
    
    data
  })
  
  output$summary_table <- renderDT({
    data <- filtered_data()
    
    summary_data <- tibble(
      Statistic = c(
        "Number of observations",
        "Number of counties",
        "Start date",
        "End date",
        "Mean tests",
        "Median tests",
        "SD of tests",
        "Mean new positives",
        "Median new positives",
        "SD of new positives"
      ),
      Value = c(
        nrow(data),
        n_distinct(data$county),
        as.character(min(data$test_date, na.rm = TRUE)),
        as.character(max(data$test_date, na.rm = TRUE)),
        round(mean(data$total_number_of_tests_performed, na.rm = TRUE), 2),
        round(median(data$total_number_of_tests_performed, na.rm = TRUE), 2),
        round(sd(data$total_number_of_tests_performed, na.rm = TRUE), 2),
        round(mean(data$new_positives, na.rm = TRUE), 2),
        round(median(data$new_positives, na.rm = TRUE), 2),
        round(sd(data$new_positives, na.rm = TRUE), 2)
      )
    )
    
    datatable(
      summary_data,
      rownames = FALSE,
      options = list(
        dom = "t",
        paging = FALSE,
        ordering = FALSE
      )
    )
  })
  
  output$trend_plot <- renderPlot({
    data <- filtered_data()
    
    y_var <- input$trend_variable
    
    daily_data <- data %>%
      group_by(test_date) %>%
      summarise(
        value = sum(.data[[y_var]], na.rm = TRUE),
        .groups = "drop"
      )
    
    y_label <- ifelse(
      y_var == "new_positives",
      "New Positive Cases",
      "Total Number of Tests Performed"
    )
    
    ggplot(daily_data, aes(x = test_date, y = value)) +
      geom_line(linewidth = 0.9, color = "#2C7FB8") +
      geom_point(alpha = 0.55, color = "#08306B") +
      labs(
        title = paste(y_label, "Over Time"),
        x = "Date",
        y = y_label,
        caption = "Data source: New York State Department of Health COVID-19 testing data."
      ) +
      theme_minimal()
  })
  
  output$scatter_plot <- renderPlot({
    data <- scatter_data()
    
    p <- ggplot(
      data,
      aes(
        x = total_number_of_tests_performed,
        y = new_positives
      )
    ) +
      geom_point(alpha = 0.35, color = "#2C7FB8") +
      labs(
        title = "Testing Volume and Newly Reported Positive Cases",
        subtitle = ifelse(
          input$county_scatter == "All counties",
          "All New York State counties, 2023",
          paste(input$county_scatter, "County, 2023")
        ),
        x = "Total Number of Tests Performed",
        y = "New Positive Cases",
        caption = "Data source: New York State Department of Health COVID-19 testing data."
      ) +
      theme_minimal()
    
    if (input$show_smooth) {
      p <- p + geom_smooth(
        method = "lm",
        se = TRUE,
        color = "#08306B",
        fill = "#9ECAE1"
      )
    }
    
    p
  })
  
  output$scatter_interpretation <- renderText({
    data <- scatter_data()
    
    model <- lm(
      new_positives ~ total_number_of_tests_performed,
      data = data
    )
    
    slope <- coef(model)[["total_number_of_tests_performed"]]
    r_squared <- summary(model)$r.squared
    
    paste0(
      "For the selected data, the estimated regression coefficient is ",
      round(slope, 3),
      ". This means that each additional test is associated with about ",
      round(slope, 3),
      " additional newly reported positive cases on average. The R-squared value is ",
      round(r_squared, 3),
      ", meaning that testing volume explains about ",
      round(r_squared * 100, 1),
      "% of the variation in newly reported positive cases for the selected data."
    )
  })
  
  output$regression_table <- renderDT({
    data <- scatter_data()
    
    model <- lm(
      new_positives ~ total_number_of_tests_performed,
      data = data
    )
    
    regression_results <- tidy(model) %>%
      mutate(
        term = recode(
          term,
          "(Intercept)" = "Intercept",
          "total_number_of_tests_performed" = "Total tests performed"
        ),
        estimate = round(estimate, 4),
        std.error = round(std.error, 5),
        statistic = round(statistic, 2),
        p.value = ifelse(p.value < 0.001, "<0.001", as.character(round(p.value, 3)))
      ) %>%
      rename(
        Term = term,
        Estimate = estimate,
        `Standard Error` = std.error,
        `t statistic` = statistic,
        `p-value` = p.value
      )
    
    datatable(
      regression_results,
      rownames = FALSE,
      options = list(dom = "t", pageLength = 5)
    )
  })
  
  output$model_fit_table <- renderDT({
    data <- scatter_data()
    
    model <- lm(
      new_positives ~ total_number_of_tests_performed,
      data = data
    )
    
    model_fit <- glance(model) %>%
      transmute(
        `R-squared` = round(r.squared, 3),
        `Adjusted R-squared` = round(adj.r.squared, 3),
        `Residual standard error` = round(sigma, 2),
        `F statistic` = round(statistic, 2),
        `p-value` = ifelse(p.value < 0.001, "<0.001", as.character(round(p.value, 3))),
        `Sample size` = nobs
      )
    
    datatable(
      model_fit,
      rownames = FALSE,
      options = list(dom = "t", pageLength = 5)
    )
  })
  
  output$correlation_text <- renderPrint({
    data <- scatter_data()
    
    cor_result <- cor.test(
      data$total_number_of_tests_performed,
      data$new_positives,
      method = "spearman"
    )
    
    cat("Spearman correlation\n")
    cat("--------------------\n")
    cat("rho:", round(unname(cor_result$estimate), 3), "\n")
    cat("p-value:", ifelse(cor_result$p.value < 0.001, "<0.001", round(cor_result$p.value, 3)), "\n")
  })
  
  output$regression_interpretation <- renderText({
    data <- scatter_data()
    
    model <- lm(
      new_positives ~ total_number_of_tests_performed,
      data = data
    )
    
    slope <- coef(model)[["total_number_of_tests_performed"]]
    r_squared <- summary(model)$r.squared
    
    paste0(
      "The selected data show a positive association between COVID-19 testing volume and newly reported positive cases. ",
      "The regression coefficient is ",
      round(slope, 3),
      ", and the model explains approximately ",
      round(r_squared * 100, 1),
      "% of the variation in new positive cases. ",
      "Because this is observational surveillance data, this finding should be interpreted as an association rather than a causal relationship."
    )
  })
}

# -----------------------------
# Run app
# -----------------------------

shinyApp(ui = ui, server = server)