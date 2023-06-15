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

#### Download data ####
# Download & unzip GSS data from all years
zip_file <- "inputs/data/large_files/GSS_stata.zip"

download.file("https://gss.norc.org/documents/stata/GSS_stata.zip", zip_file)
unzip(zip_file, exdir = "inputs/data/large_files")

# read dta data and write to csv
raw_gss_data <- read_dta("inputs/data/large_files/gss7222_r1.dta")

# filter survey data and select relevant data
raw_respondent_info <-
  raw_gss_data |> 
  select(
    year,
    id,
  )
 
