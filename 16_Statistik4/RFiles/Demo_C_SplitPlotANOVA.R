library(tidyverse)
library(nlme) # für lme()
library(lme4) # für lmer()
library(languageR) #für aovlmer.fnc()
library(lmerTest) # für lmerTest::anova

spf <- read_csv("16_Statistik4/data/spf.csv")



# model with random intercept and slope
spf.lme.1<-lme(Y~A*C, random=~C|B, spf)

# model without random slope
spf.lme.2 <- update(spf.lme.1, random=~1|B)

#Compare fitted models
#technically,only models fitted with ML (not REML)
#should be compared via anova
spf.lmeML.1 <- update(spf.lme.1, method="ML")
spf.lmeML.2 <- update(spf.lme.2, method="ML")
anova(spf.lmeML.1,spf.lmeML.2)





spf.lme.3 <- update(spf.lme.2, correlation = corAR1(form = ~1 | B))

anova(spf.lme.2, spf.lme.3)


spf.lme.4 <- update(spf.lme.2, correlation = corCompSymm(form = ~1 | B))
anova(spf.lme.2, spf.lme.4)

spf.lme.5 <- update(spf.lme.2, correlation = corSymm(form = ~1 | B))
anova(spf.lme.2, spf.lme.5)


###################################################
### chunk number 3: pg 419
###################################################
# examine the fixed effects
anova(spf.lme.2)

## ###################################################
## ### chunk number 4: pg 420
## ###################################################
## library(biology) # wird nicht mehr weitergeführt
## anova(mainEffects(spf.lme.2, at=A=="A1"))
## 
##            numDF denDF   F-value p-value
## (Intercept)    1   17     591.6800 <.0001
## M1             4   17      79.0034 <.0001
## M3             3   17      35.9589 <.0001

## ###################################################
## ### chunk number 5: pg 420
## ###################################################
## anova(mainEffects(spf.lme.2,at=A=="A2"))
##         numDF denDF F-value p-value
## (Intercept) 1 17   591.6800 <.0001
## M1          4 17    27.4692 <.0001
## M3          3 17   104.6712 <.0001

## ###################################################
## ### chunk number 6: pg 420
## ###################################################
## anova(mainEffects(spf.lme.2,at=C=="C1"))
## 
##            numDF denDF F-value p-value
## (Intercept)    1 18  591.6800 <.0001
## M1             6 18   68.9187 <.0001
## M2             1  6   10.3784 0.0181

## ###################################################
## ### chunk number 7: pg 420
## ###################################################
## anova(mainEffects(spf.lme.2,at=C=="C2"))
## 
##           numDF denDF F-value p-value
## (Intercept)   1 18   591.6800 <.0001
## M1            6 18    70.2160 <.0001
## M2            1 6      2.5946 0.1584

###################################################
### chunk number 8: pg 420
###################################################

spf.lmer <- lmer(Y~A*C+(1|B),spf)


# aovlmer.fnc(spf.lmer, noMCMC=T) # gilt nicht mehr

anova(spf.lmer)

