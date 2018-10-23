library(tidyverse)
library(lubridate)

load("09_PrePro1/data/wetter.rda")

wetter <- wetter %>%
  filter(!is.na(stn)) %>%
  filter(!is.na(datetime))

station_meta <- read_delim("09_PrePro1/data/order_52252_legend.csv",";")

wetter <- left_join(wetter,station_meta,by = "stn")


# Lösung Aufgabe 1

wetter_fil <- wetter %>%
  mutate(
    year = year(datetime),
    month = month(datetime)
  ) %>%
  filter(year == 2000 & month < 3)

# Lösung Aufgabe 2

p <- ggplot(wetter_fil, aes(datetime,tre200h0, colour = Meereshoehe)) +
  geom_point(size = 0.5) +
  labs(x = "Kalenderwoche", y = "Temperatur in ° Celsius") +
  scale_color_continuous(low = "blue", high = "red") +
  scale_x_datetime(date_breaks = "2 week", date_labels = "KW%W") 

p 


# Lösung Aufgabe 3

p <- p +
  stat_smooth(colour = "black",lty = 2)

p

# Lösung Aufgabe 4


p <- p + 
  theme(legend.direction = "horizontal",legend.position = "top")

p
    

# Lösung Aufgabe 5

p +
  scale_y_continuous(labels = function(x)paste0(x,"°C"))

# Lösung Aufgabe 6

p <- p + 
  scale_y_continuous(labels = function(x)paste0(x,"°C"),sec.axis = sec_axis(~.*(9/5)+32,name = "Temperatur in ° Farenheit",labels = function(x)paste0(x,"° F")))


p

# Lösung Aufgabe 7

wetter_fil <- mutate(wetter_fil,monat = month(datetime,label = T,abbr = F))


ggplot(wetter_fil, aes(stn,tre200h0, fill = Meereshoehe)) +
  geom_boxplot() +
  facet_grid(monat~.) +
  labs(x = "Station", y = "Temperatur") +
  theme(legend.direction = "horizontal",legend.position = "top")


# Lösung Aufgabe 8

wetter_fil$Lage[wetter_fil$Meereshoehe < 450] <- "Tieflage" 
wetter_fil$Lage[wetter_fil$Meereshoehe >= 450 & wetter_fil$Meereshoehe <1000] <- "Mittellage" 
wetter_fil$Lage[wetter_fil$Meereshoehe >= 1000] <- "Hochlage" 


ggplot(wetter_fil, aes(Name,tre200h0)) +
  geom_boxplot() +
  facet_grid(monat~Lage, scales = "free_x") +
  labs(x = "Lage", y = "Temperatur") +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))


# Lösung Aufgabe 9


h <- ggplot(wetter_fil,aes(tre200h0, fill = Lage)) +
  geom_histogram(binwidth = 1, colour = "white") +
  labs(x = "Temperatur in °C", y = "Anzahl")

h

# Lösung Aufgabe 10


h + 
  geom_vline(xintercept = 0, lty = 2, alpha = 0.5) +
  facet_wrap(~Lage) +
  lims(x = c(-30,30)) +
  theme(legend.direction = "horizontal",legend.position = "top")

