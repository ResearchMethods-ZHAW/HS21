#export files
knitr::purl("_statistik-konsolidierung/Statistik_Konsolidierung3_Demo_LM/index.Rmd", here::here("_statistik-konsolidierung/Statistik_Konsolidierung3_Demo_LM/Demo_LM_Konsolidierung3.R"), documentation = 0)
# rmarkdown::render(input = "_statistik/Statistik3_solution/index.rmd", output_format = "pdf_document", output_file = here::here("_statistik/Statistik1_solution/Solution_stat1.pdf"))





# für mehr infos
#https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html

cars <- mtcars %>% 
    mutate(cyl = as.factor(cyl)) %>% 
    slice(-31) # lösch die 31ste Zeile

#Alternativ ginge auch das
cars[-31,]

# schaue daten zuerst mal an
#1. Responsevariable
hist(cars$hp) # nur sinnvoll bei grossem n
boxplot(cars$hp)


#2. Responsevariable ~ Prediktorvariable
table(cars$cyl) # mögliches probel, da n's unterschiedlich gross
boxplot(cars$hp ~ cars$cyl) # varianzheterogentität weniger das problem, aber normalverteilung der residuen problematisch

# definiere das modell für eine ein-faktorielle anova
aov.1 <- aov(hp ~ cyl, data = cars)

#3. Schaue Modelgüte an
par(mfrow = c(2,2))
plot(aov.1)

#4. Schaue output an und ordne es ein
summary.lm(aov.1)


#5. bei meheren Kategorien wende einen post-hoc Vergleichstest an
TukeyHSD(aov.1)

#6. Ergebnisse passend darstellen
#habt ihr Vorschläge?


# Sind die Voraussetzungen für eine Anova verletzt, überprüfe alternative nicht-parametische Tests z.B. oneway-Test mit Welch-korrektur für ungleiche Varianzen (Achtung auch dieser Test hat Voraussetzungen -> siehe Skript XY)
welch1 <- oneway.test(hp ~ cyl, data = cars, var.equal = FALSE)
posthocTGH(cars$hp, cars$cyl, method = "games-howell")


#1. Wähle zusätzliche Variable aus (wenn nicht in der Aufgabe steht), was für eine Skala muss die Variable aufweisen?

#2. definiere das Modell für eine zwei-faktorielle Anova
#ACHTUNG: die Reihenfolge ist bei Anova relevant, siehe für mehr Infos: https://stats.stackexchange.com/questions/212496/why-do-p-values-change-in-significance-when-changing-the-order-of-covariates-in
# https://stats.stackexchange.com/questions/13241/the-order-of-variables-in-anova-matters-doesnt-it

#3. Rechne Modell
aov.2 <- aov(hp ~ cyl * am + wt, data = cars) 

#4. Überprüfe Modelvoraussetzungen: sind sie gegeben? 
#-> Wenn ja dann mit 5. fortfahren
#-> wenn nein (wie in unserem Fall), zurück zu Schritt 3, was für Möglichkeiten haben wir?
par(mfrow = c(2,2))
plot(aov.2)

#5. Interpretiere den Output
summary.lm(aov.2)


#6. Ergebnisse passend darstellen
# plotte ergebnisse
library(multcomp)

#erstens die signifikanten Unterschiede mit Buchstaben versehen
letters <- cld(glht(aov.1, linfct=mcp(cyl="Tukey"))) # Achtung die kategoriale Variable (unsere unabhängige Variable "cyl") muss als Faktor definiert sein z.B. as.factor()

#einfachere Variante
boxplot(hp ~ cyl, data = cars)
mtext(letters$mcletters$Letters, at=1:3)

#schönere Variante :)
ggplot(cars, aes(x = cyl, y = hp)) +
	stat_boxplot(geom = "errorbar", width = .5) +
  geom_boxplot(size = 1) + 
	annotate("text", x = 1:3, y = 350, label = letters$mcletters$Letters, size = 7) +
  labs(x = "\nAnzahl Zylinder", y = "Pferdestärke")  + mytheme

#Plot exportieren
ggsave(filename = "distill-preview.png",
       device = "png") # hier kann man festlegen, was für ein Bildformat exportiert werden möchte



#Frage: was brauchts für ein Model, damit man von einer Ancova sprechen darf?






# inspiriert von Simon Jackson: http s://drsimonj.svbtle.com/visualising-residuals
cars <- mtcars %>% 
  #ändere die unabhängige Variable mpg in 100Km/L
  mutate(kml = (235.214583/mpg)) # mehr Infos hier: https://www.asknumbers.com/mpg-to-L100km.aspx
  # %>%  # klone data set
  # slice(-31) # # lösche Maserrati und schaue nochmals Modelfit an

#############
##1.Daten anschauen
############

# Zusammenhang mal anschauen
# Achtung kml = 100km pro Liter 
plot(hp ~ kml, data = cars)

# Responsevariable anschauen
boxplot(cars$hp)

# Korrelationen uv + av anschauen
# Reihenfolge spielt hier keine Rolle, wieso?
cor(cars$mpg, cars$hp) # hängen stark zusammen


###################
#2. Modell definieren: einfache regression
##################
model <- lm(hp ~ mpg, data = cars)
summary.lm(model)

###############
#3.Modeldiagnostik und ggf. Anpassungen ans Modell oder ähnliches
###############

# semi schöne Ergebnisse
autoplot(model) + mytheme # gitb einige Extremwerte => was tun? (Eingabe/Einlesen 
#überprüfen, Transformation, Extremwerte nur ausschliessen mit guter Begründung)


# erzeuge vorhergesagte Werte und Residualwerte
cars$predicted <- predict(model)   # bilde neue Variable mit geschätzten y-Werten
cars$residuals <- residuals(model)

# schaue es dir an, sieht man gut was die Residuen sind
d <- cars %>%  
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
  scale_x_continuous(limits = c(0, 40)) +
  scale_y_continuous(limits = c(0, 300)) +
  guides(color = FALSE) +  # Color legende entfernen
  mytheme

##########
#4. plotte Ergebnis
##########
ggplot(d, aes(x = mpg, y = hp)) +
    geom_point(size = 4) +
    # geom_point(aes(y = predicted), shape = 1, size = 4) +
    # plot regression line
    geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
    #intercept
    geom_line(aes(y = mean(d$hp)), color = "blue") +
    mytheme



###################
#multiple regression
###################

# Select data
cars <- mtcars %>% 
    slice(-31) %>%
    mutate(kml = (235.214583/mpg)) %>% 
    dplyr::select(kml, hp, wt, disp)

################
# 1. Multikollinearitüt überprüfen
# Korrelation zwischen Prädiktoren kleiner .7
cor <- cor(cars[, -2])
cor[abs(cor)<0.7] <- 0  
cor # disp weglassen, vgl. model2

##### info zu Variablen
#wt = gewicht
#disp = hubraum


###############
#2. Responsevariable + Kriteriumsvariable anschauen
##############
# was würdet ihr tun?


############
#3. Definiere das Model
############
model1 <- lm(hp ~ kml + wt + disp, data = cars) 
model2 <- lm(hp ~ kml + wt, data = cars)
model3 <- lm(log10(hp) ~ kml + wt, data = cars)

#############
#4. Modeldiagnostik
############
ggfortify::autoplot(model1)
ggfortify::autoplot(model2) # besser, immernoch nicht ok => transformation? vgl. model3
ggfortify::autoplot(model3)


############
#5. Modellfit vorhersagen: wie gut sagt mein Modell meine Daten vorher
############

#es gibt 3 Mögliche Wege

# gebe dir predicted values aus für model2 (für vorzeigebeispiel einfacher :)
# gibts unterschidliche varianten die predicted values zu berechnen
# 1. default funktion predict(model) verwenden
d$predicted <- predict(model2)

# 2. datensatz selber zusammenstellen (nicht empfohlen): wichtig, die 
# prädiktoren müssen denselben
# namen haben wie im Model
# besser mit Traindata von Beginn an mehr Infos hier: https://www.r-bloggers.com/using-linear-regression-to-predict-energy-output-of-a-power-plant/

new.data <- tibble(kml = sample(seq(6.9384, 22.61, .3), 31),
                   wt = sample(seq(1.513, 5.424, 0.01), 31),
                   disp = sample(seq(71.1, 472.0, .1), 31)) 
d$predicted_own <- predict(model2, newdata = new.data)

# 3. train_test_split durchführen (empfohlen) muss jedoch von beginn an bereits 
# gemacht werden - Logik findet ihr hier: https://towardsdatascience.com/train-test-split-and-cross-validation-in-python-80b61beca4b6 oder https://towardsdatascience.com/6-amateur-mistakes-ive-made-working-with-train-test-splits-916fabb421bb
# beispiel hier: https://ijlyttle.github.io/model_cv_selection.html
cars <- mtcars %>% 
  mutate(id = 1:nrow(.)) %>%  # für das mergen der Datensätze
  mutate(kml = (235.214583/mpg)) %>% 
  dplyr::select(kml, hp, wt, disp)
  
train_data <- cars %>% 
  dplyr::sample_frac(.75) # für das Modellfitting

test_data  <- dplyr::anti_join(cars, train_data, by = 'id') # für den Test mit predict


# erstelle das Modell und "trainiere" es auf den train Datensatz
model2_train <- lm(hp ~ kml + wt, data = train_data)


# mit dem "neuen" Datensatz wird das Model überprüft ob guter Modelfit
train_data$predicted_test <- predict(model2_train, newdata = test_data)


# Residuen
train_data$residuals <- residuals(model2_train)
head(train_data)

# mehrere plots der Residual-Regression
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
d <- lm(hp ~ kml + wt+ disp, data = mtcars) %>% 
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
# 6. Modellvereinfachung
############


# Varianzpartitionierung
library(hier.part)
cars <- mtcars %>% 
  mutate(kml = (235.214583/mpg)) %>% 
  dplyr::select(kml, hp, wt, disp)


names(cars) # finde "position" deiner Responsevariable

X = cars[, -4] # definiere all die Prädiktorvariablen im Model (minus Responsevar)

# dauert ein paar sekunden
hier.part(cars$hp, X, gof = "Rsqu")

# alle Modelle miteinander vergleichen mit dredge Befehl: geht nur bis maximal 15 Variablen
model2 <- lm(hp ~ ., data = cars)
library(MuMIn)
options(na.action = "na.fail")
allmodels <- dredge(model2)
head(allmodels)

# Wichtigkeit der Prädiktoren
MuMIn::importance(allmodels)

# mittleres Model
avgmodel<- MuMIn::model.avg(get.models(allmodels, subset=TRUE))
summary(avgmodel)

# adäquatest model gemäss multimodel inference
model_ad <- lm(hp ~ carb + disp + kml + wt, data = cars)

```{.r .distill-force-highlighting-css}
```
