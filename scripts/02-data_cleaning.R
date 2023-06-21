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

# Select columns of interest # 
cleaned_respondent_info = 
  raw_respondent_info |>
  select(
    year,
    id,
    age,
    sex
  ) |>
  filter(year > 1973)
cleaned_respondent_info

#### Clean women in politics data ####
raw_women_in_politics <-
  read_csv(
      file = "inputs/data/raw_women_in_politics.csv",
      show_col_types = FALSE
    )

# Reunite labels #
raw_women_in_politics <-
  to_factor(raw_women_in_politics)
raw_women_in_politics

# Remove lines with NA, rename women in politics columns, and select relevant columns #
cleaned_fepol =
  raw_women_in_politics |>
    drop_na("fepol") |>
  rename(
    women_in_politics = fepol,
  ) |>
  select(year, id, women_in_politics)
cleaned_fepol

cleaned_fepolv =
  raw_women_in_politics |>
  drop_na("fepolv") |>
    rename(
      women_in_politics = fepolv,
    ) |>
  select(year, id, women_in_politics)
cleaned_fepolv

cleaned_fepolnv =
    raw_women_in_politics |>
  drop_na("fepolnv")|>
    rename(
      women_in_politics = fepolnv,
    ) |>
  select(year, id, women_in_politics)
cleaned_fepolnv

  # save fepol, fepolv, and fepolnv data #
  write_csv(
    x = cleaned_fepol,
    file = "cleaned_fepol.csv"
  )
  
  write_csv(
    x = cleaned_fepolv,
    file = "cleaned_fepolv.csv"
  )
  
  write_csv(
    x = cleaned_fepolnv,
    file = "cleaned_fepolnv.csv"
  )
  
  # Merge three seperate women in politics data sets into one #
  # Code referenced from: https://www.statmethods.net/management/merging.html
   cleaned_women_in_politics <- rbind (cleaned_fepol, cleaned_fepolv, cleaned_fepolnv)
   cleaned_women_in_politics
     
 
 #### Clean political preferences data ####
 raw_political_preferences <-
   read_csv(
     file = "inputs/data/raw_political_preferences.csv",
     show_col_types = FALSE
   )
 
 # Reunite labels #
 raw_political_preferences <-
   to_factor(raw_political_preferences)
 
 # Name organization #
 cleaned_political_preferences <-
   clean_names(raw_political_preferences)
 
 # Remove lines with NA #
summarized_political_preferences = 
 cleaned_political_preferences |>
   drop_na("polviews") |>
  drop_na("partyid")
(head(summarized_political_preferences))

 #### Save cleaned data ####
write_csv(
  x = cleaned_respondent_info,
  file = "inputs/data/cleaned_respondent_info.csv"
)

 write_csv(
   x = summarized_political_preferences,
   file = "inputs/data/summarized_political_preferences.csv"
 )

 