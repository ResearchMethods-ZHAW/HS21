temp <- c(10, 12 ,16, 20, 24, 25, 30, 33, 37)
besucher <- c(40,12, 50, 500, 400, 900, 1500, 900, 2000)
strand <- data.frame("Temperatur" = temp, "Besucher" = besucher)

plot(besucher~temp, data = strand)

lm.strand <- lm(Besucher~Temperatur, data = strand)
summary(lm.strand)

par(mfrow = c(2, 2))
plot(lm.strand)

par(mfrow = c(1 ,1))
xv <- rep(0:40, by = .1)
yv <- predict(lm.strand, list(Temperatur = xv), data = strand)
plot(strand$Temperatur, strand$Besucher, xlim = c(0,40))
lines(xv, yv, lwd = 3, col=  "blue")

glm.gaussian <- glm(Besucher~Temperatur, family = gaussian, data = strand)
glm.poisson <- glm(Besucher~Temperatur, family = poisson, data = strand)

summary(glm.gaussian)
summary(glm.poisson)

#Rücktranformation der Werte auf die orginale Skale (Hier Exponentialfunktion da family=possion als Link-Funktion den natürlichen Logarithmus (log) verwendet)
#Besucher = exp(3.50 + 0.11 Temperatur/°C)
exp(3.500301) #Anzahl besucher bei 0°C
exp(3.500301 + 30*0.112817) #Anzahl besucher bei 30°C

# Test Overdispersion
if(!require(AER)){install.packages("AER")}
library(AER)
dispersiontest(glm.poisson)

glm.quasi <- glm(Besucher~Temperatur, family = quasipoisson, data = strand)
summary(glm.quasi)

par(mfrow = c(2,2))
plot(glm.gaussian)
plot(glm.poisson)
plot(glm.quasi)

par(mfrow = c(1, 1))
plot(strand$Temperatur, strand$Besucher, xlim=c(0, 40))
xv <- rep(0:40, by = .1)

yv <- predict(lm.strand, list(Temperatur = xv))
lines(xv, yv, lwd = 3, col = "blue")

yv2 <- predict(glm.poisson, list(Temperatur = xv))
lines(xv, exp(yv2), lwd = 3, col = "red")

yv3 <- predict(glm.quasi, list(Temperatur = xv))
lines(xv, exp(yv3), lwd = 3, col = "green")


bathing <- data.frame("temperature"=c(1, 2, 5, 9, 14, 14, 15, 19, 22, 24, 25, 26, 27, 28, 29), "bathing"=c(0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1))
plot(bathing~temperature, data = bathing)

glm.1<-glm(bathing~temperature, family = "binomial", data = bathing)
summary(glm.1)

#Modeldiagnostik (wenn nicht signifikant, dann OK)
1 - pchisq (glm.1$deviance,glm.1$df.resid)

#Modellgüte (pseudo-R²)
1 - (glm.1$dev / glm.1$null)

#Steilheit der Beziehung (relative Änderung der odds bei x + 1 vs. x)
exp(glm.1$coefficients[2])

#LD50 (also hier: Temperatur, bei der 50% der Touristen baden)
-glm.1$coefficients[1]/glm.1$coefficients[2]

#Vorhersagen
predicted <- predict(glm.1, type = "response")

#Konfusionsmatrix
km <- table(bathing$bathing, predicted > 0.5)
km

#Missklassifizierungsrate
1-sum(diag(km)/sum(km))



#Plotting
xs <- seq(0,30,l=1000)
model.predict <- predict(glm.1, type = "response", se = T, newdata = data.frame(temperature = xs))
plot(bathing~temperature, data = bathing, xlab = "Temperature (°C)", ylab = "% Bathing", pch = 16, col = "red")
points(model.predict$fit ~ xs, type="l")
lines(model.predict$fit+model.predict$se.fit ~ xs, type = "l", lty = 2)
lines(model.predict$fit-model.predict$se.fit ~ xs, type = "l", lty = 2)

if(!require(AICcmodavg)){install.packages("AICcmodavg")}
if(!require(nlstools)){install.packages("nlstools")}
library(AICcmodavg)
library(nlstools)

loyn <- read.delim("loyn.csv", sep = ",") # Achtung Verzeichnis muss dort gesetzt sein wo Daten sind

#Selbstdefinierte Funktion, hier Potenzfunktion
power.model <- nls(ABUND~c*AREA^z, start = (list(c = 1, z = 0)), data = loyn)
summary(power.model)
AICc(power.model)

#Modeldiagnostik (in nlstools)
plot(nlsResiduals(power.model))

#Vordefinierte "Selbststartfunktionen"#
?selfStart
logistic.model <- nls(ABUND~SSlogis(AREA, Asym, xmid, scal), data = loyn)
summary(logistic.model)
AICc(logistic.model)

#Modeldiagnostik (in nlstools)
plot(nlsResiduals(logistic.model))

#Visualisierung
plot(ABUND~AREA, data = loyn)
par(mfrow = c(1, 1))
xv <- seq(0, 2000, 0.01)

# 1. Potenzfunktion
yv1 <- predict(power.model, list(AREA = xv))
lines(xv, yv1, col = "green")

# 2. Logistische Funktion
yv2 <- predict(logistic.model, list(AREA = xv))
lines(xv, yv2, col = "blue")

#Visualisierung II
plot(ABUND~log10(AREA), data = loyn)
par(mfrow = c(1, 1))

# 1. Potenzfunktion
yv1 <- predict(power.model, list(AREA = xv))
lines(log10(xv), yv1, col = "green")

# 2. Logistische Funktion
yv2 <- predict(logistic.model, list(AREA = xv))
lines(log10(xv), yv2, col = "blue")


#Model seletkion zwischen den nicht-lineraen Modelen
cand.models<-list()
cand.models[[1]] <- power.model
cand.models[[2]] <- logistic.model

Modnames <- c("Power", "Logistic")

aictab(cand.set = cand.models, modnames = Modnames)

loyn$log_AREA<-log10(loyn$AREA)       
plot(ABUND~log_AREA, data = loyn)
lines(lowess(loyn$log_AREA, loyn$ABUND, f = 0.25), lwd=2, col = "red")
lines(lowess(loyn$log_AREA, loyn$ABUND, f = 0.5), lwd=2, col = "blue")
lines(lowess(loyn$log_AREA, loyn$ABUND, f = 1), lwd=2, col = "green")

if(!require(mgcv)){install.packages("mgcv")}
library(mgcv)

gam.1 <- gam(ABUND~s(log_AREA), data = loyn)
gam.1
summary(gam.1)

plot(loyn$log_AREA, loyn$ABUND, pch = 16)
xv <- seq(-1,4, by = 0.1)
yv <- predict(gam.1, list(log_AREA = xv))
lines(xv, yv, lwd = 2, col = "red")

AICc(gam.1)
summary(gam.1)
```{.r .distill-force-highlighting-css}
```
