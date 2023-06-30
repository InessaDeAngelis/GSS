#### Preamble ####
# Purpose: Tests the three cleaned data sets
# Author: Inessa De Angelis
# Date: 21 June 2023
# Contact: inessa.deangelis@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # 01-download_data.R
  # 02-data_cleaning.R

#### Workspace setup ####
library(tidyverse)
library(here)

#### Read in cleaned data sets ####
# Read in the cleaned respondent information data # 
cleaned_respondent_info <- read.csv(here::here("outputs/data/cleaned_respondent_info.csv"))
show_col_types = FALSE

# Read in the cleaned women in politics data # 
cleaned_women_in_politics <- read.csv(here::here("outputs/data/cleaned_women_in_politics.csv"))
show_col_types = FALSE

# Read in the summarized political preferences data # 
summarized_political_preferences <- read_csv(here::here("outputs/data/summarized_political_preferences.csv"))
show_col_types = FALSE

#### Validate the cleaned respondent info data ####
# Check that responses range from 1974 through 2022 #
min(cleaned_respondent_info$year) <= 1974
max(cleaned_respondent_info$year) >= 2022
sum(is.na(cleaned_respondent_info$year)) == 0

# Check that respondent ages range from 18 to 90 #
class(cleaned_respondent_info$age) == "integer"
min(cleaned_respondent_info$age, na.rm = TRUE) >= 18
max(cleaned_respondent_info$age, na.rm = TRUE) <= 90

# Check that the gender of respondents are either male or female #
class(cleaned_respondent_info$gender) == "character"
cleaned_respondent_info |>
  group_by(gender) |>
 summarise()

#### Validate the cleaned women in politics data ####
# Check that responses range from 1974 through 2022 #
min(cleaned_women_in_politics$year) <= 1974
max(cleaned_women_in_politics$year) >= 2022
sum(is.na(cleaned_women_in_politics$year)) == 0

# Check that respondents can either agree or disagree about women belonging in politics #
class(cleaned_women_in_politics$women_in_politics) == "character"
cleaned_women_in_politics |>
  group_by(women_in_politics) |>
  summarise()

#### Validate the summarized political preferences data ####
# Check that responses range from 1974 through 2022 #
min(summarized_political_preferences$year) <= 1974
max(summarized_political_preferences$year) >= 2022
sum(is.na(summarized_political_preferences$year)) == 0

# Check political views range from Extremely liberal to Extremely conservative # 
# Code referenced from: https://github.com/christina-wei/Financial-Wellness-in-US/blob/main/scripts/03-test_data.R
class(summarized_political_preferences$political_views) == "character"
sum(!(unique(summarized_political_preferences$political_views) %in%
        c("Extremely Liberal",
          "Liberal",
          "Slightly Liberal",
          "Moderate",
          "Slightly Conservative",
          "Conservative",
          "Extremely Conservative",
          NA))) == 0

summarized_political_preferences$political_views |>
  unique() |>
  length() == 7

# Check party ids range from Strong Democrat to Other # 
class(summarized_political_preferences$party_identification) == "character"
sum(!(unique(summarized_political_preferences$party_identification) %in%
        c("Strong Democrat",
          "Not Strong Democrat",
          "Independent, Close to Democrat",
          "Independent",
          "Independent, Close to Republican",
          "Not Strong Republican",
          "Strong Republican",
          "Other",
          NA))) == 0

summarized_political_preferences$party_identification |>
  unique() |>
  length() == 8
  