# Research Methods Statistik 6
# Ordinationen I
# (c) Jürgen Dengler 


# PCA ---------------------------------------------------------------------
#Mit Beispieldaten aus Wildi (2013)
#Idee von Ordinationen aus Wildi p. 73-74

if(!require(labdsv)){install.packages("labdsv")}
library(labdsv)
#Für Ordinationen benötigen wir Matrizen, nicht Data.frames
if(!require(vegan)){install.packages("vegan")}
library("vegan")

#Generieren von Daten
raw<-matrix(c(1,2,2.5,2.5,1,0.5,0,1,2,4,3,1),nrow=6)
colnames(raw)<-c("spec.1","spec.2")
rownames(raw)<-c("r1","r2","r3","r4","r5","r6")
raw

#originale Daten im zweidimensionalen Raum
x1<-raw[,1]
y1<-raw[,2]
z<-c(rep(1:6))


#Plot Abhängigkeit der Arten vom Umweltgradienten
plot(c(x1,y1)~c(z,z),type="n",axes=T,bty="l",las=1,xlim=c(1,6),ylim=c(0,5),xlab="Umweltgradient",ylab="Deckung der Arten")
points(x1~z,pch=21,type="b")
points(y1~z,pch=16,type="b")

#zentrierte Daten
cent<-scale(raw,scale=F)
x2<-cent[,1]
y2<-cent[,2]

#rotierte Daten
o.pca<-pca(raw)
x3 <- o.pca$scores[,1]
y3 <- o.pca$scores[,2]


#Visualisierung der Schritte im Ordinationsraum
plot(c(y1,y2,y3)~c(x1,x2,x3),type="n",axes=T,bty="l",las=1,xlim=c(-4,4),ylim=c(-4,4),xlab="Art 1",ylab="Art 2")
points(y1~x1,pch=21,type="b",col="green",lwd=2)
points(y2~x2,pch=16,type="b",col="red", lwd=2)
points(y3~x3,pch=17,type="b",col="blue", lwd=2)

#Durchführung der PCA
pca<-pca(raw)

#Koordinaten im Ordinationsraum
pca$scores

#Korrelationen der Variablen mit den Ordinationsachsen
pca$loadings

#Erklärte Varianz der Achsen in Prozent
E<-pca$sdev^2/pca$totdev*100
E

#mit prcomp
pca.2<-prcomp(raw,scale=F)
summary(pca.2)
plot(pca.2)
biplot(pca.2)

#mit vegan
pca.3 <- rda(raw, scale=FALSE) #Die Funktion rda führt ein PCA aus an wenn nicht Umwelt und Artdaten definiert werden
summary(pca.3,axes=0)
biplot(pca.3, scaling=2)


#Mit Beispieldaten aus Wildi
if(!require(dave)){install.packages("dave")}
library(dave)
data(sveg)
str(sveg)
summary(sveg)
names(sveg)

#PCA: Deckungen Wurzeltransformiert, cor=T erzwingt Nutzung der Korrelationsmatrix
pca.5<-pca(sveg^0.25,cor=T)

#Koordinaten im Ordinationsraum
pca.5$scores

#Korrelationen der Variablen mit den Ordinationsachsen
pca.5$loadings

#Erklärte Varianz der Achsen in Prozent (sdev ist die Wurzel daraus)
E<-pca.5$sdev^2/pca.5$totdev*100
E
E[1:5]

#PCA-Plot der Lage der Beobachtungen im Ordinationsraum
plot(pca.5$scores[,1],pca.5$scores[,2],type="n", asp=1, xlab="PC1", ylab="PC2")
points(pca.5$scores[,1],pca.5$scores[,2],pch=18)

#Subjektive Auswahl von Arten zur Darstellung
sel.sp <- c(3,11,23,39,46,72,77,96)
snames <- names(sveg[,sel.sp])
snames

#PCA-Plot der Korrelationen der Variablen (hier Arten) mit den Achsen (h)
x <- pca.5$loadings[,1]

y<-pca.5$loadings[,2]
plot(x,y,type="n",asp=1)
arrows(0,0,x[sel.sp],y[sel.sp],length=0.08)
text(x[sel.sp],y[sel.sp],snames,pos=1,cex=0.6)


# Mit vegan
pca.6<-rda(sveg^0.25, scale=TRUE)
#Erklärte Varianz der Achsen
summary(pca.6,axes=0)
#PCA-Plot der Lage der Beobachtungen im Ordinationsraum
biplot(pca.6, scaling=1,display = c("sites"),type = c("points"))
#Subjektive Auswahl von Arten zur Darstellung
sel.sp <- c(3,11,23,39,46,72,77,96)
snames <- names(sveg[,sel.sp])
snames
#PCA-Plot der Korrelationen der Variablen (hier Arten) mit den Achsen (h)
scores<-scores(pca.6,display=c("species"))
x<-scores[,1]
y<-scores[,2]
plot(x,y,type="n",asp=1)
arrows(0,0,x[sel.sp],y[sel.sp],length=0.08)
text(x[sel.sp],y[sel.sp],snames,pos=1,cex=0.6)


# CA ----------------------------------------------------------------------
ca<-cca(sveg^0.5)
#Arten (o) und Communities (+) plotten
plot(ca)

#Nur Arten plotten
x<-ca$CA$u[,1];y<-ca$CA$u[,2]
plot(x,y)
plot(ca, display = c("species"),type = c("points"))#alternative


#Anteilige Varianz, die durch die ersten beiden Achsen erklärt wird
ca$CA$eig[1:2]/sum(ca$CA$eig)


# DCA ---------------------------------------------------------------------
dca <- decorana(sveg,mk=10)
plot(dca$rproj, asp=1)

dca.2 <- decorana(sveg,mk=100)
plot(dca.2$rproj, asp=1)


# NMDS --------------------------------------------------------------------
#Distanzmatrix als Start erzeugen
mde <-vegdist(sveg,method="euclidean")
mde
mde <-vegdist(sveg,method="bray")#Alternative mit einem für Vegetationsdaten üblichen Dissimilarity index
mde

#Zwei verschiedene NMDS-Methoden
if(!require(MASS)){install.packages("MASS")}
library(MASS)
set.seed(1) #macht man, wenn man bei einer Wiederholung exakt die gleichen Ergebnisse will
imds<-isoMDS(mde,k=2)
set.seed(1)
mmds<-metaMDS(mde,k=2)

plot(imds$points)
plot(mmds$points)

#Stress = S² = Abweichung der zweidimensionalen NMDS-Lösung von der originalen Distanzmatrix
stressplot(imds,mde)
stressplot(mmds,mde)
