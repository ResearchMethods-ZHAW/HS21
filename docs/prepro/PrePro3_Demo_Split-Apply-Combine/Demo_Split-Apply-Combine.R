
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(ggplot2)

#' ## Split-Appli-Combine (Beispiel 1)
df <- data.frame(
  key = c("A","B","C","A","B","C","A","B","C"),
  data = c(0, 5, 10, 5, 10, 15, 10, 15, 20)
)


df 

sry <- df %>%
  group_by(key) %>%
  summarise(Summe = sum(data))

 
sry <- df %>%
  group_by(key) %>%
  summarise(
    Summe = sum(data),
    Minimum = min(data),
    Maximun = max(data)
    )

?mtcars

mtcars <- mtcars                          # Einlesen des Beispielsdatensatzes mtcars
by_cyl <- group_by(mtcars, cyl)           # Gruppieren nach Anzahl Zylinder (cyl)
summarise(by_cyl,mean_mpg = mean(mpg))    # Berechnen des Mittelwerts pro 
                                          # Zylinder-Gruppe, resp. Kategorie

by_cyl_2 <- group_by(mtcars,cyl,am)       # Gruppieren nach Anzahl Zylinder (cyl) 
                                          # UND Schaltung automatisch oder manuell (am)

summarise(by_cyl_2,mean_mpg = mean(mpg))

#' ## Split-Apply-Combine (Beispiel 2)
#' ### Daten Laden


wetter <- read_csv("weather.csv",
                  col_types = list(
                    col_factor(levels = NULL),    
                    col_datetime(format = "%Y%m%d%H"),
                    col_double()
                    )
                  )



#' ### Kennwerte berechnen
mean(wetter$tre200h0, na.rm = TRUE) 

#' ### Convenience Variablen
wetter$month <- month(wetter$time)

wetter <- mutate(wetter,month = month(time))

#' ### Kennwerte nach Gruppen berechnen
mean(wetter$tre200h0[wetter$month == 1], na.rm = TRUE)

summarise(group_by(wetter,month),temp_mittel = mean(tre200h0, na.rm = TRUE))

#' ### Verketten vs. verschachteln
# 1 nimm den Datensatz "wetter"
# 2 Bilde Gruppen pro Monat
# 3 berechne das Temperaturmittel 

summarise(group_by(wetter,month),temp_mittel = mean(tre200h0))
#                  \_1_/
#         \__________2_________/
#\___________________3_______________________________________/

# wird zu:

wetter %>%                                 # 1
  group_by(month) %>%                      # 2
  summarise(temp_mittel = mean(tre200h0))  # 3


# Maximal und minimal Temperatur pro Kalenderwoche
weather_summary <- wetter %>%               #1) nimm den Datensatz "wetter"
  filter(month == 1) %>%                    #2) filter auf den Monat Januar
  mutate(day = day(time)) %>%               #3) erstelle eine neue Spalte "day"
  group_by(day) %>%                         #4) Nutze die neue Spalte um Gruppen zu bilden
  summarise(
    temp_max = max(tre200h0, na.rm = TRUE), #5) Berechne das Maximum 
    temp_min = min(tre200h0, na.rm = TRUE)  #6) Berechne das Minimum
    )   

weather_summary

#' ## Reshaping data
#' ### Breit -> lang

weather_summary %>%
  pivot_longer(c(temp_max,temp_min))

weather_summary %>%
  pivot_longer(-day)

weather_summary_long <- weather_summary %>%
  pivot_longer(-day, names_to = "Messtyp", values_to = "Messwert")



nrow(weather_summary)
nrow(weather_summary_long)

ggplot(weather_summary_long, aes(day,Messwert, colour = Messtyp)) +
  geom_line()

#' ### Lang -> breit
weather_summary_long %>%
  pivot_wider(names_from = Messtyp, values_from = Messwert)

ggplot(weather_summary) +
  geom_line(aes(day, temp_max)) +
  geom_line(aes(day, temp_min))

