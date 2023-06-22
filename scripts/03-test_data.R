#### Preamble ####
# Purpose: Tests the three cleaned data sets
# Author: Inessa De Angelis
# Date: 11 February 2023 [...UPDATE THIS...]
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

# Read in the cleaned & summarized political preferences data # 
summarized_political_preferences <- read_csv(here::here("outputs/data/summarized_political_preferences.csv"))
show_col_types = FALSE

#### Validate cleaned data ####
# Check that responses range from 1974 through 2022 #
min(cleaned_respondent_info$year) <= 1974
max(cleaned_respondent_info$year) >= 2022