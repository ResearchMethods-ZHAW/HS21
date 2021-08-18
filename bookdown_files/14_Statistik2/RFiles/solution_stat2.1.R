decay <- read.delim("14_Statistik2/data/decay.csv",sep = ",")

decay

# Um die Variablen im Dataframe im Folgenden direkt (ohne $ bzw. ohne "data = data") ansprechen zu können
attach(decay)
summary(decay)
str(decay)

boxplot(time)
boxplot(amount)
plot(amount~time)

lm.1<-lm(amount~time)
summary(lm.1)

par(mfrow=c(2,2))
plot(lm.1)

par(mfrow=c(1,1))
plot(time,amount)
abline(lm(amount~time),col="red")
abline(lm.1,col="red")

par(mfrow=c(1,2))
boxplot(amount)
boxplot(log(amount))
hist(amount)
hist(log(amount))

#Die log-transformierte Variante rechts sieht sowohl im Boxplot als auch im #Histogramm viel symmetrischer/besser normalverteilt aus. Damit ergibt sich #dann folgendes lineares Modell

lm.2<-lm(log(amount)~time)
summary(lm.2)

par(mfrow=c(2,2))
plot(lm.2)

model.quad<-lm(amount~time+I(time^2))
summary(model.quad)

anova(lm.1,model.quad)

par(mfrow=c(2,2))
plot(model.quad)

model.nls<-nls(amount~a*exp(-b*time),start=(list(a=100,b=1)))
summary(model.nls)

if(!require(nlstools)){install.packages("nlstools")}
library(nlstools)
residuals.nls <- nlsResiduals(model.nls)
plot(residuals.nls)

par(mfrow=c(1,1))
xv<-seq(0,30,0.1)

plot(time,amount)
yv1<-exp(predict(lm.2,list(time=xv)))
lines(xv,yv1,col="red")

plot(time,amount)
yv2<-predict(model.quad,list(time=xv))
lines(xv,yv2,col="blue")

plot(time,amount)
yv3<-predict(model.nls,list(time=xv))
lines(xv,yv3,col="green")
