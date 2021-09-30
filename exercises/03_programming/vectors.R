# Reminder: You can run lines with Ctrl + Enter

# Atomic vectors ----------------------------------------------------------

lgl <- c(TRUE, FALSE, TRUE, TRUE)
int <- c(1L, 2L, 3L, 4L)
dbl <- c(5.5, 33.6, 8, 12.5)
chr <- c("coffee", "café")

# print them
lgl
int
dbl
chr

# explore their type
typeof(lgl)
typeof(int)
typeof(dbl)
typeof(chr)


# Logical operations ------------------------------------------------------

telework_days <- c(2, 4:5)
office_days   <- c("monday", "wednesday")

4 %in% telework_days
3:5 %in% telework_days
is.character(office_days)

# EXERCISE: Write down the conditions to check the vector types of lgl, int, dbl
# and chr

# EXERCISE: Try out is.numeric(). What do you get of int? For dbl?


# Coercion ----------------------------------------------------------------

# Explicit
as.numeric(lgl)
as.character(int)

# Implicit
lgl * 5
c(chr, dbl)

# Introducing NAs
ages_chr <- c("29", "88", "46", ">100")
ages_num <- as.numeric(ages_chr)
ages_num


# Missing values ----------------------------------------------------------

typeof(NA)
typeof(NA_integer_)
typeof(NA_real_)
typeof(NA_character_)

# Coercion
c("tea", NA, "té")
typeof(c("tea", NA, "té"))

# Contagion
mean(c(10, 20, NA))
mean(c(10, 20, NA), na.rm = TRUE)

# Warnings
library(ggplot2)
ggplot(airquality, aes(Ozone, Temp)) +
  geom_point()

# Identifying missing values
x <- c(10, 20)
x == 10
x == NA
is.na(x)

# EXERCISE: Think about the programming language or software you use to treat
# data. How does it handle missing values?


# Recycling ---------------------------------------------------------------

rates <- c(0.93, 0.85, 0.43)

# Equivalent
rates * 100
rates * c(100, 100, 100)

# More recycling
c(10, 100, 1000, 10000) * c(1, 3)
c(10, 100, 1000, 10000) * c(1, 3, 1, 3)

# Recycling behaviour explains some weird warnings
1:5 + 1:3


# Subsetting --------------------------------------------------------------

office <- c("alexandre", "nikos", "maria paula", "tahsin")

# Subsetting by position
office[2]
office[c(1, 4)]
office[-1]

# Subsetting with a logical vector
office
present_on_monday <- c(TRUE, FALSE, TRUE, TRUE)
office[present_on_monday]

# Subsetting with names
names(office) <- c("BANQUET", "PATIAS", "CALDAS", "MEDHI")
office
office[c("CALDAS", "PATIAS")]

# EXERCISE: Recreate the example above with your own office mates.

