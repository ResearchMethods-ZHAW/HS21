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



kormoran <- read_delim("14_Statistik2/data/kormoran.csv", ";")
weight <- read_csv("14_Statistik2/data/growth.csv")




kormoran$Jahreszeit <- factor(kormoran$Jahreszeit, levels = c("F","S","H","W"), ordered = T)


kormoran_smry <- kormoran %>% 
  group_by(Unterart, Jahreszeit) %>%
  summarise(
    mean = mean(Tauchzeit)
  )


ggplot(kormoran_smry, aes(Unterart, mean, fill = Unterart)) +
  geom_bar(stat = "identity") +
  facet_grid(.~Jahreszeit) +
  scale_fill_grey(guide = F) 
model <- aov(gain~diet*supplement,weight)
summary(model)


model <- aov(Tauchzeit~Unterart*Jahreszeit, kormoran)
summary(model)




kormoran %>%
  group_by(Unterart, Jahreszeit) %>%
  summarise(
    n = n()
  ) %>%
  spread(Unterart, n)


kormoran_smry <- kormoran %>% 
  group_by(Unterart, Jahreszeit) %>%
  summarise(
    n = n(),
    mean = mean(Tauchzeit),
    se = sqrt(2.66/n)

  )



ggplot(kormoran_smry, aes(Unterart, mean, fill = Unterart)) +
  geom_bar(stat = "identity") +
  facet_grid(.~Jahreszeit) +
  scale_fill_grey(guide = F) +
  geom_errorbar(aes(ymin = mean-se, ymax = mean+se),width = 0.2) 





summary.lm(model)

model <- lm(Tauchzeit~Unterart+Jahreszeit,kormoran)

summary(model )




kormoran <- kormoran %>%
  mutate(
    Jahreszeit2 = ifelse(Jahreszeit %in% c("F","S"),"1.Halbjahr","2.Halbjahr")
  )

model <- lm(Tauchzeit~Unterart+Jahreszeit,kormoran)
model2 <- lm(Tauchzeit~Unterart+Jahreszeit2,kormoran)


anova(model ,model2)
summary(model2)
