library(bookdown)
library(rsconnect)


bookdown::render_book("index.Rmd",bookdown::gitbook(split_by = "section+number"),config_file = "_bookdown.yml")



rsconnect::deploySite(siteName = "ResearchMethodsUebung")
