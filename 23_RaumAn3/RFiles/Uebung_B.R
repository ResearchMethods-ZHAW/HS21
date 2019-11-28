library(sf)
library(tidyverse)
library(ggplot2)
library(plotly)
        
kantone <- read_sf("21_RaumAn1/data/kantone.gpkg")
wasser <- read_sf("21_RaumAn1/data/wasserverfuegbarkeit_boden.gpkg")

kantone <- st_set_crs(kantone, 2056)
wasser <- wasser %>%
  st_set_crs(4326) %>%
  st_transform(2056)

wasser_kantone <- aggregate(wasser,kantone, mean)


p_kantone <- ggplot(wasser_kantone) +
  geom_sf(aes(fill = wasserverfuegbarkeit), colour = "white",lwd = 0.2) +
  scale_fill_viridis_c() +
  labs(title = "Mittlere Wasserverfügbarkeit nach Kantone",fill = "") +
  theme_void()

ggplotly(p_kantone)

library(tmap)
tm_shape(wasser_kantone) + tm_polygons(col = "wasserverfuegbarkeit", alpha = 0.3,palette = "viridis",midpoint = NA)

tmap_mode("view")

tm_shape(wasser_kantone) + tm_polygons(col = "wasserverfuegbarkeit", alpha = 0.3,palette = "viridis",midpoint = NA)
