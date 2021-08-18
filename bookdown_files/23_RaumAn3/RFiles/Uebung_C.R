library(sf)
library(tidyverse)

gemeinden_zweitwohnung <- read_sf("23_RaumAn3/data_raw/zweitwohnung_gemeinden.gpkg")

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

MI_zweitw_gemeinde <- morans_i(gemeinden_zweitwohnung,"ja_in_percent")

ggplot() + 
  geom_sf(data = gemeinden_zweitwohnung, aes(fill = ja_in_percent), colour = "grey",lwd = 0.1) + 
  labs(fill = "Ja Anteil (%)", title = "Zweitwohnungsinitiative, Gemeindeebene", subtitle = paste("Morans I",formatC(MI_zweitw_gemeinde,2,flag = "+"))) +
  scale_fill_gradient2(low = "#2c7bb6",mid = "#ffffbf",high = "#d7191c",midpoint = 50,breaks = c(0,25,50,75,100),limits = c(0,100)) +
  theme_void()

kantone_zweitwohnung <- gemeinden_zweitwohnung %>%
  group_by(kanton) %>%
  summarise(
    ja_in_percent = weighted.mean(ja_in_percent,gultige_stimmzettel,na.rm = TRUE)
    )

MI_zweitw_kanton <- morans_i(kantone_zweitwohnung,"ja_in_percent")

ggplot() + 
  geom_sf(data = kantone_zweitwohnung, aes(fill = ja_in_percent), colour = "grey",lwd = 0.2) + 
  labs(fill = "Ja Anteil (%)", title = "Zweitwohnungsinitiative, Kantonsebene", subtitle = paste("Morans I",formatC(MI_zweitw_kanton,2,flag = "+"))) +
  scale_fill_gradient2(low = "#2c7bb6",mid = "#ffffbf",high = "#d7191c",midpoint = 50,breaks = c(0,25,50,75,100),limits = c(0,100)) +
  theme_void()

library(biscale)
library(cowplot)

data <- gemeinden_zweitwohnung %>%
  filter(!is.na(ja_in_percent), !is.na(beteiligung_in_percent)) %>%
  bi_class(x = ja_in_percent, y = beteiligung_in_percent, style = "equal", dim = 3)

map <- ggplot() +
  geom_sf(data = data, mapping = aes(fill = bi_class), color = "white", size = 0.1, show.legend = FALSE) +
  bi_scale_fill(pal = "DkBlue", dim = 3) +
  labs(
    title = "",
    caption = "Ja Anteil und Stimmbeteiligung (jeweils in %) auf der Gemeindeebene"
  ) +
  bi_theme()

legend <- bi_legend(pal = "DkBlue",
                    dim = 3,
                    xlab = "%-Ja Anteil ",
                    ylab = "%-Beteiligung ",
                    size = 8)
finalPlot <- ggdraw() +
  draw_plot(map, 0, 0, 1, 1) +
  draw_plot(legend, 0.1, .65, 0.2, 0.2)

finalPlot
