#' 
#' 
#' # PrePro1 (16.10.2017)
#' 
#' Die Datenkunde 2.0 gibt den Studierenden das Wissen und die Fertigkeiten an die Hand, selbst erhobene und bezogene Daten für Ihre eigenen Analysen vorzubereiten und anzureichern (preprocessing). Die Einheit vermittelt zentrale Datenverarbeitungskompetenzen und thematisiert bekannte Problemzonen der umweltwissenschaftlichen Datenverarbeitung – immer mit einer „hands-on“ Perspektive auf die begleitenden R-Übungen. Die Studierenden lernen die Eigenschaften ihrer Datensätze in der Fachsprache korrekt zu beschreiben. Sie lernen ausserdem Metadaten zu verstehen und die Implikationen derselben für ihre eigenen Analyseprojekte kritisch zu beurteilen. Zentrale Konzepte der Lerneinheit sind Skalenniveaus, Datentypen, Zeitdaten und Typumwandlungen.
#' 
#' ## Demo: Datentypen, Tabellen
#' 
#' [R-Demoscript als Download](09_PrePro1/RFiles/Demo_Datentypen.R)
#' 
#' ### Datentypen 
#' 
#' 
#' #### Numerics
#' 
#' Unter die Kategorie `numeric` fallen in R zwei Datentypen:
#' 
#' - `double`: Gleitkommazahl (z.B. 10.3, 7.3)
#' - `integer`: Ganzzahl (z.B. 10, 7)
#' 
#' ##### Doubles
#' 
#' Folgendermassen wird eine Gleitkommazahl einer Variabel zuweisen:
#' 
## ------------------------------------------------------------------------
x <- 10.3

x

typeof(x)

#' 
#' 
#' 
#' Statt `<-`kann auch `=` verwendet werden. Dies funktioniert aber nicht in allen Situationen, und ist zudem leicht mit `==` zu verwechseln.
#' 
## ------------------------------------------------------------------------
y = 7.3

y

#' 
#' 
#' 
#' Ohne explizite Zuweisung nimmt R immer den Datentyp `double`an:
#' 
## ------------------------------------------------------------------------
z <- 42
typeof(z)
is.integer(z)
is.numeric(z)
is.double(z)


#' 
#' #### Ganzzahl / Integer 
#' 
#' 
#' Erst wenn man eine Zahl explizit als `integer` definiert (mit `as.integer()` oder `L`), wird sie auch als solches abgespeichert.
#' 
## ------------------------------------------------------------------------
a <- as.integer(z)
is.numeric(a)
is.integer(a)

c <- 8L
is.numeric(c)
is.integer(c)

#' 
#' 
#' 
#' 
## ------------------------------------------------------------------------
typeof(a)

is.numeric(a)
is.integer(a)

#' 
#' 
#' 
#' Mit `c()` können eine Reihe von Werten in einer Variabel zugewiesen werden (als `vector`). Es gibt zudem auch `character verctors`. 
#' 
## ------------------------------------------------------------------------
vector <- c(10,20,33,42,54,66,77)
vector
vector[5]
vector[2:4]

vector2 <- vector[2:4]

#' 
#' 
#' 
#' Eine Ganzzahl kann explizit mit `as.integer()` definiert werden.
#' 
## ------------------------------------------------------------------------
a <- as.integer(7)
b <- as.integer(3.14)
a
b
typeof(a)
typeof(b)
is.integer(a)
is.integer(b)


#' 
#' Eine Zeichenkette kann als Zahl eingelesen werden.
#' 
## ------------------------------------------------------------------------
c <- as.integer("3.14")
c
typeof(c)

#' 
#' 
#' #### Logische Abfragen 
#' 
#' Wird auch auch als boolesch (Eng. **boolean**) bezeichnet.
#' 
## ------------------------------------------------------------------------
e <- 3
f <- 6
g <- e > f
e
f
g
typeof(g)


#' 
#' #### Logische Operationen
#' 
#' 
## ------------------------------------------------------------------------
sonnig <- TRUE
trocken <- FALSE

sonnig & !trocken

#' 
#' Oft braucht man auch das Gegenteil / die Negation eines Wertes. Dies wird mittels `!` erreicht
#' 
## ------------------------------------------------------------------------
u <- TRUE
v <- !u 
v

#' 
#' 
#' 
#' #### Zeichenketten
#' 
#' Zeichenketten (Eng. **character**) stellen Text dar
#' 
## ------------------------------------------------------------------------
s <- as.character(3.14)
s
typeof(s)

#' 
#' 
#' 
#' Zeichenketten verbinden / zusammenfügen (Eng. **concatenate**)
#' 
## ------------------------------------------------------------------------
fname <- "Hans"
lname <- "Muster"
paste(fname,lname)

fname2 <- "hans"
fname == fname2

#' 
#' 
#' #### `Factors`
#' 
#' Mit `Factors` wird in R eine Sammlung von Zeichenketten bezeichnet, die sich wiederholen, z.B. Wochentage (es gibt nur 7 unterschiedliche Werte für "Wochentage").
#' 
## ------------------------------------------------------------------------
wochentage <- c("Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag",
                "Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag")

typeof(wochentage)

wochentage_fac <- as.factor(wochentage)

wochentage
wochentage_fac



#' 
#' Wie man oben sieht, unterscheiden sich `character vectors` und `factors` v.a. dadurch, dass letztere über sogenannte `levels` verfügt. Diese `levels` entsprechen den Eindeutigen (`unique`) Werten.
#' 
## ------------------------------------------------------------------------
levels(wochentage_fac)

unique(wochentage)

#' 
#' 
#' 
#' #### Zeit/Datum
#' 
#' Um in R mit Datum/Zeit Datentypen umzugehen, müssen sie als `POSIXct` eingelesen werden (es gibt alternativ noch `POSIXlt`, aber diese ignorieren wir mal). Anders als Beispielsweise bei Excel, sollten in R Datum und Uhrzeit immer in **einer Spalte** gespeichert werden.
#' 
## ------------------------------------------------------------------------
datum <- "2017-10-01 13:45:10"

as.POSIXct(datum)


#' 
#' Wenn das die Zeichenkette in dem obigen Format (Jahr-Monat-Tag Stunde:Minute:Sekunde) daher kommt, braucht `as.POSIXct`keine weiteren Informationen. Sollte das Format von dem aber Abweichen, muss man der Funktion das genaue Schema jedoch mitteilen. Der Syntax dafür kann via `?strptime` nachgeschlagen werden.
#' 
## ------------------------------------------------------------------------
datum <- "01.10.2017 13:45"

as.POSIXct(datum,format = "%d.%m.%Y %H:%M")


#' 
#' Beachtet, dass in den den obigen Beispiel R automatisch eine Zeitzone angenommen hat (`CEST`). R geht davon aus, dass die Zeitzone der **System Timezone** (`Sys.timezone()`) entspricht.
#' 
#' 
#' ### Data Frames und Conveniance Variabeln
#' 
#' Eine `data.frame` ist die gängigste Art, Tabellarische Daten zu speichern. 
#' 
## ------------------------------------------------------------------------
df <- data.frame(
  Stadt = c("Zürich","Genf","Basel","Bern","Lausanne"),
  Einwohner = c(396027,194565,175131,140634,135629),
  Ankunft = c("1.1.2017 10:00","1.1.2017 14:00",
              "1.1.2017 13:00","1.1.2017 18:00","1.1.2017 21:00")
)

str(df)


#' 
#' In der obigen `data.frame` wurde die Spalte `Einwohner` als Fliesskommazahl abgespeichert. Dies ist zwar nicht tragisch, aber da wir wissen das es sich hier sicher um Ganzzahlen handelt, können wir das korrigieren. Wichtiger ist aber, dass wir die Ankunftszeit (Spalte`Ankunft`) von  einem `Factor` in ein Zeitformat (`POSIXct`) umwandeln. 
#' 
#' 
## ------------------------------------------------------------------------
df$Einwohner <- as.integer(df$Einwohner)

df$Einwohner

df$Ankunft <- as.POSIXct(df$Ankunft, format = "%d.%m.%Y %H:%M")

df$Ankunft

#' 
#' 
#' Diese Rohdaten können nun helfen, um Hilfsvariablen (**convenience variables**) zu erstellen. Z.B. können wir die Städte einteilen in gross, mittel und klein. 
#' 
## ------------------------------------------------------------------------
df$Groesse[df$Einwohner > 300000] <- "gross"
df$Groesse[df$Einwohner <= 300000 & df$Einwohner > 150000] <- "mittel"
df$Groesse[df$Einwohner <= 150000] <- "klein"


#' 
#' 
#' 
#' Oder aber, die Ankunftszeit kann von der Spalte `Ankunft`abgeleitet werden. Dazu brauchen wir aber das Package `lubridate`
#' 
## ---- message = F--------------------------------------------------------
library(lubridate)

#' 
#' 
## ------------------------------------------------------------------------
df$Ankunft_stunde <- hour(df$Ankunft)

#' 
#' ### Quellen
#' 
#' 
#' 
#' 
#' 
