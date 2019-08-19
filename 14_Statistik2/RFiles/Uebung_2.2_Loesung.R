
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

TukeyHSD(model)

# überprüft die Voraussetzungen des Welch-Test.
# gibt es eine hohe Varianzheterogenität und ist die relative Verteilung der Residuen gegeben? In diesem Fall wäre ein Welch-Test passend
w_test <- oneway.test(data=df_, tot_sold ~ label_content, var.equal=F)
w_test


# zeigt die Ergebnisse anhand eines Plots
library(multcomp)
df_$label_content <- parse_factor(df_$label_content, levels = c("Buffet", "Fleisch", "Vegetarisch")) # damit man die Buchstaben generieren kann, müssen die Menü-Inhalte zu factoren definiert werden, beachte dabei die Reihenfolge
model <- aov(tot_sold ~ label_content, data = df_)
letters <-cld(glht(model, linfct=mcp(label_content="Tukey")))

ggplot(df_, aes(x = label_content, y= tot_sold)) + geom_boxplot(fill="white", color = "black", size = 1) + labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + annotate("text", x = 1:3, y = 130, label = letters$mcletters$Letters, size = 6) + mytheme 


df_ <- df %>%
    group_by(condit, label_content, week) %>%
    summarise(tot_sold = n()) %>%
    drop_na() # # lasst die unbekannten Menü-Inhalte weg

# überprüfe Voraussetzungen für eine ANOVA

# Boxplots
ggplot(df_, aes(x = interaction(label_content, condit), y = tot_sold)) + geom_boxplot(fill="white", size = 1) + labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + mytheme


# definiert das Modell mit Interaktion
model1 <- aov(tot_sold ~ label_content * condit, data = df_)

autoplot(model1)  # Inspektion der Modellvoraussetzung: sollte ok sein (?)

summary.lm(model1) # Bei Interaktionen dürfen die Haupteffekte nicht mehr interpretiert werden

TukeyHSD(model1) # Tukey post hoc Tests




# zeigt die Ergebnisse anhand eines Plots
library(multcomp)
df_$cond_label <- interaction(df_$condit, df_$label_content) # bei Interaktionen gibt es diesen Trick, um bei den multiplen Vergleiche, die richtigen Buchstaben zu bekommen
model1 <- aov(tot_sold ~ cond_label, data = df_)
letters <-cld(glht(model1, linfct=mcp(cond_label="Tukey")))

ggplot(df_, aes(x = cond_label, y= tot_sold)) +
  geom_boxplot(fill="white", color = "black", size = 1) + 
  labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") +
  scale_y_continuous(breaks = seq(0, 130,25), limits = c(0, 130)) +
  annotate("text", x = 1:6, y = 130, label = letters$mcletters$Letters, size = 6) +
  mytheme 


# eine weitere Möglichkeit die Ergebnisse darzustellen
m_sell <- na.omit(df_) %>% group_by(condit,label_content) %>% summarise(val = mean(tot_sold)) # berechne die durchschnittlichen Verkaufszahlen pro Bedingung

ggplot(df_, aes(x = condit, y = tot_sold, linetype = label_content, shape = label_content)) + 
    geom_point(data = m_sell, aes(y = val), size = 4) +
    geom_line(data = m_sell, aes(y = val, group = label_content), size = 2) + 
    labs(y = "Durchschnittlich verkaufte Gerichte pro Woche", x = "Bedingungen") + 
    guides(linetype = F, shape = guide_legend(title = "Menü-Inhalt"))+
    scale_y_continuous(breaks = seq(0,120,20), limits = c(0,120))+
    mytheme


