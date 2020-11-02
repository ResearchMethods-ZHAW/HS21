### MSc. Research Methods
### Musterloesung 2.1 - Regressionsanalyse
### - Jürgen Dengler, 25.10.2020

SAR <- read.delim("SAR.csv",sep = ";")
SAR

# Explorative Datenanalyse
summary(SAR)
boxplot(SAR$area)
boxplot(SAR$richness)
plot(richness~area,data=SAR)

# Einfaches lineares Modell
lm.1 <- lm(richness~area,data=SAR)
summary(lm.1)
 
# Modelldiagnostik
par(mfrow=c(2,2))
plot(lm.1)

# Ergebnisplot
par(mfrow=c(1,1))
plot(SAR$area, SAR$richness, xlab="Area [m²]", ylab="Species richness")
abline(lm(richness~area, data=SAR), col="red") #Alternative 1
abline(lm.1,col="red") #Alternative 2


# Lösung A: log-Transformation der abhängigen Variablen
par(mfrow=c(1,2))
boxplot(SAR$richness)
boxplot(log10(SAR$richness))
hist(SAR$richness)
hist(log10(SAR$richness))

SAR$log_richness<-log10(SAR$richness)
lm.2 <- lm(log_richness~area, data=SAR)
summary(lm.2)

# Modelldiagnostik
par(mfrow=c(2,2))
plot(lm.2)
#sieht noch schlechter aus

# Lösung B: log-Transformation beider Variablen
par(mfrow=c(1,2))
boxplot(SAR$area)
boxplot(log10(SAR$area))
hist(SAR$area)
hist(log10(SAR$area))

SAR$log_area<-log10(SAR$area)
lm.3 <- lm(log_richness~log_area, data=SAR)
summary(lm.3)


# Modelldiagnostik
par(mfrow=c(2,2))
plot(lm.3)
#das sieht jetzt sehr gut aus, bis auf zwei Ausreisser im QQ-Plot


# Lösung C (kommt erst in Statistik 4; methodisch beste Lösung;
# mit Startwerten muss man ggf. ausprobieren)
model.nls<-nls(richness~a*area^b, start=(list(a=100,b=1)), data=SAR)
summary(model.nls)

# Modelldiagnostik
if(!require(nlstools)){install.packages("nlstools")}
library(nlstools)
residuals.nls <- nlsResiduals(model.nls)
plot(residuals.nls)

# Ergebnisplots
par(mfrow=c(1,1))
xv <- seq(0,100,0.1)

# A. lineares Modell mit log-transformierter Abhängiger
plot(SAR$area,SAR$richness)
yv1a<-10^predict(lm.2,list(area=xv))
lines(xv, yv1a, col="red")

# B. lineares Modell mit log-Transformation beider Variablen
plot(SAR$area, SAR$richness)
yv1b <- predict(lm.3, list(log_area=xv))
lines(10^xv, 10^yv1b, col="blue")

# 2. nicht-lineares Modell
plot(SAR$area,SAR$richness)
yv2 <- predict(model.nls, list(area=xv))
lines(xv,yv2,col="green")

#Modelle im Vergleich
plot(SAR$area,SAR$richness)
lines(xv, yv1a, col="red")
lines(10^xv, 10^yv1b, col="blue")
lines(xv,yv2,col="green")
