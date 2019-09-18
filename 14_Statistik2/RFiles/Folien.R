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

par(mfrow = c(2,2)) 
plot(lm(b~a,blumen_sorte))

