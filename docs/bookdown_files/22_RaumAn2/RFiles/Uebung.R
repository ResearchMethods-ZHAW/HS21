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

###################################################
## -- Übung A - Analyse von Punktverteilungen -- ##
###################################################

rotmilan_sample <- sample_n(rotmilan,1000)

rotmilan_distanzmatrix <- st_distance(rotmilan_sample)

# zeige die ersten 6 Zeilen und Spalten der Matrix
# jeder Distanz wurde 2x Gemessen (vergleiche Wert [2,1] mit [1,2])
# die Diagonale ist die Distanz zu sich selber (gleich 0)
rotmilan_distanzmatrix[1:6,1:6] 

diag(rotmilan_distanzmatrix) <- NA # entfernt alle diagonalen Werte

rotmilan_mindist <- apply(rotmilan_distanzmatrix,1,min, na.rm = TRUE)

rotmilan_mindist_df <- data.frame(distanzen = rotmilan_mindist)

ggplot() + geom_step(data = rotmilan_mindist_df, aes(distanzen),stat = "ecdf")

luftqualitaet_distanzmatrix <- st_distance(luftqualitaet)

diag(luftqualitaet_distanzmatrix) <- NA

luftqualitaet_mindist <- apply(luftqualitaet_distanzmatrix,1,min,na.rm = TRUE)

luftqualitaet_mindist_df <- data.frame(distanzen = luftqualitaet_mindist, data = "Luftqualität")

rotmilan_mindist_df$data <- "Rotmilan"

mindist_df <- rbind(luftqualitaet_mindist_df,rotmilan_mindist_df)

ggplot() + 
  geom_step(data = mindist_df, aes(distanzen, colour = data),stat = "ecdf") +
  labs(colour = "Datensatz")

#############################################
## -- Übung B - Räumliche Interpolation -- ##
#############################################

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
    ras <- mask(ras,st_as_sf(st_zm(extent)))
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

########################################
## -- Übung C - Dichteverteilungen -- ##
########################################

ggplot(kantone) + 
  geom_sf() + 
  geom_sf(data = rotmilan) +
  theme_void()

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
