library(tidyverse)
library(ggfortify) # um autoplot() für lm/aov nutzen zu können



partridge <- read_csv("14_Statistik2/data/partridge.csv")


partrigdge.aov <- aov(LONGEV ~ THORAX+TREATMENT, partridge)


autoplot(partrigdge.aov)

partrigdge.aov.log10 <- aov(log10(LONGEV) ~ THORAX+TREATMENT, partridge)

autoplot(partrigdge.aov.log10)

ggplot(partridge, aes(THORAX,LONGEV)) +
  geom_point() +
  scale_y_log10() +
  facet_wrap(~TREATMENT) +
  geom_smooth(method = "lm", se = F)

anova(aov(log10(LONGEV) ~ THORAX * TREATMENT, partridge))
ggplot(partridge, aes(THORAX,log10(LONGEV), colour = TREATMENT)) +
  geom_point(aes(pch = TREATMENT)) +
  geom_smooth(method = "lm", se = F, aes(lty = TREATMENT)) +
  labs(y = expression(paste(log[10]*LONGEV)))

anova(aov(THORAX ~ TREATMENT, partridge))
partridge$TREATMENT <- as.factor(partridge$TREATMENT)
contrasts(partridge$TREATMENT) <- cbind(c(0, 0.5, 0.5, -0.5,-0.5), c(0, 0, 0, 1, -1))


round(crossprod(contrasts(partridge$TREATMENT)), 1)

partridge.aov <- aov(log10(LONGEV) ~ THORAX +TREATMENT,partridge)


## library(biology)
## AnovaM(partridge.aov, type = "III", split = list(TREATMENT = list('PregvsVirg'=1,'1Virgvs8Virg'=2)))
## Df Sum Sq Mean Sq
## THORAX 1 1.01749 1.01749
## TREATMENT 4 0.78272 0.19568
## TREATMENT: Preg vs Virg 1 0.54203 0.54203
## TREATMENT: 1 Virg vs 8 Virg 1 0.19934 0.19934
## Residuals 119 0.83255 0.00700
## F value Pr(>F)
## THORAX 145.435 < 2.2e-16
## TREATMENT 27.970 2.231e-16
## TREATMENT: Preg vs Virg 77.474 1.269e-14
## TREATMENT: 1 Virg vs 8 Virg 28.492 4.567e-07
## Residuals
## THORAX ***
## TREATMENT ***
## TREATMENT: Preg vs Virg ***
## TREATMENT: 1 Virg vs 8 Virg ***
## Residuals
## ---
## Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
ggplot(partridge, aes(THORAX,LONGEV, colour = TREATMENT)) +
  geom_point(aes(pch = TREATMENT)) +
  scale_y_log10(breaks = seq(0,100,20)) +
  geom_smooth(method = "lm", se = F, aes(lty = TREATMENT)) +
  labs(y = expression(paste(log[10]*LONGEV))) 
