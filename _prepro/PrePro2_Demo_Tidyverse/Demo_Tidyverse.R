library(tidyverse)

library(lubridate) 


wetter <- read_table("order_52252_data.txt",
                  col_types = list(
                    col_factor(levels = NULL),    
                    col_datetime(format = "%Y%m%d%H"),
                    col_double()
                    )
                  )


mean(wetter$tre200h0, na.rm = TRUE) 

wetter$year <- year(wetter$time)

wetter <- mutate(wetter,year = year(time))

mean(wetter$tre200h0[wetter$year == 2000], na.rm = TRUE)

summarise(group_by(wetter,year),temp_mittel = mean(tre200h0, na.rm = TRUE))


summarise(group_by(wetter,year),temp_mittel = mean(tre200h0))

# wird zu:

wetter %>%                                #1) nimm den Datensatz "wetter"
  group_by(year) %>%                      #2) Bilde Gruppen pro Jahr
  summarise(temp_mittel = mean(tre200h0)) #3) berechne das Temperaturmittel 


# Maximal und minimal Temperatur pro Kalenderwoche
wetter %>%                              #1) nimm den Datensatz "wetter"
  filter(stn == "ABO") %>%              #2) filter auf Station namnes "ABO"
  mutate(kw = week(time)) %>%       #3) erstelle eine neue Spalte "kw"
  group_by(kw) %>%                      #4) Nutze die neue Spalte um Guppen zu bilden
  summarise(
    temp_max = max(tre200h0, na.rm = TRUE),#5) Berechne das Maximum 
    temp_min = min(tre200h0, na.rm = TRUE) #6) Berechne das Minimum
    )   


wetter_sry <- wetter %>%                              
  mutate(
    kw = week(time)
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



wetter_sry %>%
  pivot_longer(c(temp_max,temp_min,temp_mean))

wetter_sry %>%
  pivot_longer(-kw)

wetter_sry_long <- wetter_sry %>%
  pivot_longer(-kw, names_to = "Messtyp", values_to = "Messwert")





nrow(wetter_sry)
nrow(wetter_sry_long)

ggplot(wetter_sry_long, aes(kw,Messwert, colour = Messtyp)) +
  geom_line()

wetter_sry_long %>%
  pivot_wider(names_from = Messtyp, values_from = Messwert)
```{.r .distill-force-highlighting-css}
```
