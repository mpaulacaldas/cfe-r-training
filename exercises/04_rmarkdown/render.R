# Simple version: Creating just one country note for the country given by
# default in the template

rmarkdown::render(
  input = "template.Rmd",
  output_format = "all" # to simultaneously create html and word files
)



# Creating multiple country notes for a list of countries

possible_countries <- c("KOR", "MEX", "GBR")
possible_formats   <- c("html_document", "word_document")

fs::dir_create("country-notes")

for (i in possible_countries) {
  for (j in possible_formats) {
    rmarkdown::render(
      input = "template.Rmd",
      output_dir = "country-notes", 
      output_format = j,
      output_file = i,
      params = list(iso3 = i)
    )
  }
}
