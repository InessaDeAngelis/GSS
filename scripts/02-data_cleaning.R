#### Preamble ####
# Purpose: Cleans the raw respondent demographic information, women in politics, and political preferences data sets
# Author: Inessa De Angelis
# Date: 17 June 2023
# Contact: inessa.deangelis@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 01-download_data.R

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)

#### Read in raw data sets ####

# Read in the raw respondent information data # 
readr::read_csv("inputs/data/raw_respondent_info.csv")

# Read in the raw women in politics data # 
readr::read_csv("inputs/data/raw_women_in_politics.csv")

# Read in the raw political preferences data # 
readr::read_csv("inputs/data/raw_political_preferences.csv")

#### Clean respondent information data ####
raw_respondent_info <-
  read_csv(
    file = "inputs/data/raw_respondent_info.csv",
    show_col_types = FALSE
  )

# Name organization #
cleaned_respondent_info <-
  clean_names(raw_respondent_info)

head(cleaned_respondent_info)

# Select columns of interest # 
cleaned_respondent_info <-
  cleaned_respondent_info |>
  select(
    year,
    id,
    age,
    sex
  )
  head(cleaned_respondent_info)
