library(car)
library(tidyverse)

library(ggfortify)

select <- dplyr::select


# Chi-Quadrat-Test

# Ermitteln des kritischen Wertes für 95 perzentile und 1 FG
qchisq(0.95,1)



# Datensatz von Folie 28: Test auf Assoziation zwischen zwei kategorialen Variablen
# Frage: Wie hängen zwei Eigenschaften des gleichen Objektes zusammen?

count <- matrix(c(38,14,11,51),nrow=2)

count

dimnames(count) <- list(c("helle_haare","hunkle_haare"),c("blaue_augen","braune_augen"))

count

chisq.test(count)

chisq.test(count,correct = F)

fisher.test(count)

# Datensatz "Blumen" erstellen für t-Test

blume <-data.frame(
  sorte_a = c(20,19,25,10,8,15,13,18,11,14),
  sorte_b = c(12,15,16,7,8,10,12,11,13,10)
  )

blume
summary(blume)




boxplot(blume$sorte_a,blume$sorte_b)

hist(blume$sorte_a)

hist(blume$sorte_b)

t.test(blume$sorte_a,blume$sorte_b) #zweiseitig
t.test(blume$sorte_a,blume$sorte_b, alternative="greater") #einseitig
t.test(blume$sorte_a,blume$sorte_b, alternative="less") #einseitig
t.test(blume$sorte_a,blume$sorte_b, var.equal=T) #Varianzen gleich, klassischer t-Test
t.test(blume$sorte_a,blume$sorte_b, var.equal=F) #Varianzen ungleich, Welch's t-Test, ist auch default
t.test(blume$sorte_a,blume$sorte_b, paired=T) #gepaarter t-Test 
t.test(blume$sorte_a,blume$sorte_b, paired=T,alternative="greater") #gepaarter t-Test 

shapiro.test(blume$sorte_b)

wilcox.test(blume$sorte_a,blume$sorte_b)

# T-Tests mit einer langen (long) Tabelle

# breit zu long mit tidyr::gather

blume_long <- gather(blume,sorte,groesse)

# Für eine Long table können wir auch gut ggplot verwenden

ggplot(blume_long, aes(sorte, groesse)) +
  geom_boxplot()

ggplot(blume_long, aes(groesse)) +
  geom_histogram(binwidth = 1, colour = "white")

ggplot(blume_long, aes(groesse)) +
  geom_histogram(binwidth = 2, colour = "white")+
  facet_grid(sorte~.)

ggplot(blume_long, aes(groesse, fill = sorte)) +
  geom_density(alpha = 0.5)




t.test(groesse~sorte, blume_long)

# Optionen "alternative" und "var.equal" werden angepasst analog der "wide" table

# Randomisierung

beetles <- read_delim("13_Statistik1/data/beetle.csv", ",")


ggplot(beetles, aes(SIZE, BEETLES)) +
  geom_boxplot()


ggplot(beetles, aes(SIZE, sqrt(BEETLES))) +
  geom_boxplot()


ggplot(beetles, aes(SIZE, BEETLES)) +
  geom_boxplot() +
  scale_y_sqrt()


# extract specific inidies from t-test
stat <- function(data, indices) {
  t.test <- t.test(BEETLES~SIZE, data)$"stat"
  t.test
}


# Random generator auf der Basis eines Datensatzes
rand.gen <- function(data,mle) {
  out <- data
  out$SIZE <- sample(out$SIZE, replace=F)
  out
}


library(boot)

# boot(): bootstrap resampling

beetles.boot <- boot(data = beetles,
                     statistic = stat, 
                     R=5000, 
                     sim="parametric", 
                     ran.gen=rand.gen)


print(beetles.boot)



plot(beetles.boot)



tval <- length(beetles.boot[beetles.boot$t >= abs(beetles.boot$t0)])+1

tval

tval/(beetles.boot$R + 1)


# F-Test

var.test(blume$sorte_a,blume$sorte_b)
var.test(groesse~sorte, blume_long)


# Levene Test 

library(car)
leveneTest(blume$sorte_a,blume$sorte_b,center=mean)
leveneTest(groesse~sorte, blume_long)


# Visuelle Inspektion

sleep <- msleep %>%
  filter(vore %in% c("carni","herbi")) %>%
  dplyr::select(name,vore,bodywt)


ggplot(sleep, aes(vore, bodywt, group = vore)) +
  geom_boxplot()


sleep <- sleep %>%
  mutate(
    bodywt_log10 = log10(bodywt),
    bodywt_sqrt = sqrt(bodywt),
    bodywt_4throot = bodywt^0.25
  ) %>%
  gather(key,val, -c(name,vore))

sleep


ggplot(sleep, aes(vore, val, group = vore)) +
  geom_boxplot() +
  facet_wrap(~key, scales = "free_y")





# ANOVA mit "Blumen"-Daten

ggplot(blume_long, aes(sorte, groesse)) +
  geom_boxplot()

t.test(groesse~sorte, blume_long, var.equal=T)

#now as ANOVA

aov(groesse~sorte,blume_long)
summary(aov(groesse~sorte,blume_long)) #F-value = 4.325
summary.lm(aov(groesse~sorte,blume_long))

lm(groesse~sorte,blume_long)
summary(lm(groesse~sorte,blume_long))

# Compare the above results of t.test, aov and lm and how the relevant data are displayed

# Now check with the F-distribution:
# What would have been the critical value for a significant result at p < 0.05?

qf(0.95,1,18)

# which is the p-value associated with the obtained F-value?

1-pf(4.325,1,18) #probability of obtaining F=4,325 or greater

## Optional für Demo

#overall mean and residuals

blume_long$index <- 1:20

blume_long <- blume_long %>%
  group_by(sorte) %>%
  mutate(
    mean = mean(groesse)
  )

ggplot(blume_long, aes(index,groesse)) +
  geom_point() +
  geom_hline(aes(yintercept =  mean(groesse))) +
  geom_segment(aes(x = index,y = groesse,xend = index,yend = mean(groesse))) +
  labs(x = "Order",y = expression(Size~(cm^2)))

#group means and residuals

ggplot(blume_long, aes(index,groesse, colour = sorte)) +
  geom_point() +
  geom_hline(aes(yintercept = mean)) +
  geom_segment(aes(x = index,y = groesse,xend = index,yend = mean)) +
  labs(x = "Order",y = expression(Size~(cm^2))) +
  facet_grid(~sorte)



library(ggfortify)

autoplot(aov(groesse~sorte, blume_long))

# impact of zinc contamination (and other heavy metals) on the diversity of diatom species in the USA Rocky Mountains

medley <- read_delim("13_Statistik1/data/medley.csv", ",")


# Reorganize the levels of the categorical factor into a more logical order

medley$ZINC <- factor(medley$ZINC, levels=c("BACK", "LOW", "MED","HIGH"), ordered=T)


# Assess normality/homogeneity of variance using boxplot of species diversity against zinc group

ggplot(medley, aes(ZINC, DIVERSITY)) +
  geom_boxplot()

# Assess homogeneity of variance assumption with a table and/or plot of mean vs variance

medley_sry <- medley %>%
  group_by(ZINC) %>%
  summarise(
    mean = mean(DIVERSITY),
    var = var(DIVERSITY),
    sd = sd(DIVERSITY)
  )

ggplot(medley_sry, aes(mean,var)) +
  geom_point()
