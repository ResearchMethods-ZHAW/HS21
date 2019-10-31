
library(tidyverse)
library(car)
library(GGally)
library(ggfortify)


###################################################
### chunk number 1: pg 224
###################################################
# loyn <- read.csv('loyn.csv', header=T, sep=',')


loyn <- read_csv("15_Statistik3/data/loyn.csv")

###################################################
### chunk number 2: pg 225
###################################################
# scatterplotMatrix(~ABUND+AREA+YR.ISOL+DIST+LDIST+GRAZE+ALT, data=loyn, diag="boxplot")


GGally::ggpairs(loyn)

###################################################
### chunk number 3: pg 225
###################################################
# scatterplotMatrix(~ABUND+log10(AREA)+YR.ISOL+log10(DIST)+log10(LDIST)+GRAZE+ALT, data=loyn, diag="boxplot")

loyn %>%
  mutate(
    AREA_log10 = log10(AREA),
    DIST_log10 = log10(DIST),
    LDIST_log10 = log10(LDIST)
    ) %>%
  dplyr::select(-AREA,-DIST,-LDIST) %>%
  ggpairs()


###################################################
### chunk number 4: pg 226
###################################################
cor(loyn[,2:7])


###################################################
### chunk number 5: pg 227
###################################################

vif(lm(ABUND~log10(AREA)+YR.ISOL+log10(DIST)+log10(LDIST) +GRAZE+ALT, data=loyn))
1/vif(lm(ABUND~log10(AREA)+YR.ISOL+log10(DIST)+log10(LDIST) +GRAZE+ALT, data=loyn))

###################################################
### chunk number 6: pg 227
###################################################

# Added "na.action = "na.fail"" see https://stackoverflow.com/a/26437578/4139249

loyn.lm<-lm(ABUND~log10(AREA)+YR.ISOL+log10(DIST)+log10(LDIST)+GRAZE+ALT,data=loyn,na.action = "na.fail")

###################################################
### chunk number 6: pg 227
###################################################

# plot(loyn.lm)
autoplot(loyn.lm)

###################################################
### chunk number 7: pg 228
###################################################

summary(influence.measures(loyn.lm))

###################################################
### chunk number 8: pg 228
###################################################

summary(loyn.lm)



###################################################
### chunk number 9: pg 229
###################################################

avPlots(loyn.lm, ask=F)


library(MuMIn)

## 
## # Package biology wird von Logan nicht mehr weitergeführt und ist mit der aktuellen R Version nicht kompatibel
## library(biology)
## m<-Model.selection(loyn.lm)
## Model.selection(loyn.lm)[[1]][1:45,c(2,5,6,7)]


loyn.lm.sel <- dredge(loyn.lm, rank = "AICc")
loyn.lm.getmodels <- get.models(loyn.lm.sel, subset = T)
loyn.lm.av <- model.avg(loyn.lm.getmodels)
summary(loyn.lm.av)



###################################################
### chunk number 3: pg 239
###################################################
loyn.lm2<-lm(ABUND~log10(AREA)+GRAZE, data=loyn)
summary(loyn.lm2)

library(hier.part)

###################################################
### chunk number 1: pg 240
###################################################
#construct a dataset entirely of predictor variables
loyn.preds <- with(loyn,data.frame(logAREA=log10(AREA), YR.ISOL, logDIST=log10(DIST), logLDIST=log10(LDIST), GRAZE, ALT))


#perform hierarchical partitioning 
hier.part(loyn$ABUND,loyn.preds, gof="Rsqu")


r.HP<-rand.hp(loyn$ABUND,loyn.preds, gof="Rsqu", num.reps=100)$Iprobs

r.HP
