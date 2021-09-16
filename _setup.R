# what I installed for the slides, in work laptop
if (FALSE) {
  install.packages("xaringan")
  remotes::install_github("gadenbuie/xaringanExtra")
  remotes::install_github("gadenbuie/countdown")
  remotes::install_github("hadley/emo")
  remotes::install_github("mitchelloharawild/icons")
  icons::download_fontawesome()
}

# what I installed in each RStudio Cloud project
if (FALSE) {
  install.packages("tidyverse")
  install.packages("writexl")
  install.packages("readsdmx")
}


# Files and directories ---------------------------------------------------

library(purrr)

rmds <- c(
  "01_intro.Rmd"
  # "02_dataviz.Rmd",
  # "03_programming.Rmd",
  # "04_rmarkdown.Rmd",
  # "05_goodpractice.Rmd"
  )

rmds %>%
  fs::path("docs/", .) %>%
  walk(~ fs::file_copy("docs/00_template.Rmd", .x))

rmds %>%
  fs::path_ext_remove() %>%
  fs::path("exercises/", .) %>%
  fs::dir_create()


# Render ------------------------------------------------------------------

if (FALSE) {
  usethis::use_github_pages(branch = "main", path = "/docs")
}

library(rmarkdown)

render("README.md", output_file = "docs/index.html")
render("docs/00_template.Rmd")
render("docs/01_intro.Rmd")
