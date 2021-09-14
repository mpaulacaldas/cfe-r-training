# Let's tackle another exercise! As always, start by re-starting your R session

library(tidyverse)
library(readsdmx)

air_pol_raw <- tibble(readsdmx::read_sdmx(
  "http://dotstat.oecd.org/restsdmx/sdmx.ashx/GetData/REGION_SOCIAL/1+2..AIR_POL.ALL./all?"
  ))


# Part 1 ------------------------------------------------------------------

# The raw data as-is is not so easy to use for analysis. Let's create a more
# friendly one. Here is a list of things we would like to change:
#
# - [x] Put all the variable names in lower case
# - [ ] Create a 'year' column that takes the value of 'TIME', but in numeric, not
# character format
# - [ ] Remove the 'OBS_STATUS' variable, if it has no information
# - [ ] Remove the 'POWERCODE', 'POS' and 'VAR' columns


# Let me help you out with the first one
air_pol_lc <- rename_with(air_pol_raw, tolower)

# Remove 'POWERCODE', 'POS' and 'VAR'
air_pol_rm <- select(air_pol_lc, ...)

# Create a 'year' column that takes the value of 'TIME', but in numeric, not
# character format
air_pol_yr <- ...(air_pol_rm, year = ...)

# Check if 'OBS_STATUS' has no information
summarise(
  air_pol_yr,
  n_missing = sum(is.na(...)), # what variable goes here?
  n_rows = n()
  )

# Inspect the rows where the values are not missing
...(air_pol_yr, !is.na(obs_status))

# Remove either the 'OBS_STATUS' column, or the rows where the values are not
# missing
air_pol_os <- ...(air_pol_yr, ...)


# Use the pipe (%>%) to write a sequence that goes through the steps used to
# create air_pol_lc, air_pol_rm, air_pol_yr and air_pol_os
#
# Hint: There is a keyboard shortcut for the pipe too! It's Ctrl + Shift + M.
# Use them to chain together the pipes.
air_pol_final <- air_pol_raw %>%
  rename_with(tolower)
  select(...)
  ...(year = ...)
  ...(...)
  ...(...)

# This is the end of Part 1. Let's go back to the slides.


# Part 2 ------------------------------------------------------------------

# We will practice some joins using a formatted version of the air pollution
# table. Here I use another dplyr function: transmute(). It acts like a
# mutate() in that it creates new variables, but drops any old variables.
air_pol_subset <- air_pol_raw %>%
  transmute(
    reg_id = REG_ID,
    pm = as.numeric(ObsValue),
    year = as.numeric(TIME),
    tl = as.numeric(TL)
    )

# Take a quick look at the columns in this table. You can use View(), print the
# table from the Console or the Souce pane, or explore from the Environment
# pane.
tl2 <- read_rds("tl2.rds")

# Our end goal is to get the regional average (simple mean) of PM2.5 per country
# and year. To do this, we need a column with an iso3 code next to each reg_id
# code. Fill in the pipeline below
air_pol_lj <- air_pol_subset %>%
  left_join(..., by = c("...", "...")) %>%
  # The join left us with all of the rows of air_pol_subset, but we are only
  # interested in TL2 regions. Let's remove those rows of the TL1
  filter(...) %>%
  group_by(...) %>%
  summarise(
    mean_pm = ...,
    .groups = "drop" # this is another way of ungrouping the resulting tibble
  )

# Is there a join that would work as a shortcut to the left_join() + filter()
# step? Have a look at the documentation
?left_join
air_pol_ij <- air_pol_subset %>%
  ..._join(..., by = c("...", "...")) %>%
  group_by(...) %>%
  summarise(
    mean_pm = ...,
    .groups = "drop"
  )

# air_pol_lj and air_pol_ij are not exactly the same. Use anti_join() to do a
# little exploration. What's the reason for the different number of rows?
anti_join(..., ...)

