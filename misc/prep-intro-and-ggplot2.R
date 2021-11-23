# Session 1 ---------------------------------------------------------------

library(DBI)
library(RPostgres)

con <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = 'oecd_tl',
  host = 'gis.main.oecd.org',
  port = 5432,
  user = stringr::str_to_title(Sys.getenv("USERNAME"))
  )

tl2 <- tbl(con, "tl2") %>%
  select(iso3, reg_id = tl2_id, reg_name = name_en) %>%
  mutate(tl = 2L) %>%
  filter(reg_id != "999") %>%
  collect()

dbDisconnect(con)

saveRDS(tl2, "exercises/01_intro/tl2.rds")



# Session 2 ---------------------------------------------------------------

library(tidyverse)
library(janitor)

metro <- tibble(readsdmx::read_sdmx(
  "http://dotstat.oecd.org/restsdmx/sdmx.ashx/GetData/CITIES/./all?startTime=2000&endTime=2019"
  )) %>%
  clean_names()

metro_str <- tibble(readsdmx::read_sdmx(
  "http://dotstat.oecd.org/restsdmx/sdmx.ashx/GetDataStructure/CITIES"
  )) %>%
  clean_names()

metro_str %>%
  filter(value %in% c("T_T_CORE", "PWM_EX_CORE")) %>%
  select(value, en_description)

# metro_str %>%
#   filter(id == "CL_CITIES_VAR") %>%
#   View()

metro_ids <- metro_str %>%
  filter(id == "CL_CITIES_METRO_ID") %>%
  select(metro_name = en_description, metro_id = value)

metro_iso <- metro_ids %>%
  filter(str_length(metro_id) > 3) %>%
  mutate(
    iso = str_remove_all(metro_id, "\\d"),
    iso_guess = countrycode::countrycode(iso, "iso2c", "iso3c", warn = FALSE),
    iso3 = case_when(
      str_length(iso) == 3 ~ iso,
      iso == "UK"          ~ "GBR",
      iso == "EL"          ~ "GRC",
      TRUE ~ iso_guess
      )
    ) %>%
  distinct(metro_id, iso3)

stopifnot(
  nrow(metro_iso) == n_distinct(metro_iso$metro_id),
  all(!is.na(metro_iso$iso3))
  )

metro_core <- metro %>%
  filter(var %in% c("T_T_CORE", "PWM_EX_CORE")) %>%
  mutate(across(time, as.numeric)) %>%
  group_by(metro_id, var) %>%
  filter(time %in% c(2010, 2018)) %>%
  filter(n() == 2) %>%
  ungroup() %>%
  select(-c(obs_status, powercode, time_format, unit)) %>%
  mutate(across(var, tolower), across(obs_value, as.numeric)) %>%
  pivot_wider(names_from = var, values_from = obs_value) %>%
  rename(year = time, pop = t_t_core, pm_ex = pwm_ex_core) %>%
  filter(!is.na(pm_ex)) %>%
  left_join(metro_ids, by = "metro_id") %>%
  left_join(metro_iso, by = "metro_id") %>%
  select(iso3, starts_with("metro"), everything()) %>%
  arrange(metro_id)

metro_core %>%
  filter(year == 2018) %>%
  ggplot(aes(pm_ex, pop_den_core)) +
  geom_point()

# mutate(region = countrycode::countrycode(iso3, "iso3c", "un.region.name"))
# mutate(region = countrycode::countrycode(iso3, "iso3c", "un.subregion.name"))

saveRDS(metro_core, "exercises/02_dataviz/air_pol_metro.rds")



library(gapminder)
library(tidyverse)

gapminder %>%
  select(country:lifeExp) %>%
  pivot_wider(names_from = year, values_from = lifeExp) %>%
  write_rds("exercises/02_dataviz/gapminder_lifeExp_wide.rds")
