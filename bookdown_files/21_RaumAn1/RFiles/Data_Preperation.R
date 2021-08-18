knitr::opts_chunk$set(echo = TRUE)

library(raster)
library(tidyverse)
library(sf)
library(lubridate)
library(stars)
library(scales)
library(viridis)

point_offset <- function(point,offset, method = "uniform"){
  coords <- st_coordinates(point)
  if(method == "uniform"){offsets <- runif(2,-offset,offset)}
  if(method == "normal"){offsets <- rnorm(2,0,offset/2)}
  coords_new <- map2_dbl(coords,offsets,~.x+.y)
  st_point(coords_new)
}

wasser <- read_stars("21_RaumAn1/data_raw/wasserverfuegbarkeit_boden/swb_mon_2018.tif")
kantone <- read_sf("21_RaumAn1/data_raw/boundries/swissTLMRegio_KANTONSGEBIET_LV95.shp") %>%
  filter(ICC == "CH")

schweiz <- st_union(kantone)


ggplot() + 
  geom_stars(data = wasser) +
  scale_fill_gradient(high = "blue",low = "red", na.value=NA, limits = c(-250,-50),oob = squish) +
  geom_sf(data = kantone, fill = NA,na.rm = TRUE, inherit.aes = FALSE)


samples_regular <- st_sample(schweiz,size = 1000,type = "regular") %>%
  st_set_crs(2056)

grid <- samples_regular %>%
  st_coordinates() %>%
  apply(.,2,unique) %>%
  map(function(x){
    x <- sort(x)
    (x+lead(x))/2
  })


grid$X-lead(grid$X)
grid$Y-lead(grid$Y)


samples_offset <- map(samples_regular,~point_offset(.x,2000,"normal")) %>%
  do.call(sf:::st_sfc,.) %>%
  st_as_sf() %>%
  st_set_crs(2056)


set.seed(10)

ggplot() + 
  geom_sf(data  = kantone) +
  geom_sf(data = samples_regular,colour = "grey",alpha = 0.5) + 
  geom_sf(data = samples_offset) #+geom_vline(xintercept = grid$X) + geom_hline(yintercept = grid$Y)





samples_offset$wasserverfuegbarkeit <- raster::extract(as(wasser,"Raster"), st_coordinates(samples_offset))


samples_offset <- samples_offset %>%
  filter(!is.na(wasserverfuegbarkeit))

ggplot() + 
  geom_sf(data = kantone, fill = NA,na.rm = TRUE, inherit.aes = FALSE) +
  geom_sf(data = samples_offset, aes(colour = wasserverfuegbarkeit), fill = NA,na.rm = TRUE, inherit.aes = FALSE) +
  scale_colour_gradient(high = "blue",low = "red", na.value=NA, limits = c(-250,-50),oob = squish)


samples_offset <- st_transform(samples_offset,4326)

samples_offset <- st_set_crs(samples_offset,NA_crs_)

## st_write(samples_offset,"21_RaumAn1/data/wasserverfuegbarkeit_boden.gpkg",delete_dsn = TRUE)

kantone <- read_sf("21_RaumAn1/data_raw/boundries/swissTLMRegio_KANTONSGEBIET_LV95.shp") %>%
  filter(ICC == "CH")


bezirke <- read_sf("21_RaumAn1/data_raw/boundries/swissTLMRegio_BEZIRKSGEBIET_LV95.shp")%>%
  filter(ICC == "CH")

gemeinden <- read_sf("21_RaumAn1/data_raw/boundries/swissTLMRegio_HOHEITSGEBIET_LV95.shp")%>%
  filter(ICC == "CH",OBJEKTART == "Gemeindegebiet")



no_bezirk <- st_difference(kantone,st_union(bezirke))

ggplot() + 
  geom_sf(data = no_bezirk, aes(fill = "Kantone ohne Bezirke"), alpha = 0.4) +
  geom_sf(data = bezirke, aes(fill = "Alle Bezirke"), alpha = 0.4) + 
  labs(fill = "")


bezirke_noholes <- rbind(dplyr::select(bezirke,NAME,OBJEKTART),dplyr::select(no_bezirk, NAME,OBJEKTART)) %>%
  mutate(OBJECTID = sample(1:nrow(.),nrow(.)))

ggplot(bezirke_noholes) + geom_sf(aes(fill = OBJEKTART)) 

ggplot(bezirke_noholes) + geom_sf(aes(fill = OBJEKTART)) + facet_wrap(~OBJEKTART)


bezirke_noholes <- bezirke_noholes %>%
  mutate(area_km2 = as.numeric(st_area(.)/1000^2))


bezirke_noholes <- st_set_crs(bezirke_noholes,NA_crs_)


st_write(bezirke_noholes,"21_RaumAn1/data/bezirke.gpkg",delete_dsn = TRUE)



ggplot(gemeinden) + geom_sf()


gemeinden <- st_set_crs(gemeinden,NA_crs_)



st_write(gemeinden,"21_RaumAn1/data/gemeinden.gpkg",delete_dsn = TRUE)

kantone_abk <- read_delim("21_RaumAn1/data_raw/kantone.csv",";",col_names = c("Abk","Name","Nummer"), locale = locale(encoding = "Windows-1252")) %>%
  dplyr::select(-Name)

kantone <- kantone %>%
  mutate(Nummer = as.integer(str_sub(KANTONSNUM,3,4))) %>% 
  left_join(kantone_abk,by = "Nummer")


ggplot(kantone) + geom_sf()


kantone <- st_set_crs(kantone,NA_crs_)

st_write(kantone,"21_RaumAn1/data/kantone.gpkg",delete_dsn = TRUE)



bodeneignung <- st_read("21_RaumAn1/data_raw/bodeneignungskarte_polygon/Bodeneignungskarte_Bodeneignungskarte_polygon.shp")

bodeneignung %>%
  group_by(SKELETT) %>%
  summarise() %>%
  st_cast("POLYGON") %>%
  ungroup() %>%
  st_set_crs(NA_crs_) %>%
  mutate(SKELETT = na_if(SKELETT, -9999)) %>%
  st_write("21_RaumAn1/data/bodeneignung_skelett.gpkg",delete_dsn = TRUE)
