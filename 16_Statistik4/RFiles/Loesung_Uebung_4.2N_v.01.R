### MSc. Research Methods
### Statistik HS 2019
### Übung 4.2N - Multiple logistische Regression
### - Jürgen Dengler -

setwd("S:/pools/n/N-zen_naturmanag_lsfm/FS_Vegetationsanalyse/Lehre (Module)/MSc. Research Methods/Statstik Dengler 2019/DataSets")
islands <-read.csv("isolation.csv")

islands
str(islands)
summary(islands)

attach(islands)

#Explorative Datenanalyse
par(mfrow=c(1,1))
boxplot(area)
boxplot(isolation)

#Definition der unterschiedlichen Modelle
model.mult <- glm(incidence~area*isolation,binomial)
model.add <- glm(incidence~area+isolation,binomial)
model.area <- glm(incidence~area,binomial)
model.isolation <- glm(incidence~isolation,binomial)

#Modellergebnisse
summary(model.mult)
summary(model.add)
summary(model.area)
summary(model.isolation)

anova(model.mult,model.add,test="Chi")
anova(model.add,model.area,test="Chi")
anova(model.add,model.isolation,test="Chi")

library(AICcmodavg)
cand.models<-list()
cand.models[[1]]<-model.mult
cand.models[[2]]<-model.add
cand.models[[3]]<-model.area
cand.models[[4]]<-model.isolation

Modnames<-c("Area * Isolation","Area + Isolation","Area","Isolation")
aictab(cand.set=cand.models,modnames=Modnames)

#Modelldiagnostik für das gewählte Modell (wenn nicht signifikant, dann OK)
1 - pchisq(model.add$deviance,model.add$df.resid)

#Visuelle Inspektion der Linearität
library(car)
crPlots(model.add,ask=F)

#Modellgüte (pseudo-R²)
1 - (model.add$dev / model.add$null)

#Steilheit der Beziehung (relative Änderung der odds von x + 1 vs. x)
#area (2. Koeffizient nach dem Achsenabschnitt)
exp(model.add$coef[2])
#area (3. Koeffizient nach dem Achsenabschnitt)
exp(model.add$coef[3])

#Steilheit der Beziehung in Modellen mit nur einem Parameter
exp(model.area$coef[2])
exp(model.isolation$coef[2])

#LD50 für 1-Parameter-Modelle (hier also x-Werte, bei der 50% der Inseln besiedelt sind)
-model.area$coef[1]/model.area$coef[2]
-model.isolation$coef[1]/model.isolation$coef[2]

#Ergebnisplots
par(mfrow=c(1,2))
xs<-seq(0,10,l=1000)
model.predict<-predict(model.area,type="response",se=T,newdata=data.frame(area=xs))
plot(incidence~area,data=islands,xlab="Fläche (km²)",ylab="Vorkommenswahrscheinlichkeit",pch=16, col="red")
     points(model.predict$fit ~ xs,type="l")
     lines(model.predict$fit+model.predict$se.fit ~ xs, type="l",lty=2)
     lines(model.predict$fit-model.predict$se.fit ~ xs, type="l",lty=2)
     
model.predict2<-predict(model.isolation,type="response",se=T,newdata=data.frame(isolation=xs))
plot(incidence~isolation,data=islands,xlab="Entfernung vom Festland (km)",ylab="Vorkommenswahrscheinlichkeit",pch=16, col="blue")
     points(model.predict2$fit ~ xs,type="l")
     lines(model.predict2$fit+model.predict2$se.fit ~ xs, type="l",lty=2)
     lines(model.predict2$fit-model.predict2$se.fit ~ xs, type="l",lty=2)

