library(tidyverse)
library(sf)

bezirke <- read_sf("21_RaumAn1/data/bezirke.gpkg")

wasser <- read_sf("21_RaumAn1/data/wasserverfuegbarkeit_boden.gpkg")

wasser <- wasser %>%
  st_set_crs(4326) %>%
  st_transform(2056)

bezirke <- st_set_crs(bezirke, 2056)





wasser_bezirke <- aggregate(wasser,bezirke, mean)

 ggplot(wasser_bezirke) +
  geom_sf(aes(fill = wasserverfuegbarkeit), colour = "white",lwd = 0.2) +
  scale_fill_viridis_c() +
  labs(title = "Mittlere Wasserverfügbarkeit",subtitle = "nach Bezirk",fill = "") +
  theme_void() +
  theme(legend.position = "bottom",legend.direction = "horizontal")

n <- nrow(wasser_bezirke)
n

# Die Werte aller Bezirke:
y <- wasser_bezirke$wasserverfuegbarkeit

# Der Durchschnittswert aller Bezirke
ybar <- mean(y, na.rm = TRUE)

# von jedem Wert den Durchschnittswert abziehen:
dy <- y - ybar

dy_2 <- dy^2

dy_sum <- sum(dy_2, na.rm = TRUE)

vr <- n/dy_sum

w <- st_touches(wasser_bezirke, sparse = FALSE)

w[1:6, 1:6]

# nur die ersten 6 Geometrien auswählen
wasser_select <- wasser_bezirke %>%
  rowid_to_column() %>% # erstellt eine Spalte rowid mit der Position
  head(6)

# alle anderen Bezirke auf die BoundingBox clippen 
# (um als Hintergrundkarte zu dienen)
wasser_selectst_bg <- wasser_select %>%
  st_bbox() %>%
  st_as_sfc() %>%
  st_intersection(wasser_bezirke)

ggplot() + 
  geom_sf(data = wasser_selectst_bg) +
  geom_sf(data = wasser_select, aes(fill = factor(rowid))) + 
  geom_sf_text(data = wasser_select, aes(label = rowid)) + 
  labs(title = "Welche Bezirke berühren Bezirk Nr. 1?") +
  theme_void() + 
  theme(legend.position = "none")

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

benachbart <- my_connections(wasser_bezirke,w)

ggplot(wasser_bezirke) + 
  geom_sf() + 
  geom_sf(data = benachbart) +
  theme_void() +
  labs(title = "Benachbarte Bezirke sind mit einer Linie verbunden")


pm <- tcrossprod(dy)
pm[1:6,1:6]


pmw <- pm * w
w[1:6,1:6]
pmw[1:6,1:6]

spmw <- sum(pmw, na.rm = TRUE)
spmw

smw <- sum(w, na.rm = TRUE)

sw  <- spmw / smw

MI <- vr * sw
MI

kantone <- read_sf("21_RaumAn1/data/kantone.gpkg")

kantone <- st_set_crs(kantone, 2056)

wasser_kantone <- aggregate(wasser,kantone, mean)

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

MI_kantone <-  morans_i(wasser_kantone,"wasserverfuegbarkeit")


 ggplot(wasser_kantone) +
  geom_sf(aes(fill = wasserverfuegbarkeit), colour = "white",lwd = 0.2) +
  scale_fill_viridis_c() +
  labs(title = "Mittlere Wasserverfügbarkeit nach Kantone",subtitle = paste("Morans I:",formatC(MI_kantone,digits = 2,flag = "+")),fill = "") +
  theme_void() +
  theme(legend.position = "bottom",legend.direction = "horizontal") 
