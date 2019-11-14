### MSc. Research Methods
### Statistik HS 2019
### Übung 5.1 - Split-plot ANOVA
### - Jürgen Dengler -

setwd("S:/pools/n/N-zen_naturmanag_lsfm/FS_Vegetationsanalyse/Lehre (Module)/MSc. Research Methods/Statistik Dengler 2019/DataSets")
splityield <-read.delim("splityield.csv", sep=",")

#Checken der eingelesenen Daten
splityield
str(splityield)
summary(splityield)

#Explorative Datenanalyse (auf Normalverteilung, Varianzhomogenität)
boxplot(splityield$yield)
boxplot(yield~fertilizer, data=splityield)
boxplot(yield~irrigation, data=splityield)
boxplot(yield~density, data=splityield)
boxplot(yield~irrigation*density*fertilizer,data=splityield)

boxplot(log10(yield)~irrigation*density*fertilizer,data=splityield) #bringt keine Verbesserung

aov.1<-aov(yield~irrigation*density*fertilizer+Error(block/irrigation/density),data=splityield)
summary(aov.1)

#zum Vergleich das ANOVA-Modell komplett ohne blockförmige Anordnung
#aov.2<-aov(yield~irrigation*density*fertilizer)
#summary(aov.2)

#Visualisierung der Ergebnisse
boxplot(yield~fertilizer,data=splityield)
boxplot(yield~irrigation,data=splityield)
interaction.plot(splityield$fertilizer,splityield$irrigation,splityield$yield)
interaction.plot(splityield$density,splityield$irrigation,splityield$yield)
