#export files
knitr::purl("_statistik/Statistik3_solution/index.Rmd", here::here("_statistik/Statistik3_solution/Solution_stat3.R"), documentation = 0)
# rmarkdown::render(input = "_statistik/Statistik3_solution/index.rmd", output_format = "pdf_document", output_file = here::here("_statistik/Statistik1_solution/Solution_stat1.pdf"))



# Aus der Excel-Tabelle wurde das relevante Arbeitsblatt als csv gespeichert
ukraine <-read_delim("Ukraine_bearbeitet.csv", delim=";")
str(ukraine)
summary(ukraine)

#Explorative Datenanalyse der abhängigen Variablen
boxplot(ukraine$`Species richness`)

cor <- cor(ukraine[,3:23])
cor
cor[abs(cor)<0.7] <- 0
cor

summary(ukraine$Sand)
ukraine[!complete.cases(ukraine), ] # Zeigt zeilen mit NAs ein

cor <- cor(ukraine[,c(3:11,15:23)])
cor[abs(cor)<0.7] <- 0
cor

cor <- cor(ukraine[,c(3:11,15:23)])
cor[abs(cor)<0.6] <- 0
cor

write.table(cor, file="Corrleation.csv", sep=";", dec=".")

global.model <- lm(`Species richness` ~ Inclination+`Heat index`+`Microrelief`+`Grazing intensity`+
                    `Litter`+`Stones and rocks`+ Gravel+`Fine soil`+pH+CaCO3+`C org`+`CN ratio`+Temperature, data = ukraine)


#Multimodel inference
if(!require(MuMIn)){install.packages("MuMIn")}
library(MuMIn)

options(na.action="na.fail")
allmodels<-dredge(global.model)
allmodels

#Importance values der Variablen
importance(allmodels)

#Modelaveraging (Achtung: dauert mit 13 Variablen einige Minuten)
summary(model.avg(allmodels, rank="AICc"), subset=TRUE)


#Modelldiagnostik nicht vergessen
par(mfrow=c(2,2))
plot(global.model)
p <- plot(lm(`Species richness`~`Heat index`+Litter+CaCO3+`CN ratio`+ `Grazing intensity`))
print(p)

summary(global.model)

ggsave(filename = "_statistik/Statistik3_solution/distill-preview.png",
       plot = p,
       device = "png")

```{.r .distill-force-highlighting-css}
```
