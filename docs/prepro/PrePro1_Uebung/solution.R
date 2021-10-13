
#' ## Arbeiten mit RStudio "Project"
#' ## Arbeiten mit Libraries / Packages
library(readr)
library(lubridate)

# Im Unterschied zu install.packages() werden bei library()
# keine Anführungs- und Schlusszeichen gesetzt.

#' ## Aufgabe 1

# Musterlösung

df <- data.frame(
  Tierart = c("Fuchs","Bär","Hase","Elch"),
  Anzahl = c(2,5,1,3),
  Gewicht = c(4.4, 40.3,1.1,120),
  Geschlecht = c("m","f","m","m"),
  Beschreibung = c("Rötlich","Braun, gross", "klein, mit langen Ohren","Lange Beine, Schaufelgeweih")
  )



#' ## Aufgabe 2
# Musterlösung

str(df)
typeof(df$Anzahl)
# Anzahl wurde als `double` interpretiert, ist aber eigentlich ein `integer`. 

df$Anzahl <- as.integer(df$Anzahl)

#' ## Aufgabe 3
# Musterlösung

df$Gewichtsklasse[df$Gewicht > 100] <- "schwer"
df$Gewichtsklasse[df$Gewicht <= 100 & df$Gewicht > 5] <- "mittel"
df$Gewichtsklasse[df$Gewicht <= 5] <- "leicht"

#' ## Aufgabe 4
# Musterlösung

wetter <- readr::read_csv("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/prepro/weather.csv")


#' ## Aufgabe 5
# Musterlösung
# Die Spalte 'time' wurde als 'integer' interpretiert. Dabei handelt es
# sich offensichtlich um Zeitangaben.

#' ## Aufgabe 6
wetter$time <- as.POSIXct(as.character(wetter$time), format = "%Y%m%d%H",tz = "UTC")


#' ## Aufgabe 7
# Musterlösung

wetter$wochentag <- wday(wetter$time,label = T)
wetter$kw <- week(wetter$time)


#' ## Aufgabe 8
# Musterlösung

wetter$temp_kat[wetter$tre200h0>0] <- "warm"
wetter$temp_kat[wetter$tre200h0<=0] <- "kalt"



