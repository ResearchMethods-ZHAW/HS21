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
