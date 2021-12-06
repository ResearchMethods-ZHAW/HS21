library(sf)
library(dplyr)
library(ggplot2)

#' ### Aufgabe 1: Vektor Daten runterladen und importieren

kantone <- read_sf("kantone.gpkg")
gemeinden <- read_sf("gemeinden.gpkg") 

#' ### Aufgabe 2: Daten Visualisieren
ggplot(gemeinden) + 
  geom_sf()

ggplot(kantone) + 
  geom_sf()

#' ### Input: Koodinatensysteme
st_crs(kantone)
st_crs(gemeinden)

kantone <- st_set_crs(kantone, 4326)
gemeinden <- st_set_crs(gemeinden, 2056)

# zuweisen mit st_set_crs(), abfragen mit st_crs()
st_crs(kantone)

ggplot() + 
  geom_sf(data = kantone) +
  coord_sf(datum = 2056)

#' ### Aufgabe 3: Koordinatensyteme *transformieren*
kantone

kantone <- st_transform(kantone, 2056)

kantone

#' ### Aufgabe 4: Chloroplethen Karte


ggplot(kantone, aes(fill = EINWOHNERZ/1e6)) +
  geom_sf(color= "white",size = .05) +
  labs(title = "Anzahl Einwohner pro Kanton",
       subtitle = "in Millionen") +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.key.width = unit(0.15, 'npc'),
        legend.key.height = unit(0.02, 'npc'),
        legend.text = element_text(angle = 90,hjust = 0.5),
        legend.text.align = 1)


ggplot(gemeinden,aes(fill = EINWOHNERZ/1e6)) +
  geom_sf(color= "white",size = .05) +
  scale_fill_continuous("Einwohner (in Mio)") +
  labs(title = "Anzahl Einwohner pro Gemeinde",
       subtitle = "in Millionen") +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.key.width = unit(0.15, 'npc'),
        legend.key.height = unit(0.02, 'npc'),
        legend.text = element_text(angle = 90,hjust = 0.5),
        legend.text.align = 1)

#' ## Musterlösung

