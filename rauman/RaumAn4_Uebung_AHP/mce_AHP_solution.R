## ----solution, eval=FALSE------------------------------------------------------------
# Load libraries
library(dplyr)
options(digits=3) #set default decimal places to 3

## ###########################################################
## ## -- Use Case 1 - Analytical Hierarchy Process (AHP) -- ##
## ###########################################################
## 
## -- Exercise 1: Define initial situation -- ##
## # Goal for your AHP:
##   # Buy a car
## # Criteria:
##   # Price
##   # Engine
##   # Horsepower (hp)
##   # Safety
## # Alternatives:
##   # Renault Clio
##   # Volvo V90
##   # VW Golf
## 
## -- Exercise 2: Pairwise comparison -- ##
atts_comp <- c("Price", "Engine", "Horsepower (hp)", "Safety") #define column and row names
# generate matrix
ahp_matrix_criteria <- c(
  1,   7, 3, 1/4,
  1/7, 1, 1/5, 1/7,
  1/3,   5, 1, 1/2,
  4,   7, 2, 1
) %>% matrix(ncol = 4, byrow = TRUE) 

colnames(ahp_matrix_criteria) <- atts_comp #add column titles
rownames(ahp_matrix_criteria) <- atts_comp #add row titles
## ahp_matrix_criteria
## 
## ## -- Exercise 3: Calculate criteria weights -- ##

## ## -- Exercise 3.1: Normalization of matrix -- ##

ahp_matrix_criteria_norm <- sweep(ahp_matrix_criteria, 2, colSums(ahp_matrix_criteria), FUN="/") #run sweep function to divide each matrix value with its column sum
ahp_matrix_criteria_norm

## ## -- Exercise 3.2: Weighting of criteria -- ##
ahp_matrix_criteria_final <- ahp_matrix_criteria_norm %>% cbind(rowSums(ahp_matrix_criteria_norm))
ahp_matrix_criteria_final <- sweep(ahp_matrix_criteria_final, 2, colSums(ahp_matrix_criteria_final), FUN="/")
ahp_matrix_criteria_final

## ## -- Exercise 4: Consistency matrix -- ##
a_values <- ahp_matrix_criteria %*% ahp_matrix_criteria_final[, 5] %>%
  sweep(2, ahp_matrix_criteria_final[, 5], "/", check.margin=FALSE)

lambda_max <- colSums(a_values) / ncol(ahp_matrix_criteria)

# consistency index CI
consistency_index <- (lambda_max - ncol(ahp_matrix_criteria)) / (ncol(ahp_matrix_criteria) - 1)
consistency_index

# consistency ratio CR
random_index <- 0.89 #value from the random index table
consistency_ratio <- consistency_index / random_index
consistency_ratio #the CR value is under 0.10 so we can continue with our AHP

## -- Exercise 4: Prioritization of the alternatives -- ##
# Price
criteria_1_prio <- c(
  1, 1/2, 1/4, #Renault Clio
  2, 1,   1/3, #Volvo V90
  4, 3,   1    #VW Golf
) %>% matrix(ncol = 3, byrow = TRUE)
criteria_1_prio <- criteria_1_prio %>% cbind(rowSums(criteria_1_prio)) #calculate & add weights
criteria_1_prio <- sweep(criteria_1_prio, 2, colSums(criteria_1_prio), FUN="/") #normalization of table
criteria_1_prio

# Engine
criteria_2_prio <- c(
  1,   2, 7,   #Renault Clio
  1/2, 1, 1/5, #Volvo V90
  1/7, 5, 1    #VW Golf
) %>% matrix(ncol = 3, byrow = TRUE)
criteria_2_prio <- criteria_2_prio %>% cbind(rowSums(criteria_2_prio)) #calculate & add weights
criteria_2_prio <- sweep(criteria_2_prio, 2, colSums(criteria_2_prio), FUN="/") #normalization of table
criteria_2_prio
 
# Horsepower (hp)
criteria_3_prio <- c(
  1,   8, 2,   #Renault Clio
  1/8, 1, 1/3, #Volvo V90
  1/2, 3, 1    #VW Golf
) %>% matrix(ncol = 3, byrow = TRUE)
criteria_3_prio <- criteria_3_prio %>% cbind(rowSums(criteria_3_prio)) #calculate & add weights
criteria_3_prio <- sweep(criteria_3_prio, 2, colSums(criteria_3_prio), FUN="/") #normalization of table
criteria_3_prio

# Safety
criteria_4_prio <- c(
  1,   1/6, 2, #Renault Clio
  6,   1,   7, #Volvo V90
  1/2, 1/7, 1  #VW Golf
) %>% matrix(ncol = 3, byrow = TRUE)
criteria_4_prio <- criteria_4_prio %>% cbind(rowSums(criteria_4_prio)) #calculate & add weights
criteria_4_prio <- sweep(criteria_4_prio, 2, colSums(criteria_4_prio), FUN="/") #normalization of table
criteria_4_prio

# Final table of alternatives and it's criteria
atts_alt <- c("Renault Clio", "Volvo V90", "VW Golf")
ahp_alternative <- cbind(
  criteria_1_prio[, 4],
  criteria_2_prio[, 4],
  criteria_3_prio[, 4],
  criteria_4_prio[, 4]
)
rownames(ahp_alternative) <- atts_alt
colnames(ahp_alternative) <- atts_comp
ahp_alternative

# calculate final prioritization by multiplying the alternatives with the criteria weights
final_prio <- ahp_alternative %*% ahp_matrix_criteria_final[, 5]
colnames(final_prio) <- c("Prioritization")
final_prio

## -- Exkurs: Example of AHP package in R -- ##
devtools::install_github("gluc/ahp", build_vignettes = TRUE)
library(ahp)

# Load data
ahpFile <- system.file("extdata", "car.ahp", package="ahp")
carAhp <- Load(ahpFile)

Calculate(carAhp) #calculate AHP
Visualize(carAhp) #visualize the decision tree
Analyze(carAhp) #output model analysis
AnalyzeTable(carAhp) #output model analysis in html table

