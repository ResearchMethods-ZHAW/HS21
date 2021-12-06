knitr::opts_chunk$set(echo = FALSE)


library(dplyr)
library(sf)
library(ggplot2)

#' ### Aufgabe 1: Geopackage "Layers"
st_layers("gruental.gpkg")

wiesen <- read_sf("gruental.gpkg","wiesen")
baeume <- read_sf("gruental.gpkg", "baeume")

#' ### Aufgabe 2: Datensätze erkunden
ggplot(wiesen) +
  geom_sf(fill = "chartreuse4") +
  geom_sf(data = baeume) +
  theme_void()

#' ### Aufgabe 3:  Spatial Join mit Punkten
baeume_join <- st_join(baeume, wiesen) 

anzahl_in_wiese <- sum(!is.na(baeume_join$flaechen_typ))
anzahl_nicht_in_wiese <- sum(is.na(baeume_join$flaechen_typ))

#' ### Aufgabe 4: Spatial Join mit Flächen
baeume_20m <- st_buffer(baeume, 20)

baeume_wiesen <- st_intersection(baeume_20m, wiesen) 

baeume_wiesen$wiesen_flaeche <- as.numeric(st_area(baeume_wiesen))

baeume_wiesen$wiesen_anteil <- baeume_wiesen$wiesen_flaeche/(20^2*pi)

baeume_wiesen_df <- st_drop_geometry(baeume_wiesen)

baeume_2 <- left_join(baeume, baeume_wiesen_df, by = "baum_id") %>%
  mutate(wiesen_anteil = ifelse(is.na(wiesen_anteil),0,wiesen_anteil))

ggplot() +
  geom_sf(data = wiesen) +
  geom_sf(data = baeume_20m, fill = NA, color = "grey") +
  geom_sf(data = baeume_2, aes(colour = wiesen_anteil)) +
  scale_color_binned("Wiesen Anteil",low = "blue", high = "red", limits = c(0,1), label = scales::label_percent()) +
  coord_sf(datum = 2056)


#' ## Musterlösung

