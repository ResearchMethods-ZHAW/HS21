## Testing Moran's I implementation

## Wasserverfügbarkeit

library(sf)
library(tidyverse)
library(stars)
library(raster)

# Reading and importing the data #

wasser <- read_sf("21_RaumAn1/data/wasserverfuegbarkeit_boden.gpkg")
kantone <- st_read("21_RaumAn1/data/kantone.gpkg")
#bezirke <- st_read("data/BEZIRKSGEBIET.shp") # Bezirksgebiet (second aggregation level)

# -- transform to CH1903+LV95 -- 
wasser <- st_set_crs(wasser, 4326)
wasser <- st_transform(wasser, crs = 2056)

kantone <- st_transform(kantone, crs = 2056) %>%
  st_zm(kantone) # remove z information
bezirke <- st_transform(bezirke, crs = 2056) %>%
  st_zm(bezirke) # remove z information


#----------------------------------------
wasser_kanton <- st_join(wasser, kantone)

kantone_union <- kantone %>%
  group_by(KANTONSNUM) %>%
  summarise()

wasser_kanton_mean <- wasser_kanton %>%
  group_by(KANTONSNUM) %>%
  summarise(mean_value = mean(wasserverfuegbarkeit))

# spatial join cantons and wasserverfügbarkeit 
wasser_kanton_moran <- st_join(kantone_union, wasser_kanton_mean)

# convert to spatial object
wasser_kanton_moran <- as(wasser_kanton_moran, "Spatial")

# getting the centroids of the polygons
xy <- coordinates(wasser_kanton_moran)

## Find the ADJACENT Polygons
library(spdep)
adjPol <- poly2nb(wasser_kanton_moran, row.names = wasser_kanton_moran$KANTONSNUM.x)

# Plot the links between the polygons
plot(wasser_kanton_moran, col='gray', border='blue', lwd=2)
plot(adjPol, xy, col='red', lwd=2, add=TRUE)

# transform AdjPol to spatial weights matrix
wm <- nb2mat(adjPol, style = 'B')
wm

########################################
########## Compute MORAN'S I ###########
########################################

# number of observations
n <- length(wasser_kanton_moran)

# get the y and ymean value of the observations
y <- wasser_kanton_moran$mean_value
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

