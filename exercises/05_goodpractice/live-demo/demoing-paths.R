# if you open RStudio from the .Rproj file, this will point to the folder where
# the .Rproj file is located
getwd()

# relative path, from the working directory
wp <- readRDS("subdirectory/worker_productivity.rds")

# absolute path, from the root directory
wp2 <- readRDS("C:/Users/Caldas_M/LOCAL/_github/cfe-r-training/exercises/05_goodpractice/live-demo/subdirectory/worker_productivity.rds")

# protip: put common paths in a config.yml file
config::get("path_eco")
config::get("url_slides")
url_slides <- config::get("url_slides")

# navigate to file locations or URLs
browseURL(url_slides)
