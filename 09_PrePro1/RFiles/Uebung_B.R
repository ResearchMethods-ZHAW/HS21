library(tidyverse)
load("09_PrePro1/data/wetter.rda")

# Lösung Aufgabe 1

wetter_fil <- dplyr::filter(wetter, stn == "ABO")
plot(wetter_fil$datetime,wetter_fil$tre200h0, type = "l")


p <- ggplot(wetter_fil, aes(datetime,tre200h0)) +
  geom_line()

p
# Lösung Aufgabe 2
p <- p +
  labs(x = "Datum", y = "Temperatur", title = "Stündlich gemittelte Temperaturwerte")

p
# Lösung Aufgabe 3

limits <- as.POSIXct(c("2002-01-01 00:00:00","2002-02-01 00:00:00"),tz = "UTC")

p +
  lims(x = limits)
## NA
