
knitr::opts_chunk$set(echo = FALSE)

check_download <- function(files, folder, source = "", url = "https://github.com/ResearchMethods-ZHAW/datasets/raw/main/"){
  full_url <- paste0(url,folder,"/",files)
  exists_bool <- !file.exists(files)
  if(sum(exists_bool)>0){
    download.file(full_url[exists_bool],files[exists_bool])
    }
  cat(paste0("- [",files,"](",full_url,") ",source),sep = "\n")
}

check_download(c("zweitwohnungsinitiative.gpkg"),"rauman")


library(dplyr)
library(ggplot2)
library(sf)

# Das Geopackage beinhaltet 3 Layers (siehe st_layers("zweitwohnungsinitiative.gpkg"))
# In jedem Layer sind die Abstimmungsresultate auf eine andere politische Ebene
# aggregiert. Wir started mit der Aggregationsstufe "kanton"
zweitwohnung_kanton<- read_sf("zweitwohnungsinitiative.gpkg", "kanton")


 ggplot(zweitwohnung_kanton) +
  geom_sf(aes(fill = ja_in_percent), colour = "white",lwd = 0.2) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(11, "RdYlGn"), limits = c(0,1))  +
  theme(legend.position = "bottom")

#' ## Aufgabe 1: Herleitung der Formel
#' ### Bruch 1
#' #### Zähler (von Bruch 1)
n <- nrow(zweitwohnung_kanton)
n

#' #### Nenner (von Bruch 1)
# Die Werte aller Kantone:
y <- zweitwohnung_kanton$ja_in_percent

# Der Durchschnittswert aller Kantone
ybar <- mean(y, na.rm = TRUE)

# von jedem Wert den Durchschnittswert abziehen:
dy <- y - ybar

dy_2 <- dy^2

dy_sum <- sum(dy_2, na.rm = TRUE)

#' #### Auflösung (Bruch 1)
vr <- n/dy_sum

#' ### Bruch 2
#' #### Zähler (Bruch 2)
w <- st_touches(zweitwohnung_kanton, sparse = FALSE)

w[1:6, 1:6]


sel <- zweitwohnung_kanton$KANTONSNAME[1]

beruehrt_1 <- w[1, ]

ggplot(zweitwohnung_kanton[beruehrt_1, ]) +
  geom_sf(aes(fill = KANTONSNAME)) +
  labs(title = "Welche Kanton berühren den Kanton Zürich (st_touches)")

# Optional: Um alle Kantone zu visualisieren, welche sich berühren, könnt ihr folgende Funktion anwenden:

my_connections <- function(sf_object,relationship_matrix){
  require(sf)
  require(purrr)
  centeroids <- sf::st_centroid(st_geometry(sf_object))
  
  mycrs <- st_crs(sf_object)

  relationship_transpose <- which(relationship_matrix,arr.ind = TRUE)
  
  from <- centeroids[relationship_transpose[,1]]
  to <- centeroids[relationship_transpose[,2]]
  
  connection <- purrr::map2(from,to, ~sf::st_linestring(c(.x,.y))) %>%
    st_sfc() %>%
    st_set_crs(mycrs)
}

benachbart <- my_connections(zweitwohnung_kanton,w)

ggplot(zweitwohnung_kanton) + 
  geom_sf() + 
  geom_sf(data = benachbart) +
  theme_void() +
  labs(title = "Benachbarte Kantone sind mit einer Linie verbunden")

pm <- tcrossprod(dy)
pm[1:6,1:6]


pmw <- pm * w
w[1:6,1:6]
pmw[1:6,1:6]

spmw <- sum(pmw, na.rm = TRUE)
spmw

#' #### Nenner (Bruch 2)
smw <- sum(w, na.rm = TRUE)

#' #### Auflösung (Bruch 2)
sw  <- spmw / smw

#' ### Auflösung der Formel
MI <- vr * sw
MI

#' ## Aufgabe 2: Morans I für Gemeinde oder Bezirke berechnen
zweitwohnung_gemeinde <- read_sf("zweitwohnungsinitiative.gpkg", "gemeinde")

ggplot(zweitwohnung_gemeinde) +
  geom_sf(aes(fill = ja_in_percent), colour = "white",lwd = 0.2) +
  scale_fill_gradientn("Ja Anteil",colours = RColorBrewer::brewer.pal(11, "RdYlGn"), limits = c(0,1)) +
  theme(legend.position = "bottom")

morans_i <- function(sf_object,col) {
  require(sf)
  n <- nrow(sf_object)
  y <- unlist(st_set_geometry(sf_object,NULL)[,col],use.names = FALSE)
  ybar <- mean(y, na.rm = TRUE)
  dy <- y - ybar
  dy_sum <- sum(dy^2, na.rm = TRUE)
  vr <- n/dy_sum
  w <- st_touches(sf_object,sparse = FALSE)
  pm <- tcrossprod(dy)
  pmw <- pm * w
  spmw <- sum(pmw, na.rm = TRUE)
  smw <- sum(w, na.rm = TRUE)
  sw  <- spmw / smw
  MI <- vr * sw
  MI
}

MI_gemeinde <-  morans_i(zweitwohnung_gemeinde,"ja_in_percent")

#' ## Musterlösung

