
# Sprechstunde: 6.11  -  12.10 bis 13.20

library(tidyverse)

### was haben wir gemacht: protokoll

# konflikte mit gewissen packages

# allgemeine tipps mit r umgang und problemlösungen

# wie gehe ich an eine Aufgabe heran: 
# 1) was ist in der aufgabenstellung gegeben 
# 2) daten einlesen 
# 3) überprüfe ob alles richtig eingelesen 
# 4) visualisiere daten 
# 5) generiere model 
# 6) überprüfe modelvoraussetzungen
# 7) passe modell an resp. tranformation oder wende eine andere methode an
# 8) vereinfache modell
# 9) nehme bestes modell (anova oder AICc) > achtung bei anova (müssen modelle genested sein => p-wert) AICc keine p-werte interpretierbar nur aicc oder andere werte nehmen
# 10) text für methoden, ergebnisse (mit abbildung/tabelle oä)


# to dos:
# wieso transformation => und nur AV?
# output von log(AV) interpretieren => exp von dem nehmen?
# error: margins to large
# residuenplot: was genau und was sagt plot aus?

df <- read_delim("14_Statistik2/data/decay.csv", delim = ",")

str(df)


par(mfrow=c(1,1))
plot(amount ~ time, data=df)

model <- lm(amount~time, data = df)

library(ggfortify)
autoplot(model)
par(mfrow = c(2,2)) # error meldung: margins too large
plot(model)


model1 <- lm(log10(amount) ~ time, data = df)

anova(model, model1, test = "Chisq") # kein vergleich möglich

BIC(model)
BIC(model1)


plot(model1)


summary.lm(model1)


