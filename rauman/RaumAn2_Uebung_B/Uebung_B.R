knitr::opts_chunk$set(echo = FALSE)

library(sf)
library(dplyr)
library(ggplot2)

library(gstat) # <- ggf. installieren!

check_download <- function(files, folder, source = "", url = "https://github.com/ResearchMethods-ZHAW/datasets/raw/main/"){
  full_url <- paste0(url,folder,"/",files)
  exists_bool <- !file.exists(files)
  if(sum(exists_bool)>0){
    download.file(full_url[exists_bool],files[exists_bool])
    }
  cat(paste0("- [",files,"](",full_url,") ",source),sep = "\n")
}

check_download(c("schweiz.gpkg", "luftqualitaet.gpkg"),"rauman")


luftqualitaet <- read_sf("luftqualitaet.gpkg")

schweiz <- read_sf("schweiz.gpkg") 



my_idw <- function(groundtruth,column,cellsize, nmax = Inf, maxdist = Inf, idp = 2, extent = NULL){
  library(gstat)
  library(sf)
  
  if(is.null(extent)){
    extent <- groundtruth
  }
  
  samples <- st_make_grid(extent,cellsize,what = "centers")
  my_formula <- formula(paste(column,"~1"))
  idw_sf <- gstat::idw(formula = my_formula,groundtruth, newdata = samples, nmin = 1, nmax = nmax, maxdist = maxdist, idp = idp)
  
  idw_matrix <- cbind(as.data.frame(st_coordinates(idw_sf)),pred = st_drop_geometry(idw_sf)[,1])
  idw_matrix
}

my_idw(groundtruth = luftqualitaet,column = "value",cellsize = 10000, extent = schweiz)

#' ### Aufgabe 1: Raeumliche Interpolation mit IDW
library(purrr)
library(tidyr)



p <- lapply(1:4, function(idp){
  idw <- my_idw(groundtruth = luftqualitaet,column = "value",cellsize = 1000, nmax = Inf,maxdist = Inf,idp = idp,extent = schweiz)
  ggplot() +
    geom_raster(data = idw, aes(X,Y, fill = pred)) +
    geom_sf(data = schweiz, fill = NA) +
    geom_sf(data = luftqualitaet, size = 1, shape = 3, alpha = 0.3) +
    scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(11,"RdYlBu")),limits = c(0, 60), na.value = NA) +
    labs(fill = "μg/m3",
         title = paste("Inverse Distance Power (IDP):",idp)) +
    theme_void() +
    theme(legend.position = "bottom", legend.title = element_blank(),
      legend.key.width = unit(0.10, 'npc'),
      legend.key.height = unit(0.02, 'npc'))
}) %>%
  cowplot::plot_grid(plotlist = .)

ggsave("idw.png", p, height = 18, width = 20, units = "cm")

knitr::include_graphics("idw.png")


#' ### Aufgabe 2: Interpolation mit Nearest Neighbour
luftqualitaet_union <- st_union(luftqualitaet)

thiessenpolygone <- st_voronoi(luftqualitaet_union)

ggplot() + 
  geom_sf(data = schweiz) +
  geom_sf(data = thiessenpolygone, fill = NA)


thiessenpolygone <- st_cast(thiessenpolygone)

thiessenpolygone_clip <- st_intersection(thiessenpolygone,schweiz)

ggplot() + 
  geom_sf(data = schweiz) +
  geom_sf(data = thiessenpolygone_clip, fill = NA)


thiessenpolygone_clip <- st_as_sf(thiessenpolygone_clip)
thiessenpolygone_clip <- st_join(thiessenpolygone_clip,luftqualitaet)

ggplot() + 
  geom_sf(data = schweiz) +
  geom_sf(data = thiessenpolygone_clip, aes(fill = value)) +
  geom_sf(data = luftqualitaet) +
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(11,"RdYlBu"))) +
  theme_void() +
  theme(legend.position = "bottom", legend.title = element_blank(),
      legend.key.width = unit(0.10, 'npc'),
      legend.key.height = unit(0.02, 'npc'))

#' ## Musterlösung

