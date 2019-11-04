knitr::opts_chunk$set(fig.width = 20, fig.height = 12, warning = F, message = F)
knitr::opts_chunk$get("root.dir")

library(readr)
library(dplyr)
library(ggfortify)
library(FSA) # post hoc test after kruskal-test
library(jtools) # apa theme for ggplot

nova <- read_delim("13_Statistik1/data/novanimal.csv", delim = ";")


df <- nova # kopiere originaler Datensatz
df$label_content[grep("Pflanzlich+",df$label_content)] <- "Vegetarisch" # Fasse die Menü-Inhalte zusammen

# # lasse evtl weg, da gruppen zu klein für ANOVA
# df$age_groups <- cut(x = df$age, breaks = c(-Inf, 34, 49, 64, Inf), labels = c("18- bis 34-Jährigen", "35- bis 49-Jährigen", "50- bis 64-Jährigen", "65 Jahre und älter")) # 

df_ <- df %>%
    group_by(label_content, week) %>%
    summarise(tot_sold = n()) %>%
    na.omit() # lasse die unbekannten Verkäufe weg


# überprüfe Voraussetzungen für ANOVA

ggplot(df_, aes(x = tot_sold, y = ..count..)) + geom_histogram() + labs(x = "Anzahl verkaufte Gerichte pro Woche", y = "Häufigkeit") + theme_apa(x.font.size = 20, y.font.size = 20) +  theme(axis.text = element_text(size = 20))  # schaue die Verkaufszahlen in einem Histogramm an

ggplot(df_, aes(x = label_content, y= tot_sold)) + geom_boxplot(fill="lightgrey", width = .6) + labs(x = "\nMenu-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + theme_apa(x.font.size = 20, y.font.size = 20) +  theme(axis.text = element_text(size = 20)) # schaue die die Boxplots an

# definiere Modell: Verkaufszahlen werden durch die Menü-Inhalte beeinflusst
model <- aov(tot_sold ~ label_content, data = df_)

autoplot(model) # Aber Inspektion der Modellvoraussetzung zeigt klare Verletzungen der Nicht-Linearität und Homoskedastizität 

summary.lm(model) # Ergebnisse dürfen nicht interpretiert werden

# Alternative Testung: Kruskal-Wallis Rank Sum Test
df_$label_content <- factor(df_$label_content, levels = c("Fleisch", "Vegetarisch", "Buffet")) # unabhängige Variable muss zuest als Faktor definiert werden -> erster Faktor (hier Fleisch) wird die Refernzkategorie bilden
kruskal.test(tot_sold ~ label_content, data = df_) # sieht aus als ob sich die Verkaufszahlen zwischen den Menü-Inhalten unterscheiden würden
dunnTest(tot_sold ~ label_content, data=df_, # wie unterscheiden sich die einzelnen Levels, hierfür kann der Dunn-Test zur Hand gezogen werden. Gemäss Zar (2010) kann der Dunn Test für ungleiche Gruppen angewendet werden
              method="bh") # werden korrigierte p-Werte ausgerechnet (Benjamini-Hochberg method)




# Gruppiere Daten und fasse es zusammen
df_ <- df %>%
    group_by(condit, label_content, week) %>% # gruppiere nach Bedingung, Menü-Inhalt und Woche
    summarise(tot_sold = n()) %>%
    na.omit() # lasse die unbekannten Verkäufe weg

# überprüfe Voraussetzungen für ANOVA

ggplot(df_, aes(x = interaction(label_content, condit), y = tot_sold)) + geom_boxplot(fill="lightgrey") + labs(x = "\nMenu-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + theme_apa(x.font.size = 20, y.font.size = 20) +  theme(axis.text = element_text(size = 20)) # schaue Boxplots an


# definiere Modell mit Interaktion
model1 <- aov(tot_sold ~ label_content * condit, data = df_)

autoplot(model1)  # Inspektion der Modellvoraussetzung: sollte ok sein (?)

summary(model1) # Bei Interaktionen dürfen die Haupteffekte nicht mehr interpretiert werden

TukeyHSD(model1) # Tukey post hoc Tests

# # Alternative Testung: Kruskal-Wallis Rank Sum Test
# df_$label_content <- factor(df_$label_content, levels = c("Fleisch", "Vegetarisch", "Buffet")) # unabhängige Variable muss zuest als Faktor definiert werden
# kruskal.test(tot_sold ~ interaction(label_content, condit), data = df_) # sieht aus als ob sich die Verkaufszahlen zwischen den Menü-Inhalten unterscheiden würden
# dunnTest(tot_sold ~ interaction(label_content, condit), data=df_, # wie unterscheiden sich die einzelnen Levels, hierfür kann der Dunn-Test zur Hand gezogen werden. Gemäss Zar (2010) kann der Dunn Test für ungleiche Gruppen angewendet werden
#               method="bh") # werden korrigierte p-Werte ausgerechnet (Benjamini-Hochberg method)
# 


