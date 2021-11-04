decay <- read.delim("decay.csv",sep = ",")
decay

summary(decay)
str(decay)

boxplot(decay$time)
boxplot(decay$amount)
plot(amount~time, data=decay)

lm.1 <- lm(amount~time, data = decay)
summary(lm.1)

par(mfrow = c(2, 2))
plot(lm.1)

par(mfrow = c(1, 1))
plot(decay$time, decay$amount)
abline(lm.1, col = "red")

par(mfrow = c(1, 2))
boxplot(decay$amount)
boxplot(log(decay$amount))
hist(decay$amount)
hist(log(decay$amount))

lm.2 <- lm(log(amount)~time, data = decay)
summary(lm.2)

par(mfrow = c(2, 2))
plot(lm.2)

model.quad <- lm(amount~time + I(time^2), data=  decay)
summary(model.quad)

anova(lm.1, model.quad)

par(mfrow = c(2, 2))
plot(model.quad)

model.nls <- nls(amount~a*exp(-b*time), start=(list(a = 100, b = 1)),data = decay)
summary(model.nls)

if(!require(nlstools)){install.packages("nlstools")}
library(nlstools)
residuals.nls <- nlsResiduals(model.nls)
plot(residuals.nls)

par(mfrow = c(1, 1))
xv <- seq(0, 30, 0.1)

plot(decay$time, decay$amount)
yv1 <- exp(predict(lm.2, list(time = xv)))
lines(xv, yv1, col = "red")

plot(decay$time, decay$amount)
yv2 <- predict(model.quad, list(time = xv))
lines(xv, yv2, col=  "blue")

plot(decay$time, decay$amount)
yv3 <- predict(model.nls, list(time = xv))
lines(xv, yv3, col = "green")
```{.r .distill-force-highlighting-css}
```
