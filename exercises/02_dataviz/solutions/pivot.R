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


# Live coding: other ways to specify range of columns ---------------------

# We can use the same "select helpers" as for dplyr's select. To get the 
# documentation for these, see ?tidyselect::language. Alternatively, in the 
# documentation of tidyr::pivot_wider(), click on the link next to the id_cols 
# argument.


gapminder_wide %>% 
  pivot_longer(
    cols = where(is.numeric), # fancy, I barely use it
    names_to = "year",
    values_to = "lifeExp"
  )

gapminder_wide %>% 
  pivot_longer(
    cols = -c(country, continent), # I use it all the time
    names_to = "year",
    values_to = "lifeExp"
  )

gapminder_wide %>% 
  pivot_longer(
    cols = !c(country, continent), # same as above
    names_to = "year",
    values_to = "lifeExp"
  )

gapminder_wide %>% 
  pivot_longer(
    cols = matches("\\d{4}"), # fancy
    names_to = "year",
    values_to = "lifeExp"
  )

gapminder_wide %>% 
  pivot_longer(
    cols = starts_with("19"), # all the time
    names_to = "year",
    values_to = "lifeExp"
  )
