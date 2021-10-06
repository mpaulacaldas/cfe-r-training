# simple version: creating just one country note for a manually selected country

rmarkdown::render("template.Rmd", params = list(
  country_selected = "KR"
))



# Creating multiple country notes for a list of countries

possible_countries <- c("KR", "ME", "UK")


## ... using for loops

for (i in possible_countries) {
  rmarkdown::render(
    input = "template.Rmd",
    output_file = paste0(i,'-country-note.pdf'),
    params = list(country_selected = i)
  )
}


## ... using purrr

library(purrr)

file_params <- purrr::cross(list(country_selected = possible_countries))

purrr::map(
  .x = file_params,
  .f = ~rmarkdown::render(
    input = "template.Rmd",
    output_file = paste0(.x, "-country-note.pdf"),
    params = .x
  )
)
