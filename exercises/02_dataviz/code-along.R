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

# what happens when you run this?
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


# Hints -------------------------------------------------------------------

# Keyboard shortcuts
#
# %>%: Ctrl + Shift + M
# Run a line: Ctrl + Enter
