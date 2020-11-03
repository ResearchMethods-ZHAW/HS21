# Research Methods Statistik-Vorlesung 2020
# Ordinationen 
# Gian-Andrea Egeler & Jürgen Dengler 


#------------------------------------------
#einfaches beispiel: angelehnt an diesem post: https://www.datacamp.com/community/tutorials/pca-analysis-r

#ausgangslage: viel zusammenhängende variablen
#ziel: reduktion der variablen
#WICHTIG: mit wide-format arbeiten => das ist mit matrizen gemeint

# lade datei
d <- mtcars

# korrelationen
cor<- cor(mtcars[,c(1:7,10,11)])
cor[abs(cor)<.7] <- 0
cor

# pca
# achtung unterschiedliche messeinheiten, wichtig es muss noch einheitlich transfomiert werden
library(FactoMineR)
o.pca <- PCA(mtcars[,c(1:7,10,11)], scale.unit = TRUE) # entweder korrelations oder covarianzmatrix

# schaue output an
summary(o.pca) # generiert auch automatische plots


# plote das ganze
library(ggbiplot)
ggbiplot(o.pca,choices = c(1,2))

# nehme noch die autonamen hinzu
ggbiplot(o.pca, labels=rownames(mtcars), choices = c(1,2)) + mytheme # choice gibt die axen an


#-------------------------

#Mit Beispieldaten aus Wildi (2013, 2017)
# library(dave)
library(labdsv)
library(dave) # lade package für Datensatz sveg
head(sveg)


#PCA-----------
#Deckungen Wurzeltransformiert, cor=T erzwingt Nutzung der Korrelationsmatrix
o.pca <- labdsv::pca(sveg^0.25,cor=T)
o.pca2 <- stats::prcomp(sveg^0.25)

#Koordinaten im Ordinationsraum => Y
head(o.pca$scores)
head(o.pca2$x)

#Korrelationen der Variablen mit den Ordinationsachsen
head(o.pca$loadings)
head(o.pca2$rotation)

#Erklaerte Varianz der Achsen (sdev ist die Wurzel daraus)
# früher gabs den Befehl summary()
# jetzt von hand: standardabweichung im quadrat/totale varianz * 100 (um prozentwerte zu bekommen)
E<-o.pca$sdev^2/o.pca$totdev*100
E[1:5] # erste fünf PCA


#PCA-Plot der Lage der Beobachtungen im Ordinationsraum
plot(o.pca$scores[,1],o.pca$scores[,2],type="n", asp=1, xlab="PC1", ylab="PC2")
points(o.pca$scores[,1],o.pca$scores[,2],pch=18)

plot(o.pca$scores[,1],o.pca$scores[,3],type="n", asp=1, xlab="PC1", ylab="PC3")
points(o.pca$scores[,1],o.pca$scores[,3],pch=18)

#Subjektive Auswahl von Arten zur Darstellung
sel.sp <- c(3,11,23,39,46,72,77,96, 101, 119)
snames <- names(sveg[ , sel.sp])
snames

#PCA-Plot der Korrelationen der Variablen (hier Arten) mit den Achsen (h)
x <- o.pca$loadings[,1]
y <- o.pca$loadings[,2]
plot(x,y,type="n",asp=1)
arrows(0,0,x[sel.sp],y[sel.sp],length=0.08)
text(x[sel.sp],y[sel.sp],snames,pos=1,cex=0.6)

# hier gehts noch zu weiteren Beispielen zu PCA's:
# https://stats.stackexchange.com/questions/102882/steps-done-in-factor-analysis-compared-to-steps-done-in-pca/102999#102999
# https://stats.stackexchange.com/questions/222/what-are-principal-component-scores
# https://stats.stackexchange.com/questions/102882/steps-done-in-factor-analysis-compared-to-steps-done-in-pca/102999#102999


#CA---------

library(vegan)
library(FactoMineR) # siehe Beispiel hier: https://www.youtube.com/watch?v=vP4korRby0Q

# ebenfalls mit transformierten daten
o.ca<-cca(sveg^0.5)
o.ca1 <- CA(sveg^0.5)

#Arten (o) und Communities (+) plotten
plot(o.ca)

summary(o.ca1)
plot(o.ca1)

#Nur Arten plotten
x<-o.ca$CA$u[,1]
y<-o.ca$CA$u[,2]
plot(x,y)

#Anteilige Varianz, die durch die ersten beiden Achsen erklaert wird
o.ca$CA$eig[1:63]/sum(o.ca$CA$eig)



#NMDS----------

#Distanzmatrix als Start erzeugen
library(MASS)
library(vegan)

mde <-vegdist(sveg,method="euclidean")
mdm <-vegdist(sveg,method="manhattan")

#Zwei verschiedene NMDS-Methoden
set.seed(1) #macht man, wenn man bei einer Wiederholung exakt die gleichen Ergebnisse will
o.imds<-isoMDS(mde, k=2) # mit K = Dimensionen
set.seed(1)
o.mmds<-metaMDS(mde,k=3) # scheint nicht mit 2 Dimensionen zu konvergieren

plot(o.imds$points)
plot(o.mmds$points)

#Stress =  Abweichung der zweidimensionalen NMDS-Loesung von der originalen Distanzmatrix
stressplot(o.imds,mde)
stressplot(o.mmds,mde)



