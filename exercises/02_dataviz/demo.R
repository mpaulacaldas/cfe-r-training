# Demo script for session on making graphs on 2021-09-23.
# We will build on Dotstat data which we transformed last
# week to create figure 2.11 in OECD RCaG 2020.
# Disclaimer: This is an example for learning purposes,
# there will be some differences with the original figure.


# 0 Packages --------------------------------------------------------------

library(tidyverse) # includes dplyr, tidyr, readr, ...
library(readxl)


# 1 Data ------------------------------------------------------------------

# Import data we created last week
data_raw <- read_xlsx("worker_productivity.xlsx")

data_figure <- data_raw %>%
  # Change the type of the "country" variable to factor, and order the factor
  # with respect to the max value observed. This will make sure countries are
  # plotted in descending order with respect to the max value
  mutate(country = fct_reorder(country, -max)) %>% 
  # for plotting, Excel requires a different table structure than ggplot2, which
  # uses "tidy data". Here we pivot the table into the longer, "tidy data"
  # format, i.e. the names of the original columns now populate the "category"
  # variable
  pivot_longer(
    c(average, min, max),
    names_to = "category",
    values_to = "value"
    ) %>% 
  # transform data to more readable in the figure
  mutate(
    value = value / 1000,
    category = factor(
      category,
      levels = c("min", "average", "max"),
      labels = c("Minimum region", "National average", "Maximum region")
  ))


# 2 Graph -----------------------------------------------------------------
# 2.1 RCaG theme --------------------------------------------------------

data_figure %>%
  ggplot(aes(x = country, y = value)) +
   # in aes ...
  geom_line(aes(group = country), colour = "#00A9CB", size = 3) +
  # order matters: geom_point should come after geom_line otherwise the line
  # would be on top of the points
  geom_point(aes(colour = category, shape = category), size = 3) +
  geom_point(
    # data can be replaced for some geoms
    data = filter(data_figure, category == "National average"),
    # add this layer which is identical to previous geom_point but for average
    # only to ensure that average category is on top for countries with only 1
    # region
    colour = "black", size = 3, shape = 18
  ) +
  geom_hline(
    # linetype in aes() to create new legend entry
    aes(yintercept = 57.74, linetype = "OECD average"),
    colour = "#1461B3"
    ) +
  labs(subtitle = "'000 USD per worker") +
  scale_colour_manual(values = c("white", "black", "#0060B3")) +
  scale_shape_manual(values = c(16, 18, 16)) +
  # Customize interval on y-axis
  scale_y_continuous(
    limits = c(0, 220), expand = c(0, 0),
    breaks = seq(0, 220, by = 20)
  ) +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_text(size = 10, colour = "black", angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10, colour = "black"),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_line(color = "black"),
    axis.ticks.length = grid::unit(-0.15, "cm"),
    plot.subtitle = element_text(size = 10, colour = "black", hjust = -0.05),
    plot.margin = margin(t = 4, 1, 1, 1, "lines"),
    panel.grid.major = element_line(colour = "white"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#E9E9E9"),
    legend.text = element_text(size = 10),
    legend.title = element_blank(),
    legend.key = element_rect(color = "#E9E9E9", fill = "#E9E9E9"),
    legend.background = element_rect(fill = "#E9E9E9"),
    legend.box.background = element_rect(color = "#E9E9E9", fill = "#E9E9E9"),
    legend.box.margin = margin(0, 3, 0, 3, "cm"),
    legend.key.size = unit(0.7, "line"),
    legend.position = c(0.5, 1.12),
    legend.direction = "horizontal",
    legend.box = "horizontal"
  )

# Labels can be added using geom_text().
#
# We are not doing it here because we didn't include the labels in the data
# preparation last week.

ggsave("labour_productivity.png")


# 2.2 Other OCED theme ---------------------------------------------------------

data_figure %>%
  ggplot(aes(x = country, y = value)) +
  geom_line(aes(group = country), colour = "#4F81BD", size = 3) +
  geom_point(aes(fill = category), size = 3, shape = 21) +
  geom_point(
    data = filter(data_figure, category == "average"),
    fill = "black", size = 3, shape = 21
  ) +
  geom_hline(aes(yintercept = 57.74, linetype = "OECD average"), colour = "#1461B3") +
  labs(subtitle = "'000 USD per worker") +
  scale_fill_manual(
    labels = c("Minimum region", "National average", "Maximum region"),
    values = c("white", "black", "grey")
  ) +
  scale_y_continuous(
    limits = c(0, 220), expand = c(0, 0),
    breaks = seq(0, 220, by = 20)
  ) +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_text(size = 10, colour = "black", angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10, colour = "black"),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_line(color = "black"),
    axis.ticks.length = grid::unit(-0.15, "cm"),
    plot.subtitle = element_text(size = 10, colour = "black", hjust = -0.04),
    plot.margin = margin(t = 4, 1, 1, 1, "lines"),
    panel.background = element_rect(fill = "#F2FEFE"),
    panel.grid.major = element_line(colour = "white"),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA, size = 1),
    legend.text = element_text(size = 10),
    legend.title = element_blank(),
    legend.key = element_rect(color = "#E9E9E9", fill = "#E9E9E9"),
    legend.background = element_rect(fill = "#E9E9E9"),
    legend.box.background = element_rect(color = "#E9E9E9", fill = "#E9E9E9"),
    legend.box.margin = margin(0, 3, 0, 3, "cm"),
    legend.key.size = unit(0.7, "line"),
    legend.position = c(0.5, 1.12),
    legend.direction = "horizontal",
    legend.box = "horizontal"
  )
