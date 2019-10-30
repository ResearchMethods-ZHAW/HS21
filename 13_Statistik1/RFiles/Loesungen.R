## ladet die nötigen Packete und die novanimal.csv Datei in R

library(tidyverse)
nova <- read_delim("13_Statistik1/data/novanimal.csv", delim = ";")

## definiert mytheme für ggplot2 (verwendet dabei theme_classic())

mytheme <- 
  theme_classic() + 
  theme(
    axis.line = element_line(color = "black"), 
    axis.text = element_text(size = 20, color = "black"), 
    axis.title = element_text(size = 20, color = "black"), 
    axis.ticks = element_line(size = 1, color = "black"), 
    axis.ticks.length = unit(.5, "cm")
    )


# gruppiert die Varieblen und fasst sie nach Geschlecht und Hochschulzugehörigkeit zusammen 
canteen <- group_by(nova, gender, member) %>% 
  summarise(tot = n()) %>% 
  ungroup() %>%
  mutate(canteen_member = c("Mitarbeiterinnen", "Studentinnen", "Mitarbeiter", "Studenten")) # fasst die ersten beiden Variablen zusammen

# definiert einen Vektor mit den erwarteten Wahrscheinlichkeiten, beachtet dabei die Reihenfolge 

population_exp <- c(.15,.32,.16,.37) # Achtung: die Summe muss 1 ergeben
  
# berechnet den Chi-Quadrat-Test

chi_sq <- chisq.test(canteen$tot, p = population_exp)
chi_sq

# führt einen Fishers exakten Test durch
# erstellt dafür einen neuen Datensatz; tibble() ist eine ähnliche Funktion wie data.frame()

fisher_t <- tibble(member = c("Mitarbeiterinnen", "Studentinnen", "Mitarbeiter", "Studenten"),
  population = round(population_exp * 2138,0), # berechnet die beobachteten Zahlen der Population => Fishers exakter Test kann nicht mit erwarteten Häufigkeiten rechnen
  stichprobe = canteen$tot,
  population_pct = population_exp, 
  canteen_pct = canteen$tot / sum(canteen$tot))

fish <- fisher.test(fisher_t[ ,2:3], simulate.p.value=TRUE) # was sind die Unterschiede zwischen den beiden Tests (Chi-Quadrat-Test und Fishers exakter Test)? Wieso gibt der Fishers exakter Test keinen OR aus?
fish




# Daten müssen zuerst nach "week" und "condition" zusammengefasst werden

df <- nova %>%
    group_by(date, condit) %>%  
    summarise(tot_sold = n()) %>% 
    mutate(day = format(date, format = "%d.%m")) # erstellt neue Variable "day", damit beim Historgamm-Plot die x-Achse besser leserlich wird

# überprüft die Voraussetzungen für einen t-Test
ggplot(df, aes(x = condit, y= tot_sold)) + 
    geom_boxplot(fill = "white", color = "black", size = 1) + 
    scale_y_continuous(breaks = seq(0,60,10), limits = c(0,60)) +
    labs(x="\nBedingungen", y="Anzahl verkaufte Gerichte pro Tag\n") + 
    mytheme


# Histogramm für die Bedingung Basiswoche
df %>% filter(condit == "Basis") %>%
ggplot(aes(x = as.factor(day), y= tot_sold)) + 
    geom_bar(stat = "identity", fill = "white", color = "black", width = .6) + 
    scale_y_continuous(breaks = seq(0,60,10), limits = c(0,60)) +
    labs(x="Tage", y="Anzahl verkaufte Gerichte") +
    mytheme
  
# Histogramm für die Bedingungen Interventionwoche
df %>% filter(condit == "Intervention") %>%
ggplot(aes(x = as.factor(day), y= tot_sold)) + 
    geom_bar(stat = "identity", fill = "white", color = "black", width = .6) + 
    scale_y_continuous(breaks = seq(0,60,10), limits = c(0,60)) + 
    labs(x="Tage", y="Anzahl verkaufte Gerichte") +
    mytheme



# führt einen t-Tests durch; es wird angenommen, dass die Verkaufszahlen zwischen den Bedingungen unabhängig sind

t_test <- t.test(df[df$condit == "Basis", ]$tot_sold, df[df$condit == "Intervention", ]$tot_sold, var.equal = F)
t_test
