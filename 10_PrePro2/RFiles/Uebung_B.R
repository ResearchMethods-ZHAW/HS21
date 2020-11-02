library(tidyverse)
library(lubridate)
library(stringr)

# Lösung Aufgabe 1

sensor1 <- read_delim("10_PrePro2/data/sensor1.csv",";")
sensor2 <- read_delim("10_PrePro2/data/sensor2.csv",";")
sensor3 <- read_delim("10_PrePro2/data/sensor3.csv",";")



# Lösung Aufgabe 2

sensor1$sensor <- "sensor1"
sensor2$sensor <- "sensor2"
sensor3$sensor <- "sensor3"

sensor_all <- rbind(sensor1,sensor2,sensor3)

sensor_all <- sensor_all %>%
  mutate(
    Datetime = as.POSIXct(Datetime,format = "%d%m%Y_%H%M")
  ) %>%
  pivot_wider(names_from = sensor, values_from = Temp)





# Lösung Aufgabe 3

sensor_fail <- read_delim("10_PrePro2/data/sensor_fail.csv", delim = ";")





# Lösungsweg 1
sensor_fail$Datetime <- as.POSIXct(sensor_fail$Datetime,format = "%d%m%Y_%H%M")

sensor_fail$`Hum_%`[sensor_fail$SensorStatus == 0] <- NA
sensor_fail$Temp[sensor_fail$SensorStatus == 0] <- NA


# Lösung Aufgabe 4

# Mittelwerte der korrigierten Sensordaten: mit na.rm = TRUE werden NA-Werte aus der Berechnung entfernt. 
# Ansonsten würden sie als 0 in die Berechnung einfliessen und diese verfälschen.
mean(sensor_fail$Temp, na.rm = TRUE)
mean(sensor_fail$`Hum_%`, na.rm = TRUE)

