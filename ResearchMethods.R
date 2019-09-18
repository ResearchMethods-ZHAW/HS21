## ------------------------------------------------------------------------
input  = knitr::current_input()  # filename of input document
print(input)

output = paste(tools::file_path_sans_ext(input), 'R', sep = '.')
print(output)
knitr::purl(input,output,documentation=1,quiet=T)

## ---- eval = F-----------------------------------------------------------
## library(stringr, eval = F)
## 
## rmds <- list.files(pattern = ".Rmd",recursive = T)
## rmds <- rmds[!(grepl("ResearchMethods",rmds) | grepl("_Rcode",rmds) | grepl("99_",rmds)| grepl("index",rmds)| grepl("Archive",rmds))]
## 
## for (file in rmds){
##   file_r <- gsub("Rmd","R",file)                          # change fileextension from .rmd to r
##   file_r <- str_split_fixed(file_r,"/",Inf)                 # split path at /
##   file_r <- append(file_r, "RFiles",length(file_r)-1)     # append Foldername "RFiles" in 2nd last pos
##   file_r <- paste(file_r,collapse = "/")                  # collapse vector to string
##   if(file.exists(file_r)){
##     file.remove(file_r)
##     print(paste("Deleted",file_r))
##   }
##   print(file)
##   knitr::purl(file,documentation = 0,output = file_r)
## }

## ----include=FALSE, message=F--------------------------------------------
# automatically create a bib database for R packages
knitr::write_bib(c(
  .packages(), 'bookdown', 'knitr', 'rmarkdown','tidyverse','plotly','car','ggfortify','boot','pander','scales','multicomp','ggExtra'
), 'packages.bib')

