library(tidyverse)

dirs <- list.dirs(full.names = FALSE, recursive = FALSE)

dirs <- dirs[startsWith(dirs, "_")]

filez <- purrr::map_dfr(dirs, function(x){
  fi <- list.files(x, full.names = TRUE,recursive = TRUE)
  tibble::tibble(file = fi, topic = x)
  })

filez <- filez%>%
  mutate(filetype = map_chr(str_split(file, "\\."), ~.x[[length(.x)]])) %>%
  mutate(filetype = str_to_lower(filetype)) %>%
  filter(!filetype %in% c("rmd", "html", "css","r")) %>%
  mutate(size = file.size(file))

filez %>%
  group_by(topic, filetype) %>%
  summarise(size_mb = sum(size)/1e6) %>%
  ungroup() %>%
  mutate(
    topic = fct_reorder(topic, size_mb, sum)
  ) %>%
  ggplot(aes(size_mb,topic, fill = filetype)) +
  geom_col() 

