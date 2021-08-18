---
title: knitr
output: distill::distill_article

---






```r
library(tidyverse)
library(lubridate)
```

## Demo: `ggplot2`

[Demoscript als Download](11_InfoVis1/RFiles/Demo_ggplot.R)

Als erstes laden wir den Wetterdatensatz von der Übung Prepro1 ein.


```r
wetter <- read_table("09_PrePro1/data/order_52252_data.txt",
                  col_types = list(
                    col_factor(levels = NULL),    
                    col_datetime(format = "%Y%m%d%H"),
                    col_double()
                    )
                  )
## Error: '09_PrePro1/data/order_52252_data.txt' does not exist in current working directory ('/home/nils/temp/Unterrichtsunterlagen_HS20/_infovis1/Demo_ggplot').
```



```
## Error in head(wetter): object 'wetter' not found
```







































