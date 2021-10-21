
library(readr)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)

# Wir können den Datensatz direkt über den URL einladen oder aber ihr nutzt den 
# URL um den Datensatz lokal bei euch abzuspeichern und wie gewohnt einzulesen
temperature <- read_csv("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/infovis/temperature_SHA_ZER.csv")


plot(temperature$time, temperature$SHA, type = "l", col = "red")
lines(temperature$time, temperature$ZER, col = "blue")


# Datensatz: "temperature" | Beeinflussende Variabeln: "time" und "temp"
ggplot(data = temperature, mapping = aes(time,SHA))             

ggplot(data = temperature, mapping = aes(time,SHA)) +         
  # Layer: "geom_point" entspricht Punkten in einem Scatterplot 
  geom_point()                                    

ggplot(temperature, aes(time,SHA)) +
  geom_point()


temperature_long <- pivot_longer(temperature, -time, names_to = "station", values_to = "temp")


ggplot(temperature_long, aes(time,temp, colour = station)) +
  geom_point()

ggplot(temperature_long, aes(time,temp, colour = station)) +
  geom_point()+
  geom_line()


ggplot(temperature_long, aes(time,temp, colour = station)) +
  geom_line() +
  labs(
    x = "Zeit",
    y = "Temperatur in Grad C°", 
    title = "Temperaturdaten Schweiz",
    subtitle = "2001 bis 2002",
    color = "Station"
    )

temperature_day <- temperature_long %>%
  mutate(time = as.Date(time)) 

temperature_day

temperature_day <- temperature_day %>%
  group_by(station, time) %>%
  summarise(temp = mean(temp))
  


ggplot(temperature_day, aes(time,temp, colour = station)) +
  geom_line() +
  labs(
    x = "Zeit",
    y = "Temperatur in Grad C°", 
    title = "Temperaturdaten Schweiz",
    subtitle = "2001 bis 2002",
    color = "Station"
    ) +    
  scale_y_continuous(limits = c(-30,30))    # y-Achsenabschnitt bestimmen


ggplot(temperature_day, aes(time,temp, colour = station)) +
  geom_line() +
  labs(
    x = "Zeit",
    y = "Temperatur in Grad C°", 
    title = "Temperaturdaten Schweiz",
    subtitle = "2001 bis 2002",
    color = "Station"
    ) +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_date(date_breaks = "3 months", 
                   date_labels = "%b")


ggplot(temperature_day, aes(time,temp, colour = station)) +
  geom_line() +
  labs(
    x = "Zeit",
    y = "Temperatur in Grad C°", 
    title = "Temperaturdaten Schweiz",
    subtitle = "2001 bis 2002",
    color = "Station"
    ) +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_date(date_breaks = "3 months", 
                   date_labels = "%b") +
  theme_classic()

theme_set(theme_classic())

ggplot(temperature_day, aes(time,temp, colour = station)) +
  geom_line() +
  labs(
    x = "Zeit",
    y = "Temperatur in Grad C°", 
    title = "Temperaturdaten Schweiz",
    subtitle = "2001 bis 2002",
    color = "Station"
    ) +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_date(date_breaks = "3 months", 
                   date_labels = "%b") +
  facet_wrap(station~.)


ggplot(temperature_day, aes(time,temp, colour = station)) +
  geom_line() +
  labs(
    x = "Zeit",
    y = "Temperatur in Grad C°", 
    title = "Temperaturdaten Schweiz",
    subtitle = "2001 bis 2002"
    ) +  
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_date(date_breaks = "3 months", 
                   date_labels = "%b") +
  facet_wrap(~station,ncol = 1) +
  theme(legend.position="none")

p <- ggplot(temperature_day, aes(time,temp, colour = station)) +
  geom_line() +
  labs(
    x = "Zeit",
    y = "Temperatur in Grad C°", 
    title = "Temperaturdaten Schweiz",
    subtitle = "2001 bis 2002"
    ) +
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_date(date_breaks = "3 months", 
                   date_labels = "%b") +
  facet_wrap(~station,ncol = 1)
  # ich habe an dieser Stelle theme(legend.position="none") entfernt




ggsave(filename = "plot.png",plot = p)

p +
  theme(legend.position="none")


p <- p +
  theme(legend.position="none")

p <- p +
  geom_smooth(colour = "black")

p

