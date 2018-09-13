weight <- read_csv("14_Statistik2/data/growth.csv")

weight_smry <- weight %>% 
  group_by(diet, supplement) %>%
  summarise(
    mean = mean(gain)
  )


ggplot(weight_smry, aes(diet, mean, fill = diet)) +
  geom_bar(stat = "identity") +
  facet_grid(.~supplement) +
  scale_fill_grey(guide = F) 
model <- aov(gain~diet*supplement,weight)
summary(model)

weight %>%
  group_by(diet, supplement) %>%
  summarise(
    n = n()
  ) %>%
  spread(supplement, n)


weight_smry <- weight %>% 
  group_by(diet, supplement) %>%
  summarise(
    n = n(),
    mean = mean(gain),
    se = sqrt(1.72/n)

  )


ggplot(weight_smry, aes(diet, mean, fill = diet)) +
  geom_bar(stat = "identity") +
  facet_grid(.~supplement) +
  scale_fill_grey(guide = F)  +
  geom_errorbar(aes(ymin = mean-se, ymax = mean+se),width = 0.2) 


summary.lm(model)
model <- lm(gain~diet+supplement,weight)
summary(model )
supp2 <- factor(weight$supplement)


weight <- weight %>%
  mutate(
    supplement2 = ifelse(supplement %in% c("agrimore","supersupp"),"best","worst")
  )


model2 <- lm(gain~diet+supplement2,weight)
anova(model ,model2)
summary(model2)
