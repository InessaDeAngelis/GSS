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
  "time" = x <- sample(1972:2022, 5000, replace=T),
)
over_time

#### Simulate varying political views ####
set.seed(416)

num_people <- 5000

simulated_data <-tibble(
    person = 1:num_people,
#use 1 through 7 to represent political views 
    political_views = sample(c("1", "2", "3", "4", "5", "6", "7"), size = num_people, replace = TRUE),
)
simulated_data

#### Simulate varying party affiliation ####
set.seed(416)

num_people <- 5000

simulate_data <-tibble(
  person = 1:num_people,
  #use 0 through 7 to represent political views 
  party_affiliation = sample(c("0", "1", "2", "3", "4", "5", "6", "7"), size = num_people, replace = TRUE),
)
simulate_data

#### Simulate more liberal political views / disagree that men are emotionally better suited for politics ####
set.seed(416)
num_people <- 5000

simulated_data <-tibble(
  person = 1:num_people,
  # use 1 through 3 to represent liberal views (extremely liberal, liberal, slightly liberal)
  political_views = sample(c("1", "2", "3"), size = num_people, replace = TRUE),
  men_better_suited = sample(c("Agree", "Disagree"), size = num_people, replace = TRUE)
)
simulated_data

#### Simulate more conservative views / agree that men are emotionally better suited for politics ####
set.seed(416)
num_people <- 5000

simulated_data <-tibble(
  person = 1:num_people,
  # use 5 through 7 to represent conservative views (slightly conservative, conservative, extremely conservative)
  political_views = sample(c("5", "6", "7"), size = num_people, replace = TRUE),
  men_better_suited = sample(c("Agree", "Disagree"), size = num_people, replace = TRUE)
)
simulated_data

#### Data Validation ####
# Check that people can either agree or disagree with the statement that men are better suited for politics
population |>
group_by(men_better_suited) |>
  summarise()

# Check that political views range from 1 through 7
simulated_data$political_views |> min() == 1
simulated_data$political_views |> max() == 7

# Check that party affiliation ranges from 0 through 7
simulate_data$party_affiliation |> min() == 0
simulate_data$party_affiliation |> max() == 7