knitr::opts_chunk$set(results = "hide", fig.width = 20, fig.height = 12, warning = F, message = F, fig.pos = 'H')

# Aus der Excel-Tabelle wurde das relevante Arbeitsblatt als csv gespeichert
ukraine <-read.delim("15_Statistik3/data/Ukraine_bearbeitet.csv",sep=";")
attach(ukraine)

ukraine
str(ukraine)
summary(ukraine)

#Explorative Datenanalyse der abhängigen Variablen
boxplot(Species.richness)

cor <- cor(ukraine[,3:23])
cor
cor[abs(cor)<0.7] <- 0
cor

summary(ukraine$Sand)
ukraine[!complete.cases(ukraine), ] # Zeigt zeilen mit NAs ein

cor <- cor(ukraine[,c(3:11,15:23)])
cor[abs(cor)<0.7] <- 0
cor

cor <- cor(ukraine[,c(3:11,15:23)])
cor[abs(cor)<0.6] <- 0
cor

global.model <- lm (Species.richness ~
Inclination+Heat.index+Microrelief+Grazing.intensity+Litter+
Stones.and.rocks+Gravel+Fine.soil+pH+CaCO3+C.org+CN.ratio+Temperature)

#Multimodel inference
if(!require(MuMIn)){install.packages("MuMIn")}
library(MuMIn)
options(na.action="na.fail")
allmodels<-dredge(global.model)
allmodels

#Importance values der Variablen
importance(allmodels)

#Modelaveraging (Achtung: dauert mit 13 Variablen einige Minuten)
summary(model.avg(get.models(dredge(global.model,rank="AICc"),subset
=TRUE)))

#Modelldiagnostik nicht vergessen
par(mfrow=c(2,2))
plot(global.model)
plot(lm(Species.richness~Heat.index+Litter+CaCO3+CN.ratio+Grazing.intensity))
