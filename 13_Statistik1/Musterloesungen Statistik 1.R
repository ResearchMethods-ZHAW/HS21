## ------------------------------------------------------------------------
# gruppiert die Varieblen und fasst sie 
# nach Geschlecht und Hochschulzugehörigkeit zusammen 

canteen <- group_by(nova, gender, member) %>% 
  summarise(tot = n()) %>% 
  ungroup() %>%
  mutate(canteen_member = c("Mitarbeiterinnen", "Studentinnen", "Mitarbeiter", "Studenten"))

# definiert einen Vektor mit den erwarteten Wahrscheinlichkeiten, 
# beachtet dabei die Reihenfolge 

population_exp <- c(.15,.32,.16,.37) # Achtung: die Summe muss 1 ergeben
  
# berechnet den Chi-Quadrat-Test

chi_sq <- chisq.test(canteen$tot, p = population_exp)
chi_sq

# führt einen Fishers exakten Test durch
# erstellt dafür einen neuen Datensatz; 
# tibble() ist eine ähnliche Funktion wie data.frame()

fisher_t <- tibble(member = c("Mitarbeiterinnen", "Studentinnen", "Mitarbeiter", "Studenten"),
  population = round(population_exp * 2138,0),
  stichprobe = canteen$tot,
  population_pct = population_exp, 
  canteen_pct = canteen$tot / sum(canteen$tot))

# simulate.p.value simuliert einen p-Wert mit 100000 Replikaten

fish <- fisher.test(fisher_t[ ,2:3], simulate.p.value=TRUE, B = 100000) 
fish


## ---- echo=F, fig.-------------------------------------------------------
table <- fisher_t %>% 
  rename(Hochschulzugehörigkeit = member, `Anzahl Population` = population, `Anzahl Stichprobe` = stichprobe, `Anteil Population (%)` = population_pct, `Anteil Stichprobe (%)` = canteen_pct) %>%
  dplyr::select(Hochschulzugehörigkeit, `Anzahl Population`, `Anteil Population (%)`, `Anzahl Stichprobe`, `Anteil Stichprobe (%)`) %>% 
  mutate(`Anteil Stichprobe (%)` = round(`Anteil Stichprobe (%)`,2)*100, `Anteil Population (%)` = `Anteil Population (%)`*100)
knitr::kable(table, caption = "Anzahl und Anteil Beobachtungen in der Population und in der Stichprobe")


## ------------------------------------------------------------------------
# Daten müssen zuerst nach "week" und "condition" zusammengefasst werden

df <- nova %>%
    group_by(week, condit) %>%  
    summarise(tot_sold = n()) 

# überprüft die Voraussetzungen für einen t-Test
ggplot(df, aes(x = condit, y= tot_sold)) + 
    geom_boxplot(fill = "white", color = "black", size = 1) + 
    labs(x="\nBedingungen", y="Durchschnittlich verkaufte Gerichte pro Woche\n") + 
    mytheme


## ------------------------------------------------------------------------

# führt einen t-Tests durch; 
# es wird angenommen, dass die Verkaufszahlen zwischen den Bedingungen unabhängig sind

t_test <- t.test(df[df$condit == "Basis", ]$tot_sold, 
                 df[df$condit == "Intervention", ]$tot_sold)
t_test

