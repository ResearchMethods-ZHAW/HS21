crime <- read.csv("crime2.csv", sep = ";")
crime

crimez <- crime
crimez[,c(2:8)] <- lapply(crime[, c(2:8)], scale)
crimez

library(vegan)
crimez.KM.cascade <- cascadeKM(crimez[,c(2:8)],
                        inf.gr = 2, sup.gr = 6, iter = 100, criterion = "ssi")
summary(crimez.KM.cascade)

crimez.KM.cascade$results
crimez.KM.cascade$partition

# k-means visualisation
library(cclust)
plot(crimez.KM.cascade, sortg = TRUE)

# 4 Kategorien sind nach SSI offensichtlich besonders gut
modelz <- kmeans(crimez[,c(2:8)], 4)
modelz

#File für ANOVA (Originaldaten der Vorfälle, nicht die ztransformierten)
crime.KM4 <- data.frame(crime,modelz[1])
crime.KM4$cluster <- as.factor(crime.KM4$cluster)
crime.KM4
str(crime.KM4)

#Agglomerative Clusteranalyse
crime2 <- crime[,-1]
crime.norm <- decostand(crime2, "normalize")
crime.ch <- vegdist(crime.norm, "euc")
# Attach site names to object of class 'dist'
attr(crime.ch, "Labels") <- crime[,1]

#Ward's minimum variance clustering
crime.ch.ward <- hclust(crime.ch, method = "ward.D2")
par(mfrow = c(1, 1))
plot(crime.ch.ward, labels = crime[,1], main = "Chord - Ward")

# Choose and rename the dendrogram ("hclust" object)
hc <- crime.ch.ward
# hc <- spe.ch.beta2
# hc <- spe.ch.complete
dev.new(title = "Optimal number of clusters", width = 12, height = 8, noRStudioGD = TRUE)
dev.off()
par(mfrow = c(1, 2))


# Average silhouette widths (Rousseeuw quality index)
library(cluster)
Si <- numeric(nrow(crime))
for (k in 2:(nrow(crime) - 1))
{
 sil <- silhouette(cutree(hc, k = k), crime.ch)
 Si[k] <- summary(sil)$avg.width
}
k.best <- which.max(Si)
plot( 1:nrow(crime), Si, type = "h",
 main = "Silhouette-optimal number of clusters",
 xlab = "k (number of clusters)", ylab = "Average silhouette width")

axis(1, k.best, paste("optimum", k.best, sep = "\n"), col = "red",
 font = 2, col.axis = "red")
points(k.best, max(Si), pch = 16, col = "red", cex = 1.5)

library(multcomp)
if(!require(multcomp)){install.packages("multcomp")}
library(multcomp)
par(mfrow = c(3,3))

ANOVA.Murder <- aov(Murder~cluster, data = crime.KM4)
summary(ANOVA.Murder)
letters <- cld(glht(ANOVA.Murder, linfct = mcp(cluster = "Tukey")))
boxplot(Murder~cluster, xlab = "Cluster", ylab = "Murder", data = crime.KM4)
mtext(letters$mcletters$Letters, at = 1:6)

ANOVA.Rape <- aov(Rape~cluster,data = crime.KM4)
summary(ANOVA.Rape)
letters <- cld(glht(ANOVA.Rape, linfct = mcp(cluster = "Tukey")))
boxplot(Rape~cluster, xlab = "Cluster", ylab = "Rape", data = crime.KM4)
mtext(letters$mcletters$Letters, at = 1:6)

ANOVA.Robbery <- aov(Robbery~cluster, data = crime.KM4)
summary(ANOVA.Robbery)
letters <- cld(glht(ANOVA.Robbery, linfct = mcp(cluster = "Tukey")))
boxplot(Robbery~cluster, xlab = "Cluster", ylab = "Robbery", data = crime.KM4)
mtext(letters$mcletters$Letters, at = 1:6)

ANOVA.Assault <- aov(Assault~cluster, data = crime.KM4)
summary(ANOVA.Assault)
letters <- cld(glht(ANOVA.Assault, linfct = mcp(cluster = "Tukey")))
boxplot(Assault~cluster, xlab = "Cluster", ylab = "Assault",  data = crime.KM4)
mtext(letters$mcletters$Letters, at = 1:6)

ANOVA.Burglary <- aov(Burglary~cluster, data = crime.KM4)
summary (ANOVA.Burglary)
letters <- cld(glht(ANOVA.Burglary, linfct=mcp(cluster = "Tukey")))
boxplot(Burglary~cluster, data = crime.KM4, xlab = "Cluster", ylab = "Burglary")
mtext(letters$mcletters$Letters, at=1:6)

ANOVA.Theft <- aov(Theft~cluster, data = crime.KM4)
summary(ANOVA.Theft)
letters <- cld(glht(ANOVA.Theft, linfct = mcp(cluster = "Tukey")))
boxplot(Theft~cluster, xlab = "Cluster", ylab = "Theft", data = crime.KM4)
mtext(letters$mcletters$Letters, at = 1:6)

ANOVA.Vehicle <- aov(Vehicle~cluster, data = crime.KM4)
summary(ANOVA.Vehicle)
letters <- cld(glht(ANOVA.Vehicle, linfct = mcp(cluster = "Tukey")))
boxplot(Vehicle~cluster, data = crime.KM4, xlab = "Cluster", ylab = "Vehicle")
mtext(letters$mcletters$Letters, at = 1:6)
```{.r .distill-force-highlighting-css}
```
