library(tidyverse)
comp <- read_delim("13_Statistik1/data/competition.csv",",")

ggplot(comp, aes(clipping, biomass)) +
  geom_boxplot(fill = "lightgrey") +
  labs(x = "Competition treatment", y = "Biomass")


comp_summary <- comp %>% 
  group_by(clipping) %>%
  summarise(
    mean = mean(biomass)
  )

p <- ggplot(comp_summary, aes(clipping, mean)) +
  geom_bar(stat = "identity")

p
t <- aov(biomass~clipping, comp)

summary(t)

comp_summary <- comp %>% 
  group_by(clipping) %>%
  summarise(
    mean = mean(biomass),
    se = sqrt(4691/n())
  )

comp_summary

ggplot(comp_summary, aes(clipping, mean)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin = mean-se, ymax = mean+se),width = 0.2)








comp_summary <- comp %>% 
  group_by(clipping) %>%
  summarise(
    mean = mean(biomass),
    se = sqrt(4691/n())
  ) %>%
  mutate(
    ci = se*qt(0.975,5)
  )

ggplot(comp_summary, aes(clipping, mean)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin = mean-ci, ymax = mean+ci),width = 0.2)



comp_summary <- comp %>% 
  group_by(clipping) %>%
  summarise(
    mean = mean(biomass),
    se = sqrt(4691/n())
  ) %>%
  mutate(
    ci = se*qt(0.975,5),
    lsd = (qt(0.975,10)*sqrt(2*4961/6))/2
  )


ggplot(comp_summary, aes(clipping, mean)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin = mean-lsd, ymax = mean+lsd),width = 0.2)
