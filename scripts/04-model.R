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
analysis_data <- merge(cleaned_respondent_info, women_in_pol)

# Test combined data set #
class(analysis_data$year) == "integer"
class(analysis_data$id) == "integer"
class(analysis_data$age) == "integer"
class(analysis_data$gender) == "character"
class(analysis_data$women_in_politics) == "character"

#### Model data ####
model <- lm(age ~ women_in_politics, data = analysis_data)
model

summary(model)
