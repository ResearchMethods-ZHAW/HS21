
# für export loesung aufgabe 2
knitr::purl("solution_stat2.2_2.3s.Rmd", "Solution_stat2.2_2.3s.R", documentation = 0)




library(tidyverse)
# library(ggfortify) # zur Testung der Voraussetzungen
library(magrittr)
library(here)

## ladet die nötigen Packete und die novanimal.csv Datei in R
nova <- read_delim("https://zenodo.org/record/3890931/files/2017_ZHAW_aggregated_menu_sales_NOVANIMAL.csv?download=1", delim = ";")

## definiert mytheme für ggplot2 (verwendet dabei theme_classic())
mytheme <- 
  theme_classic() + 
  theme(
    axis.line = element_line(color = "black"), 
    axis.text = element_text(size = 12, color = "black"), 
    axis.title = element_text(size = 12, color = "black"), 
    axis.ticks = element_line(size = .75, color = "black"), 
    axis.ticks.length = unit(.5, "cm")
    )




df <- nova # klone den originaler Datensatz

# fasst die vier Inhalte der Gerichte zu drei Inhalten zusammen.
df %<>%
  # Geflügel & Fisch zu fleischgerichte zählen
  mutate(label_content = str_replace(label_content, "Geflügel|Fisch", "Fleisch")) %>% 
  # achtung reihenfolge spielt eine rolle, wegen des + (plus)
  mutate(label_content = str_replace(label_content, "Pflanzlich[+]|Pflanzlich", "Vegetarisch"))

# gruppiert Daten nach Menü-Inhalt und Woche
df %<>%
    group_by(label_content, week) %>% 
    summarise(tot_sold = n()) %>%
    drop_na() %>% 
    ungroup() # lasst die unbekannten Menü-Inhalte weg

# überprüft die Voraussetzungen für eine ANOVA
# Schaut euch die Verteilungen der Mittelwerte an (plus Standardabweichungen)
# Sind Mittelwerte nahe bei Null? 
# Gäbe uns einen weiteren Hinweis auf eine spezielle Binomail-Verteilung 
df %>% 
  split(.$label_content) %>% # teilt den Datensatz in 3 verschiedene Datensätze auf
  purrr::map(~ psych::describe(.$tot_sold)) # mit map können andere Funktionen 
# auf den Datensatz angewendet werden (alternative Funktionen sind aggregate oder apply)


# Boxplot
ggplot(df, aes(x = label_content, y= tot_sold)) +
  # Achtung: Reihenfolge spielt hier eine Rolle!
  stat_boxplot(geom = "errorbar", width = 0.25) +
  geom_boxplot(fill="white", color = "black", size = 1, width = .5) +
  labs(x = "\nMenü-Inhalt", y = "Anzahl verkaufte Gerichte pro Woche\n") +
  # achtung erster Hinweis einer Varianzheterogenität, wegen den Hot&Cold Gerichten
  mytheme

#alternative mit base
boxplot(df$tot_sold~df$label_content)

# definiert das Modell (vgl. Skript Statistik 2)
model <- aov(tot_sold ~ label_content, data = df)

summary.lm(model)

# überprüft die Modelvoraussetzungen
par(mfrow = c(2,2))
plot(model)



# überprüft die Voraussetzungen des Welch-Tests:
# Gibt es eine hohe Varianzheterogenität und ist die relative Verteilung der 
# Residuen gegeben? (siehe Statistik 2)
# Ja Varianzheterogenität ist gegeben, aber die Verteilung der Residuen folgt 
# einem "Trichter", also keiner "normalen/symmetrischen" Verteilung um 0
# Daher ziehe ich eine Transformation der AV einem nicht-parametrischen Test vor
# für weitere Infos: 
# https://data.library.virginia.edu/interpreting-log-transformations-in-a-linear-model/

# achtung hier log10, bei Rücktransformation achten
model_log <- aov(log10(tot_sold) ~ label_content, data = df) 
par(mfrow = c(2,2))
plot(model_log) # scheint ok zu sein

summary.lm(model_log) # Referenzkategorie ist Fleisch

TukeyHSD(model_log) # (vgl. Statistik 2)

# Achtung Beta-Werte resp. Koeffinzienten sind nicht direkt interpretierbar
# sie müssten zuerst wieder zurück transformiert werden, hier ein Beispiel dafür:
# für Fleisch
10^model_log$coefficients[1]

# für Hot & Cold,
10^(model_log$coefficients[1] + model_log$coefficients[2])

# ist equivalent zu
10^(model_log$coefficients[1]) * 10^(model_log$coefficients[2])

# für Vegi
10^(model_log$coefficients[1] + model_log$coefficients[3])


# plottet die originalen Beobachtungen, die nicht tranformierten Daten werden 
# hier aufgezeigt
# Wichtig: einen Verweis auf die Log-Transformation benötigt es jedoch

# aufbereitung für die Infos der Signifikanzen 
# => Alternative Lösungen findet ihr in der Musterlösung 2.3S

# Multiplikation nur aus dem Grund, weil ich vorher einen anderen Datensatz hatte
df1 <- data.frame(a = c(1, 1:3,3), b = c(150, 151, 151, 151, 150)*15) 
df2 <- data.frame(a = c(1, 1,2, 2), b = c(130, 131, 131, 130)*15)
df3 <- data.frame(a = c(2, 2, 3, 3), b = c(140, 141, 141, 140)*15)


ggplot(df, aes(x = label_content, y= tot_sold)) +
   stat_boxplot(geom = "errorbar", width = .25) +
   geom_boxplot(fill="white", color = "black", size = 1, width = .5) + 
  # aus der Information aus dem Tukey Test von oben: Buffet-Vegetarisch
   geom_line(data = df1, aes(x = a, y = b)) + annotate("text", x = 2, y = 2320, 
                                                       label = "***", size = 8) + 
  # Buffet - Fleisch
   geom_line(data = df2, aes(x = a, y = b)) + annotate("text", x = 1.5, y = 2020, 
                                                       label = "***", size = 8) +
  # Fleisch - Vegetarisch
   geom_line(data = df3, aes(x = a, y = b)) + annotate("text", x = 2.5, y = 2150, 
                                                       label = "***", size = 8)+ 
   expand_limits(y = 0) + # bezieht das 0 bei der y-Achse mit ein
   labs(x = "\nMenüinhalt", y = "Anzahl verkaufte Gerichte\n pro Woche\n") +
   mytheme 

# hier ein paar interessante Links zu anderen R-Packages, die es 
# ermöglichen signifikante Ergebniss in den Plot zu integrieren
# https://www.r-bloggers.com/add-p-values-and-significance-levels-to-ggplots/
# https://cran.r-project.org/web/packages/ggsignif/vignettes/intro.html
  
   



## ladet die nötigen Packete und die novanimal.csv Datei in R
nova <- read_delim("https://zenodo.org/record/3890949/files/2017_ZHAW_individual_menu_sales_NOVANIMAL.csv?download=1", delim = ";")

#if not loaded above, load it here
# ## definiert mytheme für ggplot2 (verwendet dabei theme_classic())
# mytheme <- 
#   theme_classic() + 
#   theme(
#     axis.line = element_line(color = "black"), 
#     axis.text = element_text(size = 12, color = "black"), 
#     axis.title = element_text(size = 12, color = "black"), 
#     axis.ticks = element_line(size = .75, color = "black"), 
#     axis.ticks.length = unit(.5, "cm")
#     )



# klone den originaler Datensatz
df <- nova 

# Daten vorbereiten
df %<>% # schaut euch das Package "magrittr" an
  # ersetze Local mit einem leeren String
  mutate(article_description = str_replace(article_description, "Local ", "")) %>% 
  filter(article_description != "Hot and Cold") %>% # lasse Buffet Gerichte weg
  filter(member != "Spezialkarten") %>% # Spezialkarten können vernachlässigt werden
  #  fasse die zwei Menülinien "World & Favorite" zusammen
  mutate(article_description = str_replace_all(article_description, "Favorite|World",
                                               "Fav_World"))  

# gruppiere Daten nach Menülinie, Geschlecht und Hochschulzugehörigkeit
df %<>%
    group_by(article_description, member, week) %>% 
    summarise(tot_sold = n()) %>%
    ungroup() %>% 
    drop_na()  # lasst die unbekannten Menü-Inhalte weg

# überprüft die Voraussetzungen für eine ANOVA
# Schaut euch die Verteilungen der Mittelwerte der Responsevariable an
# Sind Mittelwerte nahe bei Null? Gäbe uns einen weiteren Hinweis auf 
# eine spezielle Binomial-Verteilung (vgl. Statistik 4)
df %>% 
  split(.$article_description) %>% # teilt den Datensatz in 3 verschiedene Datensätze auf
  # mit map können andere Funktionen auf den Datensatz angewendet werden 
  # (alternative Funktionen sind aggregate oder apply)
  purrr::map(~ psych::describe(.$tot_sold)) 


# visualisiere dir dein Model, was siehst du? 
# sind möglicherweise gewiesse Voraussetzungen verletzt?
# Boxplot
ggplot(df, aes(x = interaction(article_description, member), y= tot_sold)) + 
   # Achtung: Reihenfolge spielt hier eine Rolle!
  stat_boxplot(geom = "errorbar", width = 0.25) +
  geom_boxplot(fill="white", color = "black", size = 1, width = .5) +
  labs(x = "\nMenülinie nach Hochschulzugehörigkeit", y = "Anzahl verkaufte Gerichte\n") + 
  # ändere Gruppennamen händisch
  scale_x_discrete(limits = c("Fav_World.Mitarbeitende", "Kitchen.Mitarbeitende",
                              "Fav_World.Studierende", "Kitchen.Studierende"),
                   breaks = c("Fav_World.Mitarbeitende", "Fav_World.Studierende",
                              "Kitchen.Mitarbeitende",  "Kitchen.Studierende"),
                   labels = c("Fav_World\nMitarbeitende", "Fav_World\nStudierende",
                              "Kitchen\nMitarbeitende",  "Kitchen\nStudierende")) +
  mytheme # wie sind die Voraussetzungen erfüllt?



# definiert das Modell (Skript Statistik 2)
model <- aov(tot_sold ~ article_description * member, data = df)

summary.lm(model)

# überprüft die Modelvoraussetzungen (Statistik 2)
par(mfrow = c(2,2)) # alternativ gäbe es die ggfortify::autoplot(model) funktion
plot(model)


# sieht aus, als ob die Voraussetzungen für eine Anova nur geringfügig verletzt sind
# mögliche alternativen: 
# 0. keine Tranformation der AV (machen wir hier)
# 1. log-transformation um die grossen werte zu minimieren (nur möglich, wenn 
# keine 0 enthalten sind und die Mittelwerte weit von 0 entfernt sind (bei uns wäre dieser Fall erfüllt)
# => bei Zähldaten ist dies leider nicht immer gegeben)
# 2. nicht parametrische Test z.B. Welch-Test, wenn hohe Varianzheterogenität 
# zwischen den Residuen

#0) keine Tranformation
# post-hov Vergleiche
TukeyHSD(model)

#1) Alterativ: log-transformation
model_log <- aov(log10(tot_sold) ~ article_description * member, data = df)

summary.lm(model_log) # interaktion ist nun nicht mehr signifikant: vgl. 
# nochmals euren Boxplot zu beginn, machen diese Koeffizienten sinn?

# überprüft die Modelvoraussetzungen (vgl. Skript Statistik 2)
# bringt aber keine wesentliche Verbesserung, daher bleibe ich bei den 
# untranfromierten Daten
par(mfrow = c(2,2))
plot(model_log)

# post-hov Vergleiche
TukeyHSD(model_log) # gibt sehr ähnliche Resultate im Vergleich zum nicht-transformierten Model



# zeigt die Ergebnisse anhand eines Boxplots
library(multcomp)

# bei Interaktionen gibt es diesen Trick, um bei den multiplen Vergleiche, 
# die richtigen Buchstaben zu bekommen
df$cond_label <- interaction(df$article_description, df$member) #
model1 <- aov(tot_sold ~ cond_label, data = df)
letters <-cld(glht(model1, linfct=mcp(cond_label="Tukey")))

ggplot(df, aes(x = interaction(article_description, member), y= tot_sold)) + 
  stat_boxplot(geom = "errorbar", width = 0.25) + 
  geom_boxplot(fill="white", color = "black", size = .75, width = .5) +
  labs(x = "\nMenülinie nach Hochschulzugehörigkeit", y = "Anzahl verkaufte Gerichte\n") + 
  scale_x_discrete(limits = c("Fav_World.Mitarbeitende", "Kitchen.Mitarbeitende",
                              "Fav_World.Studierende", "Kitchen.Studierende"),
                   breaks = c("Fav_World.Mitarbeitende", "Fav_World.Studierende",
                              "Kitchen.Mitarbeitende",  "Kitchen.Studierende"),
                   labels = c("Fav_World\nMitarbeitende", "Fav_World\nStudierende",
                              "Kitchen\nMitarbeitende",  "Kitchen\nStudierende")) +
  annotate("text", x = 1:4, y = 1000, label = letters$mcletters$Letters, size = 6) +
  mytheme 

ggsave("distill-preview.png",
       height = 12,
       width = 20,
       device = png)

```{.r .distill-force-highlighting-css}
```
