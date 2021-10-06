library(tidyverse)

tl2 <- read_rds("exercises/01_intro/tl2.rds")
gva <- read_csv(
  "exercises/01_intro/gva_per_worker.csv",
  col_types = cols(
    .default = col_character(),
    TL = col_double(),
    TIME = col_double(),
    Year = col_double(),
    `Reference Period` = col_double(),
    Value = col_double()
    )
  ) %>%
  janitor::clean_names()

gva %>%
  filter(
    var == "GVA_IND_TOTAL",
    meas == "PW_REAL_PPP",
    year == "2018",
    tl == "2"
    ) %>%
  select(reg_id, region, value) %>%
  left_join(tl2, by = "reg_id") %>%
  select(iso3, reg_id, region, value) %>%
  filter(!str_ends(reg_id, "ZZ")) %>%
  group_by(iso3) %>%
  summarise(across(
    value,
    list(min = min, average = mean, max = max),
    .names = "{.fn}"
    )) %>%
  write_rds("exercises/04_rmarkdown/worker_productivity.rds")

