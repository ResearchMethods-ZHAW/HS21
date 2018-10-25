knitr::opts_chunk$set(fig.width = 20, fig.height = 12, warning = F, message = F, error = F, include = T)
#knitr::opts_chunk$get("root.dir")
## Lade Datei

library(tidyverse)
nova <- read_delim("13_Statistik1/data/novanimal.csv", delim = ";")

## definiere theme für die Plots

mytheme <- theme_classic() + 
    theme(axis.line = element_line(color = "black"), axis.text = element_text(size = 25, color = "black"), axis.title = element_text(size = 25, color = "black"), axis.ticks = element_line(size = 1, color = "black"), axis.ticks.length = unit(.5, "cm"))

# Gruppiere und fasse die Variablen nach Geschlecht und Hochschulzugehörigkeit zusammen 
canteen <- group_by(nova, gender, member) %>% 
  summarise(tot = n()) %>% 
  ungroup() %>%
  mutate(canteen_member = c("Mitarbeiterinnen", "Studentinnen", "Mitarbeiter", "Studenten")) # Fasse die ersten beiden Variablen zusammen

# Definiere einen Vektor mit erwarteten Häufigkeiten, beachte dabei die Reihenfolge 

population_exp <- c(.15,.32,.16,.37) # erwartete Verteilung der Population (Achtung die Summe muss 1 ergeben)
  
# Berechne den Chi-Quadrat-Test

chi_sq <- chisq.test(canteen$tot, p = population_exp)
chi_sq

# Führe einen exakten Fisher Test durch
# erstelle dafür einen neuen Datensatz. tibble(), ist eine ähnliche Funktion wie data.frame() vom Hause tidyverse

fisher_t <- tibble(member = c("Mitarbeiterinnen", "Studentinnen", "Mitarbeiter", "Studenten"),
  population = population_exp * 2138, # absolute Zahlen der Population Mitarbeiterinnen, Studentinnen, Mitarbeiter, Studenten => Fisher exakt test kann nicht mit erwarteten Wahrscheinlichkeiten rechnen
  stichprobe = canteen$tot,
  population_pct = population_exp,
  canteen_pct = canteen$tot / sum(canteen$tot)) 

fish <- fisher.test(fisher_t[ ,2:3]) # was sind die Unterschiede zwischen den beiden Tests (Chisquare und Fisher exakt Test)? Wieso gibt es keinen OR aus?
fish
# Daten müssen zuerst nach "week" und "condition" zusammengefasst werden

df <- nova %>%
    group_by(date, condit) %>%  
    summarise(tot_sold = n()) %>% # zählt alle Beobachtungen gemäss dem group_by zusammen
    mutate(day = format(date, format = "%d.%m")) # erstelle neue Variable, damit beim Historgamm die X-Achse besser leserlich wird

# Testen der Voraussetzungen
ggplot(df, aes(x = condit, y= tot_sold)) + 
    geom_boxplot(fill = "white", color = "black") + 
    scale_y_continuous(breaks = seq(0,60,10), limits = c(0,60)) +
    labs(x="\nBedingungen", y="Anzahl verkaufte Gerichte pro Tag\n") + 
    mytheme
# Histogramme für die Bedingungen Basis
df %>% filter(condit == "Basis") %>%
ggplot(aes(x = as.factor(day), y= tot_sold)) + 
    geom_bar(stat = "identity", fill = "lightgrey", width = .6) + 
    scale_y_continuous(breaks = seq(0,60,10), limits = c(0,60)) +
    labs(x="Tage", y="Anzahl verkaufte Gerichte") +
    mytheme
  
# Histogramme für die Bedingungen Intervention
df %>% filter(condit == "Intervention") %>%
ggplot(aes(x = as.factor(day), y= tot_sold)) + 
    geom_bar(stat = "identity", fill = "lightgrey", width = .6) + 
    scale_y_continuous(breaks = seq(0,60,10), limits = c(0,60)) + 
    labs(x="Tage", y="Anzahl verkaufte Gerichte") +
    mytheme


# Durchführung eines t-Tests
t_test <- t.test(df[df$condit == "Basis", ]$tot_sold, df[df$condit == "Intervention", ]$tot_sold, var.equal = F) # siehe ungerichtete Hypothese
t_test
