# Demo script for introduction session on 2021-09-16
# We will transform Dotstat data to create figure 2.11 in OECD RCaG 2020
# Disclaimer: This is an example for learning purposes, 
# there will be some differences with the original figure

## 0 Packages ----------------------------------------------------------------------------------------------------------

# install.packages('tidyverse')
library(tidyverse) # includes dplyr, tidyr, readr, ...
# install.packages("writexl")
library(writexl) # writing Excel files


## 1 Data ----------------------------------------------------------------------------------------------------------
## 2.1 Import ----------------------------------------------------------------------------------------------------------

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

# Alternative:
# data <- readsdmx::read_sdmx("https://stats.oecd.org/restsdmx/sdmx.ashx/GetDataStructure/REGION_ECONOM")


# Inspecting the data
names(data_raw) # overview of all variables in dataset
head(data_raw)
# Inspecting variables
unique(data_raw$MEAS)


## 2.2 Manipulation ----------------------------------------------------------------------------------------------------------
# It is more convenient to work with all lower cap variable names
data_lower <- data_raw %>%
  rename_with(tolower)

# Select variables we need - optional - makes it less cluttered when you view the data
data_selected <- data_lower %>%
  select(reg_id, region, tl, var, meas, year, value)

# Filter observations we want within variables
data_filtered <- data_selected %>%
  filter(var == "GVA_IND_TOTAL",
         meas == "PW_REAL_PPP",
         year == "2018",
         tl == "2")

# Create group variable for countries using reg_id
# Once we learn how to join data, we can also use a file that has all descriptive stats about TL2 regions,
# including the regional TL code, name, which country they belong to, etc.
data_iso2 <- data_filtered %>%
  mutate(country = substr(reg_id, 1, 2))

# Small data cleaning extra: take out "not regionalised" observations
data_checked <- data_iso2 %>%
  mutate(check = substr(reg_id, 3, 4)) %>%
  filter(check != "ZZ")

# Calculate national average
data_average <- data_checked %>%
  group_by(country) %>%
  mutate(average = mean(value),  # This is an unweighted mean. Later in the workshop we will learn how to merge data files and we can calculate a weighted mean using additional data on total employment
         max = max(value), 
         min = min(value)) %>% 
  ungroup() # in this example this last line is not necessary


## 2.3 Saving the relevant data ----------------------------------------------------------------------------------------------------------


data_final <- data_average %>%
  distinct(country, min, average, max)

write_xlsx(data_final, "worker_productivity.xlsx")




