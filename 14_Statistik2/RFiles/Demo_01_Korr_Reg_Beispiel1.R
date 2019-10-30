library(tidyverse)
crabs <- read_csv("14_Statistik2/data/crabs.csv")
library(ggExtra) # damit wir boxplots um den Scatterplot zeichnen können


p <- ggplot(crabs, aes(BODYWT, GILLWT)) +
  geom_point() +
  geom_smooth(method = "loess")


ggMarginal(p, type = "boxplot",size = 15)

cor.test(~GILLWT + BODYWT, crabs)

