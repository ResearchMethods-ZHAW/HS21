x <- 10.3

x

typeof(x)

y = 7.3

y

z <- 42
typeof(z)
is.integer(z)
is.numeric(z)
is.double(z)


a <- as.integer(z)
is.numeric(a)
is.integer(a)

c <- 8L
is.numeric(c)
is.integer(c)

typeof(a)

is.numeric(a)
is.integer(a)

vector <- c(10,20,33,42,54,66,77)
vector
vector[5]
vector[2:4]

vector2 <- vector[2:4]

a <- as.integer(7)
b <- as.integer(3.14)
a
b
typeof(a)
typeof(b)
is.integer(a)
is.integer(b)


c <- as.integer("3.14")
c
typeof(c)

e <- 3
f <- 6
g <- e > f
e
f
g
typeof(g)


sonnig <- TRUE
trocken <- FALSE

sonnig & !trocken

u <- TRUE
v <- !u 
v

s <- as.character(3.14)
s
typeof(s)

fname <- "Hans"
lname <- "Muster"
paste(fname,lname)

fname2 <- "hans"
fname == fname2

wochentage <- c("Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag",
                "Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag")

typeof(wochentage)

wochentage_fac <- as.factor(wochentage)

wochentage
wochentage_fac



levels(wochentage_fac)

unique(wochentage)

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

datum <- "2017-10-01 13:45:10"

as.POSIXct(datum)


datum <- "01.10.2017 13:45"

as.POSIXct(datum,format = "%d.%m.%Y %H:%M")

datum <- as.POSIXct(datum,format = "%d.%m.%Y %H:%M")



strftime(datum, format = "%m")
strftime(datum, format = "%b")
strftime(datum, format = "%B")

df <- data.frame(
  Stadt = c("Zürich","Genf","Basel","Bern","Lausanne"),
  Einwohner = c(396027,194565,175131,140634,135629),
  Ankunft = c("1.1.2017 10:00","1.1.2017 14:00",
              "1.1.2017 13:00","1.1.2017 18:00","1.1.2017 21:00")
)

str(df)


df$Einwohner <- as.integer(df$Einwohner)

df$Einwohner

df$Ankunft <- as.POSIXct(df$Ankunft, format = "%d.%m.%Y %H:%M")

df$Ankunft

df$Groesse[df$Einwohner > 300000] <- "gross"
df$Groesse[df$Einwohner <= 300000 & df$Einwohner > 150000] <- "mittel"
df$Groesse[df$Einwohner <= 150000] <- "klein"


library(lubridate)

df$Ankunft_stunde <- hour(df$Ankunft)
```{.r .distill-force-highlighting-css}
```
