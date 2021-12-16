## --------------------------------------------------------------------------------------------------
library(sf)
library(terra)
library(dplyr)
library(tmap)


## ----solutionEx1, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------

#Vector data
kt_schwyz <- read_sf("Untersuchungsgebiet_Schwyz.gpkg")
settlements <- read_sf("Bewohnte_Flaeche.gpkg")
forests <- read_sf("Waldgebiete.gpkg")
protected_areas <- read_sf("Nationale_Schutzgebiete.gpkg")
lakes <- read_sf("Seeflaechen.gpkg")
streets <- read_sf("Strassen.gpkg") %>% st_intersection(kt_schwyz) #intersect with study area

#Raster data
eis25m <- rast("eis25m.tif")
dhm25m <- rast("dhm25m.tif")
wind25m <- rast("wind25m.tif")




## ----message=FALSE, warning=FALSE, include=FALSE---------------------------------------------------
#Plot vector data
tm_shape(lakes) + tm_polygons(col = "dodgerblue3") +
  tm_shape(streets) + tm_lines(col = "gray18") +
  tm_shape(forests) + tm_polygons(col = "darkseagreen4", alpha = 0.5) +
  tm_shape(settlements) + tm_polygons(col = "gray",alpha = 0.5)


## ----message=FALSE, warning=FALSE, include=FALSE---------------------------------------------------
tm_shape(dhm25m) + tm_raster(style = "cont") + tm_shape(kt_schwyz) + tm_borders()
tm_shape(eis25m) + tm_raster(style = "cont") + tm_shape(kt_schwyz) + tm_borders()
tm_shape(wind25m) + tm_raster(style = "cont") + tm_shape(kt_schwyz) + tm_borders()


## ----create_empty_raster---------------------------------------------------------------------------
r <- terra::rast(ext(kt_schwyz), 
          resolution = c(250, 250), 
          crs = "EPSG:21781")




## ----solutionEx2, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------

#Merge exclusion area
exclusion_areas <- dplyr::bind_rows(settlements, forests, protected_areas, lakes)

#create raster
r <- terra::rast(ext(kt_schwyz), 
          resolution = c(250, 250), 
          crs = "EPSG:21781")

raster_exclusion_areas <- rasterize(vect(exclusion_areas), r,
                       field = 0, background = 1) %>% crop(kt_schwyz)
plot(raster_exclusion_areas, main="Exclusion area", axes=FALSE, legend=FALSE, col=terrain.colors(2))




## ----solutionEx3, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------

slope <- terra::terrain(dhm25m, v="slope",unit="degrees", neighbors=8)
slope_250 <- slope %>% aggregate(.,fact = 10)
plot(slope_250, main="Slope", axes=FALSE)




## ----solutionEx4, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------
#create raster layers from vector 
raster_settlements <- terra::rasterize(vect(settlements), r, field = 1)
raster_protected_areas <- terra::rasterize(vect(protected_areas), r, field = 1) 
raster_forests <- terra::rasterize(vect(forests), r, field = 1) 
raster_streets <- terra::rasterize(vect(streets$geom), r, field = 1)

#calculate euclidean distances
settlements_ed <- distance(raster_settlements) %>% raster::raster() %>% raster::mask(kt_schwyz) %>% terra::rast()
protected_areas_ed <- distance(raster_protected_areas) %>% raster::raster() %>% raster::mask(kt_schwyz) %>% terra::rast()
forests_ed <- distance(raster_forests) %>% raster::raster() %>% raster::mask(kt_schwyz) %>% terra::rast()
streets_ed <- distance(raster_streets) %>% raster::raster() %>% raster::mask(kt_schwyz) %>% terra::rast()


## ----examplereclassifysettlements------------------------------------------------------------------

settlements_max <- minmax(settlements_ed)[2]

reclass_settlements <- c(0,80,0,
                        80,160,0.1,
                        160,240,0.2,
                        240,320,0.3,
                        320,400,0.4,
                        400,480,0.5,
                        480,560,0.6,
                        560,640,0.7,
                        640,720,0.8,
                        720,800,0.9,
                        800,settlements_max,1.0) %>% matrix(ncol = 3, byrow = TRUE)
reclass_settlements_ed <- terra::classify(settlements_ed, reclass_settlements)






## ----solutionEx5, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------
wind250m <- wind25m %>% aggregate(.,fact = 10)
wind_max <- minmax(wind250m)[2]

#### reclassify wind    

reclass_wind_m <- c(0,35,0,
                      35,40,0.1,
                      40,45,0.2,
                      45,50,0.3,
                      50,55,0.4,
                      55,60,0.5,
                      60,65,0.6,
                      65,70,0.7,
                      70,75,0.8,
                      75,wind_max,0.9) %>% matrix(ncol = 3, byrow = TRUE)
reclass_wind <- classify(wind250m, reclass_wind_m)
plot(reclass_wind, main="Average wind speed (reclassified)", axes=FALSE)

#### reclassify ice    
eis250m <- eis25m %>% aggregate(.,fact = 10) ## lowering the resolution
eis_max <- minmax(eis250m)[2]
#### reclassify ice    
reclass_ice_m <- c(0,6,1,
                     6,12,0.9,
                     12,18,0.8,
                     18,24,0.7,
                     24,30,0.6,
                     30,36,0.5,
                     36,eis_max,0.4) %>% matrix(ncol = 3, byrow = TRUE)
reclass_ice <- classify(eis250m, reclass_ice_m)
plot(reclass_ice, main="Icing frequency (reclassified)", axes=FALSE)

#### reclassify slope
slope250m <- slope %>% aggregate(.,fact = 10) ## lowering the resolution
slope_max <- minmax(slope250m)[2]
#### reclassify slope
reclass_slope_m <- c(0,2,1,
                       2,4,0.9,
                       4,6,0.8,
                       6,8,0.7,
                       8,10,0.6,
                       10,12,0.5,
                       12,14,0.4,
                       14,16,0.3,
                       16,18,0.2,
                       18,20,0.1,
                       20,slope_max,0) %>% matrix(ncol = 3, byrow = TRUE)
reclass_slope <- classify(slope250m, reclass_slope_m)
plot(reclass_slope, main="Slope (reclassified)", axes=FALSE)

#### reclassify settlements 

settlements_max <- minmax(settlements_ed)[2]

reclass_settlements <- c(0,80,0,
                             80,160,0.1,
                             160,240,0.2,
                             240,320,0.3,
                             320,400,0.4,
                             400,480,0.5,
                             480,560,0.6,
                             560,640,0.7,
                             640,720,0.8,
                             720,800,0.9,
                             800,settlements_max,1.0) %>% matrix(ncol = 3, byrow = TRUE)
reclass_settlements_ed <- classify(settlements_ed, reclass_settlements)
plot(reclass_settlements_ed, main="Distance to settlements (reclassified)", axes=FALSE)

#### reclassify protected areas

protected_areas_max <- minmax(protected_areas_ed)[2]
reclass_protected_areas <- c(0,50,0,
                                 50,100,0.1,
                                 100,150,0.2,
                                 150,200,0.3,
                                 200,250,0.4,
                                 250,300,0.5,
                                 300,350,0.6,
                                 350,400,0.7,
                                 400,450,0.8,
                                 450,500,0.9,
                                 500,protected_areas_max,1.0) %>% matrix(ncol = 3, byrow = TRUE)
reclass_protected_areas_ed <- classify(protected_areas_ed, reclass_protected_areas)
plot(reclass_protected_areas_ed, main="Distance to protected areas (reclassified)", axes=FALSE)

#### reclassify forest area 
forests_max <- minmax(forests_ed)[2]
reclass_forests <- c(0,10,0,
                         10,20,0.1,
                         20,30,0.2,
                         30,40,0.3,
                         40,50,0.4,
                         50,60,0.5,
                         60,70,0.6,
                         70,80,0.7,
                         80,90,0.8,
                         90,100,0.9,
                         100,forests_max,1.0) %>% matrix(ncol = 3, byrow = TRUE)
reclass_forests_ed <- classify(forests_ed, reclass_forests)
plot(reclass_forests_ed, main="Distance to forest areas (reclassified)", axes=FALSE)

#### reclassify streets   

streets_max <- minmax(streets_ed)[2]
reclass_streets <- c(0,250,1.0,
                     250,500,0.9,
                     500,750,0.8,
                     750,1000,0.7,
                     1000,1250,0.6,
                     1250,1500,0.5,
                     1500,1750,0.4,
                     1750,2000,0.3,
                     2000,2250,0.2,
                     2250,2500,0.1,
                     2500,streets_max,0) %>% matrix(ncol = 3, byrow = TRUE)
reclass_streets_ed <- classify(streets_ed, reclass_streets)
plot(reclass_streets_ed, main="Distance to streets (reclassified)", axes=FALSE)


## ----ahp_mce---------------------------------------------------------------------------------------
ahp_matrix <- c(
  1, 0, 0, 0, 0, 0, 0, #Wind
  0, 1, 0, 0, 0, 0, 0, #Distance to streets
  0, 0, 1, 0, 0, 0, 0, #Ice
  0, 0, 0, 1, 0, 0, 0, #Distance to settlements
  0, 0, 0, 0, 1, 0, 0, #Distance to forests
  0, 0, 0, 0, 0, 1, 0, #Slope
  0, 0, 0, 0, 0, 0, 1  #Distance to protected areas
) %>% matrix(ncol = 7, byrow = TRUE)


## ----solutionEx6, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------

#create AHP
ahp_matrix <- c(
  1,   6,   7,   3,   7, 4,   5, #Wind
  1/6, 1,   2,   1/5, 3, 1/5, 3, #Distance to streets
  1/7, 1/2, 1,   1/6, 2, 1/5, 2, #Ice
  1/3, 5,   6,   1,   5, 3,   4, #Distance to settlements
  1/7, 1/3, 1/2, 1/5, 1, 1/4, 1, #Distance to forests
  1/4, 5,   3,   1/3, 4, 1,   4, #Slope
  1/5, 1/3, 1/2, 1/4, 1, 1/4, 1  #Distance to protected areas
) %>% matrix(ncol = 7, byrow = TRUE)
colnames(ahp_matrix) <- c("Wind", "Streets", "Ice", "Settlements", "Forest", "Slope", "Protected areas")
rownames(ahp_matrix) <- c("Wind", "Streets", "Ice", "Settlements", "Forest", "Slope", "Protected areas")

#Normalization of matrix & weighting of criteria
weights <- rowSums(ahp_matrix) #add row sum




## ----solutionEx7, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------

# rasterOptions(tolerance = 0.5) #raster sets have different origins, increase tolerance

wind_f <- (reclass_wind * weights[1])
streets_f <- (reclass_streets_ed * weights[2])
eis_f <- (reclass_ice * weights[3]) 
settlements_f <- (reclass_settlements_ed * weights[4])
forests_f <- (reclass_forests_ed * weights[5])
slope_f <- (reclass_slope * weights[6])
protected_areas_f <- (reclass_protected_areas_ed * weights[7])

weighted_overlay <- terra::merge(streets_f,eis_f,settlements_f,forests_f,
                                  slope_f,protected_areas_f,wind_f)

# Transforming all the layer from SpatRaster class to RasterLayer class, so
# we can perform the raster multiplication operation

streets_R <- streets_f %>% raster::raster()
eis_R <- eis_f %>% raster::raster()
settlements_R <- settlements_f %>% raster::raster()
forests_R <- forests_f %>% raster::raster()
slope_R <- slope_f %>% raster::raster()
protected_areas_R <- protected_areas_f %>% raster::raster()
wind_R <- wind_f %>% raster::raster()

weighted_overlay <- streets_R*eis_R*settlements_R*forests_R*slope_R*protected_areas_R*wind_R

plot(weighted_overlay, main="Weighted overlay with all criteria", axes=FALSE, legend=F)





## ----solutionEx8, echo=FALSE, message=FALSE, warning=FALSE, include=FALSE--------------------------

# Transforming  the layer depicting the exclusion areas from SpatRaster class to RasterLayer class, so we can perform the final raster multiplication operation
raster_exclusion_areas <- raster_exclusion_areas %>% raster::raster()
final_model <- weighted_overlay * raster_exclusion_areas
plot(final_model, main="Potential sites for wind power plants in Kt. Schwyz", axes=FALSE, legend=F)


