## ------------------------------------------------------------------------
splityield <-read.csv("17_Statistik5/data/splityield.csv")
attach(splityield)

#Checken der eingelesenen Daten
splityield


## ------------------------------------------------------------------------
str(splityield)
summary(splityield)


## ------------------------------------------------------------------------
#Explorative Datenanalyse (auf Normalverteilung, Varianzhomogenität)
boxplot(yield)
boxplot(yield~fertilizer)
boxplot(yield~irrigation)
boxplot(yield~density)
boxplot(yield~irrigation*density*fertilizer)


## ------------------------------------------------------------------------
boxplot(log10(yield)~irrigation*density*fertilizer) #bringt keine Verbesserung
model<-aov(yield~irrigation*density*fertilizer+Error(block/irrigation/density))


## ------------------------------------------------------------------------
summary(model)


## ------------------------------------------------------------------------
#Visualisierung der Ergebnisse
boxplot(yield~fertilizer)
boxplot(yield~irrigation)

interaction.plot(fertilizer,irrigation,yield)

interaction.plot(density,irrigation,yield)

