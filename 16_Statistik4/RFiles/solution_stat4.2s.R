## ---- message=FALSE, echo=FALSE, results='hide', warning=FALSE-----------

library(tidyverse)
library(ggfortify)

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

#  sieht euch die Verteilung zwischen Fleisch und  kein Fleisch 
table(df_$meat)

# definiert das logistische Modell und wende es auf den Datensatz an
# modell nicht signifikant, rechnen mal trotzdem weiter
  mod0 <- glm(meat ~ gender + member + age, data = df_, binomial("logit"))
summary.lm(mod0) # Member  und Alter scheinen keinen Einfluss zu nehmen, lassen wir also weg

# neues Modell ohne Alter und Hochschulzugehörigkeit
mod1 <- update(mod0, ~. -member - age)
summary.lm(mod1)

# Modeldiagnostik (wenn nicht signifikant, dann OK)
1 - pchisq(mod1$deviance, mod1$df.resid) # hochsignifikant, d.h. kein gutes Modell

#Modellgüte (pseudo-R²)
1 - (mod1$dev / mod1$null) # sehr kleines pseudo-R²


# Konfusionsmatrix vom  Datensatz
# Model Vorhersage
# hier ein anderes Beispiel: 
predicted <- predict(mod1, df_, type = "response")

# erzeugt eine Tabelle mit den beobachteten
# Fleischesser/Nichtleischesser und den Vorhersagen des Modells
km <- table(df_$meat, predicted > 0.5)
dimnames(km) <- list(
  c("Beobachtung kein Fleisch", "Beobachtung Fleisch"),
  c("Modell kein Fleisch", "Modell Fleisch"))
km

# kalkuliert die Missklassifizierungsrate 
mf <- 1-sum(diag(km)/sum(km)) # ist mit knapp 40% eher hoch
mf



