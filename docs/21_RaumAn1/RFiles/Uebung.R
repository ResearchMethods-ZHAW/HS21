library(sf)
library(tidyverse)
library(stars)
library(raster)

## -- Aufgabe 1: Daten runterladen und importieren -- ##


# Pfad muss natürlich angepasst werden
wasser <- read_sf("21_RaumAn1/data/wasserverfuegbarkeit_boden.gpkg")
kantone <- read_sf("21_RaumAn1/data/kantone.gpkg")
bezirke <- read_sf("21_RaumAn1/data/bezirke.gpkg") 
skelettgehalt <- read_sf("21_RaumAn1/data/bodeneignung_skelett.gpkg")


## -- Aufgabe 2: Daten Visualisieren -- ##

ggplot(bezirke) + 
  geom_sf()

ggplot(wasser) + 
  geom_sf()

## -- Aufgabe 3 Koordinatensysteme zuweisen -- ##

st_crs(wasser)
st_crs(bezirke)

wasser <- st_set_crs(wasser, 4326)
bezirke <- st_set_crs(bezirke, 2056)

# zuweisen mit st_set_crs(), abfragen mit st_crs()
st_crs(wasser)

kantone <- st_set_crs(kantone, 2056)
skelettgehalt <- st_set_crs(skelettgehalt, 2056)

ggplot() + 
  geom_sf(data = kantone) +
  geom_sf(data = wasser)

## -- Aufgabe 4: Koordinatensyteme transformieren -- ##

wasser

wasser <- st_transform(wasser, 2056)

wasser

## -- Aufgabe 5: Spatialjoin -- ##

wasser_skelett <- st_join(wasser,skelettgehalt)
wasser_skelett


wasser_skelett %>%
  mutate(SKELETT = factor(SKELETT)) %>%
  ggplot() +  
  geom_boxplot(aes(SKELETT,wasserverfuegbarkeit))

## -- Aufgabe 6: Spatial Join mit Flächen -- ##

wasser_2km <- st_buffer(wasser,2000)

ggplot(wasser_2km) + geom_sf(fill = "blue")


raster_template <- raster(extent(skelettgehalt), crs = st_crs(skelettgehalt)$proj4string, resolution = 1000)


skelett_raster <- rasterize(skelettgehalt,raster_template,field = "SKELETT")

ggplot() + 
  geom_stars(data = st_as_stars(skelett_raster)) +
  coord_equal() # geom_stars() ist (noch) nicht so clever wie geom_sf() das CRS wird nicht berücksichtigt

mode <- function(x,na.rm = FALSE) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

wasser_skelett$skelett_mode <- extract(skelett_raster,wasser_2km,fun = mode)[,1]

ggplot(wasser_skelett) + 
  geom_bar(aes(skelett_mode)) + 
  labs(x = "Skelettgehalt gem. Variante 1", y = "Anzahl",
       title = "Vergleich zwischen den beiden Join Varianten") +
  facet_wrap(~SKELETT,labeller = label_both)

## -- Aufgabe 7: Spatial Join mit Kantone, Bezirke -- ##

library(ggrepel)


aggregate(x = wasser, by = kantone, FUN = mean) %>%
  ggplot() + 
  geom_sf(aes(fill = wasserverfuegbarkeit)) + 
  geom_sf(data = wasser,size = 0.1) +  
  geom_text_repel(
    data = summarise(group_by(kantone,NAME)),
    aes(label = NAME, geometry = geom),
    stat = "sf_coordinates"
  ) +
  labs(title = "Mittlere Wasserverfügbarkeit im Boden", subtitle = "pro Kanton", fill = "") +
  theme_void() +
  theme(legend.position = "bottom",legend.direction = "horizontal") 


aggregate(wasser, bezirke, mean) %>%
  ggplot() + 
  geom_sf(aes(fill = wasserverfuegbarkeit)) + 
  geom_sf(data = wasser,size = 0.1) +
  geom_sf(data = kantone, fill = NA, colour = "grey") +
  labs(title = "Mittlere Wasserverfügbarkeit im Boden", subtitle = "pro Bezirk", fill = "") +
  theme_void() +
  theme(legend.position = "bottom",legend.direction = "horizontal") 



## -- Aufgabe 8 (für Ambitionierte) -- ##

hex <- st_make_grid(kantone,cellsize = 20000, square = FALSE) %>%
  st_sf() %>%
  aggregate(x = wasser, by = .,mean) %>%
  st_intersection(st_union(kantone))

hex2 <- st_join(hex,kantone,largest = TRUE) %>%
  st_set_precision(100) %>% 
  group_by(Abk) %>% summarise()

ggplot() +
  geom_sf(data = hex, aes(fill = wasserverfuegbarkeit), colour = NA) +
  scale_fill_continuous(na.value = NA) +
  labs(title = "Mittlere Wasserverfügbarkeit im Boden", subtitle = "20km Hexagon", fill = "") +
  geom_sf(data = hex2, colour = "grey", fill = NA) +
  geom_sf_text(data = hex2, aes(label = Abk), size = 3, colour = "grey") +
  theme_void() +
  theme(legend.position = "bottom",legend.direction = "horizontal")




