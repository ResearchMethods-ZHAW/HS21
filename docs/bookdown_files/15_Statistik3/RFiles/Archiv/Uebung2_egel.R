knitr::opts_chunk$set(fig.width = 20, fig.height = 12, warning = F, message = F)
#knitr::opts_chunk$get("root.dir")

library(readr)
library(dplyr)
library(ggfortify)
library(jtools)
library(wesanderson)


nova <- read_delim("13_Statistik1/data/novanimal.csv", delim = ";")
nova_ <- read_delim("13_Statistik1/data/novanimal_data_180911_egel.csv", delim = ";")

# Genereiere Dummyvariable Fleisch 1, kein Fleisch 0
df <- nova # copiere originaler Datensatz
df$meat <- ifelse(nova$label_content == "Fleisch", 1, 0)

#check for missings
library(Amelia)
missmap(df,col=c("blue", "red"), legend=FALSE)

# all locals with NA need to be excluded
df_ <- df[complete.cases(df[ ,7:17]),] # Ein Weg um die Missings in den ausgewählten Spalten zu löschen
df_ <- df[!is.na(df$meat),] # Ein alternativer Weg um die Missings in der gwünschten Spalte zu löschen

#  Siehe die Aufteilung zwischen Fleisch- und Nicht-Fleischkauf 
table(df_$meat) # beinhahe gleichgrosse Gruppen, keine Aufteilung in zwei Datensätze nötig

# Generiere Testdata und Trainingdata
set.seed(17) # Für die Wiederholbarkeit
train.data <- df_ %>%  dplyr::sample_frac(.75) # 75% vom "ganzen" Datensatz werden rausgenommen, auf diese Daten wenden wir unser Modell an
test.data <- anti_join(df_, train.data) # der Rest, also 25% des ganzen Datensatzes ist unser Testdatensatz

# definiere das logit Modell und wende es auf den Train.Datensatz an
mod0 <- glm(meat ~ gender + member + age, data = train.data, binomial("logit"))
summary(mod0)
crPlots(mod0) # member könnte man evtl. weglassen (?)

# Model Vorhersage und Performance
# Kann das Modell unser Test-Datensatz vorhersagen?
predicted <- predict(mod0, test.data, type = "response")

# Modelgüte
data.frame(
  RMSE_test = RMSE(predicted, test.data$meat), # je kleiner, desto besser der RMSE. Das bedeutet guter Modelfit
  RMSE_train = RMSE(predicted, train.data$meat), # Vergleich RMSE zwischen train und test. 
  R2 = R2(predicted, test.data$meat) # R2 je grösser, desto besser. Das bedeutet Modell erklärt viel Varianz zwischen den Daten
)

anova(mod0, test = "Chisq") # anderer Weg um Model Performance zu testen
library(pscl)
pR2(mod0) # McFadden als Gütekriterium: zwischen 0.2 und 0.4 guter fit

# Genauigkeit des Models
fitted.results <- ifelse(predicted > 0.5,1,0) # wenn vorgergesagte Werte grösser als Zufall ist (.5) bekommen sie eine 1 sonst 0 
misClasificError <- mean(fitted.results != test.data$meat) # berechnet die Fehlklassifizierung
print(paste('Genauigkeit des Models ist',round(1-misClasificError, digits = 2))) # nahe bei 50%: Model ist passt zwar zu den Daten, aber weder das Geschlecht noch das Alter kann der Kauf von einem Fleisch-Menü vorhersagen 

# Konfusionmatrix vom test Datensatz
table(test.data$meat, predicted > 0.5)

#-----------------
# Alternative Methode,da einige Personen mehrmals im Datensatz vorkommen

mod1 <- lmer(meat ~ gender + member + age + (1|card_num), data = df_, family = binomial(link=logit))
summary(mod1)
predicted <- predict(mod1, df_, type = "response")
data.frame(
  RMSE = RMSE(predicted, df_$meat), # je kleiner, desto besser der RMSE. Das bedeutet guter Modelfit
  R2 = R2(predicted, df_$meat) # R2 je grösser, desto besser. Das bedeutet Modell klärt viel Varianz auf.
)


