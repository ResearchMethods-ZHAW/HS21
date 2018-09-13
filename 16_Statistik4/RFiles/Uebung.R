## 
## 
## 
## # Allow duplicate Labels so that calling purl() does not create an error
## # https://stackoverflow.com/q/36868287/4139249
## options(knitr.duplicate.label = 'allow')
## 
## # purl all Rmd Documents (with some exceptions) and store them in a Subfolder /RFiles
## # Document cannot be knitted if the folder "RFiles" does not exist!
## library(stringr)
## 
## rmds <- list.files(pattern = ".Rmd",recursive = T)
## rmds <- rmds[!(grepl("ResearchMethods",rmds) | grepl("_Rcode",rmds) | grepl("99_",rmds)| grepl("index",rmds)| grepl("Archive",rmds)| grepl("Admin",rmds))]
## 
## for (file in rmds){
##   file_r <- gsub("Rmd","R",file)                          # change fileextension from .rmd to r
##   file_r <- str_split_fixed(file_r,"/",Inf)                 # split path at /
##   file_r <- append(file_r, "RFiles",length(file_r)-1)     # append Foldername "RFiles" in 2nd last pos
##   file_r <- paste(file_r,collapse = "/")                  # collapse vector to string
##   if(file.exists(file_r)){
##     file.remove(file_r)
##   }
##   knitr::purl(file,documentation = 0,output = file_r)
## }
## 
## 
## 
## 
## 
## 
## # detach packages
## packages = sapply(sessionInfo()$otherPkgs, function(x) x$Package)
## packages = packages[packages != "bookdown"]
## packages = sapply(packages, function(p) paste0("package:", p))
## lapply(packages, detach, character.only = TRUE, unload = TRUE)
## # clear environment
## rm(list = ls())
