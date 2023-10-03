#### Preamble ####
# Purpose: Models the data
# Author: Inessa De Angelis
# Date: 1 October 2023
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

# Create combine demographic info and women in pol data sets for analysis #
women_in_pol <-
cleaned_women_in_politics |>
 mutate(women_in_politics) 
analysis_data <- merge(cleaned_respondent_info, women_in_pol) |>
  mutate("age" = case_when(
    age >= 18 & age <= 29 ~ "18-29",
    age >= 30 & age <= 39 ~ "30-39",
    age >= 40 & age <= 49 ~ "40-49",
    age >= 50 & age <= 64 ~ "50-64",
    age >= 65 & age <= 79 ~ "65-79",
    age >= 79 ~ "80-89"
  ))

# Test combined data set #
class(analysis_data$year) == "integer"
class(analysis_data$id) == "integer"
class(analysis_data$age) == "character"
class(analysis_data$gender) == "character"
class(analysis_data$women_in_politics) == "character"

# Make binary data set with whether they agree or disagree #
analysis_data_binary <-
  analysis_data |>
  select(age, women_in_politics) |>
  mutate(women_binary = if_else(women_in_politics == "Agree",
                                1,
                                0))

# Test binary data set #
class(analysis_data_binary$age) == "character"
class(analysis_data_binary$women_in_politics) == "character"
class(analysis_data_binary$women_binary) == "numeric"

#### Model data ####
age_and_gender <-
  glm(
    women_binary ~ age, 
    data = analysis_data_binary,
    family = "binomial"
  )
age_and_gender

summary(age_and_gender)

# Save model #
saveRDS(age_and_gender, "Outputs/model/age_and_gender.rds")

# Predictions #
age_and_gender_predictions <-
  predictions(age_and_gender) |>
  as_tibble()
age_and_gender_predictions
