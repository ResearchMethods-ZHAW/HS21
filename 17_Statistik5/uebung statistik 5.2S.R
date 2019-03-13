# Skript Musterlösung Übung 5.2S
# 19.11.18 (egeler)

## ---- message=FALSE, echo=FALSE, results='hide', warning=FALSE-----------

library(tidyverse)
library(ggfortify)
library(lme4)

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

# Genereiert eine Dummyvariable: Fleisch 1, kein Fleisch 0
df <- nova # kopiert originaler Datensatz
df$meat <- ifelse(nova$label_content == "Fleisch", 1, 0)
df_ <- df[df$label_content != "Buffet", ] # entfernt Personen die sich ein Buffet Teller gekauft haben und speichert es in eine neuen Datensatz

# Löscht alle Missings bei der Variable "Fleisch"
df_ <- df_[!is.na(df_$meat), ]

# setzt andere Reihenfolge für die Hochschulzugehörigkeit
df_$member <- factor(df_$member, levels = c("Studierende", "Mitarbeitende"))

#  sieht euch die Verteilung zwischen Fleisch und  kein Fleisch an
table(df_$meat)

# definiert das logistische Modell mit card_num als random intercept und wendet es auf den Datensatz an
mod0 <- glmer(meat ~ gender + member + age + (1|card_num), data = df_, binomial("logit")) 
summary(mod0)
 
# Pseudo R^2
library(MuMIn)
r.squaredGLMM(mod0) 
# das marginale R^2 gibt uns die erklärte Varianz der fixen Effekte
# das conditionale R^2 gibt uns die erklärte Varianz für das ganze Modell (mit fixen und variablen Effekten)
# für weitere Informationen: https://rdrr.io/cran/MuMIn/man/r.squaredGLMM.html 

# zusätzliche Informationen, welche für die Interpretation gut sein kann
# berechnet den Standardfehler 
se <- sqrt(diag(vcov(mod0)))

# zeigt eine Tabelle der Schätzer mit 95% Konfidenzintervall => falls 0 enthalten dann ist der Unterschied statistisch nicht signifikant
tab1 <- cbind(Est = fixef(mod0), LL = fixef(mod0) - 1.96 * se, UL = fixef(mod0) + 1.96 *
    se)

# erzeugt die Odds Ratios
exp(tab1)

## ---- message=F, echo=F--------------------------------------------------

rownames(tab1) <- c("Intercept", "Geschlecht (Mann)", "Hochschulzugehörigkeit (Mitarbeitende)", "Alter") # change rownames
knitr::kable(tab1, caption = "Modellschätzer und das dazugehörige 95% Konfidenzintervall", digits = 2) 


## ---- message=F, echo=F--------------------------------------------------
a <- exp(tab1) # matrix of odd ratios and CI
rownames(a) <- c("Intercept", "Geschlecht (Mann)", "Hochschulzugehörigkeit (Mitarbeitende)", "Alter") # change rownames
knitr::kable(a, caption = "Odds Ratios und das dazugehörige 95% Konfidenzintervall", digits = 2)

