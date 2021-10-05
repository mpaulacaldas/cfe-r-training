
# If conditions -----------------------------------------------------------

if (TRUE) {
  "I will print!"
}

if (FALSE) {
  "Nothing will happen!"
}


# Warnings and errors -----------------------------------------------------

if (c(TRUE, FALSE)) {
  "I will print!"
}

any(c(TRUE, FALSE))

if (any(c(TRUE, FALSE))) {
  "I will print!"
}

if (c(FALSE, TRUE)) {
  "Nothing will happen!"
}

all(c(TRUE, FALSE))

if (all(c(FALSE, TRUE))) {
  "Nothing will happen!"
}


if (NA) {
  "I will fail!"
}

if (is.na(NA)) {
  "I will succed!"
}

if (c(NA, TRUE)) {
  "I will fail too!"
}

is.na(c(NA, TRUE))
any(is.na(c(NA, TRUE)))

if (any(is.na(c(NA, TRUE)))) {
  "I will succeed too!"
}


# If - else conditions ----------------------------------------------------

language <- "spanish"
if (language == "spanish") {
  "¡Hola!"
} else {
  "Hi!"
}

language <- "french"
if (language == "spanish") {
  "¡Hola!"
} else if (language == "french") {
  "Salut!"
} else {
  "Hi!"
}


# Vectorised alternatives -------------------------------------------------

byear <- c(1970, 2005, 1992, 1962)

ifelse(2021 - byear < 18, "young", "old")

dplyr::case_when(
  byear <= 1964        ~ "boomer",
  byear %in% 1965:1980 ~ "gen x",
  byear %in% 1981:1996 ~ "millenial",
  TRUE                 ~ "gen z"
)


# Question : How do I locate an NA in a data frame? -----------------------

library(dplyr)

# Using dplyr
airquality %>% 
  filter(is.na(Ozone))
# Base R
airquality[is.na(airquality$Ozone), ]


airquality %>% 
  filter(is.na(Ozone) & is.na(Solar.R))
airquality[is.na(airquality$Ozone) & is.na(airquality$Solar.R), ]



# More efficient patterns -------------------------------------------------

# EXERCISE: The code below shows a very common pattern found in R code for
# creating dummy variables. How could you get the same result using R's coercion
# rules?
dummy_num <- ifelse(byear > 2000, 1, 0)
dummy_num2 <- 1 * (byear > 2000)

df <- data.frame(
  people = letters[1:length(byear)], 
  byear = byear, 
  var = runif(length(byear))
  )

df %>% 
  mutate(
    mean_all = mean(var),
    mean_oldies = mean(var * (byear < 2000))
    )
