library(sf)
library(dplyr)
library(ggplot2)


library(MASS) # <- ggf. installieren!


knitr::opts_chunk$set(echo = FALSE)

check_download <- function(files, folder, source = "", url = "https://github.com/ResearchMethods-ZHAW/datasets/raw/main/"){
  full_url <- paste0(url,folder,"/",files)
  exists_bool <- !file.exists(files)
  if(sum(exists_bool)>0){
    download.file(full_url[exists_bool],files[exists_bool])
    }
  cat(paste0("- [",files,"](",full_url,") ",source),sep = "\n")
}

check_download(c("schweiz.gpkg", "luftqualitaet.gpkg", "rotmilan.gpkg"),"rauman")


luftqualitaet <- read_sf("luftqualitaet.gpkg") 
rotmilan <- read_sf("rotmilan.gpkg")
schweiz <- read_sf("schweiz.gpkg") 



#' ## Aufgabe 1: Rotmilan Bewegungsdaten visualisieren
ggplot(schweiz) + 
  geom_sf() + 
  geom_sf(data = rotmilan) +
  theme_void()

#' ## Aufgabe 2: Kernel Density Estimation berechnen
my_kde <- function(points,cellsize, bandwith, extent = NULL){
  library(MASS)
  library(sf)
  library(tidyr)
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
  mat <- kde2d(coords[,1],coords[,2],h = bandwith,n = c(n_x,n_y),lims = extent_vec)

  mydf <- as.data.frame(mat[[3]])
  
  colnames(mydf) <- mat[[2]]
  mydf$X <- mat[[1]]
  
  pivot_longer(mydf, -X,names_to = "Y",names_transform = list(Y = as.numeric))

}

rotmilan_kde <- my_kde(points = rotmilan,cellsize = 1000, bandwith = 10000, extent = schweiz)

rotmilan_kde


ggplot() + 
  geom_raster(data = rotmilan_kde, aes(X, Y, fill = value)) +
  geom_sf(data = schweiz, fill = NA) +
  scale_fill_viridis_c() +
  theme_void()

q95 <- quantile(rotmilan_kde$value,probs = 0.95)

rotmilan_kde <- rotmilan_kde %>%
  mutate(
    value_new = ifelse(value>q95,value,NA),
    value_new = log10(value_new)
  )

ggplot() + 
  geom_raster(data = rotmilan_kde, aes(X, Y, fill = value_new)) +
  geom_sf(data = schweiz, inherit.aes = FALSE, fill = NA) +
  scale_fill_viridis_c(na.value = NA) +
  theme_void()


#' ## Aufgabe 3: Dichteverteilung mit Thiessen Polygonen
thiessenpolygone <- rotmilan %>%
  st_union() %>%
  st_voronoi()
schweiz <- st_union(schweiz)


thiessenpolygone <- st_cast(thiessenpolygone)

thiessenpolygone_clip <- st_intersection(thiessenpolygone,schweiz)



ggplot() + 
  geom_sf(data = schweiz) + 
  geom_sf(data = thiessenpolygone_clip) + 
  theme_void()

#' ## Musterlösung

