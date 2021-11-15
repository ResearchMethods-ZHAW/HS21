# Aus der Excel-Tabelle wurde das relevante Arbeitsblatt als csv gespeichert
ukraine <- read.delim("Ukraine_bearbeitet.csv", sep=";")

ukraine

str(ukraine)
summary(ukraine)

#Explorative Datenanalyse der abhängigen Variablen
boxplot(ukraine$Species_richness)

cor <- cor(ukraine[,3:23])
cor
cor[abs(cor)<0.7] <- 0
cor

summary(ukraine$Sand)
ukraine[!complete.cases(ukraine), ] # Zeigt zeilen mit NAs ein

cor <- cor(ukraine[, c(3:11, 15:23)])
cor[abs(cor)<0.7] <- 0
cor

cor <- cor(ukraine[,c(3:11, 15:23)])
cor[abs(cor)<0.6] <- 0
cor

write.table(cor, file = "Corrleation.csv", sep = ";", dec = ".", col.names = NA)

global.model <- lm(Species_richness ~ Inclination + Heat_index + Microrelief + Grazing_intensity +
                    Litter + Stones_and_rocks + Gravel + Fine_soil + pH + CaCO3 + C_org + CN_ratio + Temperature, data = ukraine)


# Multimodel inference
if(!require(MuMIn)){install.packages("MuMIn")}
library(MuMIn)

options(na.action = "na.fail")
allmodels <- dredge(global.model)

allmodels

# Importance values der Variablen
importance(allmodels)

# Modelaveraging (Achtung: dauert mit 13 Variablen einige Minuten)
summary(model.avg(allmodels, rank = "AICc"), subset = TRUE)

# Modelldiagnostik nicht vergessen
par(mfrow = c(2, 2))
plot(global.model)
plot(lm(Species_richness ~ Heat_index + Litter + CaCO3 + CN_ratio + Grazing_intensity, data = ukraine))

summary(global.model)
```{.r .distill-force-highlighting-css}
```
