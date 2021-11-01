

library(dplyr)
library(ggplot2)
library(readr)

kanton <- read_csv("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/infovis/tagi_data_kantone.csv") 

#' ## Aufgabe 1

# Lösung zu Aufgabe 1

plot1 <- ggplot(kanton, aes(auslanderanteil, ja_anteil)) +
  geom_point() +
  coord_fixed(1) +
  scale_y_continuous(breaks = c(0,0.1,0.3,0.5,0.7),limits =  c(0,0.7)) +
  scale_x_continuous(breaks = c(0,0.1,0.3,0.5,0.7),limits =  c(0,0.7)) +
  labs(y = "Anteil Ja-Stimmen", x = "Ausländeranteil")

plot1

#' ## Aufgabe 2
# Lösung zu Aufgabe 2

plot1 +
  geom_smooth()

#' ## Aufgabe 3
# Lösung zu Aufgabe 3

gemeinde <- read_csv("https://github.com/ResearchMethods-ZHAW/datasets/raw/main/infovis/tagi_data_gemeinden.csv")

plot2 <- ggplot(gemeinde, aes(anteil_ausl, anteil_ja)) +
  geom_point() +
  labs(x = "Ausländeranteil",y = "Anteil Ja-Stimmen") +
  coord_fixed(1) +
  lims(x = c(0,1), y = c(0,1))

plot2

#' ## Aufgabe 4
# Lösung zu Aufgabe 4

plot2 +
  geom_smooth()

#' ## Aufgabe 5

# Lösung zu Aufgabe 5

plot3 <- plot2 +
  facet_wrap(~kanton)
plot3

#' ## Aufgabe 6

# Lösung zu Aufgabe 6

plot3 +
  geom_smooth()

#' ## Aufgabe 7

# Lösung zu Aufgabe 7

plot4 <- plot2 +
  facet_wrap(~quantile)
plot4

#' ## Aufgabe 8

# Lösung zu Aufgabe 8

plot4 +
  geom_smooth()

#' ## Aufgabe 9 (Optional, fortgeschritten)

# Lösung zu Aufgabe 9

korr_tab <- gemeinde %>%
  group_by(kanton) %>%
  summarise(
    Korr.Koeffizient = cor.test(anteil_ja,anteil_ausl,method = "pearson")$estimate,
    Signifikanz_val = cor.test(anteil_ja,anteil_ausl,method = "pearson")$p.value,
    Signifikanz = ifelse(Signifikanz_val < 0.001,"***",ifelse(Signifikanz_val<0.01,"**",ifelse(Signifikanz_val<0.05,"*","-")))
  ) %>%
  select(-Signifikanz_val)



#' ## Musterlösung

