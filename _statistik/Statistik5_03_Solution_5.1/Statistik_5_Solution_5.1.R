splityield <- read.delim("splityield.csv", sep = ",", stringsAsFactors = T)
# Checken der eingelesenen Daten
splityield

str(splityield)
summary(splityield)
splityield$density <- ordered(splityield$density, levels = c("low", "medium", "high"))
splityield$density

# Explorative Datenanalyse (auf Normalverteilung, Varianzhomogenität)
boxplot(yield~fertilizer, data = splityield)
boxplot(yield~irrigation, data = splityield)
boxplot(yield~density, data = splityield)
boxplot(yield~irrigation * density * fertilizer, data = splityield)

boxplot(log10(yield)~irrigation * density * fertilizer, data = splityield)# bringt keine Verbesserung
aov.1 <- aov(yield~irrigation * density * fertilizer + Error(block/irrigation/density), data = splityield)

summary(aov.1)

# Modelvereinfachung
aov.2 <- aov(yield ~ irrigation + density + fertilizer + irrigation:density + 
               irrigation:fertilizer + density:fertilizer + Error(block/irrigation/density), data = splityield)
summary(aov.2)


aov.3 <- aov(yield ~ irrigation + density + fertilizer + irrigation:density + 
               irrigation:fertilizer+ Error(block/irrigation/density), data = splityield)
summary(aov.3)

# Visualisierung der Ergebnisse
boxplot(yield~fertilizer, data = splityield)
boxplot(yield~irrigation, data = splityield)

interaction.plot(splityield$fertilizer, splityield$irrigation, splityield$yield, 
                 xlab= "fertilizer", ylab = "mean of splityield", trace.label = "irrigation")
interaction.plot(splityield$density, splityield$irrigation, splityield$yield, 
                 xlab= "fertilizer", ylab = "mean of splityield", trace.label = "irrigation")
```{.r .distill-force-highlighting-css}
```
