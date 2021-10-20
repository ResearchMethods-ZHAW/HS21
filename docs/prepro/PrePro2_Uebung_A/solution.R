
library(dplyr)
library(readr)
library(lubridate)
library(stringr)

# Alternativ kannst du alle tidyverse packages mit library(tidyverse) laden

#' ## Aufgabe 1

# Variante 1
wetter <- read_csv("weather.csv")
wetter$stn <- as.factor(wetter$stn)
wetter$time <- as.POSIXct(as.character(wetter$time), format = "%Y%m%d%H", tz = "UTC")

# Variate 2 (für Profis)
wetter <- read_csv("weather.csv",
                  col_types = list(
                    col_factor(levels = NULL),    
                    col_datetime(format = "%Y%m%d%H"),
                    col_double()
                    )
                  )

#' ## Aufgabe 2
metadata <- read_delim("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/prepro/metadata.csv", delim = ";", locale = locale(encoding = "UTF-8"))


#' ## Aufgabe 3


# 1. Schritt
koordinaten <- str_split_fixed(metadata$Koordinaten, "/", 2)
# 2. Schritt
colnames(koordinaten) <- c("x","y")
# 3. Schritt
metadata <- cbind(metadata,koordinaten)

#' ## Aufgabe 4

metadata <- metadata[,c("stn", "Name", "x","y","Meereshoehe")]

#' ## Aufgabe 5
wetter <- left_join(wetter,metadata,by = "stn")

# Jointyp: Left-Join auf 'wetter', da uns nur die Stationen im Datensatz 'wetter' interessieren.
# Attribut: "stn"

#' ## Aufgabe 6
wetter$month <- month(wetter$time)

#' ## Aufgabe 7

mean(wetter$tre200h0[wetter$month == 1])
mean(wetter$tre200h0[wetter$month == 2])
mean(wetter$tre200h0[wetter$month == 3])

# usw. für alle 12 Monate

#' ## Musterlösung
