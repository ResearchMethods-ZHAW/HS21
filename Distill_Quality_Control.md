---
title: "Distill Quality Control"
description: |
  Checking the Qualiy of our distill website
author:
  - name: Nils Ratnaweera
date: "2021-11-01"
output: distill::distill_article
---




This file was rendered 2021-11-01 10:28:01.

# Multiple html files in folders?

This next chunk checks if there are mulitple html files within the folders. It actually removes html files that don't match the rmd file's name.


```r
mydirs <- list.dirs(recursive = FALSE,full.names = FALSE)

topics <- mydirs[startsWith(mydirs, "_")]
articles <- list.dirs(topics,recursive = FALSE)
rm_hmtl <- function(folder){
  html <- list.files(folder, "\\.html$")
  html_noext <- sub("(.+)\\.html$", "\\1", html)
  rmd <- list.files(folder, "\\.Rmd$", ignore.case = TRUE)
  rmd_noext <- sub("(.+)\\.[Rr]md$", "\\1", rmd)
  html_extra <- html[!html_noext %in% rmd_noext]
  
  if(length(html_extra)>0){
    html_rm <- file.path(folder, html_extra)
    file.remove(html_rm)
    return(paste("Multiple html files found. Removing: ", html_extra))
  }
  if(length(rmd)>1){
    return("Multiple Rmd files found")
  }
}

res <- sapply(articles, function(x){rm_hmtl(x)})


res[sapply(res, is.null)] <- NULL

if(length(res)>0){
  res
} else{
  print("all good, nothing to report")
}
```

```
## $`_prepro/PrePro1_Demo_Datentypen`
## [1] "Multiple html files found. Removing:  test.html"
```




