
library(tidyverse)
library(plotly)
library(pander)
library(webshot)

## 
## # Nur nötig, wenn ihr mit einer lokalen Installation von RStudio arbeitet
## # (also nicht auf dem Server).
## options(viewer=NULL)
## 
# Lösung Aufgabe 1

p <- mtcars %>%
  plot_ly(type = 'parcoords',
          line = list(color = ~mpg,
                      colorscale = list(c(0,'red'),c(1,'blue'))),
          dimensions = list(
            list(label = 'mpg', values = ~mpg),
            list(label = 'disp', values = ~disp),
            list(label = 'hp', values = ~hp),
            list(label = 'drat', values = ~drat),
            list(label = 'wt', values = ~wt),
            list(label = 'qsec', values = ~qsec),
            list(label = 'vs', values = ~vs),
            list(label = 'am', values = ~am),
            list(label = 'gear', values = ~gear),
            list(label = 'carb', values = ~carb)
          )
  )


beaver1_new <- beaver1 %>%
  mutate(beaver = "nr1")

beaver2_new <- beaver2 %>%
  mutate(beaver = "nr2")

beaver_new <- rbind(beaver1_new,beaver2_new)

beaver_new <- beaver_new %>%
  mutate(
    hour_dec = (time/100)%/%1,         # Ganze Stunden (mittels ganzzaliger Division)
    min_dec = (time/100)%%1/0.6,       # Dezimalminuten (15 min wird zu 0.25, via Modulo)
    hour_min_dec = hour_dec+min_dec    # Dezimal-Zeitangabe (03:30 wird zu 3.5)
    ) 

# Lösung Aufgabe 2

p <- beaver_new %>%
  plot_ly(r = ~temp, t = ~hour_min_dec, color = ~beaver,mode = "lines", type = "scatter") %>%
  layout(
    radialaxis = list(range = c(35,39)),
    angularaxis = list(range = c(0,24)),
    orientation = 270,
    showlegend = F
    )
AirPassengers

class(AirPassengers)
AirPassengers2 <- tapply(AirPassengers, list(year = floor(time(AirPassengers)), month = month.abb[cycle(AirPassengers)]), c)


AirPassengers3 <- AirPassengers2 %>%
  as.data.frame() %>%
  rownames_to_column("year") %>%
  gather(month,n,-year) %>%
  mutate(
    # ich nutze einen billigen Trick um ausgeschriebene Monate in Nummern umzuwandeln [1]
    month = factor(month, levels = month.abb,ordered = T),
    month_numb = as.integer(month),
    year = factor(year, ordered = T)
  )


# [1] beachtet an dieser Stelle das Verhalten von as.integer() wenn es sich um factors() handelt. Hier wird das Verhalten genutzt, andersweitig kann es einem zum Verhngnis werden. Das Verhalten wir auch hier verdeutlicht:
# as.integer(as.character("500"))
# as.integer(as.factor("500"))


# Lösung Aufgabe 3

p <- AirPassengers3 %>%
  plot_ly(r = ~n, t = ~month_numb, color = ~year, mode = "markers", type = "scatter") %>%
  layout(
    showlegend = T,
    angularaxis = list(range = c(0,12)),
    orientation = 270,
    legend = list(traceorder = "reversed")
) 


# Lösung Aufgabe 4

p <- trees %>%
  plot_ly(x = ~Girth, y = ~Height, z = ~Volume)
## 
## # Lösung Aufgabe 4
## 
## wetter <- readr::read_table("09_PrePro1/data/order_52252_data.txt")
