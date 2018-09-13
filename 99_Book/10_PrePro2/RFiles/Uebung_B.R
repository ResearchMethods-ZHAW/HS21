library(tidyverse)
library(lubridate)
library(stringr)
# Lösung Aufgabe 1

sensor1 <- read_delim("10_PrePro2/data/sensor1.csv",";")
sensor2 <- read_delim("10_PrePro2/data/sensor2.csv",";")
sensor3 <- read_delim("10_PrePro2/data/sensor3.csv",";")


# Lösung Aufgabe 2 (Var 1: Spalten [Variabeln] zusammen 'kleben')
sensor_all <- sensor1 %>%
  rename(sensor1 = Temp) %>%              # Spalte "Temp" in "sensor1" umbenennen
  full_join(sensor2,by = "Datetime") %>%    
  rename(sensor2 = Temp) %>%
  full_join(sensor3, by = "Datetime") %>%
  rename(sensor3 = Temp) %>%
  mutate(Datetime = as.POSIXct(Datetime,format = "%d%m%Y_%H%M"))

# Lösung Aufgabe 2 (Var 2: Zeilen [Beobachtungen] zusammen 'kleben)

sensor1$sensor <- "sensor1"
sensor2$sensor <- "sensor2"
sensor3$sensor <- "sensor3"

sensor_all <- rbind(sensor1,sensor2,sensor3)

sensor_all <- sensor_all %>%
  mutate(
    Datetime = as.POSIXct(Datetime,format = "%d%m%Y_%H%M")
  ) %>%
  spread(sensor, Temp)


# Lösung Aufgabe 3

sensor_fail <- read_delim("10_PrePro2/data/sensor_fail.csv", delim = ";")


# Lösungsweg 1
sensor_fail$Datetime <- as.POSIXct(sensor_fail$Datetime,format = "%d%m%Y_%H%M")

sensor_fail$`Hum_%`[sensor_fail$SensorStatus == 0] <- NA
sensor_fail$Temp[sensor_fail$SensorStatus == 0] <- NA

# Lösungsweg 2

sensor_fail <- read_delim("10_PrePro2/data/sensor_fail.csv", delim = ";")


sensor_fail_corr <- sensor_fail %>%
  mutate(
    Datetime = as.POSIXct(Datetime,format = "%d%m%Y_%H%M")
  ) %>%
  rename(Humidity = `Hum_%`) %>%         # Weil R "%" in Headers nicht mag
  gather(key,val, c(Temp, Humidity)) %>%
  mutate(
    val = ifelse(SensorStatus == 0,NA,val)
  ) %>%
  spread(key,val)
  

# Lösung Aufgabe 4

# Mittelwerte der unkorrigierten Sensordaten (`NA` als `0`)
mean(sensor_fail$Temp)
mean(sensor_fail$`Hum_%`)

# Mittelwerte der korrigierten Sensordaten (`NA` als `NA`). Hier müssen wir die Option 
# `na.rm = T` (Remove NA = T) wählen, denn `mean()` (und ähnliche Funktionen) retourieren 
# immer `NA`, sobald ein **einzelner** Wert in der Reihe `NA`ist.
mean(sensor_fail_corr$Temp, na.rm = T)
mean(sensor_fail_corr$Humidity, na.rm = T)

## df$Groesse[df$Einwohner > 300000] <- "gross"
## df$Groesse[df$Einwohner <= 300000 & df$Einwohner > 150000] <- "mittel"
## df$Groesse[df$Einwohner <= 150000] <- "klein"
## 
