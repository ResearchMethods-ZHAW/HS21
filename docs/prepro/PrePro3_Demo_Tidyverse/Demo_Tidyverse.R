library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(ggplot2)


wetter <- read_csv("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/prepro/weather.csv",
                  col_types = list(
                    col_factor(levels = NULL),    
                    col_datetime(format = "%Y%m%d%H"),
                    col_double()
                    )
                  )



mean(wetter$tre200h0, na.rm = TRUE) 

wetter$month <- month(wetter$time)

wetter <- mutate(wetter,month = month(time))

mean(wetter$tre200h0[wetter$month == 1], na.rm = TRUE)

summarise(group_by(wetter,month),temp_mittel = mean(tre200h0, na.rm = TRUE))


summarise(group_by(wetter,month),temp_mittel = mean(tre200h0))

# wird zu:

wetter %>%                                 #1) nimm den Datensatz "wetter"
  group_by(month) %>%                      #2) Bilde Gruppen pro Jahr
  summarise(temp_mittel = mean(tre200h0))  #3) berechne das Temperaturmittel 


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

weather_summary_long %>%
  pivot_wider(names_from = Messtyp, values_from = Messwert)
```{.r .distill-force-highlighting-css}
```
