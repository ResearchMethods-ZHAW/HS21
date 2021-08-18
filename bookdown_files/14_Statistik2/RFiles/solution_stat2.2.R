## ---- message=FALSE, echo=FALSE, results='hide', warning=FALSE----

library(tidyverse)
library(ggfortify) # zur Testung der Voraussetzungen
library(data.table)
library(magrittr)

## ladet die nötigen Packete und die novanimal.csv Datei in R
nova <- read_delim("13_Statistik1/data/2017_ZHAW_aggregated_menu_sales_NOVANIMAL.csv", delim = ";")

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




## -------------------------------

df <- nova # klone den originaler Datensatz

# fasst die vier Inhalte der Gerichte zu drei Inhalten zusammen.
df %<>%
  mutate(label_content = str_replace(label_content, "Geflügel|Fisch", "Fleisch")) # Geflügel & Fisch zu fleischgerichte zählen

# gruppiert Daten nach Menü-Inhalt und Woche
df %<>%
    group_by(label_content, week) %>% 
    summarise(tot_sold = n()) %>%
    drop_na() # lasst die unbekannten Menü-Inhalte weg

# überprüft die Voraussetzungen für eine ANOVA
# Schaut euch die Verteilungen der Mittelwerte an (plus Standardabweichungen)
# Sind Mittelwerte nahe bei Null? Gäbe uns einen weiteren Hinweis auf eine spezielle Binomail-Verteilung (vgl. Statistik 4, Folie 17)
df %>% 
  split(.$label_content) %>% # teilt den Datensatz in 3 verschiedene Datensätze auf
  purrr::map(~ psych::describe(.$tot_sold)) # mit map können andere Funktionen auf den Datensatz angewendet werden (alternative Funktionen sind aggregate oder apply)


# Boxplot
ggplot(df, aes(x = label_content, y= tot_sold)) + 
  stat_boxplot(geom = "errorbar", width = 0.25) + # Achtung: Reihenfolge spielt hier eine Rolle!
  geom_boxplot(fill="white", color = "black", size = 1, width = .5) +
  labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") + 
  mytheme # achtung erster Hinweis einer Varianzheterogenität, wegen den Hot and Cold Gerichten


# definiert das Modell (vgl. Skript Statistik 2)
model <- aov(tot_sold ~ label_content, data = df)

summary.lm(model)

# überprüft die Modelvoraussetzungen
par(mfrow = c(2,2))
plot(model)



## -------------------------------

# überprüft die Voraussetzungen des Welch-Tests:
# Gibt es eine hohe Varianzheterogenität und ist die relative Verteilung der Residuen gegeben? (siehe Folien Statistik 2: Folie 18)
# Ja Varianzheterogenität ist gegeben, aber die Verteilung der Residuen folgt einem "Trichter", also keiner "normalen/symmetrischen" Verteilung um 0
# Daher ziehe ich eine Transformation der AV einem nicht-parametrischen Test vor
# für weitere Infos: https://data.library.virginia.edu/interpreting-log-transformations-in-a-linear-model/
model_log <- aov(log10(tot_sold) ~ label_content, data = df) # achtung hier log10, bei Rücktransformation achten

par(mfrow = c(2,2))
plot(model_log) # scheint ok zu sein

summary.lm(model_log) # Referenzkategorie ist der Buffet-Inhalt

TukeyHSD(model_log) # (Statistik 2: Folien 9-11)

# Achtung Beta-Werte resp. Koeffinzienten sind nicht direkt interpretierbar
# sie müssten zuerst wieder zurück transformiert werden, hier ein Beispiel dafür:
# für Buffet
10^model_log$coefficients[1]

# für Fleisch
10^(model_log$coefficients[1] + model_log$coefficients[2])

# für Vegi
10^(model_log$coefficients[1] + model_log$coefficients[3])


## ---- echo=F, fig.cap="Die wöchentlichen Verkaufzahlen unterscheiden sich je nach Menüinhalt stark. Das Modell wurde mit den log-tranformierten Daten gerechnet.", tidy=TRUE----

# plottet die originalen Beobachtungen, die nicht tranformierten Daten werden hier aufgezeigt
# Wichtig: einen Verweis auf die Log-Transformation benötigt es jedoch

# aufbereitung für die Infos der Signifikanzen => Alternative Lösungen findet ihr in der Musterlösung 2.3S
df1 <- data.frame(a = c(1, 1:3,3), b = c(150, 151, 151, 151, 150)*15) # Multiplikation nur aus dem Grund, weil ich vorher einen anderen kleineren Datensatz verwendete :)
df2 <- data.frame(a = c(1, 1,2, 2), b = c(130, 131, 131, 130)*15)
df3 <- data.frame(a = c(2, 2, 3, 3), b = c(140, 141, 141, 140)*15)


ggplot(df, aes(x = label_content, y= tot_sold)) +
   stat_boxplot(geom = "errorbar", width = .25) +
   geom_boxplot(fill="white", color = "black", size = 1, width = .5) + 
   geom_line(data = df1, aes(x = a, y = b)) + annotate("text", x = 2, y = 2320, label = "***", size = 8) + # aus der Information aus dem Tukey Test von oben: Buffet-Vegetarisch
   geom_line(data = df2, aes(x = a, y = b)) + annotate("text", x = 1.5, y = 2020, label = "***", size = 8) + # Buffet - Fleisch
   geom_line(data = df3, aes(x = a, y = b)) + annotate("text", x = 2.5, y = 2150, label = "***", size = 8)+ # Fleisch - Vegetarisch
   expand_limits(y = 0) + # nimmt das 0 bei der y-Achse mit ein
   labs(x = "\nMenüinhalt", y = "Anzahl verkaufte Gerichte\n pro Woche\n") +
   mytheme 

# hier ein paar interessante Links zu anderen R-Packages, die es ermöglichen signifikante Ergebniss in den Plot zu integrieren
# https://www.r-bloggers.com/add-p-values-and-significance-levels-to-ggplots/
# https://cran.r-project.org/web/packages/ggsignif/vignettes/intro.html
  
   

