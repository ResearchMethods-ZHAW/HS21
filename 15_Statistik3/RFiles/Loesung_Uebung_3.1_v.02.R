### MSc. Research Methods
### Statistik HS 2019
### Übung 3.1 - Multiple Regression
### - Jürgen Dengler -

setwd("S:/pools/n/N-zen_naturmanag_lsfm/FS_Vegetationsanalyse/Lehre (Module)/MSc. Research Methods/Statistik Dengler 2019/DataSets")

ukraine <-read.delim("ukraine_bearbeitet.csv",sep=";")
attach(ukraine)

ukraine
str(ukraine)
summary(ukraine)

#Explorative Datenanalyse der abhängigen Variablen
boxplot(Species.richness)

#Korrelationsanalyse
cor <- cor(ukraine[,3:23])
cor
cor[abs(cor)<0.7] <- 0
cor

summary(ukraine$Sand)
ukraine[!complete.cases(ukraine), ] #Zeigt zeilen mit NAs ein


cor <- cor(ukraine[,c(3:11,15:23)])
cor[abs(cor)<0.7] <- 0
cor

cor <- cor(ukraine[,c(3:11,15:23)])
cor[abs(cor)<0.6] <- 0
cor

write.table(x=(cor), file="Corrleation.csv", sep=";", dec=".",  row.names=TRUE, col.names=TRUE, quote=TRUE)


global.model <- lm(Species.richness ~ Inclination+Heat.index+Microrelief+Grazing.intensity+
                    Litter+Stones.and.rocks+Gravel+Fine.soil+pH+CaCO3+C.org+CN.ratio+Temperature)

summary(global.model)


#Multimodel inference
if(!require(MuMIn)){install.packages("MuMIn")}
library(MuMIn)

options(na.action="na.fail")
allmodels<-dredge(global.model)
allmodels

#Importance values der Variablen
importance(allmodels)

#Modelaveraging (Achtung: dauert mit 13 Variablen einige Minuten)
summary(model.avg(get.models(dredge(global.model,rank="AICc"),subset=TRUE)))

#Modelldiagnostik nicht vergessen
par(mfrow=c(2,2))
plot(global.model)
plot(lm(Species.richness~Heat.index+Litter+CaCO3+CN.ratio+Grazing.intensity))

summary(global.model)
