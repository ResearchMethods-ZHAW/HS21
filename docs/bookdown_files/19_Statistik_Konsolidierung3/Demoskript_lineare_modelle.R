## ----anova & ancova, message=FALSE-------------------------------------------------------------------------------

d <- mtcars %>% 
    mutate(cyl = as.factor(cyl)) %>% 
    slice(-31)

# schaue daten zuerst mal an
#1. Responsevariable
hist(d$hp) # nur sinnvoll bei grossem n
boxplot(d$hp)


#2. Responsevariable ~ Prediktorvariable
table(d$cyl) # mögliches probel, da n's unterschiedlich gross
boxplot(d$hp ~ d$cyl) # varianzheterogentität weniger das problem, aber normalverteilung der residuen problematisch

# definiere das modell für eine ein-faktorielle anova
aov.1 <- aov(log10(hp) ~ cyl, data = d)
# par(mfrow = c(2,2))
# plot(aov.1)
summary.lm(aov.1)


#posthoc vergleiche
TukeyHSD(aov.1)


# alternativ welch t.test für ungleiche varianzen
# welch1 <- oneway.test(hp ~ cyl, data = d, var.equal = FALSE)
# posthocTGH(d$hp, d$cyl, method = "games-howell")

# definiere das modell für eine zwei-faktorielle anova
# achtung reihenfolge ist bei anova wichtig: https://stats.stackexchange.com/questions/212496/why-do-p-values-change-in-significance-when-changing-the-order-of-covariates-in
# https://stats.stackexchange.com/questions/13241/the-order-of-variables-in-anova-matters-doesnt-it
aov.2 <- aov(log10(hp) ~ cyl + am, data = d) 
# par(mfrow = c(2,2))
# plot(aov.2)
summary.lm(aov.2)


#frage: beispiel einer ancova? was bräuchte es noch?


# plotte ergebnisse
library(multcomp)

letters <- cld(glht(aov.1, linfct=mcp(cyl="Tukey"))) # achtung mit factorwerten
boxplot(hp ~ cyl, data = d)
mtext(letters$mcletters$Letters, at=1:3)

ggplot(d, aes(x = cyl, y = hp)) +
	stat_boxplot(geom = "errorbar", width = .5) +
  geom_boxplot(size = 1) + 
	annotate("text", x = 1:3, y = 350, label = letters$mcletters$Letters, size = 7) +
  labs(x = "Anzahl Zylinder", y = "Pferdestärke") +
  mytheme




## ----einfache regression, message=FALSE--------------------------------------------------------------------------

# inspiriert von Simon Jackson: http s://drsimonj.svbtle.com/visualising-residuals
d <- mtcars %>%  # klone data set
     slice(-31) # # lösche Maserrati und schaue nochmals Modelfit an

#############
##Daten anschauen
############

# achtung es sind miles per gallon:) beispiel 25 mpg = 9.41 L/100km 
plot(hp ~ mpg, data = d)

# responsevariable anschauen
boxplot(d$hp)

# correlationen uv + av anschauen
# reihenfolge spielt keine rolle
cor(d$mpg, d$hp) # hängen stark zusammen


###################
# einfache regression
##################
model <- lm(hp ~ mpg, data = d)

###############
# Modeldiagnostik
###############

# semi schöne Ergebnisse
autoplot(model) # gitb einige Extremwerte => was tun? (Eingabe/Einlesen 
#überprüfen, Transformation, Extremwerte nur ausschliessen mit guter Begründung)


# erzeuge vorhergesagte werte und residualwerte
d$predicted <- predict(model)   # bilde neue Variable mit geschätzten y-Werten
d$residuals <- residuals(model)

# schaue es dir an, sieht man gut was die Residuen sind
d %<>% 
    dplyr::select(hp, mpg, predicted, residuals)

# schauen wir es uns an
head(d, 4)

#visualisiere residuen
ggplot(d, aes(x = mpg, y = hp)) +
  # verbinde beobachtete werte mit vorausgesagte werte
  geom_segment(aes(xend = mpg, yend = predicted)) + 
  geom_point() + # Plot the actual points
  geom_point(aes(y = predicted), shape = 4) + # plot geschätzten y-Werten
  # geom_line(aes(y = predicted), color = "lightgrey") # alternativ code
  geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
  # Farbe wird hier zu den redisuen gemapped, abs(residuals) wegen negativen zahlen  
  geom_point(aes(color = abs(residuals))) + 
  # Colors to use here (für mehrere farben verwende color_gradient2)
  scale_color_continuous(low = "blue", high = "red") +  
  guides(color = FALSE) +  # Color legende entfernen
  mytheme

##########
# plotte ergebnis
##########
ggplot(d, aes(x = mpg, y = hp)) +
    geom_point(size = 4) +
    # geom_point(aes(y = predicted), shape = 1, size = 4) +
    # plot regression line
    geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
    #intercept
    geom_line(aes(y = mean(hp)), color = "blue") +
    mytheme



## ----multiple regression, message=FALSE--------------------------------------------------------------------------

###################
#multiple regression
###################

# Select data
d <- mtcars %>% 
    dplyr::select(mpg, hp, wt, disp)

################
# multikollinearitüt überprüfen
# Korrelation zwischen Prädiktoren kleiner .7
cor <- cor(d[, -1])
cor[abs(cor)<0.7] <- 0  
cor # disp weglassen, vgl. model2

##### info
#wt gewicht
#disp hubraum



############
# Fit the model
############
model1 <- lm(hp ~ mpg + wt + disp, data = d) 
model2 <- lm(hp ~ mpg + wt, data = d)
model3 <- lm(log10(hp) ~ mpg + wt, data = d)

#############
# modeldiagnostik
############
autoplot(model1)
autoplot(model2) # besser, immernoch nicht ok => transformation? vgl. model3
autoplot(model3)

# gebe dir predicted values aus für model2 (für vorzeigebeispiel einfacher :)
# gibts unterschidliche varianten die predicted values zu berechnen
# 1. default funktion predict(model) verwenden
d$predicted <- predict(model2)

# 2. datensatz selber zusammenstellen (nicht empfohlen): wichtig, die 
# prädiktoren müssen denselben
# namen haben wie im Model
# besser mit Traindata von Beginn an mehr Infos hier: https://www.r-bloggers.com/using-linear-regression-to-predict-energy-output-of-a-power-plant/

new.data <- tibble(mpg = sample(seq(15.1,33.9, .3), 32),
                   wt = sample(seq(1.513, 5.424, 0.01), 32),
                   disp = sample(seq(71.1, 472.0, .1), 32)) 
d$predicted_own <- predict(model2, newdata = new.data)

# 3. train_test_split durchführen (empfohlen) muss jedoch von beginn an bereits 
# gemacht werden logik hier: https://towardsdatascience.com/train-test-split-and-cross-validation-in-python-80b61beca4b6 oder https://towardsdatascience.com/6-amateur-mistakes-ive-made-working-with-train-test-splits-916fabb421bb
# beispiel hier: https://ijlyttle.github.io/model_cv_selection.html
d <- mtcars %>% 
  mutate(id = 1:nrow(.)) %>%  # für das mergen der datensätze
  dplyr::select(hp, mpg, wt, id)
  
train_data <- d %>% 
  dplyr::sample_frac(.75) # für das modellfitting

test_data  <- dplyr::anti_join(d, train_data, by = 'id') # für den test mit predict


# erstelle das modell und "trainiere" es auf den train datensatz
model2_train <- lm(hp ~ mpg + wt, data = train_data)


# mit dem "neuen" datensatz wird das model überprüft auf modelfit
train_data$predicted_test <- predict(model2_train, newdata = test_data)


# residuen
train_data$residuals <- residuals(model2_train)
head(train_data)

# mehrere plots der residual-regression
train_data %>% 
    # Get data into shape
    tidyr::pivot_longer(cols = c(-hp, -predicted_test, -residuals), names_to = "x") %>%  
    ggplot(aes(x = value, y = hp)) +  # Note use of `x` here and next line
    geom_segment(aes(xend = value, yend = predicted_test), alpha = .2) +
    geom_point(aes(color = residuals)) +
    scale_color_gradient2(low = "blue", mid = "white", high = "red") +
    guides(color = FALSE) +
    geom_point(aes(y = predicted_test), shape = 1) +
    geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
    facet_grid(~ x, scales = "free_x") +  # Split panels here by `iv`
    labs(x = "") +
    theme_bw()


#----------------
# Schnelle variante mit broom
d <- lm(hp ~ mpg + wt+ disp, data = mtcars) %>% 
    broom::augment()

head(d)

ggplot(d, aes(x = mpg, y = hp)) +
    geom_segment(aes(xend = mpg, yend = .fitted), alpha = .2) +
    geom_point(aes(color = .resid)) +
    scale_color_gradient2(low = "blue", mid = "white", high = "red") +
    guides(color = FALSE) +
    geom_point(aes(y = .fitted), shape = 4) +
    scale_y_continuous(limits = c(0,350)) +
    geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
    mytheme


############
# Modellvereinfachung
############


# Varianzpartitionierung
library(hier.part)
d <- mtcars
names(d) # finde "position" deiner responsevariable

X = d[, -4] # definiere all die prädiktor variablen im Model (minus Responsevar)

# dauert ein paar sekunden
hier.part(d$hp, X, gof = "Rsqu")

# alle Modelle miteinander vergleichen mit dredge Befehl
model2 <- lm(hp ~ ., data = d)
library(MuMIn)
options(na.action = "na.fail")
head(dredge(model2), 10)


