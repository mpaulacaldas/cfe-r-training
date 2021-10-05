a <- list(
  a = 1:3,
  b = "a string",
  c = pi,
  d = list(-1, -5)
  )


# Inspecting lists --------------------------------------------------------

str(a)
View(a)


# Subsetting lists --------------------------------------------------------

a["b"]
typeof(a["b"])

a[["b"]]
typeof(a[["b"]])
a$b
typeof(a$b)


# Exercise ----------------------------------------------------------------

# Type out the different subsets presented in the slides. What are the vector
# types of the outputs you get?
# https://mpaulacaldas.github.io/cfe-r-training/03_programming.html#38

# Hint: Remember the typeof() function.
a
typeof(a[1:2])
typeof(a[4])

a[[4]]
typeof(a[[4]])
typeof(a[[3]])
typeof(a[[4]][1])
typeof(a[[4]][[1]])


# Re-write the bottom row of the figure, but this time, using $
a$d
a$d[1]
a$d[[2]]

a[["d"]]
a[["d"]][1]
a[["d"]][[2]]
