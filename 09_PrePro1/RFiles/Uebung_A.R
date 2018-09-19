

library(tidyverse)

# Im Unterschied zu `install.packages()` werden bei `library()` keine Anführungs- 
# und Schlusszeichen gesetzt.


library(lubridate)


# Im Unterschied zu install.packages("tidyverse") wird bei library(tidyverse) 
# das package lubridate nicht berücksichtigt

# Lösung Aufgabe 1

df <- data.frame(
  Tierart = c("Fuchs","Bär","Hase","Elch"),
  Anzahl = c(2,5,1,3),
  Gewicht = c(4.4, 40.3,1.1,120),
  Geschlecht = c("m","f","m","m"),
  Beschreibung = c("Rötlich","Braun, gross", "klein, mit langen Ohren","Lange Beine, Schaufelgeweih")
  )

# Lösung Aufgabe 2

str(df)

# Anzahl wurde als `double` interpretiert, ist aber eigentlich ein `integer`. 
# Beschreibung wurde als `factor` interpretiert, ist aber eigentlich `character`


typeof(df$Anzahl)

df$Anzahl <- as.integer(df$Anzahl)
df$Beschreibung <- as.character((df$Beschreibung))


# Lösung Aufgabe 3 (Variante 1)

df$Gewichtsklasse[df$Gewicht > 100] <- "schwer"
df$Gewichtsklasse[df$Gewicht <= 100 & df$Gewicht > 5] <- "mittel"
df$Gewichtsklasse[df$Gewicht <= 5] <- "leicht"


# Lösung Aufgabe 3 (Variante 2, wenn der Code auf einer Zeile daherkommen muss)

df$Gewichtsklasse <- ifelse(df$Gewicht > 100, "schwer",
       ifelse(df$Gewicht > 5, "mittel",
              "leicht"))

# Lösung Aufgabe 4

wetter <- readr::read_table("09_PrePro1/data/order_52252_data.txt")

# Lösung Aufgabe 5
# Die Spalte 'time' wurde als 'integer' interpretiert. Dabei handelt es
# sich offensichtlich um Zeitangaben.
# Lösung Aufgabe 6


wetter$datetime <- as.POSIXct(as.character(wetter$time), format = "%Y%m%d%H",tz = "UTC")
# Um Verwirrung zu vermeiden, lösche ich die Originalspalte 'time'  nachdem ich 
# sichergestellt habe, dass meine Operation korrekt durchgeführt wurde

wetter$time <- NULL 

# Lösung Aufgabe 7 (Variante 1: mit lubridate)

wetter$wochentag <- wday(wetter$datetime,label = T)
wetter$kw <- week(wetter$datetime)


# Lösung Aufgabe 7 (Variante 2: mit strftime())

wochentag <- strftime(wetter$datetime,format = "%a")
kalenderwoche <- strftime(wetter$datetime,format = "%U")

## str(wochentag)         # von strftime()
## str(wetter$wochentag)  # von lubridate::wday()
## 
## str(kalenderwoche)     # von strftime()
## str(wetter$kw)         # von lubridate::week()
## 
## 
## # strftime` retourniert immer `character`. Lubridate retourniert diverse Datenformate.
## 

# Lösung Aufgabe 8 (Variante 1)

wetter$temp_kat[wetter$tre200h0>0] <- "warm"
wetter$temp_kat[wetter$tre200h0<=0] <- "kalt"
# Lösung Aufgabe 8 (Variante 2, wenn der Code auf einer Zeile daherkommen muss)

wetter$temp_kat <- ifelse(wetter$tre200h0>0,"warm","kalt")
## NA
