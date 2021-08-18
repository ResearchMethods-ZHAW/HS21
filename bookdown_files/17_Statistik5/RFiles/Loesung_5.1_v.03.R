### MSc. Research Methods
### Statistik HS 2020
### Uebung 5.1 - Split-plot ANOVA
### - Juergen Dengler -

splityield <- read.delim("17_Statistik5/data/splityield.csv", sep=",", stringsAsFactors = T)

#Checken der eingelesenen Daten
splityield
str(splityield)
summary(splityield)
levels(splityield$density) <- c("low", "medium", "high")


#Explorative Datenanalyse (auf Normalverteilung, Varianzhomogenitaet)
boxplot(splityield$yield)
boxplot(yield~fertilizer, data = splityield)
boxplot(yield~irrigation, data = splityield)
boxplot(yield~density, data = splityield)
boxplot(yield~irrigation*density*fertilizer, data = splityield)

boxplot(log10(yield)~irrigation*density*fertilizer, data = splityield) #bringt keine Verbesserung

aov.1<-aov(yield~irrigation*density*fertilizer+Error(block/irrigation/density), data = splityield)
summary(aov.1)

#zum Vergleich das ANOVA-Modell komplett ohne blockfoermige Anordnung
#aov.2<-aov(yield~irrigation*density*fertilizer)
#summary(aov.2)

#Visualisierung der Ergebnisse
boxplot(yield~fertilizer,data = splityield)
boxplot(yield~irrigation,data = splityield)
interaction.plot(splityield$fertilizer, splityield$irrigation, splityield$yield)
interaction.plot(splityield$density, splityield$irrigation, splityield$yield)
