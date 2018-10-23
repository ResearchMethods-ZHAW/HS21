
library(readr)
library(dplyr)
library(car)
library(gmodels)
library(ggfortify)
library(FSA)

nova <- read_delim("13_Statistik1/data/novanimal.csv", delim = ";")


df <- nova # kopiere originaler Datensatz
df$label_content[grep("Pflanzlich+",df$label_content)] <- "Vegetarisch" # Fasse die Menü-Inhalte zusammen

# lasse evtl weg, da gruppen zu klein für ANOVA
df$age_groups <- cut(x = df$age, breaks = c(-Inf, 34, 49, 64, Inf), labels = c("18- bis 34-Jährigen", "35- bis 49-Jährigen", "50- bis 64-Jährigen", "65 Jahre und älter")) # 

df_ <- df %>%
    group_by(label_content, condit, week) %>%
    summarise(tot_sold = n()) %>%
    na.omit() # lasse die unbekannten Verkäufe weg


# erstes Modell
model <- aov(tot_sold ~ label_content, data = df_)

ggplot(df_, aes(x = tot_sold, y = ..count..)) + geom_histogram() + labs(x = "Verkaufte Gerichte", y = "Häufigkeit") # schaue die Verkaufszahlen in einem Histogramm an
# Sieht nach keiner Normalverteilung aus, aber ab > 25 Beobachtungen pro Gruppe sind Verletzungen in der Regel unproblematisch (Quelle: uzh).  
autoplot(model) # Inspektion der Modellvoraussetzung: Daten passen für eine ANOVA (?)
leveneTest(df_$tot_sold, df_$label_content) # keine Varianzhomogenität gegeben
summary.lm(model) # Ergebnisse sollten mit Vorsicht interpretiert werden

# Alternative Testung: Kruskal-Wallis Rank Sum Test
df_$label_content <- factor(df_$label_content, levels = c("Fleisch", "Vegetarisch", "Hot and Cold")) # unabhängige Variable muss zuest als Faktor definiert werden
kruskal.test(tot_sold ~ label_content, data = df_) # sieht aus als ob sich die Verkaufszahlen zwischen den Menü-Inhalten unterscheiden würden
dunnTest(tot_sold ~ label_content, data=df_, # wie unterscheiden sich die einzelnen Levels, hierfür kann der Dunn-Test zur Hand gezogen werden. Gemäss Zar (2010) kann der Dunn Test für ungleiche Gruppen angewendet werden
              method="bh") # werden korrigierte p-Werte ausgerechnet (Benjamini-Hochberg method)

# Visualisierung und Dasrtellung der Ergebnisse 
ggplot(df_, aes(x = label_content, y= tot_sold)) + geom_boxplot(fill="lightgrey") + labs(x = "Menu-Inhalt", y = "Anzahl verkaufte Gerichte")+theme_bw()+theme() # vergrössere schrift


#Gruppiere Daten und fasse sie nach Vorkommen/Häufigkeit zusammen
df_ <- df %>%
    group_by(condit, label_content, week, gender, member) %>%
    summarise(tot_sold = n()) %>%
    na.omit() # lasse die unbekannten Verkäufe weg

# Soziodemografische Unterschiede in der Menü-Wahl?
model1 <- aov(tot_sold ~ label_content * condit, data = df_)
autoplot(model1)  # Inspektion der Modellvoraussetzung, 
leveneTest(df_$tot_sold ~ df_$label_content*df_$condit) # keine Varianzhomogenität gegeben
summary.lm(model1) # Ergebnisse müssen mit vorsicht interpretiert werden

# Alternative Testung: Kruskal-Wallis Rank Sum Test
df_$label_content <- factor(df_$label_content, levels = c("Fleisch", "Vegetarisch", "Hot and Cold")) # unabhängige Variable muss zuest als Faktor definiert werden
kruskal.test(tot_sold ~ interaction(label_content, condit), data = df_) # sieht aus als ob sich die Verkaufszahlen zwischen den Menü-Inhalten unterscheiden würden
dunnTest(tot_sold ~ interaction(label_content, condit), data=df_, # wie unterscheiden sich die einzelnen Levels, hierfür kann der Dunn-Test zur Hand gezogen werden. Gemäss Zar (2010) kann der Dunn Test für ungleiche Gruppen angewendet werden
              method="bh") # werden korrigierte p-Werte ausgerechnet (Benjamini-Hochberg method)


# visualisiere das Modell
ggplot(df_, aes(x = interaction(label_content, condit), y = tot_sold)) + geom_boxplot(fill="lightgrey") + labs(x = "Menu-Inhalt", y = "verkaufte Menus")

