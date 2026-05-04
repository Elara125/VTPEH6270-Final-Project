# COVID-19 Testing Volume and Newly Reported Positive Cases in New York State Counties, 2023

## Author

Jiaru Wei  
Cornell University  
VTPEH 6270  

## Project Description

This final project examines whether COVID-19 testing volume is associated with newly reported positive COVID-19 cases across New York State counties in 2023. The project uses publicly available COVID-19 testing data from the New York State Department of Health.

## Research Question

Is COVID-19 testing volume associated with newly reported positive cases across New York State counties in 2023?

## Data Source

The dataset used in this project comes from the New York State Department of Health statewide COVID-19 testing data available through Health Data NY.

Although the research question focuses on 2023, the available dataset used for this analysis includes records from January 1, 2023 through August 30, 2023. Therefore, the results should be interpreted as reflecting the available 2023 observation period rather than the full calendar year.

## Variables

The main outcome variable is newly reported positive COVID-19 cases.

The main explanatory variable is COVID-19 testing volume, measured as the total number of tests performed.

The unit of analysis is a county-date observation, meaning that each row represents one county on one test date.

## Methods

The analysis includes:

- Descriptive statistics for testing volume and newly reported positive cases
- A scatterplot with a fitted linear regression line
- A simple linear regression model
- A Spearman correlation test
- Model diagnostic plots to assess assumptions and limitations

## Key Finding

The analysis found a strong positive association between COVID-19 testing volume and newly reported positive cases. The linear regression model showed that higher testing volume was associated with higher reported positive case counts. However, this relationship should be interpreted as an association rather than evidence of causation.

## Repository Structure

```text
VTPEH6270-Final-Project/
├── README.md
├── final_report.Rmd
├── final_report.pdf
├── data/
│   ├── raw/
│   │   └── NYS_Statewide_COVID-19_Testing_2023.csv
│   └── covid_analysis_clean.csv
├── scripts/
│   ├── 01_data_cleaning.R
│   └── 02_analysis.R
├── outputs/
│   ├── figures/
│   └── tables/
└── app.R
```

## How to Run This Project

1. Clone or download this repository.
2. Open `VTPEH6270-Final-Project.Rproj` in RStudio.
3. Install the required R packages if needed.
4. Run `scripts/01_data_cleaning.R` to clean the data.
5. Run `scripts/02_analysis.R` to generate analysis outputs.
6. Open and knit `final_report.Rmd` to generate the PDF report.
7. Run `app.R` to launch the Shiny app.

## Required R Packages

```r
install.packages(c("tidyverse", "here", "janitor", "broom", "knitr", "shiny", "bslib", "DT"))
```

## Final Report

The final report is available as:

- `final_report.Rmd`
- `final_report.pdf`

## Shiny App

The Shiny app link will be added after deployment.

## Reproducibility

All code, data, and outputs needed to reproduce the analysis are included in this repository. The project uses relative paths through the `here` package to improve reproducibility across computers.

## AI Use Disclosure

AI-based tools were used to help organize the report structure, debug R code, and improve wording. All data analysis decisions, interpretation of results, and final edits were reviewed by the author.

## Reference

New York State Department of Health. Statewide COVID-19 Testing Data. Health Data NY. Accessed May 2026. https://health.data.ny.gov/