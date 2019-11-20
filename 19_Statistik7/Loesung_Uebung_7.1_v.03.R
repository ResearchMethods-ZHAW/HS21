### MSc. Research Methods
### Statistik HS 2019
### Übung 7.1 - RDA
### - Jürgen Dengler -

# Moordatensatz laden. 
if(!require(dave)){install.packages("dave")}
library(dave)
data(sveg)
data(ssit)
summary(sveg)
summary(ssit)
str(ssit)

# x.axis and y.axis vom data frame data frame ssit entfernen
env2 <- ssit[, -c(19,20)]

# Generiere zwei subset der erklärenden Variablen
# Physiografie (upstream-downstream-Gradient)
envtopo <- env2[, c(11 : 15)]
names(envtopo)
# Chemie
envchem <- env2[, c(1:10,16:18)]
names(envchem)

# Hellinger-transform the species dataset
library(vegan)
spe.hel <- decostand(sveg, "hellinger")
spe.hel

#  Redundancy analysis (RDA) ---------------------------------------------
## RDA der Hellinger-transformireten Moorarten-Daten, constrained
## mit allen Umweltvarialben die in env2 enthalten sind
(spe.rda <- rda(spe.hel ~ ., env2)) # Observe the shortcut formula

summary(spe.rda)	# Skalierung 2 (default)

# Canonical coefficients from the rda object
coef(spe.rda)
# Unadjusted R^2 retrieved from the rda object
(R2 <- RsquareAdj(spe.rda)$r.squared)
# Adjusted R^2 retrieved from the rda object
(R2adj <- RsquareAdj(spe.rda)$adj.r.squared)

## Triplots of the rda results (lc scores)
## Site scores as linear combinations of the environmental variables
dev.new(title = "RDA scaling 1 and 2 + lc",width = 15,height = 6,noRStudioGD = TRUE)
par(mfrow = c(1, 2))

# 1 und 2 Achse
plot(spe.rda, display = c("sp", "lc", "cn"), 
     main = "Triplot RDA spe.hel ~ env2 - scaling 2 - lc scores")
spe.sc2 <- scores(spe.rda, choices = 1:2, display = "sp")
arrows(0, 0, spe.sc2[, 1] * 0.92, spe.sc2[, 2] * 0.92,length = 0,
       lty = 1,col = "red")
text(-0.82, 0.55, "b", cex = 1.5)

#1 und 3 Achse
plot(spe.rda, display = c("sp", "lc", "cn"), choices = c(1,3),
     main = "Triplot RDA spe.hel ~ env2 - scaling 2 - lc scores")
spe.sc2 <- scores(spe.rda, choices =c(1,3), display = "sp")
arrows(0, 0, spe.sc2[, 1] * 0.92, spe.sc2[, 2] * 0.92,length = 0,
       lty = 1,col = "red")
text(-0.82, 0.55, "b", cex = 1.5)


## Triplots of the rda results (wa scores)
## Site scores as weighted averages (vegan's default)
# Scaling 1 :  distance triplot
dev.new(title = "RDA scaling 2 + wa",width = 7,height = 6,noRStudioGD = TRUE)

# Scaling 2 (default) :  correlation triplot
plot(spe.rda, main = "Triplot RDA spe.hel ~ env3 - scaling 2 - wa scores")
arrows(0, 0, spe.sc2[, 1] * 0.92, spe.sc2[, 2] * 0.92, length = 0, lty = 1, col = "red")

# Select species with goodness-of-fit at least 0.6 in the 
# ordination plane formed by axes 1 and 2
spe.good <- goodness(spe.rda)
sel.sp <- which(spe.good[, 2] >= 0.6)
sel.sp

# Triplots with homemade function triplot.rda(), scalings 1 and 2
setwd("S:/pools/n/N-zen_naturmanag_lsfm/FS_Vegetationsanalyse/Lehre (Module)/MSc. Research Methods/Statistik Dengler 2019/DataSets")
source("triplot.rda.R")

dev.new(title = "RDA plot with triplot.rda",width = 7,height = 6, noRStudioGD = TRUE)

triplot.rda(spe.rda, site.sc = "lc", cex.char2 = 0.7, pos.env = 3, 
            pos.centr = 1, mult.arrow = 1.1, mar.percent = 0.05, select.spe = sel.sp)

# Global test of the RDA result
#anova(spe.rda, permutations = how(nperm = 999))
# Tests of all canonical axes
anova(spe.rda, by = "axis", permutations = how(nperm = 999))


## Partial RDA: effect of water chemistry, holding physiography
## constant

# Simple syntax; X and W may be in separate tables of quantitative 
# variables
spechem.physio <- rda(spe.hel, envchem, envtopo)
summary(spechem.physio)

# Formula interface; X and W variables must be in the same 
# data frame
(spechem.physio2 <- 
    rda(spe.hel ~ pH.peat + log.ash.perc + Ca_peat +Mg_peat + Na_peat
       + K_peat + Acidity.peat + CEC.peat + Base.sat.perc + P.peat
       + pH.water + log.cond.water + log.Ca.water
       + Condition(Waterlev.max + Waterlev.av + Waterlev.min + log.peat.lev
       + log.slope.deg), data = env2))

# Test of the partial RDA, using the results with the formula 
# interface to allow the tests of the axes to be run
anova(spechem.physio2, permutations = how(nperm = 999))
anova(spechem.physio2, permutations = how(nperm = 999), by = "axis")

# Partial RDA triplots (with fitted site scores) 
# with function triplot.rda
dev.new(title = "Partial RDA",width = 7,height = 6,noRStudioGD = TRUE)
triplot.rda(spechem.physio, site.sc = "lc", 
            cex.char2 = 0.8, pos.env = 3, mult.spe = 1.1, mar.percent = 0.04)
text(-3.34, 3.64, "b", cex = 2)


## Variation partitioning with two sets of explanatory variables

## 1. Variation partitioning with all explanatory variables
(spe.part.all <- varpart(spe.hel, envchem, envtopo))

# Plot of the partitioning results
dev.new(title = "Variation partitioning",width = 7,height = 7,noRStudioGD = TRUE)

plot(spe.part.all, digits = 2, bg = c("red", "blue"),
     Xnames = c("Chemistry", "Physiography"), id.size = 0.7)
