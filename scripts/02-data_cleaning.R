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

# Select columns of interest, filter by relevant year, rename column # 
cleaned_respondent_info = 
  raw_respondent_info |>
  select(
    year,
    id,
    age,
    sex
  ) |>
  filter(year == 1974 | year == 1975 | year == 1977 | year == 1978 | year == 1982 | year == 1983 | year == 1985 | year == 1986 | year == 1988 | year == 1989 | year == 1990 | year == 1991 | year == 1993 | year == 1994 | year == 1996 | year == 1998 | year == 2000 | year == 2002 | year == 2004 | year == 2006 | year == 2008 | year == 2010 | year == 2012 | year == 2014 | year == 2016 | year == 2018 | year == 2021 | year == 2022) |>
  mutate(
   age = as.numeric(age)
  )|>
  rename(
    gender = sex,
  ) 
cleaned_respondent_info

# Case Match #
#Code referenced from: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html 
cleaned_respondent_info <-
  cleaned_respondent_info |>
  mutate("gender" = case_when(
    gender == 1 ~ "Male",
    gender == 2 ~ "Female",
  )) |>
select(year, id, age, gender) 
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
  
  # Merge three separate women in politics data sets into one #
  # Code referenced from: https://www.statmethods.net/management/merging.html
   cleaned_women_in_politics <- rbind (cleaned_fepol, cleaned_fepolv, cleaned_fepolnv)
   cleaned_women_in_politics

   # Case match #
   cleaned_women_in_politics <-
     cleaned_women_in_politics |>
     mutate("women_in_politics" = case_when(
       women_in_politics == 1 ~ "Agree",
       women_in_politics == 2 ~ "Disagree",
     )) |>
     select(year, id, women_in_politics)
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
 
 # Remove lines with NA & select specific years #
summarized_political_preferences = 
 cleaned_political_preferences |>
   drop_na("polviews") |>
  drop_na("partyid") |>
  filter(year == 1974 | year == 1975 | year == 1977 | year == 1978 | year == 1982 | year == 1983 | year == 1985 | year == 1986 | year == 1988 | year == 1989 | year == 1990 | year == 1991 | year == 1993 | year == 1994 | year == 1996 | year == 1998 | year == 2000 | year == 2002 | year == 2004 | year == 2006 | year == 2008 | year == 2010 | year == 2012 | year == 2014 | year == 2016 | year == 2018 | year == 2021 | year == 2022) |>
  rename(
    political_views = polviews,
    party_identification = partyid,
  )
summarized_political_preferences

# Case match #
summarized_political_preferences <-
  summarized_political_preferences |>
  mutate("political_views" = case_when(
    political_views == 1 ~ "Extremely Liberal",
    political_views == 2 ~ "Liberal",
    political_views == 3 ~ "Slightly Liberal",
    political_views == 4 ~ "Moderate",
    political_views == 5 ~ "Slightly Conservative",
    political_views == 6 ~ "Conservative",
    political_views == 7 ~ "Extremely Conservative"
  )) |>
  mutate("party_identification" = case_when(
    party_identification == 0 ~ "Strong Democrat",
    party_identification == 1 ~ "Not Strong Democrat",
    party_identification == 2 ~ "Independent, Close to Democrat",
    party_identification == 3 ~ "Independent",
    party_identification == 4 ~ "Independent, Close to Republican",
    party_identification == 5 ~ "Not Strong Republican",
    party_identification == 6 ~ "Strong Republican",
    party_identification == 7 ~ "Other"
  )) |>
  select(year, id, political_views, party_identification)
summarized_political_preferences

 #### Save cleaned data ####
write_csv(
  x = cleaned_respondent_info,
  file = "outputs/data/cleaned_respondent_info.csv"
)

write_csv(
  x = cleaned_women_in_politics,
  file = "outputs/data/cleaned_women_in_politics.csv"
)

 write_csv(
   x = summarized_political_preferences,
   file = "outputs/data/summarized_political_preferences.csv"
 )
 