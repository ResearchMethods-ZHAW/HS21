polis <- read.csv("https://media.githubusercontent.com/media/ResearchMethods-ZHAW/datasets/main/statistik/polis.csv")
polis

str(polis)
summary(polis)

# Explorative Datenanalyse
boxplot(polis$RATIO)

# Definition des logistischen Modells
glm.1 <- glm(PA~RATIO, family = "binomial", data = polis)
summary (glm.1)

# Modelldiagnostik für das gewählte Modell (wenn nicht signifikant, dann OK)
1 - pchisq(glm.1$deviance, glm.1$df.resid)

# Visuelle Inspektion der Linearität
library(car)
crPlots(glm.1, ask = F)

# Modellgüte (pseudo-R²)
1 - (glm.1$dev / glm.1$null)

# Steilheit der Beziehung in Modellen mit nur einem Parameter
exp(glm.1$coef[2])

# LD50 für 1-Parameter-Modelle (hier also x-Werte, bei der 50% der Inseln besiedelt sind)
-glm.1$coef[1] / glm.1$coef[2]

# Ergebnisplots
par(mfrow = c(1, 1))

xs <- seq(0, 70, l = 1000)
glm.predict <- predict(glm.1, type = "response", se = T, newdata = data.frame(RATIO=xs))

plot(PA~RATIO, data = polis, xlab = "Umfang-Flächen-Verhältnis", ylab = "Vorkommenswahrscheinlichkeit", pch = 16, col = "red")
     points(glm.predict$fit ~ xs,type="l")
     lines(glm.predict$fit + glm.predict$se.fit ~ xs, type = "l", lty = 2)
     lines(glm.predict$fit - glm.predict$se.fit ~ xs, type = "l", lty = 2)

```{.r .distill-force-highlighting-css}
```
