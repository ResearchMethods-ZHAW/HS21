
library(dplyr)
library(readr)
library(lubridate)
library(stringr)

#' ## Aufgabe 1
# Lösung Aufgabe 1

sensor1 <- read_delim("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/prepro/sensor1.csv",";")
sensor2 <- read_delim("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/prepro/sensor2.csv",";")
sensor3 <- read_delim("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/prepro/sensor3.csv",";")


#' ## Aufgabe 2

# Lösung Aufgabe 2

sensor1_2 <- full_join(sensor1, sensor2, "Datetime")

sensor_all <- full_join(sensor1_2, sensor3, by = "Datetime")

names(sensor_all) <- c("Datetime","sensor1","sensor2","sensor3")


#' ## Aufgabe 3
sensor_fail <- read_delim("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/prepro/sensor_fail.csv", delim = ";")



# Lösung Aufgabe 3

sensor_fail$Temp[sensor_fail$SensorStatus == 0] <- NA

#' ## Aufgabe 4

# Lösung Aufgabe 4

# Mittelwerte der korrigierten Sensordaten: mit na.rm = TRUE werden NA-Werte aus der Berechnung entfernt. 
# Ansonsten würden sie als 0 in die Berechnung einfliessen und diese verfälschen.
mean(sensor_fail$Temp, na.rm = TRUE)


