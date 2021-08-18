### Research Methods Demo Statistik 5
### Von linearen Modellen zu GLMMs
### (c) J?rgen Dengler


# Split-plot ANOVA --------------------------------------------------------
# Based on Logan (2010), Chapter 14

spf <- read.delim("spf.csv", sep = ";") 
spf.aov <- aov(Reaktion~Signal*Messung + Error(VP), data = spf)
summary(spf.aov)

interaction.plot(spf$Messung, spf$Signal, spf$Reaktion)

#nun als LMM
if(!require(nlme)){install.packages("nlme")}
library(nlme)
spf.lme.1 <- lme(Reaktion~Signal*Messung, random = ~Messung | VP, data = spf)
spf.lme.2 <- lme(Reaktion~Signal*Messung, random = ~1 | VP, data = spf)

anova(spf.lme.1)
anova(spf.lme.2)

summary(spf.lme.1)
summary(spf.lme.2)


# GLMM --------------------------------------------------------------------
#  Based on Zuur et al. (2009), Kapitel 13
DeerEcervi <- read.delim("DeerEcervi.txt", sep = "")

DeerEcervi$Ecervi.01 <- DeerEcervi$Ecervi

#Anzahl Larven hier in Presence/Absence ?bersetzt
DeerEcervi$Ecervi.01[DeerEcervi$Ecervi>0] <- 1
DeerEcervi$fSex <- as.factor(DeerEcervi$Sex)

#Hirschl?nge hier standardisiert, sonst w?rde der Achsenabschnitt im Modell f?r
#einen Hirsch der L?nge 0 modelliert, was schlecht interpretierbar ist, 
#jetzt ist der Achsenabschnitt f?r einen durschnittlich langen Hirsch
DeerEcervi$CLength <- DeerEcervi$Length - mean(DeerEcervi$Length)
DeerEcervi$fFarm <- factor(DeerEcervi$Farm)


#Zun?chst als GLM
#Interaktionen mit fFarm nicht ber?cksichtigt, da zu viele Freiheitsgrade verbraucht w?rden
DE.glm <- glm(Ecervi.01 ~ CLength * fSex+fFarm, family = binomial, data = DeerEcervi)

drop1(DE.glm, test = "Chi")
summary(DE.glm)
anova(DE.glm)


#GLMM
if(!require(MASS)){install.packages("MASS")}
library(MASS)
DE.PQL <-glmmPQL(Ecervi.01 ~ CLength * fSex,
                random = ~ 1 | fFarm, family = binomial, data = DeerEcervi)
summary(DE.PQL)


g <- 0.8883697 + 0.0378608 * DeerEcervi$CLength
p.averageFarm1 <- exp(g)/(1+exp(g))
I <- order(DeerEcervi$CLength)              #Avoid spaghetti plot
plot(DeerEcervi$CLength, DeerEcervi$Ecervi.01, xlab="Length",
     ylab = "Probability of presence of E. cervi L1")
lines(DeerEcervi$CLength[I], p.averageFarm1[I],lwd=3)
p.Upp <- exp(g+1.96*1.462108)/(1+exp(g+1.96*1.462108))
p.Low <- exp(g-1.96*1.462108)/(1+exp(g-1.96*1.462108))
lines(DeerEcervi$CLength[I], p.Upp[I])
lines(DeerEcervi$CLength[I], p.Low[I])


if(!require(lme4)){install.packages("lme4")}
library(lme4)
DE.lme4 <- glmer(Ecervi.01 ~ CLength * fSex +(1|fFarm), family = binomial, data = DeerEcervi)
summary(DE.lme4)

if(!require(glmmML)){install.packages("glmmML")}
library(glmmML)
DE.glmmML <- glmmML(Ecervi.01 ~ CLength * fSex,
                  cluster = fFarm, family = binomial, data = DeerEcervi)
summary(DE.glmmML)

