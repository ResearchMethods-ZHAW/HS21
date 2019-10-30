library(tidyverse)
library(ggfortify) # um autoplot() für lm/aov nutzen zu können



nelson <- read_csv("14_Statistik2/data/nelson.csv")


p <- ggplot(nelson, aes(HUMIDITY,WEIGHTLOSS)) +
  geom_point() +
  geom_smooth(se = F)


ggMarginal(p, type = "boxplot",size = 15)

nelson.lm <- lm(WEIGHTLOSS ~HUMIDITY, nelson)


autoplot(nelson.lm, label.size = 3)



influence.measures(nelson.lm)
summary(nelson.lm)
confint(nelson.lm)

predict(nelson.lm, data.frame(HUMIDITY = c(50, 100)), interval="prediction",se=T)

ggplot(nelson, aes(HUMIDITY, WEIGHTLOSS))+
  geom_point() +
  labs(x = "% Relative humidity", y = "Weight loss (mg)") +
  # geom_abline(intercept = nelson.lm$coefficients[1], slope = nelson.lm$coefficients[2], colour = "red") +
  geom_smooth(method = "lm", se = 0.95, lty = 2) +
  annotate("text", x= 99, y= 8.6, label = "WEIGHTLOSS == -0.053*HUMIDITY + 8.704", parse = T, hjust = 1) +
  annotate("text", x= 99, y= 9, label = "r^{2}==0.975", parse = T,hjust = 1) 

