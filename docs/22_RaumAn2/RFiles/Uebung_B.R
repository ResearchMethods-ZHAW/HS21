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

#############################################
## -- Übung B - Räumliche Interpolation -- ##
#############################################

## -- Aufgabe 2: Räumliche Interpolation mit IDW -- ##

my_idw <- function(groundtruth,column,cellsize, nmax = Inf, maxdist = Inf, idp = 2, extent = NULL){
  require(gstat)
  require(sf)
  require(raster)
  if(is.null(extent)){
    extent <- groundtruth
  }
  
  samples <- st_make_grid(extent,cellsize,what = "centers") %>% st_as_sf()
  my_formula <- formula(paste(column,"~1"))
  idw_sf <- gstat::idw(formula = my_formula,groundtruth,newdata = samples,nmin = 1, maxdist = maxdist, idp = idp)
  
  idw_matrix <- cbind(st_coordinates(idw_sf),idw_sf$var1.pred)
  
  
  ras <- raster::rasterFromXYZ(idw_matrix)
  
  if(all(grepl("polygon",st_geometry_type(extent),ignore.case = TRUE))){
    ras <- raster::mask(ras,st_as_sf(st_zm(extent)))
  }
  ras
}

## my_idw(groundtruth = luftqualitaet,column = "value",cellsize = 1000)
## 



nmax = Inf
maxdist = 40000
idp = 2

idw <- my_idw(luftqualitaet,"value",1000,nmax = nmax,maxdist = maxdist,idp = idp, extent = kantone)

luftqualitaet_extreme <- luftqualitaet %>%
  arrange(value) %>%
  slice(c(1:5,(n()-4):n()))

ggplot() +
  geom_stars(data = st_as_stars(idw)) +
  ggrepel::geom_text_repel(
    data = luftqualitaet_extreme,
    aes(label = value, geometry = geom),
    stat = "sf_coordinates",
    min.segment.length = 0
  ) +
  scale_fill_viridis_c(na.value = NA) +
  labs(title = "Luftqualitätswerte Schweiz NO2, Interpoliert mit IDW",
       fill = "μg/m3",
       subtitle = paste("nmax: ",nmax,"\nmaxdist: ",maxdist,"\nidp: ",idp,sep = " ")
  ) +
  theme_void() +
  coord_equal()


nmax = 50
maxdist = Inf
idp = 1

idw <- my_idw(luftqualitaet,"value",1000,nmax = nmax,maxdist = maxdist,idp = idp, extent = kantone)

ggplot() +
  geom_stars(data = st_as_stars(idw)) +
  ggrepel::geom_text_repel(
    data = luftqualitaet_extreme,
    aes(label = value, geometry = geom),
    stat = "sf_coordinates",
    min.segment.length = 0
  ) +
  scale_fill_viridis_c(na.value = NA) +
  labs(title = "Luftqualitätswerte Schweiz NO2, Interpoliert mit IDW",
       fill = "μg/m3",
       subtitle = paste("nmax: ",nmax,"\nmaxdist: ",maxdist,"\nidp: ",idp,sep = " ")
  ) +
  theme_void()+
  coord_equal()


nmax = 50
maxdist = Inf
idp = 2

idw <- my_idw(luftqualitaet,"value",1000,nmax = nmax,maxdist = maxdist,idp = idp, extent = kantone)

ggplot() +
  geom_stars(data = st_as_stars(idw)) +
  ggrepel::geom_text_repel(
    data = luftqualitaet_extreme,
    aes(label = value, geometry = geom),
    stat = "sf_coordinates",
    min.segment.length = 0
  ) +
  scale_fill_viridis_c(na.value = NA) +
  labs(title = "Luftqualitätswerte Schweiz NO2, Interpoliert mit IDW",
       fill = "μg/m3",
       subtitle = paste("nmax: ",nmax,"\nmaxdist: ",maxdist,"\nidp: ",idp,sep = " ")
  ) +
  theme_void()+
  coord_equal()


nmax = 50
maxdist = Inf
idp = 3

idw <- my_idw(luftqualitaet,"value",1000,nmax = nmax,maxdist = maxdist,idp = idp, extent = kantone)

ggplot() +
  geom_stars(data = st_as_stars(idw)) +
  ggrepel::geom_text_repel(
    data = luftqualitaet_extreme,
    aes(label = value, geometry = geom),
    stat = "sf_coordinates",
    min.segment.length = 0
  ) +
  scale_fill_viridis_c(na.value = NA) +
  labs(title = "Luftqualitätswerte Schweiz NO2, Interpoliert mit IDW",
       fill = "μg/m3",
       subtitle = paste("nmax: ",nmax,"\nmaxdist: ",maxdist,"\nidp: ",idp,sep = " ")
  ) +
  theme_void()


## -- Aufgabe 3: Interpolation mit Nearest Neighbour / Thiessen Polygone -- ##


luftqualitaet_union <- st_union(luftqualitaet)

thiessenpolygone <- st_voronoi(luftqualitaet_union)

thiessenpolygone <- st_set_crs(thiessenpolygone, 2056)

ggplot() + 
  geom_sf(data = kantone) +
  geom_sf(data = thiessenpolygone, fill = NA)


schweiz <- st_union(kantone)
thiessenpolygone <- st_cast(thiessenpolygone)

thiessenpolygone_clip <- st_intersection(thiessenpolygone,schweiz)

ggplot() + 
  geom_sf(data = kantone) +
  geom_sf(data = thiessenpolygone_clip, fill = NA)



thiessenpolygone_clip <- st_as_sf(thiessenpolygone_clip)
thiessenpolygone_clip <- st_join(thiessenpolygone_clip,luftqualitaet)

ggplot() + 
  geom_sf(data = kantone) +
  geom_sf(data = thiessenpolygone_clip, aes(fill = value)) +
  scale_fill_viridis_c() +
  theme_void()
