library(tidyverse)
library(lubridate)
library(stringr)
# Lösung Aufgabe 1

load("09_PrePro1/data/wetter.rda")

# Lösung Aufgabe 2

wetter <- wetter %>%
  filter(!is.na(stn)) %>%
  filter(!is.na(tre200h0))


# Lösung Aufgabe 3

wetter_spread <- spread(wetter, stn,tre200h0)



# Lösung Aufgabe 4

wetter_legende <- read_delim("09_PrePro1/data/order_52252_legend.csv",delim = ";", locale = locale(encoding = "UTF-8"))


# Lösung Aufgabe 5

koordinaten <- str_split_fixed(wetter_legende$Koordinaten, "/", 2)

colnames(koordinaten) <- c("x","y")

wetter_legende <- cbind(wetter_legende,koordinaten)

# Lösung Aufgabe 6

wetter_legende <- dplyr::select(wetter_legende, stn, Name, x,y,Meereshoehe)

# Lösung Aufgabe 7

wetter <- left_join(wetter,wetter_legende,by = "stn")

# Jointyp: Left-Join auf 'wetter', da uns nur die Stationen im Datensatz 'wetter' interessieren.
# Attribut: "stn"

# Lösung Aufgabe 8

wetter_sry <- wetter %>%
  group_by(stn) %>%
  summarise(temp_mean = mean(tre200h0))
# Lösung Aufgabe 9

wetter_sry <- wetter %>%
  group_by(stn,Meereshoehe) %>%
  summarise(temp_mean = mean(tre200h0))

# Achtung: wenn mehrere Argumente in group_by() definiert werden führt das 
# üblicherweise zu Untergruppen. In unserem Fall hat jede Station nur EINE 
# Meereshöhe, deshalb wird die Zahl der Gruppen nicht erhöht.

ggplot(wetter_sry, aes(temp_mean,Meereshoehe)) +
  geom_point()
## df$Groesse[df$Einwohner > 300000] <- "gross"
## df$Groesse[df$Einwohner <= 300000 & df$Einwohner > 150000] <- "mittel"
## df$Groesse[df$Einwohner <= 150000] <- "klein"
## 
