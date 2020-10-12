knitr::opts_chunk$set(fig.width = 20, fig.height = 12, warning = F, message = F, fig.pos = 'H',results = "show")

SAR<-read.delim("16_Statistik4/data/Curonian_Spit.csv",sep=";")
str(SAR)
summary(SAR)
attach(SAR)
#Explorative Datenanalyse
plot(Species.richness~Area)

#Potenzfunktion selbst definiert
if(!require(nlstools)){install.packages("nlstools")}
library(nlstools)
#power.model<-nls(Species.richness~c*Area^z)
#summary(power.model)

power.model<-nls(Species.richness~c*Area^z, start=(list(c=1,z=0.2)))
summary(power.model)

#logarithmische Funktion selbst definiert
logarithmic.model<-nls(Species.richness~b0+b1*log10(Area))
summary(logarithmic.model)

# Zu den verschiedenen Funktionen mit Sättigungswert (Asymptote) gehören  Michaelis-Menten, das aymptotische Modell durch den Ursprung und die logistische
# Funktion. Die meisten gibt es in R
# als selbststartende Funktionen, was meist besser funktioniert als
# wenn man sich selbst Gedanken
# über Startwerte usw. machen muss. Man kann sie aber auch selbst definieren

micmen.1<-nls(Species.richness~SSmicmen(Area, Vm, K))
summary(micmen.1)

#Dasselbe selbst definiert (mit default-Startwerten)
micmen.2<-nls(Species.richness~Vm*Area/(K+Area))
summary(micmen.2)

#Dasselbe selbst definiert (mit sinnvollen Startwerten, basierend auf dem Plot)
micmen.model3<-
nls(Species.richness~Vm*Area/(K+Area),start=list(Vm=100,K=1))
summary(micmen.model3)

#Eine asymptotische Funktion durch den Ursprung (mit implementierter Selbststartfunktion)
asym.model<-nls(Species.richness~SSasympOrig(Area, Asym, lrc))
summary(asym.model)

#Logistische Regression als Selbststart-Funktion
#logistic.model<-nls(Species.richness~SSlogis(Area,asym,xmid,scal))

#Vergleich der Modellgüte mittels AICc
library(AICcmodavg)
cand.models<-list()
cand.models[[1]]<-power.model
cand.models[[2]]<-logarithmic.model
cand.models[[3]]<-micmen.1
cand.models[[4]]<-micmen.2
cand.models[[5]]<-asym.model

Modnames<-c("Power","Logarithmic","Michaelis-Menten (SS)","Michaelis-Menten","Asymptotic through origin")
aictab(cand.set=cand.models,modnames=Modnames)

#Modelldiagnostik für das beste Modell
library(nlstools)
plot(nlsResiduals(power.model))

#Ergebnisplot
plot(Area,Species.richness,pch=16,xlab="Flaeche [m2]",ylab="Artenreichtum")
xv<-seq(0,1000,by=0.1)
yv<-predict(power.model,list(Area=xv))
lines(xv,yv,lwd=2,col="red")

#Das ist der Ergebnisplot für das beste Modell. Wichtig ist, dass man die Achsen korrekt beschriftet und nicht einfach die mehr oder weniger kryptischen Spaltennamen aus R nimmt.

#Im Weiteren habe ich noch eine Sättigungsfunktion (Michaelis-Menten mit Selbststarter) zum Vergleich hinzugeplottet

yv2<-predict(micmen.1,list(Area=xv))
lines(xv,yv2,lwd=2,col="blue")

#Ergebnisplot Double-log
plot(log10(Area),log10(Species.richness),pch=16,xlab="logA",ylab="log (S)")
xv<-seq(0,1000,by=0.0001)
yv<-predict(power.model,list(Area=xv))
lines(log10(xv),log10(yv),lwd=2,col="red")
yv2<-predict(micmen.1,list(Area=xv))
lines(log10(xv),log10(yv2),lwd=2,col="blue")
