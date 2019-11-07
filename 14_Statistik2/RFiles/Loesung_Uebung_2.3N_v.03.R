### MSc. Research Methods
### Statistik HS 2019
### Übung 2.3N - Mehrfaktorielle ANOVA
### - Jürgen Dengler, 04.11.2019 -

setwd("S:/pools/n/N-zen_naturmanag_lsfm/FS_Vegetationsanalyse/Lehre (Module)/MSc. Research Methods/Statistik Dengler 2019/DataSets") # Beispiel Pfad muss angepasst werden
kormoran <-read.delim("kormoran.csv", sep = ";")

## Überprüfen, ob Einlesen richtig funktioniert hat und welche Datenstruktur vorliegt
str(kormoran)
summary(kormoran)

#Um die Variablen im Dataframe im Folgenden direkt (ohne $ bzw. ohne "data = kormoran") ansprechen zu können
attach(kormoran)

#Umsortieren der Faktoren, damit sie in den Boxplots eine sinnvolle Reihung haben
Jahreszeit<-factor(Jahreszeit,levels=c("F","S","H","W"))

#Explorative Datenanalyse (zeigt uns die Gesamtverteilung)
boxplot(Tauchzeit)
boxplot(log10(Tauchzeit))

#Explorative Datenanalyse (Check auf Normalverteilung der Residuen und Varianzhomogenität)
boxplot(Tauchzeit~Jahreszeit*Unterart)
boxplot(log10(Tauchzeit)~Jahreszeit*Unterart)

#Vollständiges Modell mit Interaktion
aov.1 <- aov(Tauchzeit~Unterart*Jahreszeit)
aov.1
summary(aov.1)
#p-Wert der Interaktion ist 0.266

#Modellvereinfachung
aov.2 <- aov(Tauchzeit~Unterart+Jahreszeit)
aov.2
summary(aov.2)

#Anderer Weg, um zu prüfen, ob man das komplexere Modell mit Interaktion behalten soll
anova(aov.1,aov.2)
#in diesem Fall bekommen wir den gleichen p-Wert wie oben (0.266)

#Modelldiagnostik
par(mfrow=c(2,2)) #alle vier Abbildungen in einem 2 x 2 Raster
plot(aov.2)
influence.measures(aov.2) # kann man sich zusätzlich zum "plot" ansehen, um herauszufinden, ob es evtl. sehr einflussreiche Werte mit Cook's D von 1 oder grÃ¶sser gibt

#Alternative mit log10
aov.3 <-aov(log10(Tauchzeit)~Unterart+Jahreszeit)
aov.3
summary(aov.3)
plot(aov.3)

#Ergebnisdarstellung
par(mfrow=c(1,1)) #Zurückschalten auf Einzelplots
if(!require(multcomp)){install.packages("multcomp")} 
library(multcomp)

letters<-cld(glht(aov.2,linfct=mcp(Unterart="Tukey")))
boxplot(Tauchzeit~Unterart,xlab="Unterart",ylab="Tauchzeit")
mtext(letters$mcletters$Letters,at=1:2)
#genaugenommen braucht man bei nur zwei Kategorien keinen post hoc-Test

letters<-cld(glht(aov.2,linfct=mcp(Jahreszeit="Tukey")))
boxplot(Tauchzeit~Jahreszeit,xlab="Jahreszeit",ylab="Tauchzeit") #Achsenbeschriftung nicht vergessen!
mtext(letters$mcletters$Letters,at=c(1:4))

#Jetzt brauchen wir noch die Mittelwerte bzw. Effektgrössen
aggregate(Tauchzeit~Jahreszeit, FUN=mean)
aggregate(Tauchzeit~Unterart, FUN=mean)

summary(lm(Tauchzeit~Jahreszeit))
summary(lm(Tauchzeit~Unterart))