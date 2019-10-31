library(tidyverse)
library(ggfortify) # um autoplot() für lm/aov nutzen zu können


peake <- read.csv("14_Statistik2/data/peake.csv")

p <- ggplot(peake, aes(AREA, INDIV)) +
  geom_point()+
  geom_smooth()

ggMarginal(p, type = "boxplot", size = 10)

p <- p +
  scale_x_log10() +
  scale_y_log10()

ggMarginal(p, type = "boxplot", size = 10)

peake.lm <- lm(INDIV ~ AREA, data = peake)


autoplot(peake.lm, label.size = 3) 


peake.lm <- lm(log10(INDIV) ~ log10(AREA), data = peake)


autoplot(peake.lm, label.size = 3)

peake.lm <- lm(log10(INDIV) ~ log10(AREA), data = peake)

autoplot(peake.lm, label.size = 3)

influence.measures(peake.lm)
summary(peake.lm)


ggplot(peake, aes(AREA, INDIV))+
  geom_point() +
  scale_x_log10()+
  scale_y_log10() +
  labs(x = expression(paste("Mussel clump area (",mm^2,")")), y = "Number of individuals") +
  # geom_abline(intercept = peake.lm$coefficients[1], slope = peake.lm$coefficients[2]) +
  geom_smooth(method = "lm", se = 0.95, lty = 2) +
  annotate("text", x= 30000, y= 30, label = "log[10]*INDIV == 0.835~log[10]*AREA - 0.576", parse = T, hjust = 1) +
  annotate("text", x= 30000, y= 22, label = "r^{2}==0.835", parse = T,hjust = 1)

10^predict(peake.lm, data.frame(AREA = c(8000, 10000)))
10^predict(peake.lm, data.frame(AREA = c(8000, 10000)), interval = "prediction")
