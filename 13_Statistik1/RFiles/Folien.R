sorteA = c(20, 19, 25, 10, 8, 15, 13, 18, 11, 14) 
sorteB = c(12, 15, 16, 7, 8, 10, 12, 11, 13, 10)

mean(sorteA)
mean(sorteB)

mean(sorteA) - mean(sorteB)

sorteA = c(15, 19, 12, 10, 8, 5, 9, 18, 8, 14) 
sorteB = c(12, 13, 15, 6, 8, 10, 12, 5, 13, 10) 

mean(sorteA)
mean(sorteB)

mean(sorteA) - mean(sorteB)

sorteA = c(15, 19, 12, 9, 8, 10, 13, 15, 5, 16) 
sorteB = c(16, 15, 16, 9, 8, 10, 12, 13, 13, 10)

mean(sorteA)
mean(sorteB)

mean(sorteA) - mean(sorteB)


sorteA = c(15, 19, 12, 9, 8, 5, 13, 15, 5, 7) 
sorteB = c(16, 15, 16, 9, 12, 10, 12, 13, 13, 15)

mean(sorteA)
mean(sorteB)

mean(sorteA) - mean(sorteB)
haar_augen <- data.frame( 
  row.names = c("Helle Haare", "Dunkle Haare"),
  Blaue_Augen = c(38,11),
  Braune_Augen = c(14,51)
  )

haar_augen

qchisq(0.95,1)

count <- as.matrix(haar_augen)

chisq.test(count)
count <- matrix(c(3,5,9,1),nrow=2)
count
fisher.test(count)
blumen_sorte <- data.frame(
  a = c(20, 19, 25, 10, 8, 15, 13, 18, 11, 14),
  b = c(12, 15, 16, 7, 8, 10, 12, 11, 13, 10)
)
t.test(blumen_sorte$a,blumen_sorte$b,var.equal = T)
t.test(blumen_sorte$a,blumen_sorte$b,var.equal = F)

t.test(blumen_sorte$a,blumen_sorte$b)

t.test(blumen_sorte$a,blumen_sorte$b) # Zweiseitig


t.test(blumen_sorte$a,blumen_sorte$b,alternative = "greater") # Zweiseitig

t.test(blumen_sorte$a,blumen_sorte$b, alternative = "less") # Zweiseitig

blumen_jahr <- data.frame(
  jahr1 = c(20, 19, 25, 10, 8, 15, 13, 18, 11, 14),
  jahr2 = c(12, 15, 16, 7, 8, 10, 12, 11, 13, 10)
)

testRes <- t.test(blumen_jahr$jahr1,blumen_jahr$jahr2, paired=T) #gepaarter t-Test

testRes

knitr::kable(broom::tidy(testRes))
shapiro.test(blumen_sorte$a)
var.test(blumen_sorte$a,blumen_sorte$b)
library(car)
leveneTest(blumen_sorte$a,blumen_sorte$b,center=mean)

boxplot(blumen_sorte$a,blumen_sorte$b)

hist(blumen_sorte$a)

hist(blumen_sorte$b)


wilcox.test(blumen_sorte$a,blumen_sorte$b)
#siehe R-code im praktischen Teil
library(tidyverse)

blumen_long <- blumen_sorte %>%
  gather(cultivar,size)

blumen_long %>%
  group_by(cultivar) %>%
  mutate(index = row_number()) %>%
  mutate(group_mean = mean(size)) %>%
  ungroup() %>%
  mutate(overall_mean = mean(size)) %>%
  ggplot(aes(colour = cultivar)) +
  geom_point(aes(index,size))  +
  geom_hline(aes(colour = cultivar,yintercept = group_mean)) +
  geom_hline(aes(colour = "Overall mean",yintercept = overall_mean)) +
  facet_grid(~cultivar) +
  labs(colour = "Legend") +
  geom_segment(aes(x = index,y = size,xend = index, yend = group_mean))
t.test(size~cultivar, blumen_long, var.equal=T)
summary(aov(size~cultivar,blumen_long))
set.seed(1)

sorteC <- data.frame(cultivar = rep("c",10),size = as.integer(rnorm(10,17,5)),stringsAsFactors = F)

blumen_long <- bind_rows(blumen_long,sorteC)


summary(aov(size~cultivar,blumen_long))

