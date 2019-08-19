library(tidyverse)
# Im Unterschied zu `install.packages()` werden bei `library()` keine Anführungs- 
# und Schlusszeichen gesetzt.


library(lubridate)
# Im Unterschied zu install.packages("tidyverse") wird bei library(tidyverse) 
# das package lubridate nicht berücksichtigt


# Lösung Aufgabe 1

df <- data_frame(
  Tierart = c("Fuchs","Bär","Hase","Elch"),
  Anzahl = c(2,5,1,3),
  Gewicht = c(4.4, 40.3,1.1,120),
  Geschlecht = c("m","f","m","m"),
  Beschreibung = c("Rötlich","Braun, gross", "klein, mit langen Ohren","Lange Beine, Schaufelgeweih")
  )




# Lösung Aufgabe 2

str(df)

# Anzahl wurde als `double` interpretiert, ist aber eigentlich ein `integer`. 
# Mit data.frame() wurde Beschreibung wurde als `factor` interpretiert, ist 
# aber eigentlich `character`



typeof(df$Anzahl)

df$Anzahl <- as.integer(df$Anzahl)
df$Beschreibung <- as.character(df$Beschreibung)



# Lösung Aufgabe 3

df$Gewichtsklasse[df$Gewicht > 100] <- "schwer"
df$Gewichtsklasse[df$Gewicht <= 100 & df$Gewicht > 5] <- "mittel"
df$Gewichtsklasse[df$Gewicht <= 5] <- "leicht"




# Lösung Aufgabe 4

wetter <- readr::read_table("09_PrePro1/data/order_52252_data.txt")



# Lösung Aufgabe 5
# Die Spalte 'time' wurde als 'integer' interpretiert. Dabei handelt es
# sich offensichtlich um Zeitangaben.

# Lösung Aufgabe 6

# mit readr
parse_datetime(as.character(wetter$time[1:10]), format = "%Y%m%d%H")


# mit as.POSIXct()
wetter$time <- as.POSIXct(as.character(wetter$time), format = "%Y%m%d%H",tz = "UTC")





# Lösung Aufgabe 7

wetter$wochentag <- wday(wetter$time,label = T)
wetter$kw <- week(wetter$time)





# Lösung Aufgabe 8

wetter$temp_kat[wetter$tre200h0>0] <- "warm"
wetter$temp_kat[wetter$tre200h0<=0] <- "kalt"
