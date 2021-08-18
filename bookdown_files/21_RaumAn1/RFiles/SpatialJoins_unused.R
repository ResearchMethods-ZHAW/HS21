
quadrate <-st_make_grid(kantone,cellsize = 200000) %>%
  st_as_sf() %>%
  mutate(id = LETTERS[row_number()])


set.seed(10)
punkte <- st_sample(st_buffer(quadrate,100000),10) %>% st_as_sf() %>% mutate(value = rnorm(nrow(.)))


ggplot(quadrate) + geom_sf() + geom_sf_label(aes(label = id)) + geom_sf(data = punkte,inherit.aes = FALSE, aes(colour = value)) + theme_void()



quadrate_punkte <- st_join(quadrate,punkte) 
quadrate_punkte

quadrate_punkte <- quadrate_punkte%>%
  group_by(id) %>%
  summarise(Anzahl_Punkte = sum(!is.na(value)))

quadrate_punkte

ggplot(quadrate_punkte) + 
  geom_sf(aes(fill = factor(Anzahl_Punkte))) + 
  scale_fill_viridis_d() +
  labs(fill = "Anzahl Punkte") +
  geom_sf_label(aes(label = id)) + 
  geom_sf(data = punkte) + 
  theme_void()

st_join(punkte,quadrate)
