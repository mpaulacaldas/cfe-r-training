# Date created: September 2021
# About: Create data folders to collect raw data on countries for RCaG report

library(here)
library(fs)

motherdir <- here()
dir_dataraw <- here("data-raw")

selected_countries <- c("UK", "ME", "KR")

dir_create(fs::path(dir_dataraw, selected_countries))

