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

#### Read in cleaned data sets ####
# Read in the cleaned respondent information data # 
readr::read_csv("outputs/data/cleaned_respondent_info.csv")

# Read in the cleaned women in politics data # 
readr::read_csv("outputs/data/cleaned_women_in_politics.csv")

# Read in the cleaned & summarized political preferences data # 
readr::read_csv("outputs/data/summarized_political_preferences.csv")