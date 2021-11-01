library(dplyr)
library(tidyr)
library(ggplot2)

#' ## Aufgabe 1: Parallel coordinate plots
mtcars2 <- mtcars %>%
  tibble::rownames_to_column("car") %>%
  pivot_longer(-car)

mtcars2 <- mtcars2 %>%
  group_by(name) %>%
  mutate(value_scaled = scales::rescale(value))




mtcars2 <- mtcars2 %>%
  group_by(car) %>%
  mutate(gear = value[name == "gear"])

ggplot(mtcars2, aes(name, value_scaled, group = car, color = factor(gear))) +
  geom_point() +
  geom_line() +
  theme_minimal() +
  theme(legend.position = "none", axis.title.y = element_blank())
  

#' ## Aufgabe 2: Polar Plot mit Biber Daten
beaver1_new <- beaver1 %>%
  mutate(beaver = "nr1")

beaver2_new <- beaver2 %>%
  mutate(beaver = "nr2")

beaver_new <- rbind(beaver1_new,beaver2_new)


beaver_new <- beaver_new %>%
  mutate(
    hour_dec = (time/100)%/%1,         # Ganze Stunden (mittels ganzzaliger Division)
    min_dec = (time/100)%%1/0.6,       # Dezimalminuten (15 min wird zu 0.25, via Modulo)
    hour_min_dec = hour_dec+min_dec    # Dezimal-Zeitangabe (03:30 wird zu 3.5)
    ) 



# Lösung Aufgabe 2

beaver_new %>%
  ggplot(aes(hour_min_dec, temp, color = beaver)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0,23,2)) +
  coord_polar() +
  theme_minimal() +
  theme(axis.title =  element_blank())


#' ## Aufgabe 3: Raster Visualisierung mit Flugpassagieren
AirPassengers

class(AirPassengers)

AirPassengers2 <- tapply(AirPassengers, list(year = floor(time(AirPassengers)), month = month.abb[cycle(AirPassengers)]), c)



AirPassengers3 <- AirPassengers2 %>%
  as.data.frame() %>%
  tibble::rownames_to_column("year") %>%
  pivot_longer(-year, names_to = "month", values_to = "n") %>%
  mutate(
    # ich nutze einen billigen Trick um ausgeschriebene Monate in Nummern umzuwandeln
    month = factor(month, levels = month.abb,ordered = T),
    month_numb = as.integer(month),
    year = as.integer(year)
  )






#' ## Musterlösung

