#### Preamble ####
# Purpose: Models the data
# Author: Inessa De Angelis
# Date: 10 October 2023
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

# Create specific data set for analysis #
women_in_pol <-
  cleaned_women_in_politics |>
  mutate(year, id, women_in_politics)

pol_views <-
  summarized_political_preferences |>
  select(year,id, political_views) 

analysis_data <- merge(women_in_pol, pol_views) 

demographic_info <-
  cleaned_respondent_info |>
  select(year, id, gender)

final_analysis_data <- merge(analysis_data, demographic_info)

analysis_data_3 <-
  final_analysis_data |>
  mutate(
    women_in_politics = case_when(
      women_in_politics == "Agree" ~ 1,
      women_in_politics == "Disagree" ~ 2,
    ),
    women_in_politics = as_factor(women_in_politics),
    gender = case_when(
      gender == "Male" ~ 1,
      gender == "Female" ~ 2,
    ),
    gender = as_factor(gender),
  political_views = case_when(
    political_views == "Extremely Liberal" ~ 1,
    political_views == "Liberal" ~ 2,
    political_views == "Slightly Liberal" ~ 3,
    political_views == "Moderate" ~ 4,
    political_views == "Slightly Conservative" ~ 5,
    political_views == "Conservative" ~ 6,
    political_views == "Extremely Conservative" ~ 7
  ),
  political_views = as_factor(political_views)
  ) |>
select(women_in_politics, gender, political_views)

# Test combined data set #
class(analysis_data_3$women_in_politics) == "factor"
class(analysis_data_3$gender) == "factor"
class(analysis_data_3$political_views) == "factor"
nrow(analysis_data_3) == 37005

#### Model ####
gender_women_polviews <-
  stan_glm(
    women_in_politics ~ gender + political_views,
    data = analysis_data_3,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 16
  )
gender_women_polviews

# Save model #
saveRDS(
  gender_women_polviews, file = "Outputs/model/gender_women_polviews.rds"
)

# Interpretation #
gender_women_polviews <-
  readRDS(file = "Outputs/model/gender_women_polviews.rds")

modelsummary(
  list(
    "Support Women in Politics" = gender_women_polviews
  ),
  statistic = "mad"
)

# Predictions #
gender_women_polviews_predictions <-
  predictions(gender_women_polviews) |>
  as_tibble()
gender_women_polviews_predictions

# Graph #
gender_women_polviews_predictions |>
  ggplot(aes(x = political_views, y = estimate, color = women_in_politics)) +
  geom_jitter(width = 0.2, height = 0.0, alpha = 0.3) +
  labs(
    x = "Political Views",
    y = "Estimated probability respondents support women in politics",
    color = "Women in Politics"
  ) +
  theme_classic() +
  theme(axis.text.x = element_text(angle=45, hjust = 1, size = 10)) + 
  theme(legend.position = "bottom") +
  theme(legend.text = element_text(size = 6)) +
  theme(legend.title = element_text(size = 9)) 

# Estimates only #
just_the_estimates <-
  gender_women_polviews_predictions |>
  select(estimate, women_in_politics, gender, political_views) |>
  unique()
just_the_estimates

slopes(gender_women_polviews, newdata = "median")