
library(readr)
library(dplyr)
library(lubridate)
library(tidyr)
library(ggplot2)


temperature <- read_csv("temperature_2005.csv")

#' ## Aufgabe 1
temperature_long <- pivot_longer(temperature, -time, names_to = "station", values_to = "temperature")

knitr::kable(head(temperature_long))

metadata <- read_csv("temperature_2005_metadata.csv")

temperature_long <- left_join(temperature_long, metadata, by = c(station = "stn"))

#' ## Aufgabe 2

# Musterlösung

ggplot(temperature_long, aes(time,temperature, color = Meereshoehe)) +
  geom_point(size = 0.5) +
  labs(x = "", y = "Temperatur in ° Celsius") +
  scale_x_datetime(date_breaks = "3 months", date_labels = "%b")  +
  scale_color_gradient(low = "blue", high = "red")

#' ## Aufgabe 3
temperature_long <- temperature_long %>%
  mutate(time = as.Date(time)) %>%
  group_by(time, station, Name, Meereshoehe, x, y) %>%
  summarise(temperature = mean(temperature))

#' ## Aufgabe 4
p <- ggplot(temperature_long, aes(time,temperature, color = Meereshoehe)) +
  geom_point(size = 0.5) +
  labs(x = "", y = "Temperatur in ° Celsius") +
  scale_x_date(date_breaks = "3 months", date_labels = "%b")  +
  scale_color_gradient(low = "blue", high = "red")

p


#' ## Aufgabe 5

# Musterlösung

p <- p +
  stat_smooth(colour = "black",lty = 2)

p

#' ## Aufgabe 6

# Musterlösung


p <- p + 
  theme(legend.position = "top")

p
    

#' ## Aufgabe 7 (optional, fortgeschritten)

# Musterlösung

p +
  scale_y_continuous(labels = function(x)paste0(x,"°C")) +
  labs(x = "Kalenderwoche", y = "Temperatur")



#' ## Aufgabe 8

# Musterlösung

temperature_long <- mutate(temperature_long, monat = month(time,label = T,abbr = F))


ggplot(temperature_long, aes(monat,temperature, fill = Meereshoehe)) +
  geom_boxplot() +
  labs(x = "Station", y = "Temperatur") +
  facet_wrap(~station) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#' ## Aufgabe 9

# Musterlösung

temperature_long <- temperature_long %>%
  mutate(lage = cut(Meereshoehe, c(0, 400, 600,1000),labels = c("Tieflage", "Mittellage", "Hochlage")))

ggplot(temperature_long, aes(temperature)) +
  geom_histogram() +
  facet_grid(~lage) +
  labs(x = "Lage", y = "Temperatur") +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))


#' ## Musterlösung

