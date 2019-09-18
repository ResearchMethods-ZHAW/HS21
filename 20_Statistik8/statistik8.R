library(vegan)
library(readr)
library(dplyr)
library(cluster)

crime <- read_delim("20_Statistik8/crime.csv", delim = ",") %>%
  rename(states = X1)

summary(crime)


o.ca<-cca(log10(crime[, 2:8]))
crime_l <- log10(crime[,2:8])

# ssi
cascade <-
  cascadeKM(
    crime_l,
    inf.gr = 2,
    sup.gr = 10,
    iter = 100,
    criterion = "ssi"
  )
summary(cascade)
cascade$results
cascade$partition

plot(cascade, sortg = TRUE)

model <- kmeans(crime_l,8)
plot(o.ca$CA$u, asp=1,col=model[[1]])


## Hierarchical agglomerative clustering of the species abundance 
## data

# Compute matrix of chord distance among sites
crime.norm <- decostand(crime_l, "normalize")
crime.ch <- vegdist(crime.norm, "euc")


# Attach site names to object of class 'dist'
attr(crime.ch, "Labels") <- rownames(crime)
attributes(crime.ch)

# Compute average UPGMA linkage agglomerative clustering
crime.ch.average <- hclust(crime.ch, method = "average")
# Plot a dendrogram using the default options
plot(crime.ch.average, 
     labels = rownames(crime), 
     main = "Chord - UPGMA")


# Compute complete linkage agglomerative clustering
crime.ch.compl <- hclust(crime.ch, method = "complete")
# Plot a dendrogram using the default options
plot(crime.ch.compl, 
     labels = rownames(crime), 
     main = "Chord - Complete linkage")


# Average clustering
coph_average <- cophenetic(crime.ch.average)
cor(crime.ch, coph_average)

plot(
  crime.ch,
  coph_average,
  xlab = "Chord distance",
  ylab = "Cophenetic distance",
  asp = 1,
  # xlim = c(0, sqrt(2)),
  # ylim = c(0, sqrt(2)),
  main = c("average linkage", paste("Cophenetic correlation =",
                                   round(
                                     cor(crime.ch, coph_average), 3
                                   )))
)
abline(0, 1)
lines(lowess(crime.ch, coph_average), col = "red")

# complete linkage clustering
coph_complete <- cophenetic(crime.ch.compl)
cor(crime.ch, coph_complete)

plot(
  crime.ch,
  coph_complete,
  xlab = "Chord distance",
  ylab = "Cophenetic distance",
  asp = 1,
  # xlim = c(0, sqrt(2)),
  # ylim = c(0, sqrt(2)),
  main = c("complete linkage", paste("Cophenetic correlation =",
                                    round(
                                      cor(crime.ch, coph_complete), 3
                                    )))
)
abline(0, 1)
lines(lowess(crime.ch, coph_complete), col = "red")

## Select a dendrogram (Ward/chord) and apply three criteria
## to choose the optimal number of clusters

# Choose and rename the dendrogram ("hclust" object)
hc <- crime.ch.compl

# Average silhouette widths (Rousseeuw quality index)

Si <- nrow(crime)
for (k in 2:(nrow(crime) - 1)) {
  sil <- silhouette(cutree(hc, k = k), crime_l)
  Si[k] <- summary(sil)$avg.width
}

(k.best <- which.max(Si)) # 6 clusters

# Choose the number of clusters
k <- 4 

# Reorder clusters
library(gclus)
spe.chwo <- reorder.hclust(crime.ch.compl, crime.ch)
rect.hclust(spe.chwo, k = 4)
