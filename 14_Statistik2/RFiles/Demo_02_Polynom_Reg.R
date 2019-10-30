

library(tidyverse)
library(ggfortify) # um autoplot() für lm/aov nutzen zu können

mytilus <- read_csv("14_Statistik2/data/mytilus.csv")
ggplot(mytilus, aes(DIST,asin(sqrt(LAP))*180/pi))+
  geom_point() +
  geom_smooth(se = F, colour = "black") +
  geom_smooth(method = "lm", se = F, lty = 2, colour = "black")
autoplot(lm(asin(sqrt(LAP))*180/pi~DIST, data=mytilus),which = 1)
mytilus.lm5 <- lm(asin(sqrt(LAP)) * 180/pi ~ DIST + I(DIST^2)+I(DIST^3)+I(DIST^4)+I(DIST^5), mytilus)

plot(mytilus.lm5, which = 1)


autoplot(mytilus.lm5, label.size = 3)

anova(mytilus.lm5)
mytilus.lm1 <- lm(asin(sqrt(LAP)) * 180/pi ~ DIST, mytilus)
mytilus.lm2 <- lm(asin(sqrt(LAP)) * 180/pi ~ DIST + I(DIST^2),mytilus)

anova(mytilus.lm2, mytilus.lm1)



mytilus.lm3 <- lm(asin(sqrt(LAP)) * 180/pi ~ DIST + I(DIST^2)+I(DIST^3), mytilus)
anova(mytilus.lm3, mytilus.lm2)
summary(mytilus.lm3)
ggplot(mytilus, aes(DIST,asin(sqrt(LAP))*180/pi))+
  geom_point() +
  geom_smooth(se = F, colour = "black") +
  labs(y = expression(paste("Arcsin ",sqrt(paste("freq. of allele ", italic("Lap"))^{94}))), x = expression(paste("Miles east of Southport,Connecticut")))
