
library(tidyverse)
library(car)
library(ggExtra)
library(ggfortify)
###################################################
### chunk number 1: pg 248
###################################################

peake <- read_csv("15_Statistik3/data/peake.csv")

###################################################
### chunk number 2: pg 248
###################################################
library(car)
scatterplot(SPECIES~AREA, data=peake)

p <- ggplot(peake, aes(AREA,SPECIES)) +
  geom_point() +
  geom_smooth(method = "lm", se = F, colour = "black", lty = 2) +
  geom_smooth(method = "loess")


ggMarginal(p,type = "boxplot", size = 10)

###################################################
### chunk number 3: pg 248
###################################################

autoplot(lm(SPECIES~AREA, data=peake),which = 1)
###################################################
### chunk number 4: pg 249
###################################################
peake.nls <- nls(SPECIES~alpha*AREA^beta, start=list(alpha=0.1, beta=1), peake)

ggplot(peake, aes(AREA, SPECIES)) +
  geom_point() +
  geom_smooth(method = "nls",
              se=FALSE,
              formula = y~alpha*x^beta,
              method.args = list(start=list(alpha=0.1, beta=1))
              )

###################################################
### chunk number 5: pg 249
###################################################
ggplot(NULL, aes(fitted(peake.nls),resid(peake.nls))) +
  geom_point()


###################################################
### chunk number 6: pg 249
###################################################
plot(peake.nls)
summary(peake.nls)
###################################################
### chunk number 7: pg 249
###################################################
AIC(peake.nls) #AIC

peake.lm<-lm(SPECIES~AREA, data=peake) #linear fit

AIC(peake.lm) #lm AIC
###################################################
### chunk number 8: pg 250
###################################################
peake.nls1 <- nls(SPECIES~SSasymp(AREA,a,b,c),peake)
summary(peake.nls1)
AIC(peake.nls1) #AIC
deviance(peake.nls1)/df.residual(peake.nls1) #MSresid
anova(peake.nls,peake.nls1)
###################################################
### chunk number 9: 251
###################################################

ggplot(peake, aes(AREA, SPECIES)) +
  geom_point() +
  geom_smooth(method = "nls",
              se=FALSE,
              formula = y~alpha*x^beta,
              method.args = list(start=list(alpha=0.1, beta=1)),
              lty = 2, colour = "black"
              ) +
    geom_smooth(method = "nls",
              se=FALSE,
              formula = y~SSasymp(x,Asym, R0, lrc) # replace a, b, c with Asym, R0 and lrc
              )

