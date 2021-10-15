## ----message=F--------------------------------------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(stringr)


## ----loesung-1--------------------------------------------------------------------------------------------

wetter <- read_csv("weather.csv",
                  col_types = list(
                    col_factor(levels = NULL),    
                    col_datetime(format = "%Y%m%d%H"),
                    col_double()
                    )
                  )


## ---------------------------------------------------------------------------------------------------------
# Lösung Aufgabe 2

wetter <- wetter %>%
  filter(!is.na(stn)) %>%
  filter(!is.na(tre200h0))



## ---------------------------------------------------------------------------------------------------------

# Lösung Aufgabe 3

wetter_legende <- read_delim("metadata.csv",
                             delim = ";", 
                             locale = locale(encoding = "UTF-8"))



## ---------------------------------------------------------------------------------------------------------

# Lösung Aufgabe 4

# 1. Schritt
koordinaten <- str_split_fixed(wetter_legende$Koordinaten, "/", 2)
# 2. Schritt
colnames(koordinaten) <- c("x","y")
# 3. Schritt
wetter_legende <- cbind(wetter_legende,koordinaten)


## ---- message=F-------------------------------------------------------------------------------------------

# Lösung Aufgabe 5

wetter_legende <- wetter_legende[,c("stn", "Name", "x","y","Meereshoehe")]


## ---------------------------------------------------------------------------------------------------------

# Lösung Aufgabe 7

wetter <- left_join(wetter,wetter_legende,by = "stn")

# Jointyp: Left-Join auf 'wetter', da uns nur die Stationen im Datensatz 'wetter' interessieren.
# Attribut: "stn"


## ----warning=F--------------------------------------------------------------------------------------------

# Lösung Aufgabe 8
unique(wetter$stn)



## ---------------------------------------------------------------------------------------------------------
# Lösung Aufgabe 9

wetter_sry <- wetter %>%
  group_by(stn,Meereshoehe) %>%
  summarise(temp_mean = mean(tre200h0))

# Achtung: wenn mehrere Argumente in group_by() definiert werden führt das 
# üblicherweise zu Untergruppen. In unserem Fall hat jede Station nur EINE 
# Meereshöhe, deshalb wird die Zahl der Gruppen nicht erhöht.


## ---------------------------------------------------------------------------------------------------------
ggplot(wetter_sry, aes(temp_mean,Meereshoehe)) +
  geom_point()

