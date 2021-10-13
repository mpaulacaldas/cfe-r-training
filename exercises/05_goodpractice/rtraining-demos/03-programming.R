# Demo script for session on programming efficiently on 2021-09-30.
# We will build on Dotstat data which we transformed in the first
# session and an alteration of the graph we made in the second
# session.

# 0 Packages --------------------------------------------------------------

library(tidyverse)
library(readxl)
library(here)

# 1 Global ----------------------------------------------------------------

motherdir <- here()
dir_dataraw <- here("data-raw")
dir_data <- here("data")
dir_fig <- here("figures")


# 1 Data ------------------------------------------------------------------

# Import data we created during the first workshop
data_raw <- read_xlsx(fs::path(dir_data, "worker_productivity.xlsx")) %>% 
  mutate(country = fct_reorder(country, -max)) %>%
  pivot_longer(
    c(average, min, max),
    names_to = "category",
    values_to = "value"
  ) %>%
  mutate(
    value = value / 1000,
    category = factor(
      category,
      levels = c("min", "average", "max"),
      labels = c("Minimum region", "National average", "Maximum region")
    ))


# 2 Helpers ---------------------------------------------------------------

# build a plot skeleton and theme that you can use for many graphs
oecd_ggplot <- function(data) {
  ggplot(data, aes(x = country, y = value)) +
    geom_line(colour = "#00A9CB", size = 3) +
    geom_point(aes(colour = category, shape = category), size = 3) +
    geom_point(
      data = filter(data, category == "National average"),
      colour = "black", size = 3, shape = 18
    ) +
    geom_hline(
      aes(yintercept = 57.74, linetype = "OECD average"),
      colour = "#1461B3"
    ) +
    labs(subtitle = "'000 USD per worker") +
    scale_colour_manual(values = c("white", "black", "#0060B3")) +
    scale_shape_manual(values = c(16, 18, 16)) +
    scale_y_continuous(
      limits = c(0, 220), expand = c(0, 0),
      breaks = seq(0, 220, by = 20)
    )
}

oecd_theme <- function() {
  theme(
    axis.title = element_blank(),
    axis.text.x = element_text(size = 10, colour = "black", angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10, colour = "black"),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_line(color = "black"),
    axis.ticks.length = unit(-0.15, "cm"),
    panel.grid.major = element_line(colour = "white"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#E9E9E9"),
    legend.text = element_text(size = 10),
    legend.title = element_blank(),
    legend.key = element_rect(color = "#E9E9E9", fill = "#E9E9E9"),
    legend.background = element_rect(fill = "#E9E9E9"),
    legend.box.background = element_rect(color = "#E9E9E9", fill = "#E9E9E9"),
    legend.box.margin = margin(0, 0.5, 0, 0.5, "cm"),
    legend.key.size = unit(0.7, "line"),
    legend.direction = "horizontal",
    legend.box = "horizontal",
    legend.position = c(0.5, 1.12),
    plot.subtitle = element_text(size = 10, colour = "black", hjust = -0.05),
    plot.title = element_text(size = 14, colour = "black", hjust = 0.5, vjust = 15),
    plot.margin = margin(t = 4, 1, 1, 1, "lines")
  )
}


# 3 Graphs ----------------------------------------------------------------

# We will make three graphs for three randomly selected countries
selected_countries <- c("UK", "ME", "KR")

# Using a loop, we make three figures which will be saved in your files
for (i in selected_countries) {
  
  data_figure <- data_raw %>%
    filter(country %in% c("IE", i, "BG"))
  
  p <- data_figure %>%
    oecd_ggplot() +
    oecd_theme()
  
  ggsave(
    filename = paste0("loop_", i, "-labour-productivity.png"),
    plot = p,
    width = 7,
    height = 5,
    units = "in",
    path = dir_fig
  )
  
}

# We can do the same thing with a function and using purrr::walk()
oecd_ggsave <- function(i) {
  
  data_figure <- data_raw %>%
    filter(country %in% c("IE", i, "BG"))
  
  p <- data_figure %>%
    oecd_ggplot() +
    oecd_theme()
  
  ggsave(
    filename = paste0("purrr_", i, "-labour-productivity.png"),
    plot = p,
    width = 7,
    height = 5,
    units = "in",
    path = dir_fig
  )
}
walk(selected_countries, oecd_ggsave)