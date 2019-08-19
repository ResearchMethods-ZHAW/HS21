knitr::opts_chunk$set(fig.width = 20, fig.height = 12, warning = F, message = F)
#knitr::opts_chunk$get("root.dir")

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


