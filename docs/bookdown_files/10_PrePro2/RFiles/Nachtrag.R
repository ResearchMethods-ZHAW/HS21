typeof(42)
typeof(42L)

zahlen <- factor(c("null","eins","zwei","drei"))

zahlen

zahlen <- factor(zahlen,ordered = T)

zahlen

zahlen <- factor(zahlen,ordered = T,levels = c("null","eins","zwei","drei","vier"))

zahlen

typeof(zahlen)

is.integer(zahlen)

class(zahlen)

zahlen
as.integer(zahlen)

zahlen2 <- factor(c("3","2","1","0"))

as.integer(zahlen2)


zahlen2 <- factor(c("3","2","1","0"))

as.integer(as.character(zahlen2))


library(tidyverse)

df1 <- read_table("09_PrePro1/data/order_52252_data.txt",
                  col_types = list(
                    col_character(),                  # Macht aus der 1.Spalte ein character
                    col_datetime(format = "%Y%m%d%H"),# Macht aus der 2.Spalte ein POSIXct
                    col_double()                      # Macht aus der 3.Spalte ein double
                    )
                  )

df1

df1 <- read_table("09_PrePro1/data/order_52252_data.txt",
                  col_types = list(
                    col_factor(levels = NULL),        # Macht aus der 1.Spalte ein factor
                    col_datetime(format = "%Y%m%d%H"),# Macht aus der 2.Spalte ein POSIXct
                    col_double()                      # Macht aus der 3.Spalte ein double
                    )
                  )


df1

