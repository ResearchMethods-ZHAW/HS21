load("Doubs.RData")
summary(env)
summary(spe)

# Die Dataframes env und spe enthalten die Umwelt- respective die Artdaten

if(!require(vegan)){install.packages("vegan")}
library("vegan")

env.pca <- rda(env, scale = TRUE)
env.pca
# In env.pca sieht man, dass es bei 11 Umweltvariablen logischerweise 11 orthogonale Principle Components gibt

summary(env.pca, axes = 0)

# Hier sieht man auch die Übersetzung der Eigenvalues in erklärte Varianzen der einzelnen Principle Components

summary(env.pca)
# Hier das ausführliche Summary mit den Art- und Umweltkorrelationen auf den ersten sechs Achsen

screeplot(env.pca, bstick = TRUE, npcs = length(env.pca$CA$eig))
# Visualisierung der Anteile erklärter Varianz, auch im Vergleich zu einem Broken-Stick-Modell

par(mfrow = c(2, 2))
biplot(env.pca, scaling = 1)
biplot(env.pca, choices = c(1, 3), scaling = 1)
biplot(env.pca, choices = c(1, 4), scaling = 1)

#Wir extrahieren nun die ersten vier PC-Scores aller Aufnahmeflächen

scores <- scores(env.pca, c(1:4), display = c("sites"))
scores

#Berechnung der Artenzahl mittels specnumber; Artenzahl und Scores werden zum Dataframe für die Regressionsanalyse hinzugefügt
doubs <- data.frame(env, scores, species_richness = specnumber(spe))
doubs
str(doubs)

##Lösung mit lm (alternativ ginge Poisson-glm) und frequentist approach (alternativ ginge Multimodelinference mit AICc)
lm.pc.0 <- lm(species_richness ~ PC1 + PC2 + PC3 + PC4, data = doubs)
summary(lm.pc.0)

# Modellvereinfachung: PC4 ist nicht signifikant und wird entfernt
lm.pc.1 <- lm(species_richness ~ PC1 + PC2 + PC3, data = doubs)
summary(lm.pc.1) # jetzt sind alle Achsen signifikant und werden in das minimal adäquate Modell aufgenommen

# Modelldiagnostik/Modellvalidierung
par(mfrow = c(2, 2))
plot(lm.pc.1) 

glm.pc.1 <- glm(species_richness ~ PC1 + PC2 + PC3 + PC4, family = "poisson", data = doubs)
summary(glm.pc.1)
glm.pc.2 <- glm(species_richness ~ PC1 + PC2 + PC3, family = "poisson", data = doubs)
summary(glm.pc.2)
par(mfrow = c(2, 2))
plot(glm.pc.2) # sieht nicht besser aus als LM, die Normalverteilung ist sogar schlechter

# Korrelationen zwischen Prädiktoren
cor <- cor(doubs[, 1:11])
cor[abs(cor)<.7] <- 0
cor 

# Globalmodell (als hinreichend unabhängige Variablen werden ele, slo, pH und pho aufgenommen)
lm.orig.1 <- lm(species_richness ~ ele + slo + pH + pho, data = doubs)
summary(lm.orig.1)

# Modellvereinfachung: slo als am wenigsten signifikante Variable gestrichen
lm.orig.2 <- lm(species_richness ~ ele + pH + pho, data = doubs)
summary(lm.orig.2)

# Modellvereinfachung: pH ist immer noch nicht signifikant und wird gestrichen
lm.orig.3 <- lm(species_richness ~ ele + pho, data = doubs)
summary(lm.orig.3)

# Modelldiagnostik
par(mfrow = c(2, 2))
plot(lm.orig.3) # nicht so gut, besonders die Bananenform in der linken obereren Abbildung

# Nach Modellvereinfachung bleiben zwei signifikante Variablen, ele und pho.

# Da das nicht so gut aussieht, versuchen wir es mit dem theoretisch angemesseneren Modell, einem Poisson-GLM.

#Versuch mit glm
glm.orig.1 <- glm(species_richness ~ ele + pho + pH + slo, family = "poisson", data = doubs)
summary(glm.orig.1)

glm.orig.2 <- glm(species_richness ~ ele + pho + slo, family = "poisson", data = doubs)
summary(glm.orig.2)

glm.orig.3 <- glm(species_richness ~ ele + pho, family = "poisson", data = doubs)
summary(glm.orig.3)
plot(glm.orig.3)

# Das sieht deutlich besser aus als beim LM. Wir müssen aber noch prüfen, ob evtl. Overdispersion vorliegt.

if(!require(AER)){install.packages("AER")}
library(AER)
dispersiontest(glm.orig.3) #signifikante Überdispersion

# Ja, es gibt signifikante Overdispersion (obwohl der Dispersionparameter sogar unter 2 ist, also nicht extrem). Wir können nun entweder quasipoisson oder negativebinomial nehmen.

glmq.orig.3 <- glm(species_richness ~ ele + pho, family = "quasipoisson", data = doubs)
summary(glmq.orig.3)

# Parameterschätzung bleiben gleich, aber Signifikanzen sind niedriger als beim GLM ohne Overdispersion.
plot(glmq.orig.3)
```{.r .distill-force-highlighting-css}
```
