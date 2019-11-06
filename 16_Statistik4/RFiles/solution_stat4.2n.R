## ------------------------------------------------------------------------
islands <-read.csv("16_Statistik4/data/isolation.csv")
islands
str(islands)
summary(islands)


## ------------------------------------------------------------------------
attach(islands)
#Explorative Datenanalyse
boxplot(area)

boxplot(isolation)


## ------------------------------------------------------------------------
#Definition der unterschiedlichen Modelle
model.mult <- glm(incidence~area*isolation,binomial)
model.add <- glm(incidence~area+isolation,binomial)
model.area <- glm(incidence~area,binomial)
model.isolation <- glm(incidence~isolation,binomial)


## ------------------------------------------------------------------------
#Modellergebnisse
summary(model.mult)
summary(model.add)

summary(model.area)
summary(model.isolation)


## ------------------------------------------------------------------------
anova(model.mult,model.add,test="Chi")


## ------------------------------------------------------------------------
anova(model.add,model.area,test="Chi")
anova(model.add,model.isolation,test="Chi")


## ------------------------------------------------------------------------
library(AICcmodavg)
cand.models<-list()
cand.models[[1]]<-model.mult
cand.models[[2]]<-model.add
cand.models[[3]]<-model.area
cand.models[[4]]<-model.isolation

Modnames<-c("Area * Isolation","Area +
Isolation","Area","Isolation")
aictab(cand.set=cand.models,modnames=Modnames)


## ------------------------------------------------------------------------
#Modelldiagnostik für das gewählte Modell (wenn nicht signifikant,dann OK)
1 - pchisq(model.add$deviance,model.add$df.resid)

#Nicht signifikant, d. h. kein „lack of fit“.

#Visuelle Inspektion der Linearität
library(car)
crPlots(model.add,ask=F)


## ------------------------------------------------------------------------
#Modellgüte (pseudo-R²)
1 - (model.add$dev / model.add$null)

# 58% der Vorkommenswahrscheinlichkeit der Vogelart wird durch die beiden gewählten Prediktorvariablen erklärt.


#Steilheit der Beziehung (relative Änderung der odds von x + 1 vs.x)
#area (2. Koeffizient nach dem Achsenabschnitt)
exp(model.add$coef[2])

#> 1, d. h. Vorkommenswahrscheinlichkeit steigt mit Flächengrösse.

#area (3. Koeffizient nach dem Achsenabschnitt)
exp(model.add$coef[3])

#< 1, d. h. Vorkommenswahrscheinlichkeit sinkt mit zunehmender Isolation.


## ------------------------------------------------------------------------
#Ergebnisplots
#Da es keine signifikante Interaktion gibt, kann man die separaten Darstellungen der beiden Einzelbeziehungen nehmen.

xs<-seq(0,10,l=1000)
model.predict<-
predict(model.area,type="response",se=T,newdata=data.frame(area=xs))
plot(incidence~area,data=islands,xlab="Fläche
(km²)",ylab="Vorkommenswahrscheinlichkeit",pch=16, col="red")
 points(model.predict$fit ~ xs,type="l")
 lines(model.predict$fit+model.predict$se.fit ~ xs,
type="l",lty=2)
 lines(model.predict$fit-model.predict$se.fit ~ xs,
type="l",lty=2)
 
 model.predict2<-
predict(model.isolation,type="response",se=T,newdata=data.frame(isolation=xs))
plot(incidence~isolation,data=islands,xlab="Entfernung vom Festland
(km)",ylab="Vorkommenswahrscheinlichkeit",pch=16, col="blue")
 points(model.predict2$fit ~ xs,type="l")
 lines(model.predict2$fit+model.predict2$se.fit ~ xs,
type="l",lty=2)
 lines(model.predict2$fit-model.predict2$se.fit ~ xs,
type="l",lty=2)

