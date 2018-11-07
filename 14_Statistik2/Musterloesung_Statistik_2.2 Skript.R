### Musterlösung Aufgabe 2.2: einfaktorielle ANOVA

library(tidyverse)
library(ggfortify) # zur Testung der Voraussetzungen

## ladet die nötigen Packete und die novanimal.csv Datei in R
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



## ------------------------------------------------------------------------

df <- nova # klone den originaler Datensatz

# fasst die vier Inhalte der Gerichte zu drei Inhalten zusammen.
df$label_content[grep("Pflanzlich+",df$label_content)] <- "Vegetarisch" 

# gruppiert Daten nach Menü-Inhalt und Woche
df_ <- df %>%
    group_by(label_content, week) %>% 
    summarise(tot_sold = n()) %>%
    drop_na() # lasst die unbekannten Menü-Inhalte weg

# überprüft die Voraussetzungen für eine ANOVA
# Histogramm, sagt aber nicht viel aus
ggplot(df_, aes(x = tot_sold, y = ..count..)) + 
  geom_histogram() + 
  labs(x = "\nAnzahl verkaufte Gerichte pro Woche", y = "Häufigkeit\n") +
  mytheme 


# Boxplot
ggplot(df_, aes(x = label_content, y= tot_sold)) +
  geom_boxplot(fill="white", color = "black", size = 1) +
  labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") +
  mytheme # klare Varianzheterogenität


# definiert das Modell
model <- aov(tot_sold ~ label_content, data = df_)

summary.lm(model)

autoplot(model) + mytheme 


## ------------------------------------------------------------------------

# überprüft die Voraussetzungen des Welch-Test.
# Gibt es eine hohe Varianzheterogenität und 
# ist die relative Verteilung der Residuen gegeben? 
# In diesem Fall wäre ein Welch-Test passend
w_test <- oneway.test(data=df_, tot_sold ~ label_content, var.equal=F)
w_test

## ----
# plottet die Ergebnisse
ggplot(df_, aes(x = label_content, y= tot_sold)) +
  geom_boxplot(fill="white", color = "black", size = 1) + 
  labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + 
  mytheme 


