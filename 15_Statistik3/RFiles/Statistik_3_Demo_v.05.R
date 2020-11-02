# Research Methods Demo Statistik 3


# ANCOVA ------------------------------------------------------------------
# Basierend auf Crawley (2017)

# Experiment zur Fruchtproduktion ("Fruit") von Ipomopsis sp. ("Fruit") in 
# Abh?ngigkeit von der Beweidung (Grazing mit 2 Levels: Grazed, Ungrazed) 
# und korrigiert f?r die Pflanzengr?sse vor der Beweidung (hier ausgedr?ckt 
# als Durchmesser an der Spitze des Wurzelstock: "Root")

compensation<-read.table("ipomopsis.csv", header=T, sep=",")
summary(compensation)
compensation$Grazing<-as.factor(compensation$Grazing)

plot(Fruit~Root, data=compensation)
boxplot(Fruit~Grazing, data=compensation)

tapply(compensation$Fruit, compensation$Grazing, mean)

aoc.1 <- lm(Fruit~Root*Grazing, data=compensation)
summary.aov(aoc.1)

aoc.2 <- lm(Fruit~Grazing*Root, data=compensation)
summary.aov(aoc.2)

aoc.3 <- lm(Fruit~Grazing+Root, data=compensation)
summary.lm(aoc.3)

# Plotten der Ergebnisse
library(tidyverse)
ggplot(compensation, aes(Fruit, Root, color = Grazing)) +
  geom_point()

# Ploten mit base R
plot(Fruit~Root, pch = 16, col = Grazing, data=compensation)
legend("topleft", c("grazed","ungrazed"), col=c("black","red"), pch=16) 


# Polynomische Regression -------------------------------------------------

e <- c(20,19,25,10,8,15,13,18,11,14,25,39,38,28,24)
f <- c(12,15,10,7,2,10,12,11,13,10,9,2,4,7,13)

lm.1 <- lm(f~e)
lm.quad <- lm(f~e+I(e^2))

summary(lm.1)
summary(lm.quad)

par(mfrow=c(1,1))

# 1. lineares Modell
plot(f~e,xlim=c(0,40), ylim=c(0,20))
abline(lm(f~e), col="blue")

# 2. quadratisches Modell
xv <- seq(0,40,0.1)
plot(f~e,xlim=c(0,40), ylim=c(0,20))
yv2 <- predict(lm.quad, list(e=xv))
lines(xv, yv2, col="red")

# Residualplots
par(mfrow=c(2,2))
plot(lm(f~e))
plot(lm(f~e+I(e^2)))



# Multiple lineare Regression basierend auf Logan, Beispiel 9A ------------
loyn <- read.table("loyn.csv", header=T, sep=",")
loyn

summary(loyn)

lm.1 <- lm (ABUND ~ YR.ISOL + ALT + GRAZE, data=loyn)
summary(lm.1)

aov(lm.1)
par(mfrow=c(2,2))
plot(lm.1)
influence.measures(lm.1)

cor <- cor(loyn[,2:7])
print(cor, digits=2)

cor[abs(cor)<0.6] <- 0
cor
print(cor, digits=3)

if(!require(car)){install.packages("car")} 
library(car)
vif(lm.1)


# Simulation Overfitting --------------------------------------------------
test <- data.frame("x"=c(1,2,3,4,5,6),"y"=c(34,21,70,47,23,45))

par(mfrow=c(1,1))
plot(y~x, data=test)

lm.0 <- lm(y~1, data=test)
lm.1 <- lm(y~x, data=test)
lm.2 <- lm(y~x+I(x^2), data=test)
lm.3 <- lm(y~x+I(x^2)+I(x^3), data=test)
lm.4 <- lm(y~x+I(x^2)+I(x^3)+I(x^4), data=test)
lm.5 <- lm(y~x+I(x^2)+I(x^3)+I(x^4)+I(x^5), data=test)
lm.6 <- lm(y~x+I(x^2)+I(x^3)+I(x^4)+I(x^5)+I(x^6), data=test)
summary(lm.0)
summary(lm.1)
summary(lm.2)
summary(lm.3)
summary(lm.4)
summary(lm.5)

xv <- seq(from=0,to=10,by=0.1)

plot(y~x,cex=2,col="black",lwd=3, data=test)
yv <- predict(lm.1, list(x=xv))
lines(xv,yv,col="red",lwd=3)
yv <- predict(lm.2,list(x=xv))
lines(xv,yv,col="blue",lwd=3)
yv<-predict(lm.3,list(x=xv))
lines(xv,yv,col="green",lwd=3)
yv <- predict(lm.4,list(x=xv))
lines(xv,yv,col="orange",lwd=3)
yv <- predict(lm.5,list(x=xv))
lines(xv,yv,col="black",lwd=3)


# Modellvereinfachung (mit Loyn-Datensatz)
lm.1 <- lm (ABUND ~ YR.ISOL + ALT + GRAZE, data=loyn)
summary(lm.1)

lm.2 <- update(lm.1,~.-YR.ISOL)
summary(lm.2)

anova(lm.1,lm.2)


# Hierarchical partitioning -----------------------------------------------
if(!require(hier.part)){install.packages("hier.part")}
library(hier.part)

loyn.preds <-with(loyn, data.frame(YR.ISOL, ALT, GRAZE))
hier.part(loyn$ABUND,loyn.preds, gof="Rsqu")


# Partial regressions -----------------------------------------------------
avPlots(lm.1, ask=F)


# Multimodel inference ----------------------------------------------------
if(!require(MuMIn)){install.packages("MuMIn")}
library(MuMIn)

global.model <- lm(ABUND ~ YR.ISOL + ALT + GRAZE, data=loyn)
options(na.action="na.fail")

allmodels <- dredge(global.model)
allmodels
importance(allmodels)

avgmodel <- model.avg(allmodels, subset=TRUE)
summary(avgmodel)

