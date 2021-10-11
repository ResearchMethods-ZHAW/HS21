#lade Packages
library(tidyverse)
library(magrittr)
library(here)
library(lubridate)

#mytheme
mytheme <- 
  theme_classic() + 
  theme(
    axis.line = element_line(color = "black"), 
    axis.text = element_text(size = 20, color = "black"), 
    axis.title = element_text(size = 20, color = "black"), 
    axis.ticks = element_line(size = 1, color = "black"), 
    axis.ticks.length = unit(.5, "cm")
  )



#lade Daten
# mehr Info darüber: https://cran.r-project.org/web/packages/explore/vignettes/explore_mtcars.html
cars <- mtcars

#neue kategoriale variable
cars %<>% 
  as_tibble() %>% # da "nur" data frame kann glimplse nichts damit anfangen 
  mutate(vs_cat = if_else(.$vs == 0, "normal", "v-type")) %>% 
  mutate(am_cat = if_else(am == 0, "automatic", "manual"))

# betrachte die Daten
summary(cars)
glimpse(cars)

#Assoziation zwischen Anzahl Zylinder und Motorentyp ()
table(cars$vs_cat, cars$am_cat) # Achtung: sieht aus, als gäbe es weniger V-Motoren bei den Handgeschalteten Autos

#lass und das überprüfen
#achtung: bei chi-square test kommt es sehr auf das format drauf an (er erwartet entweder vektoren oder eine matrix!)
chi_sq <- chisq.test(cars$am, cars$vs)
chi_sq

#fisher exakter test
fisher.test(cars$am_cat, cars$vs_cat)



# bei t-Test immer zuerst visualisieren: in diesem Fall Boxplot mit Variablen Getriebe (v- vs. s-motor) und Anzahl Pferdestärke
ggplot(cars, aes(y = hp, x = vs_cat)) +
  # stat_boxplot(geom ='errorbar', width = .25) +
  # geom_boxplot() +
  geom_violin()
  labs(x = "\nBauform Motor", y = "Pferdestärke (PS)\n") +
  mytheme
  
#alternativ     
boxplot(cars$hp~cars$vs_cat) # sieht ganz ok aus, jedoch weist die variable "normale Motoren" deutlich eine grössere Streuung aus -> siehe aov.1 und deren Modelgüte-Plots

# Definiere Model: t-Test, wobei die AV metrisch (in unserem Fall eine Zählvariable) sein muss
ttest <- t.test(cars$hp ~ cars$vs_cat)
aov.1 <- aov(cars$hp ~ cars$vs_cat)


#schaue Modellgüte an
par(mfrow = c(2,2))
plot(aov.1)

#zeige resultate
ttest
summary.lm(aov.1)


## # für mehr infos here: https://cran.r-project.org/web/packages/datasauRus/vignettes/Datasaurus.html
## 
## library(datasauRus)
## if(requireNamespace("dplyr")){
##   suppressPackageStartupMessages(library(dplyr))
##   dt <- datasaurus_dozen %>%
##     group_by(dataset) %>%
##     summarize(
##       mean_x    = mean(x),
##       mean_y    = mean(y),
##       std_dev_x = sd(x),
##       std_dev_y = sd(y),
##       corr_x_y  = cor(x, y)
##     )
## }
## 
## # check data structure
## glimpse(dt)
## 
## 
## # plot two examples
## if(requireNamespace("ggplot2")){
##   library(ggplot2)
## 
##   dt = filter(datasaurus_dozen, dataset == "dino" | dataset == "slant_up")
## 
##   ggplot(dt, aes(x=x, y=y, colour=dataset))+
##     geom_point()+
##     theme_bw() +
##     theme(legend.position = "none") +
##     facet_wrap(~dataset) +
##     geom_smooth(method = "lm", se = FALSE)
## 
## }
## 
