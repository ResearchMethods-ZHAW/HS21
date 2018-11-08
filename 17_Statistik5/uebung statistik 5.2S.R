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

#  sieht euch die Verteilung zwischen Fleisch und  kein Fleisch 
table(df_$meat)

# definiert das logistische Modell mit card_num als random intercept und wendet es auf den Datensatz an
mod0 <- glmer(meat ~ gender + member + age + (1|card_num), data = df_, binomial("logit")) # control = glmerControl(optimizer = "bobyqa") => in case model dont converge
 
# Normalverteilung der Residuen
plot(mod0)

# berechnet den standardfehler 
se <- sqrt(diag(vcov(mod0)))

# zeigt eine Tabelle der Schätzer mit 95% Konfidenzintervall => falls 0 enthalten dann ist der Unterschied statistisch nicht signifikant
tab1 <- cbind(Est = fixef(mod0), LL = fixef(mod0) - 1.96 * se, UL = fixef(mod0) + 1.96 *
    se)

# erzeugt die Odds Ratios
exp(tab)

