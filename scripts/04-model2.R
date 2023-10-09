#### Preamble ####
# Purpose: Models the data
# Author: Inessa De Angelis
# Date: 5 October 2023
# Contact: inessa.deangelis@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# 01-download_data.R
# 02-data_cleaning.R
# 03-test_data.R

#### Workspace set up ####
library(tidyverse)
library(rstanarm)
library(modelsummary)
library(marginaleffects)
library(knitr)

#### Read data #####
# Read in the cleaned respondent information data # 
cleaned_respondent_info <- read.csv(here::here("outputs/data/cleaned_respondent_info.csv"))
show_col_types = FALSE

# Read in the cleaned women in politics data # 
cleaned_women_in_politics <- read.csv(here::here("outputs/data/cleaned_women_in_politics.csv"))
show_col_types = FALSE

# Read in the summarized political preferences data # 
summarized_political_preferences <- read_csv(here::here("outputs/data/summarized_political_preferences.csv"))
show_col_types = FALSE

# Create combined demographic info and women in pol data sets for analysis #
women_in_pol <-
  cleaned_women_in_politics |>
  mutate(women_in_politics) 
analysis_data <- merge(cleaned_respondent_info, women_in_pol) 

analysis_data_2 <-
  analysis_data |>
  mutate(
    women_in_politics = case_when(
      women_in_politics == "Agree" ~ 1,
      women_in_politics == "Disagree" ~ 2,
    ),
    women_in_politics = as_factor(women_in_politics),
    gender = case_when(
      gender == "Male" ~ 1,
      gender == "Female" ~ 2,
    ),
    gender = as_factor(gender),
    age = case_when(
      age >= 18 & age <= 29 ~ "18-29",
      age >= 30 & age <= 39 ~ "30-39",
      age >= 40 & age <= 49 ~ "40-49",
      age >= 50 & age <= 64 ~ "50-64",
      age >= 65 & age <= 79 ~ "65-79",
      age >= 79 ~ "80-89"
    ),
    age = factor(
      age,
      levels = c(
        "18-29",
        "30-39",
        "40-49",
        "50-64",
        "65-79",
        "80-89"
      )
    )
  ) |>
  select(women_in_politics, gender, age)

#### Model ####
age_gender_women <-
  stan_glm(
    women_in_politics ~ gender + age,
    data = analysis_data_2,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 3, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 3, autoscale = TRUE),
    seed = 16
  )
age_gender_women

# Save model #
saveRDS(
age_gender_women, file = "age_gender_women.rds"
)

# Interpretation #
age_gender_women <-
  readRDS(file = "age_gender_women.rds")

modelsummary(
  list(
    "Support Women in Pol" = age_gender_women
  ),
  statistic = "mad"
)