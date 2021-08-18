library(gstat)
library(sf)
library(tidyverse)
library(lubridate)
library(stars)

luftqualitaet <- read_sf("22_RaumAn2/data/luftqualitaet.gpkg")
kantone <- read_sf("21_RaumAn1/data/kantone.gpkg")
rotmilan <- read_sf("22_RaumAn2/data/rotmilan.gpkg")


luftqualitaet <- st_set_crs(luftqualitaet,2056)
kantone <- st_set_crs(kantone, 2056)
rotmilan <- st_set_crs(rotmilan, 2056)

########################################
## -- Übung C - Dichteverteilungen -- ##
########################################

## -- Aufgabe 4: Rotmilan Bewegungsdaten visualisieren -- ##

ggplot(kantone) + 
  geom_sf() + 
  geom_sf(data = rotmilan) +
  theme_void()

## -- Aufgabe 5: Kernel Density Estimation berechnen -- ##

my_kde <- function(points,cellsize, bandwith, extent = NULL){
  require(MASS)
  require(raster)
  require(sf)
  require(stars)
  if(is.null(extent)){
    extent_vec <- st_bbox(points)[c(1,3,2,4)]
  } else{
    extent_vec <- st_bbox(extent)[c(1,3,2,4)]
  }
  
  n_y <- ceiling((extent_vec[4]-extent_vec[3])/cellsize)
  n_x <- ceiling((extent_vec[2]-extent_vec[1])/cellsize)
  
  extent_vec[2] <- extent_vec[1]+(n_x*cellsize)-cellsize
  extent_vec[4] <- extent_vec[3]+(n_y*cellsize)-cellsize

  coords <- st_coordinates(points)
  matrix <- kde2d(coords[,1],coords[,2],h = bandwith,n = c(n_x,n_y),lims = extent_vec)
  raster(matrix)
}

schweiz <- st_union(kantone)
rotmilan_kde <- my_kde(rotmilan,cellsize = 1000,bandwith = 10000, extent = schweiz)

rotmilan_kde

plot(rotmilan_kde)

ggplot() + 
  geom_stars(data = st_as_stars(rotmilan_kde)) +
  geom_sf(data = kantone, fill = NA) +
  scale_fill_viridis_c() +
  theme_void() +
  theme(legend.position = "none")

q95 <- raster::quantile(rotmilan_kde,probs = 0.95)

ggplot() + 
  geom_sf(data = kantone, fill = NA) +
  geom_stars(data = st_as_stars(rotmilan_kde),alpha = 0.8) +
  scale_fill_viridis_c(trans = "log10",limits = c(q95,NA),na.value = NA) +
  theme_void() +
  labs(fill = "KDE",title = "Dichteverteilung von Bewegungsdaten eines Rotmilans",subtitle = "Jahre 2017-2019") +
  theme(legend.position = "top", legend.direction = "horizontal")

## -- Aufgabe 6: Dichteverteilung mit Thiessen Polygonen -- ##


thiessenpolygone <- rotmilan %>%
  st_union() %>%
  st_voronoi()

ggplot() + 
  geom_sf(data = kantone) + 
  geom_sf(data = thiessenpolygone, fill = NA) + 
  geom_sf(data = rotmilan) +
  theme_void()

schweiz <- st_union(kantone)


thiessenpolygone

thiessenpolygone <- st_cast(thiessenpolygone)

thiessenpolygone

# Dieser Schritt kann eine Weile dauern
thiessenpolygone_clip <- st_intersection(thiessenpolygone,schweiz)


ggplot() + 
  geom_sf(data = schweiz) + 
  geom_sf(data = thiessenpolygone_clip) + 
  theme_void()
