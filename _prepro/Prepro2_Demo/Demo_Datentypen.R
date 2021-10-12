
#' ### Piping 


subtrahieren <- function(minuend, subtrahend){
  differenzwert <- minuend - subtrahend
  return(differenzwert)
}

multiplizieren <- function(multiplikator, multiplikand){
  produkt <- multiplikator*multiplikand
  return(produkt)
}

dividieren <- function(dividend, divisor){
  quotiend <- dividend/divisor
  return(quotiend)
}

diary <- c(
  "The temperature is 21° Farenheit",
  "The temperature is 42° Farenheit",
  "The temperature is 55° Farenheit"
)

dividieren(multiplizieren(subtrahieren(as.numeric(substr(diary, 20, 21)),32),5),9)

# Nimm diary, und dann
temp1 <- substr(diary, 20, 21)     # extrahiere werte 20 bis 21, und dann
temp2 <- as.numeric(temp1)         # konvertiere character zu numeric, und dann
temp3 <- subtrahieren(temp2, 32)   # subtrahiere 32, und dann
temp4 <- multiplizieren(temp3, 5)  # multipliziere mit 5, und dann
output <- dividieren(temp4, 9)     # dividieren mit 9

diary |>                          # Nimm diary, und dann
  substr(20, 21) |>               # extrahiere werte 20 bis 21, und dann
  as.numeric() |>                 # konvertiere character zu numeric, und dann
  subtrahieren(32) |>             # subtrahiere 32, und dann
  multiplizieren(5) |>            # multipliziere mit 5, und dann
  dividieren(9)                    # dividieren mit 9
  



