# Adding some layers to the demo script of workshop 1 and 2.
# Disclaimer: This is an example for learning purposes,
# there will be some differences with the original figure.


# 0 Packages --------------------------------------------------------------

library(tidyverse)


# 1 Data ------------------------------------------------------------------
# 1.1 Import --------------------------------------------------------------
data_raw <- read_csv(
  "gva_per_worker.csv",
  col_types = cols(
    .default = col_character(),
    TL = col_double(),
    TIME = col_double(),
    Year = col_double(),
    `Reference Period` = col_double(),
    Value = col_double()
  )
)


# 1.2 Manipulation --------------------------------------------------------

data_average <- data_raw %>%
  rename_with(tolower) %>%
  select(reg_id, region, tl, var, meas, year, value) %>%
  filter(var == "GVA_IND_TOTAL",
         meas == "PW_REAL_PPP",
         year == "2018",
         tl == "2") %>%
  mutate(country = substr(reg_id, 1, 2)) %>%
  mutate(check = substr(reg_id, 3, 4)) %>%
  filter(check != "ZZ") %>%
  group_by(country) %>%
  mutate(average = mean(value),
         max = max(value),
         min = min(value)) %>%
  ungroup()

# For this example we are only adding the labels on top
data_max <- data_average %>%
  group_by(country)  %>%
  filter(value == max(value)) %>%
  ungroup() %>%
  rename(max_region = region)


data_figure <- data_average %>%
  distinct(country, min, average, max) %>%
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
    )) %>%
  left_join(data_max[c("max_region","country")], by = c("country"))


# 2 Graph -----------------------------------------------------------------

data_figure %>%
  ggplot(aes(x = country, y = value)) +
  geom_line(colour = "#00A9CB", size = 3) +
  geom_point(aes(colour = category, shape = category), size = 3) +
  geom_point(
    data = filter(data_figure, category == "National average"),
    colour = "black", size = 3, shape = 18
  ) +
  geom_hline(
    aes(yintercept = 57.74, linetype = "OECD average"),
    colour = "#1461B3"
  ) +
  geom_text(data = . %>%  filter(category == "Maximum region"),
            aes(label = max_region), angle = 90, hjust = -0.2) +
  labs(subtitle = "'000 USD per worker") +
  scale_colour_manual(values = c("white", "black", "#0060B3")) +
  scale_shape_manual(values = c(16, 18, 16)) +
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
    axis.ticks.length = unit(-0.15, "cm"),
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

ggsave("labour_productivity.png")

