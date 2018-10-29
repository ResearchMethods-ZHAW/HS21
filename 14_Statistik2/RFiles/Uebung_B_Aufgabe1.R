knitr::opts_chunk$set(fig.width = 20, fig.height = 12, warning = F, message = F)
#knitr::opts_chunk$get("root.dir")

library(tidyverse)
library(ggfortify) # zur Testung der Voraussetzungen
library(FSA) # post hoc test after kruskal-test

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



df <- nova # clone den originaler Datensatz
df$label_content[grep("Pflanzlich+",df$label_content)] <- "Vegetarisch" # fasst die vier Inhalte der Gerichte zu drei Inhalten zusammen.

df_ <- df %>%
    group_by(label_content, week) %>% 
    summarise(tot_sold = n()) %>%
    drop_na() # lasst die unbekannten Menü-Inhalte weg

# überprüft die Voraussetzungen für eine ANOVA
# Histogramm
ggplot(df_, aes(x = tot_sold, y = ..count..)) + geom_histogram() + labs(x = "\nAnzahl verkaufte Gerichte pro Woche", y = "Häufigkeit\n") + mytheme

# Boxplot
ggplot(df_, aes(x = label_content, y= tot_sold)) + geom_boxplot(fill="white", color = "black", size = 1) + labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + mytheme 


# definiert das Modell
model <- aov(tot_sold ~ label_content, data = df_)

autoplot(model) # Inspektion der Modellvoraussetzung zeigt klare Verletzungen der Nicht-Linearität und Homoskedastizität 

summary.lm(model) # Dürfen die Ergebnisse interpretiert werden?

# überprüft die Voraussetzungen des Kruskal-Wallis Rank Sum Test.
# gibt es starke Abweichungen von der Normalverteilung und die Varianzen ähneln sich? In diesem Fall wäre ein Kruskal-Wallis Test passend.
df_$label_content <- factor(df_$label_content, levels = c("Fleisch", "Vegetarisch", "Buffet")) # unabhängige Variable muss zuest als Faktor definiert werden

kk_test <- kruskal.test(tot_sold ~ label_content, data = df_)
kk_test

dunnTest(tot_sold ~ label_content, data=df_, # wie unterscheiden sich die einzelnen Levels, hierfür kann der Dunn-Test zur Hand gezogen werden. Gemäss Zar (2010) kann der Dunn Test für ungleiche Gruppen angewendet werden
              method="bh") # werden korrigierte p-Werte ausgerechnet (Benjamini-Hochberg method)


# überprüft die Voraussetzungen des Welch-Test.
# gibt es eine hohe Varianzheterogenität und ist die relative Verteilung der Residuen gegeben? In diesem Fall wäre ein Welch-Test passend
w_test <- oneway.test(data=df_, tot_sold ~ label_content, var.equal=F)
w_test
df_ <- df %>%
    group_by(condit, label_content, week) %>%
    summarise(tot_sold = n()) %>%
    drop_na() # # lasst die unbekannten Menü-Inhalte weg

# überprüfe Voraussetzungen für eine ANOVA

# Boxplots
ggplot(df_, aes(x = interaction(label_content, condit), y = tot_sold)) + geom_boxplot(fill="lightgrey") + labs(x = "\nMenu-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + mytheme


# definiert das Modell mit Interaktion
model1 <- aov(tot_sold ~ label_content * condit, data = df_)

autoplot(model1)  # Inspektion der Modellvoraussetzung: sollte ok sein (?)

summary(model1) # Bei Interaktionen dürfen die Haupteffekte nicht mehr interpretiert werden

TukeyHSD(model1) # Tukey post hoc Tests


