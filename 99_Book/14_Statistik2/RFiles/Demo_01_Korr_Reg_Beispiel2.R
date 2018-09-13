library(tidyverse)

green <- read_csv("14_Statistik2/data/green.csv")



p1 <- green %>%
  filter(SITE == "LS") %>%
  ggplot(aes(TOTMASS,BURROWS)) +
  geom_point() +
  geom_smooth(se = F)

p2 <- green %>%
  filter(SITE == "DS") %>%
  ggplot(aes(TOTMASS,BURROWS)) +
  geom_point() +
  geom_smooth(se = F)

ggMarginal(p1, type = "boxplot",size = 15)
ggMarginal(p2, type = "boxplot",size = 15)

cor.test(~BURROWS + TOTMASS, data = green, subset = SITE == "LS", method="spearman")
cor.test(~BURROWS + TOTMASS, data = green, subset = SITE == "DS",method="spearman")
ggplot(green, aes(BURROWS, TOTMASS)) +
  geom_point() +
  stat_ellipse(geom = "path", level = 0.95) +
  facet_wrap(~SITE)
