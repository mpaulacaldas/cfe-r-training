# simple version: creating just one country note for a manually selected country

rmarkdown::render(
  input = "04-rmarkdown.Rmd", 
  params = list(
    country_selected = "KR"
  ),
  output_format = "all" # to simultaneously create html and word files
)



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
