library(tidyverse)
library(lubridate)



wetter <- read_table("order_52252_data.txt",
                  col_types = list(
                    col_factor(levels = NULL),    
                    col_datetime(format = "%Y%m%d%H"),
                    col_double()
                    )
                  )



wetter_fil <- wetter %>%
  mutate(
    year = year(time),
    month = month(time)
    ) %>%
  filter(year == 2000 & month == 1)

plot(wetter_fil$time, wetter_fil$tre200h0)

# Datensatz: "wetter_fil" | Beeinflussende Variabeln: "time" und "tre200h0"
ggplot(data = wetter_fil, mapping = aes(time,tre200h0))             

ggplot(data = wetter_fil, mapping = aes(time,tre200h0)) +
  # Layer: "geom_point" entspricht Punkten in einem Scatterplot 
  geom_point()                                    


ggplot(wetter_fil, aes(time,tre200h0)) +
  geom_point()


ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_point()

ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_point() +
  geom_line()


ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_line() +
  labs(x = "Woche",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "Januar 2000")

ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_line() +
  labs(x = "Woche",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "Januar 2000") +    
  scale_y_continuous(limits = c(-30,30))    # y-Achsenabschnitt bestimmen


ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_line() +
  labs(x = "Woche",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "Januar 2000") +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "1 week", 
                   date_minor_breaks = "1 day", 
                   date_labels = "KW%W")


ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_line() +
  labs(x = "Woche",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "Januar 2000") +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "1 week", 
                   date_minor_breaks = "1 day", 
                   date_labels = "KW%W") +
  theme_classic()

theme_set(theme_classic())

ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_line() +
  labs(x = "Woche",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "Januar 2000") +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "2 weeks", 
                   date_minor_breaks = "1 day", 
                   date_labels = "KW%W") +
  facet_wrap(~stn)


ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_line() +
  labs(x = "Woche",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "Januar 2000") +  
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "1 week", date_minor_breaks = "1 day", date_labels = "KW%W") +
  facet_wrap(~stn,ncol = 3) +
  theme(legend.position="none")

p <- ggplot(wetter_fil, aes(time,tre200h0, colour = stn)) +
  geom_line() +
  labs(x = "Woche",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "Januar 2000") +
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "1 week", date_minor_breaks = "1 day", date_labels = "KW%W") +
  facet_wrap(~stn,ncol = 3)
  # ich habe an dieser Stelle theme(legend.position="none") entfernt




ggsave(filename = "plot.png",plot = p)

p +
  theme(legend.position="none")


p <- p +
  theme(legend.position="none")

p <- p +
  geom_smooth(colour = "black")

p
```{.r .distill-force-highlighting-css}
```
