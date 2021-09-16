library(tidyverse)

air_pol <- read_rds("air_pol.rds") %>%
  mutate(ObsValue = as.numeric(ObsValue))
air_pol


# Demonstrate filtering ---------------------------------------------------

# Keep only rows for France
air_fra <- filter(air_pol, REG_ID == "FRA")

# Get the region with the lowest level of air pollution
filter(air_pol, ObsValue == min(ObsValue))

# What was the level of PM2.5 in Colombia in 2000?
filter(air_pol, TIME == "2000" & REG_ID == "COL")
filter(air_pol, TIME == "2000", REG_ID == "COL") # mind the comma!

# What was the level of PM2.5 in 2000 OR in Colombia (any year)?
filter(air_pol, TIME == "2000" | REG_ID == "COL")


# Question Maria ----------------------------------------------------------

# What if we want to change the groups?

air_pol_grouped <- group_by(air_pol, REG_ID, TL)
air_pol_grouped

# Answer: group_by() overwrites the groups
air_pol_by_year <- group_by(air_pol_grouped, TIME)

# If you want to add the group, use .add
group_by(air_pol_grouped, TIME, .add = TRUE)

# Remove the group
ungroup(air_pol_grouped)


# Demo piping -------------------------------------------------------------

# these two
air_pol_filtered <- filter(air_pol, TL == "1")
air_pol_grouped2 <- group_by(air_pol_filtered, TIME)

# can be written as
air_pol %>% 
  filter(TL == "1") %>% 
  group_by(TIME)

# larger example
air_pol %>% 
  filter(TL == "1") %>% 
  group_by(TIME) %>% 
  filter(ObsValue == max(as.numeric(ObsValue))) %>% 
  ungroup() %>% 
  arrange(desc(TIME)) %>% 
  select(REG_ID, TIME) %>% 
  filter(row_number() < 10)
