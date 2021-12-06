#' ### Aufgabe 1
knitr::opts_chunk$set(echo = FALSE)

check_download <- function(files, folder, source = "", url = "https://github.com/ResearchMethods-ZHAW/datasets/raw/main/"){
  full_url <- paste0(url,folder,"/",files)
  exists_bool <- !file.exists(files)
  if(sum(exists_bool)>0){
    download.file(full_url[exists_bool],files[exists_bool])
    }
  cat(paste0("- [",files,"](",full_url,") ",source),sep = "\n")
}

check_download(c("rotmilan.gpkg","schweiz.gpkg", "luftqualitaet.gpkg"),"rauman")


library(sf)
library(dplyr)
library(ggplot2)

rotmilan <- read_sf("rotmilan.gpkg")

schweiz <- read_sf("schweiz.gpkg")

luftqualitaet <- read_sf("luftqualitaet.gpkg")

ggplot(rotmilan) +
  geom_sf(data = schweiz) +
  geom_sf(aes(colour = timestamp), alpha = 0.2) +
  scale_color_datetime(low = "blue", high = "red")

#' ### Aufgabe 2
#' #### Schritt 1:
rotmilan_distanzmatrix <- st_distance(rotmilan)

nrow(rotmilan_distanzmatrix)
ncol(rotmilan_distanzmatrix)
# zeige die ersten 6 Zeilen und Spalten der Matrix
# jeder Wert ist 2x vorhanden (vergleiche Wert [2,1] mit [1,2])
# die Diagonale ist die Distanz zu sich selber (gleich 0)
rotmilan_distanzmatrix[1:6,1:6] 

#' #### Schritt 2
diag(rotmilan_distanzmatrix) <- NA # entfernt alle diagonalen Werte

rotmilan_distanzmatrix[1:6,1:6] 

rotmilan_mindist <- apply(rotmilan_distanzmatrix,1,min, na.rm = TRUE)


#' #### Schritt 3
rotmilan_mindist <- sort(rotmilan_mindist) 

#' #### Schritt 4
kumm_haeufgikeit <- seq_along(rotmilan_mindist) / length(rotmilan_mindist)

#' #### Schritt 5

rotmilan_mindist_df <- data.frame(distanzen = rotmilan_mindist,
                                  kumm_haeufgikeit = kumm_haeufgikeit)



p <- ggplot() + 
  geom_line(data = rotmilan_mindist_df, aes(distanzen, kumm_haeufgikeit)) +
  labs(x = "Distanz (Meter)", y = "Häufigkeit (kummuliert)")

p

prob <- 0.95
res <- quantile(ecdf(rotmilan_mindist_df$distanzen), prob)
res2 <- quantile(ecdf(rotmilan_mindist_df$distanzen), 0.99)
xlim <- c(5000, NA)
ylim <- c(.5, .75)
p + 
  geom_segment(aes(x = res, xend = res, y = -Inf, yend = prob), colour = "lightblue") +
  geom_segment(aes(x = -Inf, xend = res, y = prob, yend = prob), colour = "lightblue") +
  geom_point(aes(x = res, y = prob), size =3, colour = "lightblue") +
  ggrepel::geom_label_repel(aes(x = 0, y = prob, label = paste0(prob*100,"% der Werte...")),
                            xlim = xlim, ylim = ylim,  hjust = 0, min.segment.length = 0,fill = "lightblue") +
  ggrepel::geom_label_repel(aes(x = res, y = 0, label = paste0("... sind kleiner als ",round(res,0),"m")),
                            xlim = xlim, ylim = ylim, hjust = 0,vjust = 1, fill = "lightblue",min.segment.length = 0,inherit.aes = FALSE) +
  scale_y_continuous(breaks = c(0, .25,.5,.75,prob,1))


#' ## Aufgabe 3
luftqualitaet_distanzmatrix <- st_distance(luftqualitaet)

diag(luftqualitaet_distanzmatrix) <- NA

luftqualitaet_mindist <- apply(luftqualitaet_distanzmatrix,1,min,na.rm = TRUE)

luftqualitaet_mindist <- sort(luftqualitaet_mindist)

kumm_haeufgikeit_luftquali <- seq_along(luftqualitaet_mindist) / length(luftqualitaet_mindist)


luftqualitaet_mindist_df <- data.frame(distanzen = luftqualitaet_mindist,
                                  kumm_haeufgikeit = kumm_haeufgikeit_luftquali)

luftqualitaet_mindist_df$data <- "Luftqualitaet"
rotmilan_mindist_df$data <- "Rotmilan"


mindist_df <- rbind(luftqualitaet_mindist_df,rotmilan_mindist_df)


ggplot(mindist_df,) + 
  geom_line(aes(distanzen, kumm_haeufgikeit, colour = data)) +
  labs(x = "Distanz (Meter)", y = "Häufigkeit (kummuliert)", colour = "Datensatz")


#' ## Musterlösung

