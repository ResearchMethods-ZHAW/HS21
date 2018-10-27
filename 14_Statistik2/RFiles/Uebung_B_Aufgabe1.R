knitr::opts_chunk$set(fig.width = 20, fig.height = 12, warning = F, message = F)
#knitr::opts_chunk$get("root.dir")

library(tidyverse)
library(FSA) # post hoc test after kruskal-test

# lade Datensatz
nova <- read_delim("13_Statistik1/data/novanimal.csv", delim = ";")

## definiere theme für die Plots

mytheme <- 
  theme_classic() + 
  theme(
    axis.line = element_line(color = "black"), 
    axis.text = element_text(size = 20, color = "black"), 
    axis.title = element_text(size = 20, color = "black"), 
    axis.ticks = element_line(size = 1, color = "black"), 
    axis.ticks.length = unit(.5, "cm")
    )



df <- nova # kopiere originaler Datensatz
df$label_content[grep("Pflanzlich+",df$label_content)] <- "Vegetarisch" # benenne die pflanzlichen Gerichte zu vegetarischen Gerichte um

df_ <- df %>%
    group_by(label_content, week) %>% # fasse den Datensatz zusammen
    summarise(tot_sold = n()) %>%
    drop_na() # lasse die unbekannten Verkäufe weg

# überprüfe Voraussetzungen für ANOVA

ggplot(df_, aes(x = tot_sold, y = ..count..)) + geom_histogram() + labs(x = "\nAnzahl verkaufte Gerichte pro Woche", y = "Häufigkeit\n") + mytheme# schaue die Verkaufszahlen in einem Histogramm an

ggplot(df_, aes(x = label_content, y= tot_sold)) + geom_boxplot(fill="lightgrey", width = .6) + labs(x = "\nMenu-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + mytheme # schaue die die Boxplots an

# definiere Modell: Verkaufszahlen werden durch die Menü-Inhalte beeinflusst
model <- aov(tot_sold ~ label_content, data = df_)

autoplot(model) # Aber Inspektion der Modellvoraussetzung zeigt klare Verletzungen der Nicht-Linearität und Homoskedastizität 

summary.lm(model) # Ergebnisse dürfen nicht interpretiert werden

# Alternative Testung: Kruskal-Wallis Rank Sum Test
df_$label_content <- factor(df_$label_content, levels = c("Fleisch", "Vegetarisch", "Buffet")) # unabhängige Variable muss zuest als Faktor definiert werden -> erster Faktor (hier Fleisch) wird die Refernzkategorie bilden
kk_test <- kruskal.test(tot_sold ~ label_content, data = df_) # sieht aus als ob sich die Verkaufszahlen zwischen den Menü-Inhalten unterscheiden würden
dunnTest(tot_sold ~ label_content, data=df_, # wie unterscheiden sich die einzelnen Levels, hierfür kann der Dunn-Test zur Hand gezogen werden. Gemäss Zar (2010) kann der Dunn Test für ungleiche Gruppen angewendet werden
              method="bh") # werden korrigierte p-Werte ausgerechnet (Benjamini-Hochberg method)


# Welch-Test
oneway.test(data=df_, tot_sold ~ label_content, var.equal=F)
# Gruppiere Daten und fasse es zusammen, nehme dabei den veränderten Datensatz von Aufgabe 1
df_ <- df %>%
    group_by(condit, label_content, week) %>% # gruppiere nach Bedingung, Menü-Inhalt und Woche
    summarise(tot_sold = n()) %>%
    drop_na() # lasse die unbekannten Verkäufe weg

# überprüfe Voraussetzungen für ANOVA

ggplot(df_, aes(x = interaction(label_content, condit), y = tot_sold)) + geom_boxplot(fill="lightgrey") + labs(x = "\nMenu-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + mytheme # schaue Boxplots an

# definiere Modell mit Interaktion
model1 <- aov(tot_sold ~ label_content * condit, data = df_)

autoplot(model1)  # Inspektion der Modellvoraussetzung: sollte ok sein (?)

summary(model1) # Bei Interaktionen dürfen die Haupteffekte nicht mehr interpretiert werden

TukeyHSD(model1) # Tukey post hoc Tests


