#### Preamble ####
# Purpose: Downloads and saves data from US General Social Survey
# Author: Inessa De Angelis
# Date: 12 June 2023
# Contact: inessa.deangelis@mail.utoronto.ca 
# License: MIT
# Pre-requisites: None
# Data set: https://gss.norc.org/ 


#### Workspace setup ####
library(tidyverse)
library(haven)
library(here)

#### Download data ####
# Download & unzip GSS data from all years
zip_file <- "inputs/data/large_files/GSS_stata.zip"

download.file("https://gss.norc.org/documents/stata/GSS_stata.zip", zip_file)
unzip(zip_file, exdir = "inputs/data/large_files")

# read dta data and write to csv
raw_gss_data <- read_dta(here::here("inputs/data/large_files/GSS_stata/gss7222_r1.dta"))

# filter survey data and select relevant data
raw_respondent_info <-
  raw_gss_data |> 
  select(
    year,
    id,
    age,
    sex,
    educ,
    income,
    marital
  )
 
# save raw respondent info data #
write_csv(
  x = raw_respondent_info,
  file = "inputs/data/raw_respondent_info.csv"
)

# select women in politics data #
raw_women_in_politics <-
raw_gss_data |> 
  select(
    year,
    id,
    fepol,
    fepolv,
    fepolnv
  )

# save raw women in politics data #
write_csv(
  x = raw_women_in_politics,
  file = "inputs/data/raw_women_in_politics.csv"
)

# select political preferences data #
raw_political_preferences <-
  raw_gss_data |> 
  select(
    year,
    id,
    polviews,
    partyid
  )

# save raw political preferences data #
write_csv(
  x = raw_political_preferences,
  file = "inputs/data/raw_political_preferences.csv"
)