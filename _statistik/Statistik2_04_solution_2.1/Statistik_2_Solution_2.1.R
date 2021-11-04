SAR <- read.delim("SAR.csv", sep = ";")

SAR

summary(SAR)
boxplot(SAR$area) # extrem rechtsschief
boxplot(SAR$richness) # extrem rechtsschief
plot(richness~area, data = SAR) # sieht nicht linear aus

lm.1 <- lm(richness~area, data = SAR)
summary(lm.1)

par(mfrow = c(2, 2))
plot(lm.1)

par(mfrow = c(1, 1))
plot(SAR$area, SAR$richness, xlab = "Area [m²]", ylab = "Species richness")
abline(lm(richness~area, data = SAR), col = "red") #Alternative 1
abline(lm.1, col = "red") #Alternative 2

par(mfrow=c(1,2))
boxplot(SAR$richness)
boxplot(log10(SAR$richness))
hist(SAR$richness)
hist(log10(SAR$richness))

SAR$log_richness <- log10(SAR$richness)
lm.2 <- lm(log_richness~area, data = SAR)
summary(lm.2)

par(mfrow = c(2, 2))
plot(lm.2)

par(mfrow=c(1,2))
boxplot(SAR$area)
boxplot(log10(SAR$area))
hist(SAR$area)
hist(log10(SAR$area))

SAR$log_area <- log10(SAR$area)
lm.3 <- lm(log_richness~log_area, data = SAR)
summary(lm.3)

par(mfrow = c(2, 2))
plot(lm.3)

par(mfrow = c(1, 1))
xv <- seq(0, 100, 0.1)

par(mfrow = c(1,1))
xv <- seq(0,100,0.1)

plot(SAR$area, SAR$richness)
yv1a <- 10^predict(lm.2, list(area = xv))
lines(xv, yv1a, col = "blue")

xvlog <- seq(-4,2,0.1)
plot(SAR$log_area, SAR$log_richness, xlab = "log10 (Fläche [m²])", ylab = "log10 (Artenreichtum)")
yv1b <- predict(lm.3, list(log_area = xvlog))
lines(xvlog, yv1b, col = "green")

plot(SAR$area, SAR$richness, xlab = "Fläche [m²]", ylab = "Artenreichtum")
yv1b <- predict(lm.3, list(log_area = xv))
lines(10^xv, 10^yv1b, col = "green")

#Modelle im Vergleich
plot(SAR$area, SAR$richness)
abline(lm.1, col="red")
lines(xv, yv1a, col="blue")
lines(10^xv, 10^yv1b, col="green")
```{.r .distill-force-highlighting-css}
```
