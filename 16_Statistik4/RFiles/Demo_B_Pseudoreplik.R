library(tidyverse)


rats <- read_csv("16_Statistik4/data/rats.csv")

names(rats)

rats <- rats %>%
  mutate(
    Treatment = factor(Treatment),
    Rat = factor(Rat),
    Liver = factor(Liver)
  )

# this is the wrong way to do the analysis

model <- aov(Glycogen~Treatment,rats)
summary(model)

# this is the right way to do the analysis
rats_smry <- rats %>%
  group_by(Treatment,Rat) %>%
  summarise(Glyco_mean = mean(Glycogen))


model <- aov(Glyco_mean~Treatment,rats_smry)
summary(model)


# variance components analysis

model2 <- aov(Glycogen~Treatment+Error(Treatment/Rat/Liver),data = rats)
summary(model2)

qf(0.95,2,3)
