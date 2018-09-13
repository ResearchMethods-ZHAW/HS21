
library(tidyverse)
library(car)
library(rms) # library(Design) not available on CRAN anymore. Replaced by rms

###################################################
### chunk number 1: pg 498
###################################################
polis <- read_csv("16_Statistik4/data/polis.csv")
###################################################
### chunk number 2: pg 498
###################################################
polis.glm <- glm(PA~RATIO, family=binomial, data=polis)
###################################################
### chunk number 4: pg 498
###################################################
polis.lrm<-lrm(PA~RATIO,data=polis,y=T, x=T)
resid(polis.lrm,type='gof')

###################################################
### chunk number 5: pg 499
###################################################
pp<-sum(resid(polis.lrm,type='pearson')^2)
1-pchisq(pp,polis.glm$df.resid)
###################################################
### chunk number 6: pg 499
###################################################
1-pchisq(polis.glm$deviance, polis.glm$df.resid)
###################################################
### chunk number 7: pg 499
###################################################
pp/polis.glm$df.resid

###################################################
### chunk number 8: pg 499
###################################################
cr.plots(polis.glm, ask=F)

###################################################
### chunk number 9: pg 499
###################################################
influence.measures(polis.glm)
###################################################
### chunk number 10: pg 500
###################################################
summary(polis.glm)
###################################################
### chunk number 11: pg 501
###################################################
anova(polis.glm, test="Chisq")

## 
## ###################################################
## ### chunk number 12: pg 501
## ###################################################
## library(biology) # library biology wird nicht mehr weitergeführt
## odds.ratio(polis.glm)
## 
##     Odds ratio Lower 95
## RATIO 0.8028734 0.659303 0.9777077
###################################################
### chunk number 13: pg 501
###################################################
1-(polis.glm$dev/polis.glm$null)
###################################################
### chunk number 14: pg 501
###################################################
-polis.glm$coef[1]/polis.glm$coef[2]
ggplot(polis, aes(RATIO, PA))+
  geom_point() +
  geom_smooth(method = "glm",method.args = list(family = "binomial"),se = 0.95) +
  labs(y = expression(paste(italic(Uta), "presence/absence")), x = "Permenter to area ratio")

