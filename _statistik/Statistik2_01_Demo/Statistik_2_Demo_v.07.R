#__________________________________________________________________________
# Research Methods, Teil Statistik
# Statistik 2: Demo
# Statistik_2_Demo.R | Version 0.7
#__________________________________________________________________________


# t-test als ANOVA --------------------------------------------------------
a <- c(20, 19, 25, 10, 8, 15, 13 ,18, 11, 14)
b <- c(12, 15, 16, 7, 8, 10, 12, 11, 13, 10)

blume <- data.frame(cultivar = c(rep("a", 10), rep("b" , 10)), size = c(a, b))

par(mfrow=c(1,1))
boxplot(size~cultivar, xlab = "Sorte", ylab = "Bluetengroesse [cm]", data = blume)

t.test(size~cultivar, blume, var.equal = T)

aov(size~cultivar, data = blume)
summary(aov(size~cultivar, data = blume))
summary.lm(aov(size~cultivar, data = blume))


# Echte ANOVA -------------------------------------------------------------
c <- c(30, 19, 31, 23, 18, 25, 26, 24, 17, 20)
blume2 <- data.frame(cultivar = c(rep("a", 10), rep("b", 10), rep("c", 10)), size = c(a, b, c))
blume2$cultivar <- as.factor(blume2$cultivar)

summary(blume2)             
head(blume2)

par(mfrow=c(1,1))
boxplot(size~cultivar, xlab = "Sorte", ylab = "Blütengrösse [cm]", data = blume2)

aov(size~cultivar, data = blume2)
summary(aov(size~cultivar, data = blume2))
summary.lm(aov(size~cultivar, data = blume2))

aov.1 <- aov(size~cultivar, data = blume2)
summary(aov.1)
summary.lm(aov.1)

# Berechnung Mittelwerte usw. zur Charakterisierung der Gruppen
aggregate(size~cultivar, blume2, function(x) c(Mean = mean(x), SD = sd(x), Min = min(x), Max = max(x)))

lm.1 <- lm(size~cultivar, data = blume2)
summary(lm.1)

#Tukeys Posthoc-Test
if(!require(agricolae)){install.packages("agricolae")}
library(agricolae)

HSD.test(aov.1, "cultivar", group = FALSE, console = T)

#Beispiel Posthoc-Labels in Plot
aov.2 <- aov(Sepal.Width ~ Species, data = iris)
HSD.test(aov.2, "Species", console = T)
boxplot(Sepal.Width ~ Species, data = iris)
boxplot(Sepal.Width ~ Species, ylim = c(2, 5), data = iris)
text(1, 4.8, "a")
text(2, 4.8, "c")
text(3, 4.8, "b")

library(tidyverse)
ggplot(iris, aes(Species, Sepal.Width)) + geom_boxplot(size = 1) +
  annotate("text", y = 5, x = 1:3, label = c("a", "c", "b"))


# Klassische Tests der Modellannahmen (NICHT EMPFOHLEN!!!)  --------
shapiro.test(blume2$size[blume2$cultivar == "a"])
shapiro.test(blume2$a)


var.test(blume2$size[blume2$cultivar == "a"], blume2$size[blume2$cultivar == "b"])

if(!require(car)){install.packages("car")}
library(car)
leveneTest(blume2$size[blume2$cultivar == "a"], blume2$size[blume2$cultivar == "b"], center=mean)

wilcox.test(blume2$size[blume2$cultivar == "a"], blume2$size[blume2$cultivar == "b"])


# Nicht-parametrische Alternativen, wenn Modellannahmen der ANVOA  --------

# Zum Vergleich normale ANOVA noch mal

summary(aov(size~cultivar, data = blume2))

# Bei starken Abweichungen von der Normalverteilung, aber ähnlichen Varianzen
# Kruskal-Wallis-Test
kruskal.test(size~cultivar, data = blume2)
if(!require(FSA)){install.packages("FSA")} 
library(FSA)
dunnTest(size~cultivar, method = "bh", data = blume2) # korrigierte p-Werte nach Bejamini-Hochberg


#Bei erheblicher Heteroskedastizitaet, aber relative normal/symmetrisch verteilten Residuen

#Welch-Test
oneway.test(size~cultivar, var.equal = F, data = blume2)


# 2-faktorielle ANOVA -----------------------------------------------------
d <- c(10, 12, 11, 13, 10, 25, 12, 30, 26, 13)
e <- c(15, 13, 18, 11, 14, 25, 39, 38, 28, 24)
f <- c(10, 12, 11, 13, 10, 9, 2, 4, 7, 13)

blume3 <- data.frame(cultivar=c(rep("a", 20), rep("b", 20), rep("c", 20)),
                   house = c(rep(c(rep("yes", 10), rep("no", 10)), 3)),
                  size = c(a, b, c, d, e, f))
blume3

boxplot(size~cultivar + house, data = blume3)

summary(aov(size~cultivar + house, data = blume3))
summary(aov(size~cultivar + house + cultivar:house, data = blume3)) 
#Kurzschreibweise: "*" bedeutet, dass Interaktion zwischen cultivar und house eingeschlossen wird
summary(aov(size~cultivar * house, data = blume3)) 
summary.lm(aov(size~cultivar + house, data = blume3))


interaction.plot(blume3$cultivar, blume3$house, blume3$size)
interaction.plot(blume3$house, blume3$cultivar, blume3$size)

anova(lm(blume3$size~blume3$cultivar*blume3$house), lm(blume3$size~blume3$cultivar + blume3$house))
anova(lm(blume3$size~blume3$house), lm(blume3$size~blume3$cultivar * blume3$house))


# Korrelationen -----------------------------------------------------------

library(car)

blume <- data.frame(a, b)
scatterplot(a~b, blume)

cor.test(a, b, method = "pearson", data = blume)
cor.test(a, b, method = "spearman", data = blume)
cor.test(a, b, method = "kendall", data = blume) 

#Jetzt als Regression
lm.2 <- lm(b~a)
anova(lm.2)
summary(lm.2)

#Model II-Regression
if(!require(lmodel2)){install.packages("lmodel2")} 
library(lmodel2)
lmodel2(b~a)

# Beispiele Modelldiagnostik ----------------------------------------------

par(mfrow=c(2, 2)) # 4 Plots in einem Fenster
plot(lm(b~a))

if(!require(ggfortify)){install.packages("ggfortify")}
library(ggfortify)
autoplot(lm(b~a))

# Modellstatistik nicht OK
g <- c(20, 19, 25, 10, 8, 15, 13, 18, 11, 14, 25, 39, 38, 28, 24)
h <- c(12, 15, 10, 7, 8, 10, 12, 11, 13, 10, 25, 12, 30, 26, 13)
par(mfrow = c(1, 1))

plot(h~g,xlim = c(0, 40), ylim = c(0, 30))
abline(lm(h~g))

par(mfrow = c(2, 2))
plot(lm(h~g))

# Modelldiagnostik mit ggplot
df <- data.frame(g, h)
ggplot(df, aes(x = g, y = h)) + 
    # scale_x_continuous(limits = c(0,25)) +
    # scale_y_continuous(limits = c(0,25)) +
    geom_point() +
    geom_smooth( method = "lm", color = "black", size = .5, se = F) + 
    theme_classic()

par(mfrow=c(2, 2))
autoplot(lm(h~g))
