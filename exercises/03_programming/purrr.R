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


# Other ways to define .f -------------------------------------------------

map_dbl(1:3, triple)
map_dbl(1:3, function(x) x * 3)
map_dbl(1:3, ~ .x * 3)


# Live coding -------------------------------------------------------------

library(repurrrsive)
library(tidyverse)

gap_split
