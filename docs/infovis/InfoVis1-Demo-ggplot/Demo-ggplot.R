
library(readr)
library(lubridate)
library(dplyr)
library(ggplot2)

temperature <- read_csv("/home/nils/ownCloud/Lehre/Master/ResearchMethods/2021_HS/git_repos/datasets/infovis/temperature_SHA_ZER.csv",
                   col_types = cols(
                     col_factor(levels = NULL),    
                     col_datetime(),
                     col_double()
                   )
                  )


plot(temperature$time, temperature$temp)

# Datensatz: "temperature" | Beeinflussende Variabeln: "time" und "temp"
ggplot(data = temperature, mapping = aes(time,temp))             

ggplot(data = temperature, mapping = aes(time,temp)) +         
  # Layer: "geom_point" entspricht Punkten in einem Scatterplot 
  geom_point()                                    

ggplot(temperature, aes(time,temp)) +
  geom_point()

ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_point()

ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_point()+
  geom_line()


ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_line() +
  labs(x = "Zeit",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "2001 bis 2002")

ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_line() +
  labs(x = "Zeit",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "2001 bis 2002") +    
  scale_y_continuous(limits = c(-30,30))    # y-Achsenabschnitt bestimmen


ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_line() +
  labs(x = "Zeit",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "2001 bis 2002") +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "3 months", 
                   date_labels = "%b")


ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_line() +
  labs(x = "Zeit",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "2001 bis 2002") +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "3 months", 
                   date_labels = "%b") +
  theme_classic()

theme_set(theme_classic())

ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_line() +
  labs(x = "Zeit",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "2001 bis 2002") +    
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "3 months", 
                   date_labels = "%b") +
  facet_wrap(stn~.)


ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_line() +
  labs(x = "Zeit",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "2001 bis 2002") +  
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "3 months", 
                   date_labels = "%b") +
  facet_wrap(~stn,ncol = 3) +
  theme(legend.position="none")

p <- ggplot(temperature, aes(time,temp, colour = stn)) +
  geom_line() +
  labs(x = "Zeit",
       y = "Temperatur in Grad C°", 
       title = "Temperaturdaten Schweiz",
       subtitle = "2001 bis 2002") +
  scale_y_continuous(limits = c(-30,30)) +
  scale_x_datetime(date_breaks = "3 months", 
                   date_labels = "%b") +
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

