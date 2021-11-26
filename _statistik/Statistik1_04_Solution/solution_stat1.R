#export files
knitr::purl("solution_stat1.Rmd", "solution_stat1.R", documentation = 0)




# Als eine Möglichkeit, die Aufgabe 1.1 zu bearbeiten, nehmen wir hier den 
# Datensatz  der Gästebefragung NOVANIMAL und gehen der folgenden Frage nach: 
# Gibt es einen Zusammenhang zwischen Geschlecht und dem wahrgenommenen 
# Milchkonsum (viel vs. wenig Milch/-produkte)

# die Variable wahrgenommener Milchkonsum muss 
# noch in 2 Kategorien zusammengefasst werden: geringer vs. hoher Milchkonsum


# Variable  milk == wahrgenommener Milchkonsum 
# alles kleiner als 4 (3 inklusive) == geringer wahrgenommener Milchkonsum, 
#alles grösser als 3 (4 inklusive) == hoher wahrgenommener Milchkonsum
nova2 <- nova_survey %>% 
  filter(gender != "x") %>% # x aus der Variable Geschlecht entfernen 
  mutate(milkcon = if_else(milk <= 3, "wenig", "viel")) %>% 
  select(gender, milkcon) %>% 
  drop_na() # alle Missings können gestrichen werden
 
    
# mal anschauen
table(nova2)

#achtung chi_squre erwartet matrix
nova_mtx <- xtabs(~ gender + milkcon ,data = nova2) 
# da es in diesem fall keine kriteriumsvariable gibt, fehlt das y sozusagen



#Chi-squared Test
chi_sq <- chisq.test(nova_mtx)
chi_sq


#visualisierung
OP <- par(mfrow=c(1,2), "mar"=c(1,1,3,1))
mosaicplot(chi_sq$observed, cex.axis =1 , main = "Observed counts")
mosaicplot(chi_sq$expected, cex.axis =1 , main = "Expected counts\n(wenn geschlecht keinen einfluss hat)")
par(OP)

#Fisher's Test nur mit 2X2 Kontingenztabelle möglich
fisher.test(nova_mtx)

table <- nova2 %>%
  group_by(gender, milkcon) %>% 
  summarise(tot = n()) %>% 
  mutate(`wahr. Milchkonsum (%)` = round(tot / sum(tot) * 100, 1)) %>% 
  rename(Geschlecht = gender, `wahr. Milchkonsum` = milkcon, `absolute Werte`= tot)

knitr::kable(table, caption = "Wahrgenommener Milchkonsum nach Geschlecht")


# Gemäss Aufgabenstellung müsset die Daten zuerst nach Kalenderwochen "week" 
# und Bedingungen "condition" zusammengefasst werden

df <- nova %>%
    group_by(week, condit) %>%  
    summarise(tot_sold = n()) 

# überprüft die Voraussetzungen für einen t-Test
ggplot2::ggplot(df, aes(x = condit, y= tot_sold)) + # achtung 0 Punkt fehlt
    geom_boxplot(fill = "white", color = "black", size = 1) + 
    labs(x="\nBedingungen", y="Durchschnittlich verkaufte Gerichte pro Woche\n") + 
    mytheme

# Auf den ersten Blick scheint es keine starken Abweichungen zu einer 
#Normalverteilung zu geben resp. es sind keine extremen schiefen Verteilungen
# ersichtlich (vgl. Skript Statistik 2)



# führt einen t-Tests durch; 
# es wird angenommen, dass die Verkaufszahlen zwischen den Bedingungen 
# unabhängig sind

t_test <- t.test(tot_sold ~ condit, data=df, var.equl = T)

#alternative Formulierung
t.test(df[df$condit == "Basis", ]$tot_sold, 
                 df[df$condit == "Intervention", ]$tot_sold) 

```{.r .distill-force-highlighting-css}
```
