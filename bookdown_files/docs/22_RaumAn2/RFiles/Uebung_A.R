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

## -- Aufgabe 1: G-Function-- ##

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
