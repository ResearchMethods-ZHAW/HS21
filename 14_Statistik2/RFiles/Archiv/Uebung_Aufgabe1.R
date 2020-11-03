library(tidyverse)
library(ggfortify) # um autoplot() für lm/aov nutzen zu können

decay <- read_csv("14_Statistik2/data/decay.csv")

ggplot(decay, aes(time, amount)) +
  geom_point() +
  geom_smooth(method = "lm")

summary(lm(amount~time, decay))
ggplot(decay, aes(time, log(amount))) +
  geom_point() +
  geom_smooth(method = "lm")

model <- lm(log(amount)~time, decay)
summary(model)
upper <- 4.547386 + 0.100295
lower <- 4.547386 - 0.100295
exp(upper)
exp(lower)
exp(4.547386)
autoplot(model)

fun.1 <- function(x){94.38536 * exp(-0.068528 * x)}


ggplot(decay, aes(time, amount)) +
  geom_point() +
  stat_function(fun = fun.1)
df <- data.frame(x = 0:10)

ggplot(df) +
  lims(x= c(0,10), y = c(4,14)) +
  stat_function(fun = function(x)4+2*x-0.1*x^2, col = "blue") +
  stat_function(fun = function(x)4+2*x-0.2*x^2, col = "green") +
  stat_function(fun = function(x)12-4*x+0.3*x^2, col = "red") +
  stat_function(fun = function(x)4+0.5*x+0.1*x^2, col = "yellow")



model2 <- lm(amount~time, decay)
model3 <- lm(amount~time+I(time^2), decay)
summary(model3)



