# Date created: 2021-10-11
# About: Show range of regional population affected by air pollution 

# 0 Packages ----------------------------------------------------------------

library(tidyverse)  # for data science # includes ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats
library(here)       # easy file referencing
library(scales)     # scale functions for visualisation
library(png)        # read, write and display bitmap images stored in the PNG format
library(ggrepel)    # repel overlapping text labels
library(writexl)    # writing Excel files

# 1 Global ----------------------------------------------------------------

motherdirectory <- here() 
dir_data <- here("data")
dir_fig <- here("figures")
dir_tables <- here("tables")

airpoll_theme <- function(){
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 11, color = "black"),
    axis.text.y = element_text(size = 11, color = "black"),
    axis.title.x = element_text(hjust = 1),
    axis.title.y = element_text(hjust = 1, angle = 0),
    axis.line = element_line(colour = "black"),
    axis.ticks.x = element_blank(),
    legend.position = "top",
    legend.key = element_rect(color = "#E6E6E6", fill = "#E6E6E6"),
    legend.text = element_text(size=11),
    legend.background = element_rect(fill="#E6E6E6"),
    legend.box.background = element_rect(color = "#E6E6E6",fill = "#E6E6E6"),
    legend.box.margin = margin(0,6.8,0,6.8,"cm")
  )
}



# 2 Data ------------------------------------------------------------------

airpoll2_spex35 <- read_rds(fs::path(dir_data, "airpoll2_spex35.rds"))

airpoll2_spex10 <- read_rds(fs::path(dir_data, "airpoll2_spex10.rds"))


# 3 Graph -----------------------------------------------------------------

## For over 35 
airpoll2_spex35 %>%
  filter(year == "2019") %>%
  ggplot(aes(x = reorder(iso3,spex_35_natavg2), y = aggr)) +
  geom_point(aes(color = type, shape = type, alpha = type), size = 2.5) + 
  geom_line(aes(group = iso3)) +
  geom_text(
    data = . %>% group_by(iso3) %>% 
      filter(spex_35 == max(spex_35))%>% filter(aggr == max(aggr)) %>% 
      subset(!duplicated(spex_35)), 
    aes(label = sprintf(tl2_id)), 
    angle = 90, hjust = -0.2
  ) +
  scale_color_manual(
    name = "", 
    labels = c("Minimum", "Country average", "Maximum"), 
    values = c( "aquamarine","blue1", "burlywood4")
  ) +
  scale_shape_manual(
    name = "", 
    labels = c("Minimum", "Country average", "Maximum"),
    values = c(16,15,17)
  ) +
  scale_alpha_manual(
    name = "", 
    labels = c("Minimum", "Country average", "Maximum"), 
    values = c(0.5,1,1)
  ) +
  airpoll_theme() +
  theme(axis.title = element_blank())



##. For over 10

airpoll2_spex10 %>%
  filter(year == "2019") %>%
  ggplot(aes(x = reorder(iso3, spex_10_natavg2), y = aggr)) +
  geom_line(aes(group=iso3)) +
  geom_point(aes(fill = type, shape = type, alpha = type), size = 2.5) + 
  labs(x = "", 
       y = "%")  +
  scale_fill_manual(
    name = "", 
    labels = c("Minimum", "Country average", "Maximum"), 
    values = c( "white","black", "#1E64B4")
  ) +
  scale_shape_manual(
    name = "", 
    labels = c("Minimum", "Country average", "Maximum"),
    values = c(24,23,25)
  ) +
  scale_alpha_manual(
    name = "", 
    labels = c("Minimum", "Country average", "Maximum"), 
    values = c(1,1,1)
  )   +
  airpoll_theme() +
  scale_y_continuous(limits=c(0,100), expand=c(0,0))

# dimensions in pixels: width = 937 ; height = 550 pixels
ggsave(
  "g3_31.png", 
  width = 24.791458333, 
  height = 14.552083333, 
  units = c("cm"), 
  path = dir_fig
)
ggsave(
  "g3_31.emf", 
  width = 9.76041666653543, 
  height = 5.72916666653543, 
  units = c("cm"), 
  path = dir_fig
)


airpoll2_spex10_table <- airpoll2_spex10 %>%
  filter(year == "2019") %>%
  select(year, iso3, type, aggr) %>%
  unique() %>%
  pivot_wider(names_from = type, values_from = aggr)

write_xlsx(
  airpoll2_spex10_table, 
  path = paste0(dir_tables, "/airpoll_spex10.xlsx")
)
