# to run the lines, highlight and use the "run" button in the top right of
# this script, or use the keyboard shortcut Ctrl + Enter

library(gapminder)
library(tidyverse)

gapminder_wide <- read_rds("gapminder_wide.rds")
gapminder_long <- read_rds("gapminder_long.rds")

# From long to wide -------------------------------------------------------

gapminder_long %>%
  pivot_wider(names_from = indicator, values_from = value)

# From wide to long -------------------------------------------------------

gapminder_wide %>%
  pivot_longer(
    cols = `1952`:`2007`,
    names_to = "year",
    values_to = "lifeExp"
  )

# bonus: we can select columns in many different ways with cols. can you think
# of a different way to specify the columns we are interested in?
gapminder_wide %>%
  pivot_longer(
    cols = ..., # replace the ...
    names_to = "year",
    values_to = "lifeExp"
  )
