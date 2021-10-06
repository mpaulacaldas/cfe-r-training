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

rproj <-
  c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: No",
    "SaveWorkspace: No",
    "AlwaysSaveHistory: Default",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX"
  )

rmds <- c(
  "01_intro.Rmd",
  "02_dataviz.Rmd",
  "03_programming.Rmd",
  "04_rmarkdown.Rmd"
  # "05_goodpractice.Rmd"
  )

file_copy2 <- safely(fs::file_copy, otherwise = NULL)

rmds %>%
  fs::path("docs/", .) %>%
  walk(~ file_copy2("docs/00_template.Rmd", .x, overwrite = FALSE))

rmds %>%
  fs::path_ext_remove() %>%
  fs::path("exercises/", .) %>%
  fs::dir_create()

rmds %>%
  fs::path_ext_remove() %>%
  fs::path("exercises/", ., "solutions") %>%
  fs::dir_create()

rmds %>%
  fs::path_ext_remove() %>%
  {paste0("exercises/", ., "/", ., ".Rproj")} %>%
  purrr::walk(~ writeLines(rproj, .x))


# Render ------------------------------------------------------------------

if (FALSE) {
  usethis::use_github_pages(branch = "main", path = "/docs")
}

library(rmarkdown)

render("README.md", output_file = "docs/index.html")
render("docs/00_template.Rmd")
render("docs/01_intro.Rmd")
render("docs/02_dataviz.Rmd")
render("docs/03_programming.Rmd")
render("docs/04_rmarkdown.Rmd")
