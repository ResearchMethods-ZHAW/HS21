packages = sapply(sessionInfo()$otherPkgs, function(x) x$Package)
packages = packages[!packages %in% c("knitr","pander")]
used_packages <- paste(sapply(packages, function(x)paste0("@R-",x)),collapse = ", ")
used_packages <- paste("Dieses Kapitel verwendet folgende Libraries:",used_packages)
pander::pandoc.p(used_packages)
