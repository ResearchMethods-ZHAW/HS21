## ---- message=FALSE, echo=FALSE, results='hide', warning=FALSE----

library(tidyverse)


## ladet die nötigen Packete und die novanimal.csv Datei in R
nova <- read_delim("13_Statistik1/data/2017_ZHAW_individual_menu_sales_NOVANIMAL.csv", delim = ";")

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
# klone den originaler Datensatz
df <- nova 

# Daten vorbereiten
df %<>% # schaut euch das Package "magrittr" an
  mutate(article_description = str_replace(article_description, "Local ", "")) %>% # ersetze Local mit einem leeren String
  filter(article_description != "Hot and Cold") %>% # lasse Buffet Gerichte weg
  filter(member != "Spezialkarten") %>% # Spezialkarten können vernachlässigt werden
  mutate(article_description = str_replace_all(article_description, "Favorite|World", "Fav_World")) #  fasse die zwei Menülinien "World & Favorite" zusammen

# gruppiere Daten nach Menülinie, Geschlecht und Hochschulzugehörigkeit
df %<>%
    group_by(article_description, member, week) %>% 
    summarise(tot_sold = n()) %>%
    drop_na()  # lasst die unbekannten Menü-Inhalte weg

# überprüft die Voraussetzungen für eine ANOVA
# Schaut euch die Verteilungen der Mittelwerte der Responsevariable an
# Sind Mittelwerte nahe bei Null? Gäbe uns einen weiteren Hinweis auf eine spezielle Binomail-Verteilung (vgl. Statistik 4, Folie 17)
df %>% 
  split(.$article_description) %>% # teilt den Datensatz in 3 verschiedene Datensätze auf
  purrr::map(~ psych::describe(.$tot_sold)) # mit map können andere Funktionen auf den Datensatz angewendet werden (alternative Funktionen sind aggregate oder apply)


# visualisiere dir dein Model, was siehst du? sind möglicherweise gewiesse Voraussetzungen verletzt?
# Boxplot
ggplot(df, aes(x = interaction(article_description, member), y= tot_sold)) + 
  stat_boxplot(geom = "errorbar", width = 0.25) + # Achtung: Reihenfolge spielt hier eine Rolle!
  geom_boxplot(fill="white", color = "black", size = 1, width = .5) +
  labs(x = "\nMenülinie nach Hochschulzugehörigkeit", y = "Anzahl verkaufte Gerichte\n") + 
  scale_x_discrete(limits = c("Fav_World.Mitarbeitende", "Kitchen.Mitarbeitende", "Fav_World.Studierende", "Kitchen.Studierende"),
                   breaks = c("Fav_World.Mitarbeitende", "Fav_World.Studierende", "Kitchen.Mitarbeitende",  "Kitchen.Studierende"),
                   labels = c("Fav_World\nMitarbeitende", "Fav_World\nStudierende", "Kitchen\nMitarbeitende",  "Kitchen\nStudierende")) +
  mytheme # wie sind die Voraussetzungen erfüllt?


# definiert das Modell (Statistik 2: Folien 4-8)
model <- aov(tot_sold ~ article_description * member, data = df)

summary.lm(model)

# überprüft die Modelvoraussetzungen (Statistik 2: Folien X-Y)
par(mfrow = c(2,2)) # alternativ gäbe es die ggfortify::autoplot(model) funktion
plot(model)




## -------------------------------
# sieht aus, als ob die Voraussetzungen für eine Anova nur geringfügig verletzt sind
# mögliche alternativen: 
# 1. log-transformation um die grossen werte zu minimieren (nur möglich, wenn keine 0 enthalten sind und die Mittelwerte weit von 0 entfernt sind => bei Zähldaten ist dies leider nicht immer gegeben)
# 2. nicht parametrische Test z.B. Welch-Test, da hohe Varianzheterogenität zwischen den Residuen


#1) log-transformation
model_log <- aov(log10(tot_sold) ~ article_description * member, data = df)

summary.lm(model_log) # interaktion ist nun nicht mehr signifikant: vgl. nochmals euren Boxplot zu beginn, machen diese Koeffizienten sinn?

# überprüft die Modelvoraussetzungen (vgl. Skript Statistik 2)
# bringt aber keine wesentliche Verbesserung, daher bleibe ich bei den untranfromierten Daten
par(mfrow = c(2,2))
plot(model_log)

# post-hov Vergleiche
TukeyHSD(model)



## ---- echo=F, fig.cap="Box-Whisker-Plots der wöchentlichen Verkaufszahlen pro Menü-Inhalte. Kleinbuchstaben bezeichnen homogene Gruppen auf *p* < .05 nach Tukeys post-hoc-Test."----

# zeigt die Ergebnisse anhand eines Boxplots
library(multcomp)
df$cond_label <- interaction(df$article_description, df$member) # bei Interaktionen gibt es diesen Trick, um bei den multiplen Vergleiche, die richtigen Buchstaben zu bekommen
model1 <- aov(tot_sold ~ cond_label, data = df)
letters <-cld(glht(model1, linfct=mcp(cond_label="Tukey")))

ggplot(df, aes(x = interaction(article_description, member), y= tot_sold)) + 
  stat_boxplot(geom = "errorbar", width = 0.25) + # Achtung: Reihenfolge spielt hier eine Rolle!
  geom_boxplot(fill="white", color = "black", size = 1, width = .5) +
  labs(x = "\nMenülinie nach Hochschulzugehörigkeit", y = "Anzahl verkaufte Gerichte\n") + 
  scale_x_discrete(limits = c("Fav_World.Mitarbeitende", "Kitchen.Mitarbeitende", "Fav_World.Studierende", "Kitchen.Studierende"),
                   breaks = c("Fav_World.Mitarbeitende", "Fav_World.Studierende", "Kitchen.Mitarbeitende",  "Kitchen.Studierende"),
                   labels = c("Fav_World\nMitarbeitende", "Fav_World\nStudierende", "Kitchen\nMitarbeitende",  "Kitchen\nStudierende")) +
  annotate("text", x = 1:4, y = 1000, label = letters$mcletters$Letters, size = 8) +
  mytheme 

ggsave("plot1_solution2.3s.pdf",
       height = 12,
       width = 20,
       device = cairo_pdf)


