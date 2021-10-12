# Date created: 2021-10-11
# About: Wrangling regional air pollution data

# 0 Packages ----------------------------------------------------------------

library(tidyverse) # for data science # includes ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats
library(readxl) # import excel files
library(here)
library(styler)

# 1 Global ----------------------------------------------------------------

motherdirectory <- here()
dir_dataraw <- here("data-raw")
dir_data <- here("data")

# 2 Data ------------------------------------------------------------------
# 2.1 Import --------------------------------------------------------------


airpoll_raw <- read_excel(
  fs::path(dir_dataraw, "/airpollution_tl2.xlsx"),
  col_types = c("text", "text", "numeric", "text", "numeric", "text")
  ) %>%
  rename(tl2_id = reg_id) %>%
  rename(iso3 = iso)

airpoll_oecd <- airpoll_raw %>%
  mutate(oecd = ifelse(
    (iso3 == "AUS" | iso3 == "AUT" | iso3 == "BEL" |
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
      iso3 == "USA"), 1, 0
  ))


airpoll_oecd_wide <- airpoll_oecd %>%
  pivot_wider(names_from = variable, values_from = value)

airpoll_country <- airpoll_oecd %>%
  filter(tl2_id == "TOTAL") %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  rename(pwm_ex_natavg = pwm_ex) %>%
  rename(spex_10_natavg = spex_10) %>%
  rename(spex_15_natavg = spex_15) %>%
  rename(spex_25_natavg = spex_25) %>%
  rename(spex_35_natavg = spex_35) %>%
  rename(spop_w_natavg = spop_w) %>%
  select(-SDUST)

airpoll <- left_join(
  airpoll_oecd_wide,
  airpoll_country[,
    c(
      "iso3", "year", "pwm_ex_natavg", 
      "spex_10_natavg", "spex_15_natavg", "spex_25_natavg", 
      "spex_35_natavg", "spop_w_natavg"
    )
  ],
  by = c("iso3", "year")
  ) %>%
  filter(tl2_id != "TOTAL") %>%
  filter(oecd == "1")


# 2.2 Create variables -----------------------------------------------------------

## For over 35

airpoll_spex35 <- airpoll %>%
  group_by(iso3, year) %>%
  mutate(min_spex_35 = min(spex_35)) %>%
  mutate(max_spex_35 = max(spex_35)) %>%
  ungroup() %>%
  mutate(spex_35_natavg2 = spex_35_natavg) %>%
  pivot_longer(
    c(`spex_35_natavg`, `max_spex_35`, `min_spex_35`),
    names_to = "type",
    values_to = "aggr"
  ) %>%
  mutate(type = factor(
    type,
    levels = c("min_spex_35", "spex_35_natavg", "max_spex_35")
  ))

airpoll_spex35_test <- airpoll_spex35 %>%
  group_by(iso3) %>%
  filter(spex_35 == max(spex_35)) %>%
  mutate(top_region = tl2_id)

airpoll2_spex35 <- left_join(
  airpoll_spex35,
  airpoll_spex35_test[, c("tl2_id", "top_region")],
  by = c("tl2_id")
)

write_rds(airpoll2_spex35, fs::path(dir_data, "airpoll2_spex35.rds"))




## For over 10

airpoll_spex10 <- airpoll %>%
  group_by(iso3, year) %>%
  mutate(min_spex_10 = min(spex_10)) %>%
  mutate(max_spex_10 = max(spex_10)) %>%
  ungroup() %>%
  mutate(spex_10_natavg2 = spex_10_natavg) %>%
  pivot_longer(
    c(`spex_10_natavg`, `max_spex_10`, `min_spex_10`),
    names_to = "type",
    values_to = "aggr"
  ) %>%
  mutate(type = factor(
    type,
    levels = c("min_spex_10", "spex_10_natavg", "max_spex_10")
  ))

airpoll_spex10_test <- airpoll_spex10 %>%
  group_by(iso3) %>%
  filter(spex_10 == max(spex_10)) %>%
  mutate(top_region = tl2_id)

airpoll2_spex10 <- left_join(
  airpoll_spex10,
  airpoll_spex10_test[, c("tl2_id", "top_region")],
  by = c("tl2_id")
)

write_rds(airpoll2_spex10, fs::path(dir_data, "airpoll2_spex10.rds"))
