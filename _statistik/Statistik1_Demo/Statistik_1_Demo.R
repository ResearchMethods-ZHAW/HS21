binom.test(43, 100) #In Klammern übergibt man die Anzahl der Erfolge und die Stichprobengrösse
binom.test(57, 100)

qchisq(0.95, 1)

count <- matrix(c(38, 14, 11, 51), nrow = 2)
count
chisq.test(count)
fisher.test(count)

a <- c(20, 19, 25, 10, 8, 15, 13, 18, 11, 14)
b <- c(12, 15, 16, 7, 8, 10, 12, 11, 13, 10)
blume<-data.frame(a, b)
blume
summary(blume)
boxplot(blume$a, blume$b)
boxplot(blume)
hist(blume$a)
hist(blume$b)

t.test(blume$a, blume$b)

t.test(blume$a, blume$b, alternative = "greater") #einseitig
t.test(blume$a, blume$b, alternative = "less") #einseitig

t.test(blume$a, blume$b, var.equal = T) #Varianzen gleich, klassischer t-Test
t.test(blume$a, blume$b, var.equal = F) #Varianzen ungleich, Welch's t-Test, ist auch default, d.h. wenn var.equal nicht                        # definiert wird, wird ein Welch's t-Test ausgeführt. 

t.test(blume$a, blume$b, paired = T)
t.test(blume$a, blume$b, paired = T, alternative="greater")

shapiro.test(blume$b)
var.test(blume$a, blume$b)
if(!require(car)){install.packages("car")} # installiert das Zusatzpacket car (wenn nicht bereits installiert)
library(car)
leveneTest(blume$a, blume$b, center=mean)
wilcox.test(blume$a, blume$b)

cultivar <- c(rep("a", 10), rep("b", 10))
size <- c(a,b)
blume.long <- data.frame(cultivar, size)

rm(size) #Befehl rm entfernt die nicht mehr benötitgten Objekte aus dem Workspace
rm(cultivar)


rm(size) #Befehl rm entfernt die nicht mehr benötitgten Objekte aus dem Workspace
rm(cultivar)

blume.long <- data.frame(cultivar=c(rep("a", 10), rep("b", 10)), size=c(a, b))
summary(blume.long)             
head(blume.long)

boxplot(size~cultivar, data = blume.long)

t.test(size~cultivar, blume.long, var.equal = T)
t.test(size~cultivar, blume.long, var.equal = F)


library(tidyverse)
ggplot(blume.long, aes(cultivar, size)) + geom_boxplot()
ggplot(blume.long, aes(cultivar, size)) + geom_boxplot() + theme_classic()
ggplot(blume.long, aes(cultivar, size)) + geom_boxplot(size = 1) + theme_classic()+
theme(axis.line = element_line(size=1)) + theme(axis.title = element_text(size = 14))+
theme(axis.text = element_text(size=14))
ggplot(blume.long, aes(cultivar,size)) + geom_boxplot(size=1) + theme_classic()+
  theme(axis.line = element_line(size = 1), axis.ticks = element_line(size = 1), 
       axis.text = element_text(size = 20), axis.title = element_text(size = 20))

mytheme <- theme_classic() + 
  theme(axis.line = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 20, color = "black"), 
        axis.title = element_text(size = 20, color = "black"), 
        axis.ticks = element_line(size = 1, color = "black"), 
        axis.ticks.length = unit(.5, "cm"))

ggplot(blume.long, aes(cultivar, size)) + 
  geom_boxplot(size = 1) +
  mytheme

t_test <- t.test(size~cultivar, blume.long)

ggplot(blume.long, aes(cultivar, size)) + 
  geom_boxplot(size = 1) + 
  mytheme +
  annotate("text", x = "b", y = 24,
  label = paste0("italic(p) == ", round(t_test$p.value, 3)), 
  parse = TRUE, size = 8)

ggplot (blume.long, aes(cultivar,size)) + 
  geom_boxplot(size = 1) + 
  mytheme +
  labs(x = "Cultivar", y = "Size (cm)")

```{.r .distill-force-highlighting-css}
```
