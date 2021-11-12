SAR <- read.delim("Curonian_Spit.csv", sep=";")
str(SAR)
summary(SAR)

 # Explorative Datenanalyse
plot(Species.richness~Area, data = SAR)

# Potenzfunktion selbst definiert
if(!require(nlstools)){install.packages("nlstools")}
library(nlstools)
# power.model <- nls(Species.richness~c*Area^z, data = SAR)
# summary(power.model)

power.model <- nls(Species.richness~c * Area^z, start = (list(c = 1, z = 0.2)), data = SAR)
summary(power.model)

#logarithmische Funktion selbst definiert
logarithmic.model <- nls(Species.richness~b0 + b1 * log10(Area), data = SAR)
summary(logarithmic.model)

micmen.1 <- nls(Species.richness~SSmicmen(Area, Vm, K), data = SAR)
summary(micmen.1)

# Dasselbe selbst definiert (mit default-Startwerten)
micmen.2 <- nls(Species.richness~Vm*Area/(K+Area), data = SAR)
summary(micmen.2)

# Dasselbe selbst definiert (mit sinnvollen Startwerten, basierend auf dem Plot)
micmen.3 <- nls(Species.richness~Vm*Area/(K+Area), start = list(Vm = 100, K = 1), data = SAR)
summary(micmen.3)

# Eine asymptotische Funktion durch den Ursprung (mit implementierter Selbststartfunktion)
asym.model <- nls(Species.richness~SSasympOrig(Area, Asym, lrc), data = SAR)
summary(asym.model)

logistic.model <- nls(Species.richness~SSlogis(Area, asym, xmid, scal), data = SAR)
summary(logistic.model)

logistic.model.2 <- nls(Species.richness~asym/(1 + exp((xmid-Area) / scal)), 
                      control = nls.control(maxiter = 100), 
                      start = (list(xmid = 1, scal = 0.2, asym = 100)), data = SAR)
summary(logistic.model.2)

# Vergleich der Modellgüte mittels AICc
library(AICcmodavg)
cand.models <- list()
cand.models[[1]] <- power.model
cand.models[[2]] <- logarithmic.model
cand.models[[3]] <- micmen.1
cand.models[[4]] <- micmen.2
cand.models[[5]] <- asym.model
cand.models[[6]] <- logistic.model.2

Modnames<-c("Power", "Logarithmic", "Michaelis-Menten (SS)", "Michaelis-Menten", 
            "Asymptotic through origin", "Logistische Regression")
aictab(cand.set=cand.models, modnames=Modnames)

# Modelldiagnostik für das beste Modell
library(nlstools)
plot(nlsResiduals(power.model))

# Ergebnisplot
plot(Species.richness~Area, pch = 16, xlab = "Fläche [m²]", ylab = "Artenreichtum", data = SAR)
xv <- seq(0, 1000, by = 0.1)
yv <- predict(power.model, list(Area = xv))
lines(xv, yv, lwd = 2, col = "red")
yv2 <- predict(micmen.1, list(Area = xv))
lines(xv, yv2, lwd = 2, col = "blue")

# Ergebnisplot Double-log
plot(log10(Species.richness)~log10(Area), pch = 16, xlab = "log A", ylab = "log (S)", data = SAR)

xv <- seq(0, 1000, by = 0.0001)

yv <- predict(power.model, list(Area = xv))
lines(log10(xv), log10(yv), lwd = 2, col = "red")

yv2 <- predict(micmen.1, list(Area=xv))
lines(log10(xv), log10(yv2), lwd = 2, col = "blue")
```{.r .distill-force-highlighting-css}
```
