library(editData)
library(yaml)

rmdfiles <- read.csv("rmdfiles.csv")

rmds_torender <- editData(rmdfiles)

rmds_torender <- paste(rmds_torender$Folder, rmds_torender$File, sep = "/")

bookdown_yaml <- yaml::read_yaml("_bookdown.yml")

bookdown_yaml$rmd_files <- c("index.Rmd",rmds_torender)

yaml::write_yaml(bookdown_yaml, "_bookdown.yml")


