# Structure ---------------------------------------------------------------

output <- vector("double", 7)
for (m in seq_along(output)) {
  output[m] <- format(
    Sys.Date() + m,
    "%e %b, %Y"
    )
}
output


# Less-than-ideal patterns ------------------------------------------------

days   <- c("tomorrow", "day after tomorrow")
output <- NULL
for (m in 1:length(days)) {
  output <- c(output, format(Sys.Date() + m, "%e %b, %Y"))
}
output
#> [1] " 1 Oct, 2021" " 2 Oct, 2021"


# Exercise ----------------------------------------------------------------

# Look back at the "vectorised examples" we showed earlier. How would you write
# them out as loops?

byear <- c(1970, 2005, 1992, 1962)

ifelse(2021 - byear < 18, "young", "old")

# Below is some boilerplate code to guide you. Remember, replace the ... with
# your own code
output <- vector("double", length(byear))
for (y in ...) {
  if (2021 - ... < 18) {
    ...
  } else {
    ...
  }
}

dplyr::case_when(
  byear <= 1964        ~ "boomer",
  byear %in% 1965:1980 ~ "gen x",
  byear %in% 1981:1996 ~ "millenial",
  TRUE                 ~ "gen z"
)

# No boilerplate code for this one. Give it your best shot!
