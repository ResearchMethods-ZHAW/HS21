### MSc. Research Methods
### Lösung Beispielaufgabe

decay <- read.delim("decay.csv", sep = ",")
decay

summary(decay)
str(decay)

# Explorative Datenanalyse
boxplot(decay$time)
boxplot(decay$amount)
plot(amount~time, data=decay)

# Einfaches lineares Modell
lm.1 <- lm(amount~time, data=decay)
summary(lm.1)
 
# Modelldiagnostik
par(mfrow=c(2,2))
plot(lm.1)

# Ergebnisplot
par(mfrow=c(1,1))
plot(decay$time, decay$amount)
abline(lm.1, col="red")


# Lösung 1: log-Transformation der abhängigen Variablen
par(mfrow=c(1,2))
boxplot(decay$amount)
boxplot(log(decay$amount))
hist(decay$amount)
hist(log(decay$amount))

lm.2 <- lm(log(amount)~time, data=decay)
summary(lm.2)

# Modelldiagnostik
par(mfrow=c(2,2))
plot(lm.2)

# Lösungen 2 und 3 greifen auf Methoden von Statistik 3 und 4 zurück, sie sind hier nur zum Vergleich angeführt

# Lösung 2: quadratische Regression (kam erst in Statistik 3; könnte für die Datenverteilung passen, 
# entspricht aber nicht der physikalischen Gesetzm?ssigkeit)
model.quad<-lm(amount~time+I(time^2), data=decay)
summary(model.quad)

# Vergleich mit dem einfachen Modell mittels ANOVA (es ginge auch AICc)
anova(lm.1, model.quad)

# Modelldiagnostik
par(mfrow=c(2,2))
plot(model.quad)

# Lösung 3 (kam erst in Statistik 4; methodisch beste L?sung;
# mit Startwerten muss man ggf. ausprobieren)
model.nls <- nls(amount~a*exp(-b*time), start=(list(a=100,b=1)),data=decay)
summary(model.nls)

# Modelldiagnostik
if(!require(nlstools)){install.packages("nlstools")}
library(nlstools)
residuals.nls <- nlsResiduals(model.nls)
plot(residuals.nls)

# Ergebnisplots
par(mfrow=c(1,1))
xv<-seq(0,30,0.1)

# 1. lineares Modell mit log-transformierter Abh?ngiger
plot(decay$time, decay$amount)
yv1 <- exp(predict(lm.2, list(time=xv)))
lines(xv, yv1, col="red")

# 2. quadratisches Modell
plot(decay$time, decay$amount)
yv2 <- predict(model.quad, list(time=xv))
lines(xv, yv2, col="blue")

# 3. nicht-lineares Modell
plot(decay$time, decay$amount)
yv3 <- predict(model.nls, list(time=xv))
lines(xv, yv3, col="green")

