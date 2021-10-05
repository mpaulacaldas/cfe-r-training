# Iteration over vectors with purrr ---------------------------------------

library(purrr)
triple <- function(x) x * 3
map(1:3, triple)


# Control the type of output ----------------------------------------------

map(1:3, triple)
map_dbl(1:3, triple)
map_chr(1:3, triple)


# Pass arguments to .f ----------------------------------------------------

seniority <- list(
  eds = c(2, 10, 5, 3),
  rdg = c(3, 16, NA)
)
map_dbl(seniority, mean)
map_dbl(seniority, mean, na.rm = TRUE)

# QUESTION: How would you check which are the arguments to mean()?
?mean

# Other ways to define .f -------------------------------------------------

map_dbl(1:3, triple)
map_dbl(1:3, function(x) x * 3)
map_dbl(1:3, ~ .x * 3)


# Live coding: Gapminder --------------------------------------------------

library(repurrrsive) # lists for learning
library(tidyverse)

# repurrrsive loads this list as a "promise", let's force it to show up in the 
# environment
gap_split <- repurrrsive::gap_split

View(gap_split)

ggplot(gap_split[[1]], aes(year, pop)) +
  geom_line()

gap_split %>% 
  map(~ .x$pop) %>% 
  map_dbl(mean)

gap_split %>% 
  map_dfr(summarise, mean = mean(pop), .id = "country")


# Live coding: JSON  ------------------------------------------------------

# JSON files are commonly used in APIs. The easiest way to parse them is to 
# read them as lists.

# This opens up an example of a JSON file
file.edit(repurrrsive::discog_json())

# This is how that file would look in R if you imported it as a list
discog <- repurrrsive::discog
View(discog)
