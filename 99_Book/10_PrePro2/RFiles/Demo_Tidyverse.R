## install.packages("tidyverse")
library(tidyverse)
library(lubridate) 
load("09_PrePro1/data/wetter.rda")

mean(wetter$tre200h0, na.rm = T) 
wetter$year <- year(wetter$datetime)
wetter <- mutate(wetter,year = year(datetime))
mean(wetter$tre200h0[wetter$year == 2000], na.rm = T)
summarise(group_by(wetter,year),temp_mittel = mean(tre200h0, na.rm = T))

summarise(group_by(wetter,year),temp_mittel = mean(tre200h0))

# wird zu:

wetter %>%                                #1) nimm den Datensatz "wetter"
  group_by(year) %>%                      #2) Bilde Gruppen pro Jahr
  summarise(temp_mittel = mean(tre200h0)) #3) berechne das Temperaturmittel 

# Maximal und minimal Temperatur pro Kalenderwoche
wetter %>%                              #1) nimm den Datensatz "wetter"
  filter(stn == "ABO") %>%              #2) filter auf Station namnes "ABO"
  mutate(kw = week(datetime)) %>%       #3) erstelle eine neue Spalte "kw"
  group_by(kw) %>%                      #4) Nutze die neue Spalte um Guppen zu bilden
  summarise(
    temp_max = max(tre200h0, na.rm = T),#5) Berechne das Maximum 
    temp_min = min(tre200h0, na.rm = T) #6) Berechne das Minimum
    )   

wetter_sry <- wetter %>%                              
  mutate(
    kw = week(datetime)
    ) %>%
  filter(stn == "ABO") %>%
  group_by(kw) %>%                      
  summarise(
    temp_max = max(tre200h0),               
    temp_min = min(tre200h0),
    temp_mean = mean(tre200h0)
    )  

ggplot() +
  geom_line(data = wetter_sry, aes(kw,temp_max), colour = "yellow") +
  geom_line(data = wetter_sry, aes(kw,temp_mean), colour = "pink") +
  geom_line(data = wetter_sry, aes(kw,temp_min), colour = "black") +
  labs(y = "temp")

wetter_sry_long <- wetter_sry %>%
  gather(Key, Value, c(temp_max,temp_min,temp_mean))

nrow(wetter_sry)
nrow(wetter_sry_long)
wetter_sry_long <- wetter_sry %>%
  gather(Key, Value, -kw)
ggplot(wetter_sry_long, aes(kw,Value, colour = Key)) +
  geom_line()
wetter_sry_long %>%
  spread(Key,Value)
