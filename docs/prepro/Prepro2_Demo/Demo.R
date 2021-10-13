
#' ## Piping 
diary <- c(
  "The temperature is 310° Kelvin",
  "The temperature is 322° Kelvin",
  "The temperature is 410° Kelvin"
)

diary

subtrahieren <- function(minuend, subtrahend){
  minuend - subtrahend
}

# 1. Nimm diary
# 2. Extrahiere auf jeder Zeile die Werte 20 bis 22
# 3. Konvertiere "character" zu "numeric"
# 4. Subtrahiere 273.15
# 5. Berechne den Mittlwert

output <- mean(subtrahieren(as.numeric(substr(diary, 20, 22)),273.15))
#                                             \_1_/
#                                      \________2__________/
#                           \___________________3___________/
#              \________________________________4__________________/
#         \_____________________________________5____________________/

temp <- substr(diary, 20, 22)       # 1, 2
temp <- as.numeric(temp)            # 3
temp <- subtrahieren(temp, 273.15)  # 4
output <- mean(temp)                # 5

library(magrittr)

diary %>%                            # 1
  substr(20, 22) %>%                 # 2
  as.numeric() %>%                   # 3 
  subtrahieren(273.15) %>%           # 4
  mean()                             # 5

diary |>                             # 1
  substr(20, 22) |>                  # 2
  as.numeric() |>                    # 3 
  subtrahieren(273.15) |>            # 4
  mean()                             # 5

#' ## Joins
studierende <- data.frame(
  Matrikel_Nr = c(100002, 100003, 200003),
  Studi = c("Patrick", "Manuela", "Pascal"),
  PLZ = c(8006, 8820, 8006)
)

studierende

ortschaften <- data.frame(
  PLZ = c(8001, 8006, 8810, 8820),
  Ortsname = c("Zürich", "Zürich", "Horgen", "Wädenswil")
)

ortschaften

library(dplyr)

inner_join(studierende, ortschaften, by = "PLZ")

left_join(studierende, ortschaften, by = "PLZ")

right_join(studierende, ortschaften, by = "PLZ")

full_join(studierende, ortschaften, by = "PLZ")

