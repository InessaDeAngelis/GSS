#### Preamble ####
# Purpose: Simulates respondent demographic information, women in politics, and political preferences data sets
# Author: Inessa De Angelis
# Date: 12 June 2023
# Contact: inessa.deangelis@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(tibble)

#### Simulate data: men better suited emotionally for politics than women ####
#Code referenced from: https://tellingstorieswithdata.com/08-hunt.html#surveys
set.seed(416)

treat_control <-
  tibble(
    group = sample(x = c("Treatment", "Control"), size = 50, replace = TRUE),
    response = sample(x = c(1, 2), size = 50, replace = TRUE)
  )

treat_control



