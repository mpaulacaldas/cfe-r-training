# to run the lines, highlight and use the "run" button in the top right of
# this script, or use the keyboard shortcut Ctrl + Enter

library(gapminder)
library(tidyverse)


# Code along #1 -----------------------------------------------------------

gapminder_example <- gapminder %>%
  filter(year %in% c(1957, 2007))

summary(gapminder_example)

# what does this do? where does the plot show up?
ggplot(data = gapminder_example)

ggplot(
  data = gapminder_example,
  mapping = aes(x = gdpPercap, y = lifeExp)
  )

# do you remember what the shortcut is for the pipe (%>%)? if not, look for the
# hints at the bottom of the script
gapminder_example %>%
  ggplot(aes(x = gdpPercap, y = lifeExp))

gapminder_example %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# feel free to do a little exploring of your own :)


# All done! Go back to the slides


# Code along #2 -----------------------------------------------------------

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  geom_point()

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      shape = continent
      )
    ) +
  geom_point()

# what happens when you move the entire aes() bit to geom_point()?
gapminder_example %>%
  ggplot() +
  geom_point(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
    )
  )


# Live coding: aes() can be defined in many different places --------------

# So far, we have defined aes() at the ggplot() level. This means that the 
# mappings specified in aes() will be applied to every geom that follows.

# Alternatively, you can define aes() at the geom level. If you do this, the 
# mappings will applied only to that layer
gapminder_example %>%
  ggplot() +
  geom_point(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
    )
  )

# Compare for example to this output. There is a different aes() in every geom, 
# i.e. there are different mappings between our variables and the geographical 
# elements of each layer.
gapminder_example %>%
  ggplot() +
  geom_point(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
    )
  ) +
  # By not setting the "colour" aesthetic, we are saying that we want a smoothed
  # line that uses all of the available data, instead of a smoothed line per 
  # continent
  geom_smooth(
    aes(
      x = gdpPercap,
      y = lifeExp
    )
  )

# Note that in the above example there is some repetition. The x and y mappings 
# are the same for geom layers. We can therefore move these two to the geom()
# layer, to make the code more compact and easier to modify in the future. Note 
# that the resulting plot remains the same.
gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp
    )
  ) +
  geom_point(aes(colour = continent)) +
  geom_smooth()


# Question from the chat: What is the keyboard shortcut to add the sections?
# Answer: Ctrl + Shift + R

# End of live coding ------------------------------------------------------

# what happens when you run this?

# Answer: You get an error saying ggplot2 can't find the "continent" object. 
# This is because ggplot2 will only look for 'continent' column inside 
# gapminder_example if it is defined inside the aes()
gapminder_example %>%
  ggplot() +
  geom_point(
    aes(
      x = gdpPercap,
      y = lifeExp
    ),
    colour = continent
  )

# what about this?
gapminder_example %>%
  ggplot() +
  geom_point(
    aes(
      x = gdpPercap,
      y = lifeExp
    ),
    colour = "purple"
  )

gapminder_example %>%
  ggplot() +
  geom_point(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
    )
  )


# Live coding: how to manually set colours --------------------------------

# Customisation happens via the scale_* functions. If you want to manually 
# set your colours, you can use scale_colour_manual() and use a "named vector".
# If you forget how this syntax goes, have a look at the examples in the 
# documentation

?scale_colour_manual

gapminder_example %>%
  ggplot() +
  geom_point(aes(
    x = gdpPercap,
    y = lifeExp,
    colour = continent,
    shape = continent
  )) +
  scale_colour_manual(
    values = c(
      "Africa" = "pink",
      "Americas" = "yellow",
      "Asia" = "green",
      "Europe" = "black",
      "Oceania" = "purple"
    )
  )


# Code along #3 -----------------------------------------------------------

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  geom_point()

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  geom_point() +
  scale_x_log10()

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  geom_point() +
  scale_x_log10() +
  scale_colour_brewer(palette = "Dark2")

# bonus: what changes in this plot?
gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  geom_point() +
  scale_x_log10(labels = scales::number) +
  scale_colour_brewer(palette = "Dark2")


# Live coding: using the scales package to further customise scales -------

# The scales package comes with a lot of useful functions to customise the look
# of your labels. The one in the previous example works by converting a numeric 
# vector into a character vector with nicer formatting. For example:
scales::number(c(100000, 10000000000))

# Sidenote: The notation `package::function()` is useful when you want to be
# clear about the source of a function, or you want to load only one function
# instead of the entire package

# The scales package also has a set of label_* functions that give you a bit
# more flexibility in the way you format labels
label_k <- scales::label_number(scale = 1/1000, suffix = " K")

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
    )
  ) +
  geom_point() +
  scale_x_log10(labels = label_k) +
  scale_colour_brewer(palette = "Dark2")


# Code along #4 -----------------------------------------------------------

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  # why do we use show.legend = FALSE? what happens if we remove it and leave
  # only geom_point()?
  geom_point(show.legend = FALSE) +
  facet_wrap(~ continent)

gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  geom_point(show.legend = FALSE) +
  facet_grid(continent ~ year)

# bonus: what does scales = "free_x" do?
gapminder_example %>%
  ggplot(
    aes(
      x = gdpPercap,
      y = lifeExp,
      colour = continent
      )
    ) +
  geom_point(show.legend = FALSE) +
  facet_grid(continent ~ year, scales = "free_x")


# Common charts -----------------------------------------------------------

# histograms
gapminder_example %>%
  ggplot(aes(x = gdpPercap)) +
  geom_histogram() +
  facet_grid(. ~ year)

# columns
gapminder_summary <- gapminder_example %>% 
  group_by(continent, year) %>% 
  summarise(
    gdp_wmean = weighted.mean(
      gdpPercap, 
      pop
    ),
    .groups = "drop"
  )
ggplot(gapminder_summary) +
  geom_col(
    aes(
      x = continent, 
      y = gdp_wmean
    )
  ) +
  facet_grid(. ~ year)

# lines
gapminder %>%
  ggplot(
    aes(
      x = year, 
      y = lifeExp, 
      group = country
    )
  ) +
  geom_line(show.legend = FALSE)


# your turn: recreate the plot in the slides. you can take inspiration from:
gapminder %>%
  ggplot(
    aes(
      x = year, 
      y = lifeExp, 
      group = country
    )
  ) +
  geom_line(show.legend = FALSE)


# Solution
gapminder %>%
  ggplot(
    aes(
      x = year,
      y = lifeExp,
      group = country,
      colour = continent
    )
  ) +
  geom_line(show.legend = FALSE) +
  facet_wrap(~ continent, scales = "free_x")



# Live coding: How to invert the order of the grids -----------------------

# To do this, we will change the factor levels of the "continent" column. This 
# can be done either at a pre-processing stage or directly when plotting. The
# forcats package has a useful set of functions to work with factors. forcats 
# is also part of the tidyverse. Here there are two examples: 

# fct_rev(): Reverse the order of the factor (i.e. order of continents)

gapminder %>%
  # transformations to my data, before plotting
  mutate(continent = forcats::fct_rev(continent)) %>% 
  # end of transformations to data
  ggplot(
    aes(
      x = year,
      y = lifeExp,
      group = country,
      colour = continent
    )
  ) +
  geom_line(show.legend = FALSE) +
  facet_wrap(~ continent, scales = "free_x")

gapminder %>%
  ggplot(
    aes(
      x = year,
      y = lifeExp,
      group = country,
      colour = continent
    )
  ) +
  geom_line(show.legend = FALSE) +
  facet_wrap(~ fct_rev(continent), scales = "free_x")


# fct_infreq(): Order with respect to frequency (i.e. continents with most
# countries first)

gapminder %>%
  ggplot(
    aes(
      x = year,
      y = lifeExp,
      group = country,
      colour = continent
    )
  ) +
  geom_line(show.legend = FALSE) +
  facet_wrap(~ fct_infreq(continent), scales = "free_x")


# Hints -------------------------------------------------------------------

# Keyboard shortcuts
#
# %>%: Ctrl + Shift + M
# Run a line: Ctrl + Enter
