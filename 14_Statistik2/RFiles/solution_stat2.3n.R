## ------------------------------------------------------------------------

kormoran <-read.delim("14_Statistik2/data/kormoran.csv",sep = ";")

## Ueberpruefen, ob Einlesen richtig funktioniert hat und welche Datenstruktur vorliegt
str(kormoran)
summary(kormoran)

#Man erkennt, dass es sich um einen Dataframe mit einer metrischen (Tauchzeit) und zwei kategorialen (Unterart, Jahreszeit) Variablen handelt.
#Die adäquate Analyse (1 metrische Abhängige vs. 2 kategoriale Unabhängige) ist damit eine zweifaktorielle ANOVA
#Die Sortierung der Jahreszeiten (default: alphabetisch) ist inhaltlich aber nicht sinnvoll und sollte angepasst werden.

# Um die Variablen im Dataframe im Folgenden direkt (ohne $ bzw. ohne "data = kormoran") ansprechen zu koennen
attach(kormoran)

# Umsortieren der Faktoren, damit sie in den Boxplots eine sinnvolle Reihung haben
Jahreszeit<-factor(Jahreszeit,levels=c("F","S","H","W"))

# Explorative Datenanalyse (zeigt uns die Gesamtverteilung)
boxplot(Tauchzeit)

#Das ist noch OK für parametrische Verfahren (Box ziemlich symmetrisch um Median, Whisker etwas asymmetrisch aber nicht kritisch). Wegen der leichten Asymmetrie (Linksschiefe) könnte man eine log-Transformation ausprobieren.

boxplot(log10(Tauchzeit))

#Der Gesamtboxplot für log10 sieht perfekt symmetrisch aus, das spräche also für eine log10-Transformation. De facto kommt es aber nicht auf den Gesamtboxplot an, sondern auf die einzelnen.

# Explorative Datenanalyse (Check auf Normalverteilung der Residuen und Varianzhomogenitaet)
boxplot(Tauchzeit~Jahreszeit*Unterart)
boxplot(log10(Tauchzeit)~Jahreszeit*Unterart)

#Hier sieht mal die Verteilung für die untransformierten Daten, mal für die transformierten besser aus. Da die Transformation keine klare Verbesserung bringt, bleiben wir im Folgenden bei den untransformierten Daten, da diese leichter (direkter) interpretiert werden können

# Vollständiges Modell mit Interaktion
aov.1 <- aov(Tauchzeit~Unterart*Jahreszeit)
aov.1
summary(aov.1)
#p-Wert der Interaktion ist 0.266

#Das volle (maximale) Modell zeigt, dass es keine signifikante Interaktion zwischen Jahreszeit und Unterart gibt. Wir können das Modell also vereinfachen, indem wir die Interaktion herausnehmen (+ statt * in der Modellspezifikation)

#Modellvereinfachung
aov.2 <- aov(Tauchzeit~Unterart+Jahreszeit)
aov.2
summary(aov.2)

#Im so vereinfachten Modell sind alle verbleibenden Terme signifikant, wir sind also beim „minimal adäquaten Modell“ angelangt

#Anderer Weg, um zu pruefen, ob man das komplexere Modell mit Interaktion behalten soll
anova(aov.1,aov.2)
#in diesem Fall bekommen wir den gleichen p-Wert wie oben (0.266)

#Modelldiagnostik
par(mfrow=c(2,2)) #alle vier Abbildungen in einem 2 x 2 Raster
plot(aov.2)
influence.measures(aov.2) # kann man sich zusätzlich zum "plot" ansehen, um herauszufinden, ob es evtl. sehr einflussreiche Werte mit Cook's D von 1 oder grösser gibt

#Links oben ist alles bestens, d. h. keine Hinweise auf Varianzheterogenität („Keil“) oder Nichtlinearität („Banane“)
#Rechts oben ganz gut, allerdings weichen Punkte 1 und 20 deutlich von der optimalen Gerade ab -> aus diesem Grund können wir es doch noch mal mit der log10-Transformation versuchen (s.u.)
#Rechts unten: kein Punkt hat einen problematischen Einfluss (die roten Linien für Cook’s D > 0.5 und > 1 sind noch nicht einmal im Bildausschnitt.

#Alternative mit log10
aov.3 <-aov(log10(Tauchzeit)~Unterart+Jahreszeit)
aov.3
summary(aov.3)
plot(aov.3)

#Rechts oben: Punkt 20 jetzt auf der Linie, aber Punkt 1 weicht umso deutlicher ab -> keine Verbesserung -> wir bleiben bei den untransformierten Daten.

#Ergebnisdarstellung

#Da wir keine Interaktion zwischen Unterart und Jahreszeit festgestellt haben, brauchen wir auch keinen Interaktionsplot (unnötig kompliziert), statt dessen können wir die Ergebnisse am besten mit zwei getrennten Plots für die beiden Faktoren darstellen. Bitte die Achsenbeschriftungen und den Tukey post-hoc-Test nicht vergessen.

par(mfrow=c(1,1)) #Zurückschalten auf Einzelplots
if(!require(multcomp)){install.packages("multcomp")} 
library(multcomp)

#letters<-cld(glht(aov.2,linfct=mcp(Unterart="Tukey")))
boxplot(Tauchzeit~Unterart,xlab="Unterart",ylab="Tauchzeit")
#mtext(letters$mcletters$Letters,at=1:2)
#genaugenommen braucht man bei nur zwei Kategorien keinen post hoc-Test

letters<-cld(glht(aov.2,linfct=mcp(Jahreszeit="Tukey")))
boxplot(Tauchzeit~Jahreszeit,xlab="Jahreszeit",ylab="Tauchzeit") #Achsenbeschriftung nicht vergessen!
mtext(letters$mcletters$Letters,at=c(1:4))

#Jetzt brauchen wir noch die Mittelwerte bzw. Effektgroessen

#Für den Ergebnistext brauchen wir auch noch Angaben zu den Effektgrössen. Hier sind zwei Möglichkeiten, um an sie zu gelangen.

summary(lm(Tauchzeit~Jahreszeit))
summary(lm(Tauchzeit~Unterart))

aggregate(kormoran[,1],list(Unterart),mean)
aggregate(kormoran[,1],list(Jahreszeit),mean)


