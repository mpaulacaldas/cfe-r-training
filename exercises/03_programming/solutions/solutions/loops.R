# Structure ---------------------------------------------------------------

output <- vector("character", 7)
output
length(output)
typeof(output)


for (m in seq_along(output)) {
  output[m] <- format(
    Sys.Date() + m,
    "%e %b, %Y"
    )
}
output


# Gotcha ------------------------------------------------------------------

# seq_along() tends to be safer than the 1:length() pattern
seq_along(output) == 1:length(output)
output <- NULL
1:length(output)
seq_along(output)


# Less-than-ideal patterns ------------------------------------------------

days   <- c("tomorrow", "day after tomorrow")
output <- NULL
for (m in 1:length(days)) {
  output <- c(output, format(Sys.Date() + m, "%e %b, %Y"))
}
output


# Exercise ----------------------------------------------------------------

# Look back at the "vectorised examples" we showed earlier. How would you write
# them out as loops?

byear <- c(1970, 2005, 1992, 1962)

ifelse(2021 - byear < 18, "young", "old")

# Below is some boilerplate code to guide you. Remember, replace the ... with
# your own code
output <- vector("double", length(byear))
for (y in seq_along(output)) {
  if (2021 - byear[[y]] < 18) {
    output[[y]] <- "young"
  } else {
    output[[y]] <- "old"
  }
}
output

# Now try to recreate the vector returned by the code below, using a for loop
# No boilerplate code for this one. Give it your best shot!
dplyr::case_when(
  byear <= 1964        ~ "boomer",
  byear %in% 1965:1980 ~ "gen x",
  byear %in% 1981:1996 ~ "millenial",
  TRUE                 ~ "gen z"
)

output2 <- vector("double", length(byear))
for (y in seq_along(output2)) {
  current_year <- byear[[y]]
  if (current_year <= 1964) {
    generation <- "boomer"
  } else if (current_year <= 1980) {
    generation <- "gen x"
  } else if (current_year <= 1996) {
    generation <- "millenial"
  } else {
    generation <- "gen z"
  }
  output2[[y]] <- generation
}
output2


# Question: How would I use loops to create new variables? ----------------

library(tidyverse)

# Let's use airquality. We put it in tibble format only for the nicer printing.
airquality2 <- tibble(airquality)

# First, keep in mind that you might not even need for loops. Have a look at 
# dplyr::across(). It allows you to apply functions to a number of columns at 
# the same time.
airquality2 %>% 
  mutate(across(everything(), mean))

# How you would do the same with a loop
airquality2_output <- airquality2
for (c in seq_along(airquality2)) {
  airquality2_output[[c]] <- mean(airquality2_output[[c]])
}
airquality2_output

# use [[ for subsetting inside a loop instead of [ ... why?
airquality2_output[, 1] # returns a tibble
airquality2_output[[1]] # returns a vector

# Say you just want to do it for two columns
airquality2 %>% 
  mutate(across(c(Wind, Temp), mean))

airquality2_output <- airquality2
for (n in c("Wind", "Temp")) {
  airquality2_output[[n]] <- mean(airquality2_output[[n]])
}
airquality2_output

# You want to _create_ new columns instead of replacing old ones
airquality2 %>% 
  mutate(across(c(Wind, Temp), mean, .names = "{.col}_avg"))

airquality2_output <- airquality2
for (n in c("Wind", "Temp")) {
  new_n <- paste0(n, "_avg")
  airquality2_output[[new_n]] <- mean(airquality2_output[[n]])
}
airquality2_output
