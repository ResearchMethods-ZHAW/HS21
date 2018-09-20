library(broom)
library(tidyverse)
haar_augen <- data.frame( 
  row.names = c("Helle Haare", "Dunkle Haare"),
  Blaue_Augen = c(38,11),
  Braune_Augen = c(14,51)
  )

fisher.test(haar_augen)

blumen_sorte <- data.frame(
  a = c(20, 19, 25, 10, 8, 15, 13, 18, 11, 14),
  b = c(12, 15, 16, 7, 8, 10, 12, 11, 13, 10)
)
cor.test(~a+b,blumen_sorte,method = "pearson")
cor.test(~a+b,blumen_sorte,method = "spearman")
cor.test(~a+b,blumen_sorte,method = "kendal")

anova(lm(b~a,blumen_sorte))

summary(lm(b~a,blumen_sorte))


plot(blumen_sorte$b~blumen_sorte$a) 
abline(lm(b~a,blumen_sorte))
ggplot(blumen_sorte, aes(a,b)) + 
  geom_point()

anova_tidy <- tidy(lm(b~a,blumen_sorte)) # 


ggplot(blumen_sorte, aes(a,b)) + 
  geom_point() +
  geom_smooth(method = "lm",se = F,lty = "dotted") +
  geom_abline(slope = anova_tidy$estimate[2],intercept = anova_tidy$estimate[1],alpha = 0.4)
