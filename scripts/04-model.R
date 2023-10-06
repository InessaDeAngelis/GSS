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

# Create combined demographic info and women in pol data sets for analysis #
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
nrow(analysis_data) == 39341

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
nrow(analysis_data_binary) == 39341

#### Age & Gender Model data ####
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

# Graph #
age_and_gender_predictions|>
  mutate(women_in_politics = factor(women_binary)) |>
  ggplot(aes(x = age, y = estimate, color = women_binary)) +
  geom_jitter(width = 0.2, height = 0.0, alpha = 0.3) +
  labs(
    x = "Severity of Harassment",
    y = "Estimated probability that an age group supports women in politics",
    color = "Women in Politics"
  ) +
  theme_classic() +
  theme(axis.text.x = element_text(angle=45, hjust = 1, size = 10)) + 
  theme(legend.position = "bottom") +
  theme(legend.text = element_text(size = 6)) +
  theme(legend.title = element_text(size = 9)) 

# Estimates only #
just_the_estimates <-
  age_and_gender_predictions |>
  select(estimate, women_binary, age) |>
  unique()

age_and_gender_predictions |>
  mutate(women_in_politics = factor(women_binary)) |>
  count(age, women_binary) |>
pivot_wider(names_from = women_binary,
            values_from = n) |>
  mutate(`0` = if_else(is.na(`0`), 0, `0`)) |>
  mutate(proportion_supporting = `1` / (`0` + `1`)) |>
  rename("Disagree" = `0`,
         "Agree" = `1`) |>
  left_join(just_the_estimates, by = join_by(age))

slopes(age_and_gender, newdata = "median")