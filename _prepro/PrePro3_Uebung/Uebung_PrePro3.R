#' ## Aufgabe 1

library(readr)

sensors_combined <- read_csv("sensors_combined.csv")

sensors_combined$Datetime <- as.POSIXct(sensors_combined$Datetime, format = "%d%m%Y_%H%M")

#' ## Aufgabe 2
library(tidyr)


# Variante 1 (Spalten abwählen)
sensors_long <- pivot_longer(sensors_combined, -Datetime) 

# Variante 2 (Spalten anwählen)
sensors_long <- pivot_longer(sensors_combined, c(sensor1:sensor3))


#' ## Aufgabe 3
library(dplyr)

sensors_long %>%
  group_by(name) %>%
  summarise(temp_mean = mean(value, na.rm = TRUE))

#' ## Aufgabe 4
library(lubridate)

sensors_long %>%
  mutate(month = month(Datetime)) %>%
  group_by(month, name) %>%
  summarise(temp_mean = mean(value, na.rm = TRUE))

#' ## Aufgabe 5

weather <- read_csv("weather.csv", col_types = cols(col_factor(), col_datetime("%Y%m%d%H"), col_double()))

#' ## Aufgabe 6

weather_summary <- weather %>%
  mutate(week = isoweek(time)) %>%
  group_by(week) %>%
  summarise(
    temp_mean = mean(tre200h0, na.rm = TRUE)
  )


plot(weather_summary$week, weather_summary$temp_mean, type = "l")

#' ## Aufgabe 7
weather_summary2 <- weather %>%
  mutate(
    week = week(time),
    year = year(time)
    ) %>%
  group_by(year, week) %>%
  summarise(
    temp_mean = mean(tre200h0, na.rm = TRUE)
  )

plot(weather_summary2$week, weather_summary2$temp_mean, type = "l")

#' ## Aufgabe 8
weather_summary2 <- weather_summary2 %>%
  pivot_wider(names_from = year, values_from = temp_mean,names_prefix = "year")

plot(weather_summary2$week, weather_summary2$year2000, type = "l",col = "blue")
lines(weather_summary2$week, weather_summary2$year2001, type = "l",col = "red")


#' ## Musterlösung

