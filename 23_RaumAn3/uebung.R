# Spatial Autocorrelation  - Moran's I

# Reading the shapefiles

library(sf)
library(maptools)
library(ggplot2)
library(dplyr)

luftQual <- st_read("data/Luftqualitaet_2015_NO2.shp") # Luftqualität in der Schweiz
kantone <- st_read("data/KANTONSGEBIET.shp") # Kantone (first aggregation level)
bezirke <- st_read("data/BEZIRKSGEBIET.shp") # Bezirksgebiet (second aggregation level)

# -- transform to CH1903+LV95 -- 
luftQual <- st_transform(luftQual, crs = 2056)
kantone <- st_transform(kantone, crs = 2056) %>%
  st_zm(kantone) # remove z information
bezirke <- st_transform(bezirke, crs = 2056) %>%
  st_zm(bezirke) # remove z information


# Join by Canton

luftQual_kanton <- st_join(luftQual, kantone)

kantone_union <- kantone %>%
  group_by(kantonsnum) %>%
  summarise()

luftQual_kanton_mean <- luftQual_kanton %>%
  group_by(kantonsnum) %>%
  summarise(mean_value = mean(value))

# spatial join cantons and NO2 
kantone_Moran <- st_join(kantone_union, luftQual_kanton_mean)

# convert to spatial object
kantone_Moran <- as(kantone_luftqual, "Spatial")

# getting the centroids of the polygons
xy <- coordinates(kantone_Moran)

## Find the ADJACENT Polygons
library(spdep)
adjPol <- poly2nb(kantone_Moran, row.names = kantone_Moran$kantonsnum.x)
class(adjPol)
summary(adjPol)

# example Kanton 26 has the following neighboring
adjPol[26]

# Plot the links between the polygons
plot(kantone_Moran, col='gray', border='blue', lwd=2)
plot(adjPol, xy, col='red', lwd=2, add=TRUE)

# transform AdjPol to spatial weights matrix
wm <- nb2mat(adjPol, style = 'B')
wm

########################################
########## Compute MORAN'S I ###########
########################################

# number of observations
n <- length(kantone_Moran)

# get the y and ymean value of the observations
y <- kantone_Moran$mean_value
ybar <- mean(y, na.rm = TRUE)

# according to the Moran's formula we need:
# (yi-ymean)^2

dy <- y - ybar
g <- expand.grid(dy,dy) # Creates a data frame from all combinations of the supplied vectors
yiyj <- g[,1] * g[,2]


# Make a matrix of the multiplied pairs
pm <- matrix(yiyj, ncol=n)

# Multiply this matrix with the weights to set
# to zero the value for the pairs that are not adjacent !!

pmw <- pm * wm
pmw

# We now sum the values
spmw <- sum(pmw, na.rm = TRUE)
spmw

# Next, divide this value by the sum of weights.
smw <- sum(wm, na.rm = TRUE)
sw  <- spmw / smw

# And compute the inverse variance of y
vr <- n / sum(dy^2, na.rm = TRUE)

# The final step to compute Moran’s I
MI <- vr * sw
MI
