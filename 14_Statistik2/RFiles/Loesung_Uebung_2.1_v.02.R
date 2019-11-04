### MSc. Research Methods
### Statistik HS 2019
### Übung 2.1 - Regressionsanalyse
### - Jürgen Dengler, 31.10.2019 -
setwd("S:/pools/n/N-zen_naturmanag_lsfm/FS_Vegetationsanalyse/Lehre (Module)/MSc. Research Methods/Statstik Dengler 2019/Ueberarbeitungsprozess/DataSets")


decay <-read.csv("decay.csv")
decay

# Um die Variablen im Dataframe im Folgenden direkt (ohne $ bzw. ohne "data = data") ansprechen zu können
attach(decay)
summary(decay)
str(decay)

# Explorative Datenanalyse
boxplot(time)
boxplot(amount)
plot(amount~time)

# Einfaches lineares Modell
lm.1<-lm(amount~time)
summary(lm.1)
 
# Modelldiagnostik
par(mfrow=c(2,2))
plot(lm.1)

# Ergebnisplot
par(mfrow=c(1,1))
plot(time,amount)
abline(lm(amount~time),col="red")
abline(lm.1,col="red")


# Lösung 1: log-Transformation der abhängigen Variablen
par(mfrow=c(1,2))
boxplot(amount)
boxplot(log(amount))
hist(amount)
hist(log(amount))

lm.2<-lm(log(amount)~time)
summary(lm.2)

# Modelldiagnostik
par(mfrow=c(2,2))
plot(lm.2)

# Lösungen 2 und 3 greifen auf Methoden von Statistik 3 und 4 zurück, sie sind hier nur zum Vergleich angeführt

# Lösung 2: quadratische Regression (kam erst in Statistik 3; könnte für die Datenverteilung passen, 
# entspricht aber nicht der physikalischen Gesetzmässigkeit)
model.quad<-lm(amount~time+I(time^2))
summary(model.quad)

# Vergleich mit dem einfachen Modell mittels ANOVA (es ginge auch AICc)
anova(lm.1,model.quad)

# Modelldiagnostik
par(mfrow=c(2,2))
plot(model.quad)

# Lösung 3 (kam erst in Statistik 4; methodisch beste Lösung;
# mit Startwerten muss man ggf. ausprobieren)
model.nls<-nls(amount~a*exp(-b*time),start=(list(a=100,b=1)))
summary(model.nls)

# Modelldiagnostik
if(!require(nlstools)){install.packages("nlstools")}
library(nlstools)
residuals.nls <- nlsResiduals(model.nls)
plot(residuals.nls)

# Ergebnisplots
par(mfrow=c(1,1))
xv<-seq(0,30,0.1)

# 1. lineares Modell mit log-transformierter Abhängiger
plot(time,amount)
yv1<-exp(predict(lm.2,list(time=xv)))
lines(xv,yv1,col="red")

# 2. quadratisches Modell
plot(time,amount)
yv2<-predict(model.quad,list(time=xv))
lines(xv,yv2,col="blue")

# 3. nicht-lineares Modell
plot(time,amount)
yv3<-predict(model.nls,list(time=xv))
lines(xv,yv3,col="green")
