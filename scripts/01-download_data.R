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
# [...ADD CODE HERE TO DOWNLOAD...]



#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(the_raw_data, "inputs/data/raw_data.csv") 

         
