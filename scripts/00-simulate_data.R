#### Preamble ####
# Purpose: Simulates respondent demographic information, women in politics, and political preferences data sets
# Author: Inessa De Angelis
# Date: 12 June 2023
# Contact: inessa.deangelis@mail.utoronto.ca
# License: MIT
# Pre-requisites: None 

#### Workspace setup ####
library(tidyverse)
library(janitor)

#### Data expectations ####
# Agreement varies with the statement that men are better suited emotionally for politics than women
# Agreement varies by gender with the statement that men are better suited emotionally for politics than women
# Agreement varies over time with the statement that men are better suited emotionally for politics than women
# Political views vary on a scale from 1-7 from extremely liberal, to moderate, to extremely conservative 
# Party affiliation varies on a scale from 0-7 from strong Democrat, to independent/neutral, to strong Republican
# People with more liberal political views will disagree that men are emotionally better suited for politics than women
# People with more conservative views will agree that men are emotionally better suited for politics than women

#### Simulate responses to men being better suited emotionally for politics than women ####
#Code referenced from: https://tellingstorieswithdata.com/08-hunt.html
set.seed(416)

num_people <- 5000

population <- tibble(
  person = 1:num_people,
  men_better_suited = sample(c("Agree", "Disagree"), size = num_people, replace = TRUE),
)
population

#### Simulate responses by gender to men being better suited emotionally for politics than women ####
set.seed(416)

num_people <- 5000

responses <- tibble(
  person = 1:num_people,
  men_better_suited = sample(c("Agree", "Disagree"), size = num_people, replace = TRUE), 
  gender = sample(c("Male", "Female"), size = num_people, replace = TRUE), 
)
responses

#### Simulate responses over time to men being better suited emotionally for politics than women ####
set.seed(416)

num_people <- 5000

over_time <- tibble(
  person = 1:num_people,
  men_better_suited = sample(c("Agree", "Disagree"), size = num_people, replace = TRUE), 
  "year" = x <- sample(1974:2022, 5000, replace=T),
)
over_time

#### Simulate varying political views ####
set.seed(416)

num_people <- 5000

simulated_data <-tibble(
    person = 1:num_people,
#use Extremely liberal through Extremely conservative  to represent political views 
    political_views = sample(c("Extremely Liberal", "Liberal", "Slightly Liberal", "Moderate", "Slightly Conservative", "Conservative", "Extremely Conservative"), size = num_people, replace = TRUE),
)
simulated_data

#### Simulate varying party affiliation ####
set.seed(416)

num_people <- 5000

simulate_data <-tibble(
  person = 1:num_people,
  #use Strong Democrat through Other to represent political views 
  party_affiliation = sample(c("Strong Democrat", "Not Strong Democrat", "Independent, Close to Democrat", "Independent", "Independent, Close to Republican", "Not Strong Republican", "Strong Republican", "Other"), size = num_people, replace = TRUE),
)
simulate_data

#### Simulate more liberal political views / disagree that men are emotionally better suited for politics ####
# Code referenced from: https://tellingstorieswithdata.com/06-farm.html#probabilistic-sampling
set.seed(416)

simulated_data <- tibble(
  unit = 1:5000,
  men_better_suited =
    sample(x = c("Agree", "Disagree"), 
           size = 5000, 
           replace = TRUE, 
           prob = c(0.2, 0.8)), 
  political_views =
    sample(x = c("Liberal", "Extremely liberal"), 
           size = 5000, 
           replace = TRUE, 
           prob = c(0.4, 0.6))
)
simulated_data 

#### Simulate more conservative views / agree that men are emotionally better suited for politics ####
set.seed(416)

simulated_data <- tibble(
  unit = 1:5000,
  men_better_suited =
    sample(x = c("Agree", "Disagree"), 
           size = 5000, 
           replace = TRUE, 
           prob = c(0.8, 0.2)), 
    political_views =
    sample(x = c("Conservative", "Extremely conservative"), 
           size = 5000, 
           replace = TRUE, 
           prob = c(0.4, 0.6))
)
simulated_data 

#### Data Validation ####
# Check that people can either agree or disagree with the statement that men are better suited for politics #
population |>
group_by(men_better_suited) |>
  summarise()

# Check that people can either agree or disagree by gender with the statement that men are better suited for politics #
responses |>
  group_by(gender, men_better_suited) |>
  summarise()

# Check that responses range from 1974 to 2022 #
min(over_time$year) == 1974
max(over_time$year) == 2022

# Check political views range from Extremely liberal to Extremely conservative # 
# Code referenced from: https://github.com/christina-wei/Financial-Wellness-in-US/blob/main/scripts/03-test_data.R
class(simulated_data$political_views) == "character"
sum(!(simulated_data$political_views) %in%
        c("Extremely Liberal",
          "Liberal",
          "Slightly Liberal",
          "Moderate",
          "Slightly Conservative",
          "Conservative",
          "Extremely Conservative",
          NA)) == 0

simulated_data$political_views |>
  unique() |>
  length() == 7

# Check party affiliation range from Strong Democrat to Other # 
class(simulate_data$party_affiliation) == "character"
sum(!(unique(simulate_data$party_affiliation) %in%
        c("Strong Democrat",
          "Not Strong Democrat",
          "Independent, Close to Democrat",
          "Independent",
          "Independent, Close to Republican",
          "Not Strong Republican",
          "Strong Republican",
          "Other",
          NA))) == 0

simulate_data$party_affiliation |>
  unique() |>
  length() == 8

