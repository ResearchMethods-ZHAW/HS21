## ----quasi-posson regression, message=FALSE----------------------------------------------------------------------
############
# quasipoisson regression
############

d <- mtcars

glm.poisson <- glm(hp ~ mpg, data = d, family = poisson(link = log))

summary(glm.poisson) # klare overdisperion

# deshalb quasipoisson
glm.quasipoisson <- glm(hp ~ mpg, data = d, family = quasipoisson(link = log))

summary(glm.quasipoisson)


# visualisiere
ggplot2::ggplot(d, aes(x = mpg, y = hp)) + 
    geom_point(size = 8) + 
    geom_smooth(method = "glm", method.args = list(family = "poisson"), se = F, color = "green", size = 2) + 
    scale_x_continuous(limits = c(0,35)) + 
    scale_y_continuous(limits = c(0,400)) + 
    theme_classic()




## ----logistische regression, message=FALSE-----------------------------------------------------------------------
############
# logistische regression
############
d <- mtcars

# erstelle das modell
glm.binar <- glm(vs ~ hp, data = d, family = binomial(link = logit)) 

summary(glm.binar)


# überprüfe das modell
d$predicted <- predict(glm.binar, type = "response")


# visualisiere
ggplot(d, aes(x = hp, y = vs)) +    
    geom_point(size = 8) +
    # geom_point(aes(y = predict(glm.binar)), shape  = 1, size = 6) +
    guides(color = F) +
    geom_smooth(method = "glm", method.args = list(family = 'binomial'), se = F, size = 2)


#Modeldiagnostik (wenn nicht signifikant, dann OK)
1 - pchisq(glm.binar$deviance,glm.binar$df.resid)  


#Modellgüte (pseudo-R²)
1 - (glm.binar$dev / glm.binar$null)  

#Steilheit der Beziehung (relative Änderung der odds von x + 1 vs. x)
exp(glm.binar$coefficients[2])


#LD50 (wieso negativ: weil zweiter koeffizient negative steigung hat)
abs(glm.binar$coefficients[1]/glm.binar$coefficients[2])


# kreuztabelle (confusion matrix): fasse die ergebnisse aus predict und "gegebenheiten, realität" zusammen
tab1 <- table(d$predicted>.5, d$vs)
dimnames(tab1) <- list(c("M:S-type","M:V-type"), c("T:V-type", "T:S-type"))
tab1

prop.table(tab1, 2)



## ----glm m& gam, message=FALSE-----------------------------------------------------------------------------------

###########
# LOESS & GAM
###########

ggplot2::ggplot(mtcars, aes(x = mpg, y = hp)) + 
    geom_point(size = 8) + 
    geom_smooth(method = "gam", se = F, color = "green", size = 2, formula = y ~ s(x, bs = "cs")) + 
    geom_smooth(method = "loess", se = F, color = "red", size = 2) + geom_smooth(method = "glm", size = 2, color = "blue", se = F) + scale_x_continuous(limits = c(0,35)) + 
    scale_y_continuous(limits = c(0,400)) + 
    theme_classic()



