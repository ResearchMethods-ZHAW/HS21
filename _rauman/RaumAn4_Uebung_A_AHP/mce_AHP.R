
#' ## Exercise 1: Define initial situation 
# Goal: Rent a new apartment The 4 criteria we will use to are:

# Citeria: 
# - Price
# - Distance to work
# - Size
# - Scenic Beauty

# Options / Alternatives
# 1. Weinbergstrasse 17, 8134 Adliswil, 35 m2 for 1’455 CHF, not so pretty and 45 minutes from work
# 2. Zürichstrasse 56, 8134 Adliswil,  104 m2 for 2’960.– CHF, very pretty and 45 minutes from work
# 3. Geissbergstrasse 18, 8184 Bachenbülach, 130 m2 for 3’800 CHF, very pretty and 30 mintues from work


#' ## Exercise 2: Pairwise comparison (Paarweiser Vergleich 1 & 2)

pairwise_comparison <- c(
  1,   3, 0, 0,
  1/3, 1, 0, 0,
  0,   0, 1, 0,
  0,   0, 0, 1
) %>% matrix(ncol = 4, byrow = TRUE) 


# criteria 1: Price
# criteria 2: Distance to work
# criteria 3: Size
# criteria 4: Scenic Beauty
pairwise_comparison <- c(
  1,   5,   9,   9,
  1/5, 1,   6,   7,
  1/9, 1/6, 1,   7,
  1/9, 1/7, 1/7, 1
) %>%
  matrix(ncol = 4, byrow = TRUE)


criterias <- c("price", "distance","size", "beauty")

rownames(pairwise_comparison) <- criterias
colnames(pairwise_comparison) <- criterias

#' ## Exercise 3: Calculation of the criteria weights 
#' ### Exercise 3.1: Normalization of matrix (Berechnung der Kritiriengewichte 1)

ahp_colsums <- colSums(pairwise_comparison)

pairwise_comparison_normalized <- sweep(pairwise_comparison, 2,ahp_colsums, FUN = "/")



#' ### Exercise 3.2: Weighting of criteria (Berechnung der Kritiriengewichte 2)
criteria_sums <- rowSums(pairwise_comparison_normalized)

criteria_weight <- criteria_sums/sum(criteria_sums)

sum(criteria_weight)


#' ## Exercise 4: Consistency analysis (Konsistenzanalyse 1 & 2)
a_values <- pairwise_comparison %*% criteria_weight

b_values <- a_values / criteria_weight

lambda_max = sum(a_values)/ncol(pairwise_comparison)

CI <- (lambda_max - ncol(pairwise_comparison)) / (ncol(pairwise_comparison)-1)

RI <- 0.89

CR <- CI/RI

CR < 0.1


#' ## Congratulations!
#' ## Musterlösung

