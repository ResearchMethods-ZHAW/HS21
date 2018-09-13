
library(tidyverse)
library(ggplot2)
library(stringr)

## # Es kann sein, dass man die Codierung des Files spezifizieren muss. Mit `readr::read_delim()`
## # läuft dies mit der Option locale = locale(encoding = "UTF-8") wobei anstelle von UTF-8 die
## # entsprechende Codierung angegeben wird.
## # Tipp: Excel speichert CSV oft in ANSI, welches für den Import in R nicht sonderlich geeignet
## # ist. Falls Probleme auftreten muss das File mittels einer geeigneter Software (Widows: "Editor"
## # oder "Notepad++", Mac: "TextEdit")  und mit einer neuen Codierung (z.B. `UTF-8`) abgespeichert
## # werden.
kanton <- read_delim("11_InfoVis1/data/initiative_masseneinwanderung_kanton.csv",",",locale = locale(encoding = "UTF-8"))

# Lösung zu Aufgabe 1

# da die Spalten in Kovic's Daten Umlaute und Sonderzeichen enthalten, müssen diese in R mit Graviszeichen 
# angesprochen werden. Dieses Zeichen wirder Schweizer Tastatur [1]  mit 
# Shitft + Gravis (Links von der Backspace taste) + Leerschlag erstellt
# [1] https://de.wikipedia.org/wiki/Tastaturbelegung#Schweiz


# Alternativ können die Spalten im Originalfile oder mit dplyr::rename() umbenannt werden


plot1 <- ggplot(kanton, aes(`Ausländeranteil`, `Ja-Anteil`)) +
  geom_point() +
  coord_fixed(1) +
  scale_y_continuous(breaks = c(0,0.1,0.3,0.5,0.7),limits =  c(0,0.7)) +
  scale_x_continuous(breaks = c(0,0.1,0.3,0.5,0.7),limits =  c(0,0.7)) +
  labs(y = "Anteil Ja-Stimmen")

plot1
# Lösung zu Aufgabe 2

plot1 +
  geom_smooth()
gemeinde <- read_delim("11_InfoVis1/data/initiative_masseneinwanderung_gemeinde.csv",",",locale = locale(encoding = "UTF-8"))
# Lösung zu Aufgabe 3

plot2 <- ggplot(gemeinde, aes(`Anteil Ausl`, `Anteil Ja`)) +
  geom_point() +
  labs(x = "Ausländeranteil",y = "Anteil Ja-Stimmen") +
  coord_fixed(1) +
  lims(x = c(0,1), y = c(0,1))

plot2
# Lösung zu Aufgabe 4

plot2 +
  geom_smooth()

# Lösung zu Aufgabe 5

plot3 <- plot2 +
  facet_wrap(~Kanton)
plot3

# Lösung zu Aufgabe 6

plot3 +
  geom_smooth()

# Lösung zu Aufgabe 7

plot4 <- plot2 +
  facet_wrap(~Quantile)
plot4

# Lösung zu Aufgabe 8

plot4 +
  geom_smooth()

# Lösung zu Aufgabe 9

korr_tab <- gemeinde %>%
  group_by(Kanton) %>%
  summarise(
    Korr.Koeffizient = cor.test(`Anteil Ja`,`Anteil Ausl`,method = "pearson")$estimate,
    Signifikanz_val = cor.test(`Anteil Ja`,`Anteil Ausl`,method = "pearson")$p.value,
    Signifikanz = ifelse(Signifikanz_val < 0.001,"***",ifelse(Signifikanz_val<0.01,"**",ifelse(Signifikanz_val<0.05,"*","-")))
  ) %>%
  select(-Signifikanz_val)

## 
## 
## library(tidyverse)
## 
## # Im Unterschied zu `install.packages()` werden bei `library()` keine Anführungs-
## # und Schlusszeichen gesetzt.
## 
## 
## library(lubridate)
## 
## 
## # Im Unterschied zu install.packages("tidyverse") wird bei library(tidyverse)
## # das package lubridate nicht berücksichtigt
