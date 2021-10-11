---
title: Uebung
output: 
  distill::distill_article:
    toc: true
categories:
- PrePro1
author:
  - name: Patrick Laube
  - name: Nils Ratnaweera
  - name: Nikolaos Bakogiannis
draft: false
preview: preview.png
---




## Arbeiten mit RStudio "Project"

Wir empfehlen die Verwendung von "Projects" innerhalb von RStudio. RStudio legt für jedes Projekt dann einen Ordner an, in welches die Projekt-Datei abgelegt wird (Dateiendung `.Rproj`). Sollen innerhalb des Projekts dann R-Skripts geladen oder erzeugt werden, werden diese dann auch im angelegten Ordner abgelegt. Mehr zu RStudio Projects findet ihr  [hier](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects).


Das Verwenden von Projects bringt verschiedene Vorteile, wie zum Beispiel:

- Festlegen der Working Directory ohne die Verwendung des expliziten Pfades (`setwd()`). Das ist sinnvoll, da sich dieser Pfad ändern kann (Zusammenarbeit mit anderen Usern, Ausführung des Scripts zu einem späteren Zeitpunkt) 
- Automatisches Zwischenspeichern geöffneter Scripts und Wiederherstellung der geöffneten Scripts bei der nächsten Session
- Festlegen verschiedener projektspezifischer Optionen
- Verwendung von Versionsverwaltungssystemen (git oder SVN)


## Arbeiten mit Libraries / Packages

R ist ohne Zusatzpackete nicht mehr denkbar. Die allermeisten Packages werden auf [CRAN](https://cran.r-project.org/) gehostet und können leicht mittels `install.packages()` installiert werden. Eine sehr wichtige Sammlung von Packages wird von RStudio entwickelt. Unter dem Namen [Tidyverse](https://www.tidyverse.org/) werden eine Reihe von Packages angeboten, den R-Alltag enorm erleichtert. Wir werden später näher auf das "Tidy"-Universum eingehen, an dieser Stelle können wir die Sammlung einfach mal installieren.

```
install.packages("tidyverse")
```

Um ein `package` in R verwenden zu können, gibt es zwei Möglichkeiten: 

- entweder man lädt es zu Beginn der R-session mittles `library(tidyverse)` (ohne Anführungs- und Schlusszeichen). 
- oder man ruft eine `function` mit vorangestelltem Packetname sowie zwei Doppelpunkten auf. `dplyr::filter()` ruft die Funktion `filter()` des Packets `dplyr` auf. 

Letztere Notation ist vor allem dann sinnvoll, wenn sich zwei unterschiedliche Funktionen mit dem gleichen namen in verschiedenen pacakges existieren. `filter()` existiert als Funktion einersits im package `dplyr` sowie in  `stats`. Dieses Phänomen nennt man "masking". 


Zu Beginn laden wir die nötigen Pakete:



```r
library(tidyverse)
# Im Unterschied zu `install.packages()` werden bei `library()` keine Anführungs- 
# und Schlusszeichen gesetzt.


library(lubridate)
# Im Unterschied zu install.packages("tidyverse") wird bei library(tidyverse) 
# das package lubridate nicht berücksichtigt
```

Tidyverse liefert viele Funktionen, für die es in der normalen R-Umgebung ("base R") keine wirkliche Alternative gibt. Andere Funktionen sind alternativen zu Base-R Funktionen:

- `data_frame()` statt `data.frame()` 
- `read_*` statt `read.*`
- `parse_datetime` statt `as.POSIXct()`

Diese verhalten sich leicht anders als Base-R Funktionen: Sie treffen weniger Annahmen und sind etwas restriktiver. Wir verwenden oft Tidyverse Funktionen, ihr könnt aber selber entscheiden welche Version ihr benutzt.

## Aufgabe 1

Erstelle eine `data.frame` mit nachstehenden Daten.

Tipps:

- Eine leere `data.frame` zu erstellen ist schwieriger als wenn erstellen und befüllen der `data.frame` in einem Schritt erfolgt
- R ist dafür gedacht, Spalte für Spalte zu arbeiten ([warum?](http://www.noamross.net/blog/2014/4/16/vectorization-in-r--why.html)), nicht Reihe für Reihe. Versuche dich an dieses Schema zu halten.





|Tierart | Anzahl| Gewicht|Geschlecht |Beschreibung                |
|:-------|------:|-------:|:----------|:---------------------------|
|Fuchs   |      2|     4.4|m          |Rötlich                     |
|Bär     |      5|    40.3|f          |Braun, gross                |
|Hase    |      1|     1.1|m          |klein, mit langen Ohren     |
|Elch    |      3|   120.0|m          |Lange Beine, Schaufelgeweih |



## Aufgabe 2

Was für Datentypen wurden (in Aufgabe 1) von R automatisch angenommen? Sind diese sinnvoll? 

Tipp: Nutze dazu `str()`


```
## 'data.frame':	4 obs. of  5 variables:
##  $ Tierart     : chr  "Fuchs" "Bär" "Hase" "Elch"
##  $ Anzahl      : num  2 5 1 3
##  $ Gewicht     : num  4.4 40.3 1.1 120
##  $ Geschlecht  : chr  "m" "f" "m" "m"
##  $ Beschreibung: chr  "Rötlich" "Braun, gross" "klein, mit langen Ohren" "Lange Beine, Schaufelgeweih"
```



```
## [1] "double"
```


## Aufgabe 3


Nutze die Spalte `Gewicht` um die Tiere in 3 Gewichtskategorien einzuteilen: 

- leicht: < 5kg
- mittel: 5 - 100 kg
- schwer: > 100kg






|Tierart | Anzahl| Gewicht|Geschlecht |Beschreibung                |Gewichtsklasse |
|:-------|------:|-------:|:----------|:---------------------------|:--------------|
|Fuchs   |      2|     4.4|m          |Rötlich                     |leicht         |
|Bär     |      5|    40.3|f          |Braun, gross                |mittel         |
|Hase    |      1|     1.1|m          |klein, mit langen Ohren     |leicht         |
|Elch    |      3|   120.0|m          |Lange Beine, Schaufelgeweih |schwer         |




## Aufgabe 4

Importiere den Datensatz [weather.csv](weather.csv) (Rechtsklick -> Speichern Unter). Es handelt sich dabei um die stündlich gemittelten Temperaturdaten an verschiedenen Standorten in der Schweiz. Wir empfehlen [`read_csv()`]( http://r4ds.had.co.nz/data-import.html) anstelle von `read.csv()`.







|stn |       time| tre200h0|
|:---|----------:|--------:|
|ABO | 2000010100|     -2.6|
|ABO | 2000010101|     -2.5|
|ABO | 2000010102|     -3.1|
|ABO | 2000010103|     -2.4|
|ABO | 2000010104|     -2.5|
|ABO | 2000010105|     -3.0|
|ABO | 2000010106|     -3.7|
|ABO | 2000010107|     -4.4|
|ABO | 2000010108|     -4.1|
|ABO | 2000010109|     -4.1|


## Aufgabe 5

Schau dir die Rückmeldung von `read_csv()`an. Sind die Daten korrekt interpretiert worden?






## Aufgabe 6

Die Spalte `time` ist eine Datum/Zeitangabe im Format JJJJMMTTHH (siehe [meta.txt](meta.txt)). Damit R dies als Datum-/Zeitangabe erkennt, müssen wir die Spalte in einem R-Format (`POSIXct`) einlesen und dabei R mitteilen, wie sie aktuell formatiert ist. Lies die Spalte mit `as.POSIXct()` (oder `parse_datetime`) ein und spezifiziere sowohl `format` wie auch `tz`. 

Tipps: 

- Wenn keine Zeitzone festgelegt wird, trifft `as.POSIXct()` eine Annahme (basierend auf `Sys.timezone()`). In unserem Fall handelt es sich aber um Werte in UTC (siehe [meta.txt](meta.txt))
- `as.POSIXct`erwartet `character`: Wenn du eine Fehlermeldung hast die `'origin' must be supplied` (o.ä) heisst, hast du der Funktion vermutlich einen `Numeric` übergeben.








Table: Die neue Tabelle sollte so aussehen

|stn |time                | tre200h0|
|:---|:-------------------|--------:|
|ABO |2000-01-01 00:00:00 |     -2.6|
|ABO |2000-01-01 01:00:00 |     -2.5|
|ABO |2000-01-01 02:00:00 |     -3.1|
|ABO |2000-01-01 03:00:00 |     -2.4|
|ABO |2000-01-01 04:00:00 |     -2.5|
|ABO |2000-01-01 05:00:00 |     -3.0|
|ABO |2000-01-01 06:00:00 |     -3.7|
|ABO |2000-01-01 07:00:00 |     -4.4|
|ABO |2000-01-01 08:00:00 |     -4.1|
|ABO |2000-01-01 09:00:00 |     -4.1|




## Aufgabe 7


Erstelle zwei neue Spalten mit Wochentag (Montag, Dienstag, etc) und Kalenderwoche. Verwende dazu die neu erstellte `POSIXct`-Spalte






|stn |time                | tre200h0|wochentag | kw|
|:---|:-------------------|--------:|:---------|--:|
|ABO |2000-01-01 00:00:00 |     -2.6|Sa        |  1|
|ABO |2000-01-01 01:00:00 |     -2.5|Sa        |  1|
|ABO |2000-01-01 02:00:00 |     -3.1|Sa        |  1|
|ABO |2000-01-01 03:00:00 |     -2.4|Sa        |  1|
|ABO |2000-01-01 04:00:00 |     -2.5|Sa        |  1|
|ABO |2000-01-01 05:00:00 |     -3.0|Sa        |  1|
|ABO |2000-01-01 06:00:00 |     -3.7|Sa        |  1|
|ABO |2000-01-01 07:00:00 |     -4.4|Sa        |  1|
|ABO |2000-01-01 08:00:00 |     -4.1|Sa        |  1|
|ABO |2000-01-01 09:00:00 |     -4.1|Sa        |  1|





## Aufgabe 8


Erstelle eine neue Spalte basierend auf die Temperaturwerte mit der Einteilung "kalt" (Unter Null Grad) und "warm" (über Null Grad)





|stn |time                | tre200h0|wochentag | kw|temp_kat |
|:---|:-------------------|--------:|:---------|--:|:--------|
|ABO |2000-01-01 00:00:00 |     -2.6|Sa        |  1|kalt     |
|ABO |2000-01-01 01:00:00 |     -2.5|Sa        |  1|kalt     |
|ABO |2000-01-01 02:00:00 |     -3.1|Sa        |  1|kalt     |
|ABO |2000-01-01 03:00:00 |     -2.4|Sa        |  1|kalt     |
|ABO |2000-01-01 04:00:00 |     -2.5|Sa        |  1|kalt     |
|ABO |2000-01-01 05:00:00 |     -3.0|Sa        |  1|kalt     |
|ABO |2000-01-01 06:00:00 |     -3.7|Sa        |  1|kalt     |
|ABO |2000-01-01 07:00:00 |     -4.4|Sa        |  1|kalt     |
|ABO |2000-01-01 08:00:00 |     -4.1|Sa        |  1|kalt     |
|ABO |2000-01-01 09:00:00 |     -4.1|Sa        |  1|kalt     |




