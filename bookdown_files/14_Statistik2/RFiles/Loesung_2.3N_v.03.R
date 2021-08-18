# Musterloesung Uebung 2.3N - Mehrfaktorielle ANOVA

kormoran <- read.delim("kormoran.csv", sep = ";", stringsAsFactors = T)  #Working directory muss angepasst werden

## Überprüfen, ob Einlesen richtig funktioniert hat und welche Datenstruktur vorliegt
str(kormoran)
summary(kormoran)

#Umsortieren der Faktoren, damit sie in den Boxplots eine sinnvolle Reihung haben
levels(kormoran$Jahreszeit) <- c("F","S","H","W")

#Explorative Datenanalyse (zeigt uns die Gesamtverteilung)
boxplot(kormoran$Tauchzeit)
boxplot(log10(kormoran$Tauchzeit))

#Explorative Datenanalyse (Check auf Normalverteilung der Residuen und Varianzhomogenität)
boxplot(Tauchzeit~Jahreszeit*Unterart, data = kormoran)
boxplot(log10(Tauchzeit)~Jahreszeit*Unterart, data = kormoran)

#Vollständiges Modell mit Interaktion
aov.1 <- aov(Tauchzeit~Unterart*Jahreszeit, data = kormoran)
aov.1
summary(aov.1)
#p-Wert der Interaktion ist 0.266

#Modellvereinfachung
aov.2 <- aov(Tauchzeit~Unterart+Jahreszeit, data = kormoran)
aov.2
summary(aov.2)

#Anderer Weg, um zu prüfen, ob man das komplexere Modell mit Interaktion behalten soll
anova(aov.1, aov.2)
#in diesem Fall bekommen wir den gleichen p-Wert wie oben (0.266)

#Modelldiagnostik
par(mfrow=c(2,2)) #alle vier Abbildungen in einem 2 x 2 Raster
plot(aov.2)
influence.measures(aov.2) # kann man sich zusätzlich zum "plot" ansehen, um herauszufinden, ob es evtl. sehr einflussreiche Werte mit Cook's D von 1 oder grÃ¶sser gibt

#Alternative mit log10
aov.3 <-aov(log10(Tauchzeit)~Unterart+Jahreszeit, data=kormoran)
aov.3
summary(aov.3)
plot(aov.3)

#Ergebnisdarstellung
par(mfrow=c(1,1)) #Zurückschalten auf Einzelplots
if(!require(multcomp)){install.packages("multcomp")} 
library(multcomp)

boxplot(Tauchzeit~Unterart, xlab="Unterart", ylab="Tauchzeit", data=kormoran)
letters<-cld(glht(aov.2, linfct=mcp(Unterart="Tukey")))
mtext(letters$mcletters$Letters,at=1:2)
#genaugenommen braucht man bei nur zwei Kategorien keinen post hoc-Test

letters<-cld(glht(aov.2, linfct=mcp(Jahreszeit="Tukey")))
boxplot(Tauchzeit~Jahreszeit, xlab="Jahreszeit", ylab="Tauchzeit", data=kormoran) #Achsenbeschriftung nicht vergessen!

#Jetzt brauchen wir noch die Mittelwerte bzw. Effektgrössen
aggregate(Tauchzeit~Jahreszeit, FUN=mean, data=kormoran)
aggregate(Tauchzeit~Unterart, FUN=mean, data=kormoran)

summary(lm(Tauchzeit~Jahreszeit, data=kormoran))
summary(lm(Tauchzeit~Unterart, data=kormoran))