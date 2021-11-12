#export files
knitr::purl("solution4.2s.Rmd", "Solution_stat4.2s.R", documentation = 0)




library(dplyr)
library(readr)
library(magrittr)
library(lubridate)
library(ggplot2)
library(stringr)
library(tidyr)
library(readr)

# lade Daten von Zenodo
# für Informationen zu den einzelnen Variablen, siehe https://zenodo.org/record/3554884/files/2020_ZHAW_vonRickenbach_Variablen_cleaned_recoded_survey_dataset_anonym_NOVANIMAL.pdf?download=1
nova_survey <- read_delim("https://zenodo.org/record/3554884/files/2019_ZHAW_vonRickenbach_cleaned_recorded_survey_dataset_NOVANIMAL_anonym.csv?download=1", 
                          delim = ";",
                          locale = locale(encoding = "Latin1")) 

#überprüfe die Datenstruktur
glimpse(nova_survey)

## definiert mytheme für ggplot2 (verwendet dabei theme_classic())
mytheme <- 
  theme_classic() + 
  theme(
    axis.line = element_line(color = "black"), 
    axis.text = element_text(size = 20, color = "black"), 
    axis.title = element_text(size = 20, color = "black"), 
    axis.ticks = element_line(size = 1, color = "black"), 
    axis.ticks.length = unit(.5, "cm")
    )



# Genereiert eine Dummyvariable: Fleisch 1, kein Fleisch 0
df <- nova_survey %>%  # kopiert originaler Datensatz
  rename(umwelteinstellung = tho_2) %>% # änderung name der variable
  mutate(umwelteinstellung = case_when(umwelteinstellung == 4 ~ 1,
                                       umwelteinstellung == 3 ~ 1,
                                       umwelteinstellung == 2 ~ 0, 
                                       umwelteinstellung == 1 ~ 0)) %>% 
  # lasse die kleine Gruppe mit x weg
  dplyr::filter(!str_detect(string = "x", gender)) %>% 
  # lasse die kleine Gruppe "andere" weg
  dplyr::filter(!str_detect(string = "Andere", member)) %>%  
  # wähle nur die relevanten variablen aus
  dplyr::select(mensa, age_groups, gender, member, umwelteinstellung, meat) 

# Schaut euch die Missings an in der Kriteriumsvariable "mensa"
sum(is.na(df$mensa))

# schaut euch die Missings an in den Prädiktorvariablen "Alter", "Geschlecht", "Hochschulzugehörigkeit", "Umwelteinstellung"

Amelia::missmap(df) 


# vieles deutet darauf hin, dass die missings (fehlende Werte) 
# zufällig zustande gekommen sind (sog. MCAR); für mehr Informationen: https://uvastatlab.github.io/2019/05/01/getting-started-with-multiple-imputation-in-r/

# bester Weg wäre, die wenigen fehlenden Werte zu imputieren; 
# einfachheitshalber löschen wir sie aber :)
df %<>%
  drop_na()

#  sieht euch die Verteilung zwischen Mensagänger und Selbstverpfleger an
# sind nicht gleichmässig verteilt, bei der Vorhersage müssen wir das berücksichtigen
table(df$mensa) 
df %>% count(mensa) # alternativ

# definiert das logistische Modell und wendet es auf den Datensatz an

mod0 <-glm(mensa ~ gender + member + age_groups + meat + umwelteinstellung, 
           data = df, binomial("logit"))
summary.lm(mod0) # Umwelteinstellung scheint keinen Einfluss auf die 
# Verpflegung zu haben, gegeben die Daten

# neues Modell ohne Umwelteinstellung
mod1 <- update(mod0, ~. -umwelteinstellung)
summary.lm(mod1)

# Modeldiagnostik (wenn nicht signifikant, dann OK)
1 - pchisq(mod1$deviance, mod1$df.resid) # Ok

#Modellgüte (pseudo-R²)
1 - (mod1$dev / mod1$null) # eher kleines pseudo-R2, deckt sich mit dem R-Squared aus dem obigen output summary.lm()


# Konfusionsmatrix vom  Datensatz
# Model Vorhersage
# hier ein anderes Beispiel: 
predicted <- predict(mod1, df, type = "response")

# erzeugt eine Tabelle mit den beobachteten
# Mensagänger/Selbstverpfleger und den Vorhersagen des Modells
km <- table(predicted > 0.5, df$mensa) 
# alles was höher ist als 50% ist 
# kommt in die Kategorie Mensagänger

# anpassung der namen
dimnames(km) <- list(
  c("Modell Selbst", "Modell Mensa"),
  c("Daten Selbst", "Daten Mensa"))
km

#############
### reminder: https://towardsdatascience.com/understanding-confusion-matrix-a9ad42dcfd62
#############

#TP = true positive: you predicted positive and it’s true; hier vorhersage 
# mensagänger stimmt also (727)

#TN = true negative: you predicted negative and it’s true, hier vorhersage der 
# selbstverpfleger stimmt (87)

#FP = false positive (fehler 1. art, auch spezifizität genannt) you predicted 
# and it’s false. hier modell sagt mensagänger vorher 
# (obwohl in realität selbstverpfleger) (195)

#FN = false negative (fehler 2. art, auch sensitivität genannt), 
# you predicted negative and it’s false. hier modell sagt selbtverpfleger vorher 
# (obwohl in realität mensagänger) (59)


# es scheint, dass das Modell häufig einen alpha Fehler zu machen, d.h. es 
# das Modell weist keine hohe Spezifizität auf: konkret werden viele Mensagänger als 
# Selbstverpfleger vorhergesagt resp. klassifiziert. Dafür gibt es mehere Gründe: 

#1) die Kriteriumsvariable ist sehr ungleich verteilt, d.h. es gibt weniger
# Selbstverpfleger als Mensgänger im Datensatz 
 
#2) nicht adäquates Modell z.B. link mit probit zeigt besserer fit

#3) Overfitting: wurde hier nicht berücksichtigt, in einem Paper/Arbeit 
# müsste noch einen Validierungstest gemacht werden z.B. test-train 
# Cross-Validation oder k fold Cross-Validation 

# kalkuliert die Missklassifizierungsrate 
mf <- 1-sum(diag(km)/sum(km)) # ist mit knapp 23 %  eher hoch
mf


# kleiner exkurs: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2636062/
# col wise proportion, da diese die "realität" ist
km_prop <- prop.table(km,2)


# specificity = a / (a+c) => ability of a test to correctly 
# classify an individual as disease-free is called the test′s specificity
spec = km_prop[1] / (km_prop[1] + km_prop[2])
spec

# sensitivity = d / (b+d) => Sensitivity is the ability of a 
# test to correctly classify an individual as ′diseased′
sens = km_prop[4] / (km_prop[3] + km_prop[4])
sens


knitr::kable(km)
```{.r .distill-force-highlighting-css}
```
