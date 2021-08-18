
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
  # head(6) %>%
  select(file,name,name2, tag) %>%
  pmap(function(file,name,name2, tag){
    newdir <- paste0("_",str_to_lower(name))
    newdir
    if(!dir.exists(newdir)){dir.create(newdir)}
    
    
    
    
    
    subdir <- str_split(basename(file), "\\.")[[1]][1]
    subdirpath <- file.path(newdir, subdir)
    if(!dir.exists(subdirpath)){dir.create(subdirpath)}
    
    rl <- read_lines(file)
    
    rl[str_detect(rl, "readLines")] <- "```"
    

    title <- rl[str_detect(rl, "^#")][1]
    
    title <- str_extract(title, "\\w+")
    yaml_header <- list(title = title, output = "distill::distill_article") %>%
      yaml::as.yaml()
    
    head <- c(
      "---",
      yaml_header,
      "---",
      "",
      "```{r echo = FALSE}",
      "knitr::opts_chunk$set(error = TRUE)",
      "```"
    )
    
    rl <- c(head, rl)
    
    
    write_lines(rl, file.path(subdirpath, "index.Rmd"))
    
    
    # paths <- str_extract(rl, '"[\\w\\/]+\\.\\w+"')
    # paths[!is.na(paths)]
  })


distill_dirs <- list.dirs(recursive = FALSE)
distill_dirs <- distill_dirs[str_detect(basename(distill_dirs), "^_")]

library(knitr)
distill_dirs %>%
  map(function(x){
    file_list <- list.files(x, "index.Rmd", recursive = TRUE, full.names = TRUE)
    
    map(file_list, ~knit(.x))
    
    
  })

library(glue)

mydf %>%
  group_by(name2, name) %>%
  summarise() %>%
  split(.$name2) %>%
  imap(function(x,y){
    x <- x$name
    
    
    #### creates the yaml- menu header for _site.yml
    li <- c(
      glue('- text: "',{y},'"'),
      '  menu:',
      c(t(cbind(paste0('  - text: "',x,'"'),paste0('    href: ',x,'.html'))))
    )
    
    # write_lines(li,"test.yaml",append = TRUE)
    
    
   
    })


map(mydf$name, function(x){
  
  
  head <- c(
    '---',
    glue('title: "{x}"'),
    glue('listing: {str_to_lower(x)}'),
    '---'
  )
  
  
  write_lines(head, glue("{x}.Rmd"))
  
  
})

