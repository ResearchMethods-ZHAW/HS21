
library(tidyverse)



dirs <- list.dirs("bookdown_files", recursive = FALSE, full.names = TRUE)

idx <- basename(dirs) %>%
  str_extract("^\\d{2}") %>%
  as.integer()

mydirs <- dirs[idx > 0 & idx < 30 & !is.na(idx)]


map_dfr(mydirs, function(x){
  
  abstract <- list.files(x, "Abstract.Rmd", full.names = TRUE)
  
  if(length(abstract) != 1){
    print(paste("folder",x,"does not have an abstract"))
    title <- NA
    }  else{
      rl <- read_lines(abstract) 
      title <- rl[str_detect(rl, "^#")]
    }
  
  
  
  
  tibble(folder = x, title = title)
})

mydf <- mydirs %>%
  map_dfr(function(x){
    
    topic <- basename(x)
    fi <- list.files(path = x, pattern = ".Rmd", recursive = FALSE, full.names = TRUE)
    
    tibble(topic = topic, file = fi)
  }) %>%
  mutate(
    number = str_extract(topic, "\\d{2}"),
    name = str_match(topic, "_(.+)")[,2],
    i = str_extract(name,"\\d"),
    name2 = str_extract(name, "([a-zA-Z]+)"),
    tag = str_match(name, "_(.+)")[,2]
  )


mydf %>%
  select(file,name,name2, tag) %>%
  pmap(function(file,name,name2, tag){
    newdir <- paste0("_",str_to_lower(name))
    newdir
    if(!dir.exists(newdir)){dir.create(newdir)}
    
    
   
    
    
    subdir <- str_split(basename(file), "\\.")[[1]][1]
    subdirpath <- file.path(newdir, subdir)
    if(!dir.exists(subdirpath)){dir.create(subdirpath)}
    
    # rl <- read_lines(file)
    
    # header <- c(
    #   "---"
    # )
    
    list(title = subdir) 
    
    
  })




dirs <- list.dirs("_statistik", recursive = FALSE, full.names = TRUE)

cha <- tibble(original = dirs) %>% 
  mutate(
    new = str_remove(dirs, "_stat\\d|_Statistik_\\d")
    )  

cha %>% head(1) %>%
pmap(function(original, new){
  file.rename(original, new)
})
