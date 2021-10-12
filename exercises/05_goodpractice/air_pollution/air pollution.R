library(tidyverse) # for data science # includes ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats
library(readxl) # import excel files
library(scales) # scale functions for visualisation
library(png) # read, write and display bitmap images stored in the PNG format
library(ggrepel) # repel overlapping text labels
library(nlme) # Fit and compare Gaussian linear and nonlinear mixed-effects models.
library(devEMF) # save figure as EMF

#### 1 DATA ####

airpollution_tl2 <- read_excel("~/Desktop/Projects/R/OECD/air pollution/airpollution_tl2.xlsx", 
                               col_types = c("text", "text", "numeric","text", "numeric", "text"))
names(airpollution_tl2)[names(airpollution_tl2) == 'reg_id'] <- 'tl2_id'
names(airpollution_tl2)[names(airpollution_tl2) == 'iso'] <- 'iso3'

airpollution_tl2 <- airpollution_tl2 %>%
  mutate(oecd = ifelse((iso3 == "AUS" | iso3 == "AUT" | iso3 == "BEL" | 
                          iso3 == "CAN" | iso3 == "CHE" | iso3 == "CHL" | 
                          iso3 == "COL" | iso3 == "CZE" | iso3 == "DEU" | 
                          iso3 == "DNK" | iso3 == "ESP" | iso3 == "EST" |
                          iso3 == "FIN" | iso3 == "FRA" | iso3 == "GBR" |
                          iso3 == "GRC" | iso3 == "HUN" | iso3 == "IRL" |
                          iso3 == "ISL" | iso3 == "ISR" | iso3 == "ITA" |
                          iso3 == "JPN" | iso3 == "KOR" | iso3 == "LTU" |
                          iso3 == "LUX" | iso3 == "LVA" | iso3 == "MEX" |
                          iso3 == "NLD" | iso3 == "NOR" | iso3 == "NZL" |
                          iso3 == "POL" | iso3 == "PRT" | iso3 == "SVK" |
                          iso3 == "SVN" | iso3 == "SWE" | iso3 == "TUR" |
                          iso3 == "USA" ),1,0))

airpollution_tl2_wide <- airpollution_tl2 %>%
  pivot_wider(names_from = variable, values_from = value)

airpollution_tl2_country <- airpollution_tl2 %>%
  filter(tl2_id == "TOTAL")
airpollution_tl2_country <- airpollution_tl2_country %>%
  pivot_wider(names_from = variable, values_from = value)
names(airpollution_tl2_country)[names(airpollution_tl2_country) == 'pwm_ex'] <- 'pwm_ex_natavg'
names(airpollution_tl2_country)[names(airpollution_tl2_country) == 'spex_10'] <- 'spex_10_natavg'
names(airpollution_tl2_country)[names(airpollution_tl2_country) == 'spex_15'] <- 'spex_15_natavg'
names(airpollution_tl2_country)[names(airpollution_tl2_country) == 'spex_25'] <- 'spex_25_natavg'
names(airpollution_tl2_country)[names(airpollution_tl2_country) == 'spex_35'] <- 'spex_35_natavg'
names(airpollution_tl2_country)[names(airpollution_tl2_country) == 'spop_w'] <- 'spop_w_natavg'
airpollution_tl2_country <- airpollution_tl2_country %>%
  select( -SDUST)

airpollution_tl2_wide <- left_join(airpollution_tl2_wide, airpollution_tl2_country[, c("iso3", "year","pwm_ex_natavg","spex_10_natavg","spex_15_natavg","spex_25_natavg","spex_35_natavg", "spop_w_natavg")], by = c("iso3","year"))
airpollution_tl2_wide <- airpollution_tl2_wide %>%
  filter(tl2_id != "TOTAL") %>%
  filter(oecd == "1")



#### 2. max min graph,  ####
#### 2.1 Creat min max variables ####
#### .... For over 35 #### 
## min_spex_35 = min value for spex 35
airpollution_tl2_wide <- airpollution_tl2_wide %>%
  group_by(iso3, year) %>%
  mutate(min_spex_35 = min(spex_35))

## max_spex_35 = maximum value for spex 35
airpollution_tl2_wide <- airpollution_tl2_wide %>%
  group_by(iso3, year) %>%
  mutate(max_spex_35 = max(spex_35))

## for sorting
airpollution_tl2_wide <- airpollution_tl2_wide %>%
  mutate(spex_35_natavg2 = spex_35_natavg)

airpollution_tl2_spex_35 <- airpollution_tl2_wide %>%
  pivot_longer(c(`spex_35_natavg`,`max_spex_35`,`min_spex_35`), names_to = "type", values_to = "aggr")

airpollution_tl2_spex_35$type = factor(airpollution_tl2_spex_35$type, levels = c("min_spex_35", "spex_35_natavg", "max_spex_35") )

airpollution_tl2_spex_35_test <- airpollution_tl2_spex_35 %>%
  group_by(iso3) %>%
  filter(spex_35 == max(spex_35)) %>%
  mutate(top_region = tl2_id)

airpollution_tl2_spex_35 <- left_join(airpollution_tl2_spex_35, airpollution_tl2_spex_35_test[ , c("tl2_id", "top_region")], by = c("tl2_id"))
#### .... For over 10 ####
## min_spex_10 = min value for spex 10
airpollution_tl2_wide <- airpollution_tl2_wide %>%
  group_by(iso3, year) %>%
  mutate(min_spex_10 = min(spex_10))

## max_spex_10 = maximum value for spex 10
airpollution_tl2_wide <- airpollution_tl2_wide %>%
  group_by(iso3, year) %>%
  mutate(max_spex_10 = max(spex_10))

## for sorting
airpollution_tl2_wide <- airpollution_tl2_wide %>%
  mutate(spex_10_natavg2 = spex_10_natavg)

airpollution_tl2_spex_10 <- airpollution_tl2_wide %>%
  pivot_longer(c(`spex_10_natavg`,`max_spex_10`,`min_spex_10`), names_to = "type", values_to = "aggr")

airpollution_tl2_spex_10$type = factor(airpollution_tl2_spex_10$type, levels = c("min_spex_10", "spex_10_natavg", "max_spex_10") )

airpollution_tl2_spex_10_test <- airpollution_tl2_spex_10 %>%
  group_by(iso3) %>%
  filter(spex_10 == max(spex_10)) %>%
  mutate(top_region = tl2_id)

airpollution_tl2_spex_10 <- left_join(airpollution_tl2_spex_10, airpollution_tl2_spex_10_test[ , c("tl2_id", "top_region")], by = c("tl2_id"))



#### 2.2 Graph ####
#### .... For over 35 #### 
graph_1 <- airpollution_tl2_spex_35 %>%
  filter(year == "2019") %>%
  ggplot(aes(x = reorder(iso3,spex_35_natavg2), y = aggr)) +
  geom_point(aes(color = type, shape = type, alpha = type), size = 2.5) + 
  geom_line(aes(group=iso3)) +
  geom_text(data = . %>% group_by(iso3)  %>% filter(spex_35 == max(spex_35))%>% filter(aggr == max(aggr)) %>% subset(!duplicated(spex_35)), aes(label = sprintf(tl2_id)), angle = 90, hjust = -0.2) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "bold")) +
  theme(legend.position = "top",legend.key=element_rect(fill='white')) +
  labs(x = "", y = "")  +
  scale_color_manual(name = "", labels = c("Minimum", "Country average", "Maximum"), values=c( "aquamarine","blue1", "burlywood4")) +
  scale_shape_manual(name = "", labels = c("Minimum", "Country average", "Maximum"),values = c(16,15,17)) +
  scale_alpha_manual(name = "", labels = c("Minimum", "Country average", "Maximum"), values=c( 0.5,1,1)) 


#### .... For over 10 ####

fig23 <- airpollution_tl2_spex_10 %>%
  filter(year == "2019") %>%
  ggplot(aes(x = reorder(iso3,spex_10_natavg2), y = aggr)) +
  geom_line(aes(group=iso3)) +
  geom_point(aes(fill = type, shape = type, alpha = type), size = 2.5) + 
  labs(x = "", 
       y = "%")  +
  scale_fill_manual(name = "", labels = c("Minimum", "Country average", "Maximum"), values=c( "white","black", "#1E64B4")) +
  scale_shape_manual(name = "", labels = c("Minimum", "Country average", "Maximum"),values = c(24,23,25)) +
  scale_alpha_manual(name = "", labels = c("Minimum", "Country average", "Maximum"), values=c(1,1,1))   +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=11, color = "black"),
        axis.text.y = element_text(size=11, color = "black"),
        axis.title.y = element_text(hjust = 1, angle = 0),
        legend.position = "top",
        legend.key = element_rect(color = "#E6E6E6", fill = "#E6E6E6"),
        legend.text = element_text(size=11),
        axis.line = element_line(colour = "black"),
        legend.background = element_rect(fill="#E6E6E6"),
        legend.box.background = element_rect(color = "#E6E6E6",fill = "#E6E6E6"),
        legend.box.margin = margin(0,6.8,0,6.8,"cm"),
        axis.ticks.x = element_blank(),
        axis.title.x = element_text(hjust = 1)) +
  scale_y_continuous(limits=c(0,100), expand=c(0,0))

# dimensions in pixels:: width = 937 ; height = 550 pixels
# dimensions in cm: width = 24.791458333, height = 14.552083333
ggsave("fig23.png", width = 24.791458333, height = 14.552083333, units = c("cm"))
# dimensions in inches: width = 9.76041666653543, height = 5.72916666653543
emf(file = "fig23.emf", emfPlus = FALSE, width = 9.76041666653543, height = 5.72916666653543)
fig23
dev.off()


