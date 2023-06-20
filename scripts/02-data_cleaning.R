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
library(labelled)

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

# Reunite labels #
# Based on code from: https://tellingstorieswithdata.com/08-hunt.html 
raw_respondent_info <-
  to_factor(raw_respondent_info)

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

#### Clean women in politics data ####
cleaned_women_in_politics <-
  read_csv(
      file = "inputs/data/raw_women_in_politics.csv",
      show_col_types = FALSE
    )

# Reunite labels #
raw_women_in_politics <-
  to_factor(raw_women_in_politics)
  
# Name organization #
  cleaned_women_in_politics <-
  clean_names(raw_women_in_politics)
  cleaned_women_in_politics 
head(cleaned_women_in_politics)
  
# Remove lines with NA #
  cleaned_women_in_politics |>
    drop_na("fepol") 
  
  cleaned_women_in_politics |>
    drop_na("fepolv") 
  
  cleaned_women_in_politics |>
    drop_na("fepolnv") 
  
# Combine fepol, fepolv, and fepolnv columns #
  cleaned_women_in_politics |>
    unite(Women_in_Politics, c('fepol', 'fepolv', 'fepolnv'), sep='/')
  