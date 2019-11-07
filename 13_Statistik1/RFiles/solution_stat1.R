## ------------------------------------------------------------------------
# Als eine Möglichkeit, die Aufgabe 1.1 zu bearbeiten, nehmen wir hier den novanimal-Datensatz und gehen der folgenden Frage nach: Gibt es einen Zusammenhang zwischen Geschlecht und der Wahl des Menüinhalts (vegtarisch vs. fleischhaltig) in der Mensa

# berücksichtigt nur vegetarische und fleischhaltige Menüs
# 1) alle Buffet-Menüs weglassen
# 2) alle veganen Gerichte zu vegetarische Gerichte umbenennen
nova2<-subset(nova, !(nova$label_content=="Buffet")) #Subset des Datensatzes ohne Buffet (Da Buffet nicht Fleisch/Vegetarisch zugordnet werden kann)

nova2$label_content[nova2$label_content %in% c('Pflanzlich','Pflanzlich+')] <- "Vegetarisch" # Überschreibt das Label "Pflanzlich","Pflanzlich+" mit "Vegetarisch"

nova2$label_content[grep("Pflanzlich+", nova2$label_content)] <- "Vegetarisch" # alternativer Lösungsweg

nova3<-droplevels(nova2) #entfernt die Kategorien die nicht mehr mehr benutzt werden

#Anzahl Vegetarische/FleischMenüs pro Geschlecht~Vegetarisch Base R
observed<-table(nova2$gender, nova2$label_content) 


#Anzahl Vegetarische/FleischMenüs pro Geschlecht~Vegetarisch Tidyverse
#braucht in diesem speziellen Fall viel mehr Code, da der Chi-Quadrat-Test am liebsten Matrizen will
# unser Vorschlag, nehmt den table Befehl
# untenstehend der vollständige Code in Tidyverse
observed_t <- nova2 %>% 
  group_by(gender, label_content) %>% 
  summarise(tot = n()) %>% 
  ungroup() %>%
  spread(., key = label_content, value = tot) %>%  #
  # set_rownames(.$gender) %>% funktioniert leider nicht mehr mit tibble
  select(-gender) %>%
  as.matrix()


#Chi-squared Test
chi_sq <- chisq.test(observed)
chi_sq

#Fisher's Test 
fisher.test(observed)


## ---- echo=F-------------------------------------------------------------
library(reshape2)
table <- as.data.frame(observed) %>%
  mutate(`Verkaufszahlen (%)` = round(Freq / sum(Freq) * 100, 1)) %>% 
  rename(Geschlecht = Var1, Menüinhalt = Var2, Verkaufszahlen = Freq) %>% 
  mutate(Geschlecht = recode(Geschlecht, "F" = "Frauen", "M" = "Männer"))
knitr::kable(table, caption = "Tabelle 1 \n Verkaufszahlen des Menüinhalts nach Geschlecht")



## ------------------------------------------------------------------------
# bereitet eure Daten auf
# gruppiert die Variablen und fasst sie 
# nach Geschlecht und Hochschulzugehörigkeit zusammen 
# fügt Information aus der Aufgabenstellung hinzu: absolute Häufigkeiten der Gesamtheit
# für den Chi-Quardrat-Test ist eine Berechnung der relativen Häufigkeiten nötig

df_t <- group_by(nova, gender, member) %>% 
  summarise(stichprobe = n()) %>% 
  ungroup() %>%
  mutate(canteen_member = c("Mitarbeiterinnen", "Studentinnen", "Mitarbeiter", "Studenten"), # Achtung: Reihenfolge muss stimmten vgl. canteen_member
         gesamtheit = c(345, 719, 339, 816), # Achtung: Reihenfolge muss stimmten vgl. oben
         gesamtheit_pct = gesamtheit / sum(gesamtheit),
         stichprobe_pct = stichprobe / sum(stichprobe)) # Berechnung der relativen Häufigkeiten

# berechnet den Chi-Quadrat-Test

chi_sq <- chisq.test(df_t$stichprobe, p = df_t$gesamtheit_pct) # es werden zwei Informationen übergeben, eure beobachteten Werte (stichprobe) und die in der Grundgesamtheit/Population erwarteten Werte (wichtig als relative Häufigkeiten)

chi_sq



## ---- echo=F-------------------------------------------------------------
table <- df_t %>% 
  rename(Hochschulzugehörigkeit = member, `Anzahl Population` = gesamtheit, `Anzahl Stichprobe` = stichprobe, `Anteil Population (%)` = gesamtheit_pct, `Anteil Stichprobe (%)` = stichprobe_pct) %>%
  dplyr::select(Hochschulzugehörigkeit, `Anzahl Population`, `Anteil Population (%)`, `Anzahl Stichprobe`, `Anteil Stichprobe (%)`) %>% 
  mutate(`Anteil Stichprobe (%)` = round(`Anteil Stichprobe (%)`,2)*100, `Anteil Population (%)` = `Anteil Population (%)`*100)
knitr::kable(table, caption = "Tabelle 2 \nAnzahl und Anteil Beobachtungen in der Population und in der Stichprobe")



## ------------------------------------------------------------------------
# Gemäss Aufgabenstellung müsset die Daten zuerst nach Kalenderwochen "week" und Bedingungen "condition" zusammengefasst werden

df <- nova %>%
    group_by(week, condit) %>%  
    summarise(tot_sold = n()) 

# überprüft die Voraussetzungen für einen t-Test
ggplot(df, aes(x = condit, y= tot_sold)) + # achtung 0 Punkt fehlt
    geom_boxplot(fill = "white", color = "black", size = 1) + 
    labs(x="\nBedingungen", y="Durchschnittlich verkaufte Gerichte pro Woche\n") + 
    mytheme

# Auf den ersten Blick scheint es keine starken Abweichungen zu einer Normalverteilung zu geben resp. es sind keine extremen schiefen Verteilungen ersichtlich (vgl. Statistik 2, Folien 12-21)



## ------------------------------------------------------------------------

# führt einen t-Tests durch; 
# es wird angenommen, dass die Verkaufszahlen zwischen den Bedingungen unabhängig sind

t_test <- t.test(tot_sold~condit, data=df)

t.test(df[df$condit == "Basis", ]$tot_sold, 
                 df[df$condit == "Intervention", ]$tot_sold) #alternative Formulierung


