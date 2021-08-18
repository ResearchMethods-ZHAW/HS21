## -----------------------------
# Als eine Möglichkeit, die Aufgabe 1.1 zu bearbeiten, nehmen wir hier den Datensatz  der Gästebefragung NOVANIMAL und gehen der folgenden Frage nach: Gibt es einen Zusammenhang zwischen Geschlecht und dem wahrgenommenen Milchkonsum (viel vs. wenig Milch/-produkte)

# die Variable wahrgenommener Milchkonsum muss noch in 2 Kategorien zusammengefasst werden: geringer vs. hoher Milchkonsum


# Variable  milk == wahrgenommener Milchkonsum 
# alles kleiner als 4 (3 inklusive) == geringer wahrgenommener Milchkonsum, alles grösser als 3 (4 inklusive) == hoher wahrgenommener Milchkonsum
nova2 <- nova_survey %>% 
  filter(gender != "x") %>% # x aus der Variable Geschlecht entfernen 
  mutate(milkcompt = if_else(milk >= 3, "wenig", "viel")) %>% 
  select(gender, milkcompt) %>% 
  drop_na() # alle Missings können gestrichen werden
 
    
# mal anschauen
table(nova2)


#Chi-squared Test
chi_sq <- chisq.test(nova2$gender, nova2$milkcompt)
chi_sq

#Fisher's Test 
fisher.test(nova2$gender, nova2$milkcompt)


## ---- echo=F------------------
table <- nova2 %>%
  group_by(gender, milkcompt) %>% 
  summarise(tot = n()) %>% 
  mutate(`wahr. Milchkonsum (%)` = round(tot / sum(tot) * 100, 1)) %>% 
  rename(Geschlecht = gender, `wahr. Milchkonsum` = milkcompt, `absolute Werte`= tot)

knitr::kable(table, caption = "Tabelle 1 \n Wahrgenommener Milchkonsum nach Geschlecht")



## -----------------------------
# Gemäss Aufgabenstellung müsset die Daten zuerst nach Kalenderwochen "week" und Bedingungen "condition" zusammengefasst werden

df <- nova %>%
    group_by(week, condit) %>%  
    summarise(tot_sold = n()) 

# überprüft die Voraussetzungen für einen t-Test
ggplot(df, aes(x = condit, y= tot_sold)) + # achtung 0 Punkt fehlt
    geom_boxplot(fill = "white", color = "black", size = 1) + 
    labs(x="\nBedingungen", y="Durchschnittlich verkaufte Gerichte pro Woche\n") + 
    mytheme

# Auf den ersten Blick scheint es keine starken Abweichungen zu einer Normalverteilung zu geben resp. es sind keine extremen schiefen Verteilungen ersichtlich (vgl. Skript Statistik 2)



## -----------------------------

# führt einen t-Tests durch; 
# es wird angenommen, dass die Verkaufszahlen zwischen den Bedingungen unabhängig sind

t_test <- t.test(tot_sold~condit, data=df)

t.test(df[df$condit == "Basis", ]$tot_sold, 
                 df[df$condit == "Intervention", ]$tot_sold) #alternative Formulierung


