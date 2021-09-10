remotes::install_github("gadenbuie/xaringanExtra")
remotes::install_github("gadenbuie/countdown")
remotes::install_github("hadley/emo")
remotes::install_github("mitchelloharawild/icons")
icons::download_fontawesome()

library(purrr)
c(
  "01_intro.Rmd",
  "02_dataviz.Rmd",
  "03_programming.Rmd",
  "04_rmarkdown.Rmd",
  "05_goodpractice.Rmd"
  ) %>%
  fs::path("docs/", .) %>%
  walk(~ fs::file_copy("docs/_template.Rmd", .x))

