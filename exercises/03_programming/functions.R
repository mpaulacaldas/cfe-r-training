# Syntax ------------------------------------------------------------------

# name            # arguments
greet <- function(person, language = "ENG") {
  # function body
  greeting <- "Hi"
  if (language == "ESP") {
    greeting <- "Hola"
  }
  # returned value
  paste0(greeting, ", ", person, "!")
}

# when call a function, you can specify the arguments
greet(person = "Jolien")

# ... or fill them by position
greet("Jolien")
greet("Jolien", "ESP")

# if you change the order of the arguments, you need to name them, otherwise you
# might get unexpected results
greet(language = "ESP", person = "Jolien")


# Exercise ----------------------------------------------------------------

# Take a look at the code below, run it step by step. What does it do?
# YOUR ANSWER:

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

out <- df
out

out$a <- (df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
out

out$b <- (df$b - min(df$b, na.rm = TRUE)) /
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
out

out$c <- (df$c - min(df$c, na.rm = TRUE)) /
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
out

out$d <- (df$d - min(df$d, na.rm = TRUE)) /
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
out

# Take the bit of the code below, and study it. How would you write a function
# to make things look cleaner? What name would you give to the function?
(df$a - min(df$a, na.rm = TRUE)) / (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

... <- function(...) {
  ...
}

# Try running your function, do you get the same result as above?
...(df$a)

# Create a new data frame, using your new function. Is there any difference
# between your new data frame and the old one?

out2 <- df

out2$a <- ...(df$a)
out2$b <- ...(df$b)
out2$c <- ...(df$c)
out2$d <- ...(df$d)

out
out2

all.equal(out, out2)
