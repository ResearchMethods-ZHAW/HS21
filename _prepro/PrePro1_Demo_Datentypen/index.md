---
title: Demo Datentypen
output: 
  distill::distill_article:
    toc: true
    toc_float: true
author:
  - name: Patrick Laube
  - name: Nils Ratnaweera
  - name: Nikolaos Bakogiannis
preview: types.jpg
categories:
- PrePro1
draft: false
---






[R-Code als Download](Demo_Datentypen.R)

### Datentypen 


#### Numerics

Unter die Kategorie `numeric` fallen in R zwei Datentypen:

- `double`: Gleitkommazahl (z.B. 10.3, 7.3)
- `integer`: Ganzzahl (z.B. 10, 7)

##### Doubles

Folgendermassen wird eine Gleitkommazahl einer Variabel zuweisen:


```
## [1] 10.3
## [1] "double"
```



Statt `<-`kann auch `=` verwendet werden. Dies funktioniert aber nicht in allen Situationen, und ist zudem leicht mit `==` zu verwechseln.


```
## [1] 7.3
```



Ohne explizite Zuweisung nimmt R immer den Datentyp `double`an:


```
## [1] "double"
## [1] FALSE
## [1] TRUE
## [1] TRUE
```

#### Ganzzahl / Integer 


Erst wenn man eine Zahl explizit als `integer` definiert (mit `as.integer()` oder `L`), wird sie auch als solches abgespeichert.


```
## [1] TRUE
## [1] TRUE
## [1] TRUE
## [1] TRUE
```





```
## [1] "integer"
## [1] TRUE
## [1] TRUE
```



Mit `c()` können eine Reihe von Werten in einer Variabel zugewiesen werden (als `vector`). Es gibt zudem auch `character vectors`. 


```
## [1] 10 20 33 42 54 66 77
## [1] 54
## [1] 20 33 42
```



Eine Ganzzahl kann explizit mit `as.integer()` definiert werden.


```
## [1] 7
## [1] 3
## [1] "integer"
## [1] "integer"
## [1] TRUE
## [1] TRUE
```

Eine Zeichenkette kann als Zahl eingelesen werden.


```
## [1] 3
## [1] "integer"
```


#### Logische Abfragen 

Wird auch auch als boolesch (Eng. **boolean**) bezeichnet.


```
## [1] 3
## [1] 6
## [1] FALSE
## [1] "logical"
```

#### Logische Operationen



```
## [1] TRUE
```

Oft braucht man auch das Gegenteil / die Negation eines Wertes. Dies wird mittels `!` erreicht


```
## [1] FALSE
```



#### Zeichenketten

Zeichenketten (Eng. **character**) stellen Text dar


```
## [1] "3.14"
## [1] "character"
```



Zeichenketten verbinden / zusammenfügen (Eng. **concatenate**)


```
## [1] "Hans Muster"
## [1] FALSE
```


#### `Factors`

Mit `Factors` wird in R eine Sammlung von Zeichenketten bezeichnet, die sich wiederholen, z.B. Wochentage (es gibt nur 7 unterschiedliche Werte für "Wochentage").


```
## [1] "character"
##  [1] "Montag"     "Dienstag"   "Mittwoch"   "Donnerstag" "Freitag"    "Samstag"    "Sonntag"    "Montag"    
##  [9] "Dienstag"   "Mittwoch"   "Donnerstag" "Freitag"    "Samstag"    "Sonntag"
##  [1] Montag     Dienstag   Mittwoch   Donnerstag Freitag    Samstag    Sonntag    Montag     Dienstag  
## [10] Mittwoch   Donnerstag Freitag    Samstag    Sonntag   
## Levels: Dienstag Donnerstag Freitag Mittwoch Montag Samstag Sonntag
```

Wie man oben sieht, unterscheiden sich `character vectors` und `factors` v.a. dadurch, dass letztere über sogenannte `levels` verfügt. Diese `levels` entsprechen den Eindeutigen (`unique`) Werten.


```
## [1] "Dienstag"   "Donnerstag" "Freitag"    "Mittwoch"   "Montag"     "Samstag"    "Sonntag"
## [1] "Montag"     "Dienstag"   "Mittwoch"   "Donnerstag" "Freitag"    "Samstag"    "Sonntag"
```

Zudem ist fällt auf, dass die Reihenfolge der Wohentag alphabetisch sortiert ist. Wie diese sortiert werden zeigen wir an einem anderen Beispiel:



```
## [1] null eins zwei drei
## Levels: drei eins null zwei
```

Offensichtlich sollten diese `factors` geordnet sein, R weiss davon aber nichts. Eine Ordnung kann man mit dem Befehl `ordered = T` festlegen. 

Beachtet: `ordered = T` kann nur bei der Funktion `factor()` spezifiziert werden, nicht bei `as.factor()`. Ansonsten sind `factor()` und `as.factor()` sehr ähnlich.



```
## [1] null eins zwei drei
## Levels: drei < eins < null < zwei
```

Beachtet das "<"-Zeichen zwischen den Levels. Die Zahlen werden nicht in der korrekten Reihenfolge, sondern Alphabetisch geordnet. Die richtige Reihenfolge kann man mit `levels = ` festlegen.


```
## [1] null eins zwei drei
## Levels: null < eins < zwei < drei < vier
```

Wie auch schon erwähnt werden `factors` als `character` Vektor dargestellt, aber als Integers gespeichert. Das führt zu einem scheinbaren Wiederspruch wenn man den Datentyp auf unterschiedliche Weise abfragt.


```
## [1] "integer"
## [1] FALSE
```


Mit `typeof()` wird eben diese Form der Speicherung abgefragt und deshalb mit `integer` beantwortet. Da es sich aber nicht um einen eigentlichen Integer Vektor handelt, wird die Frage `is.integer()` mit `FALSE` beantwortet. Das ist etwas verwirrend, beruht aber darauf, dass die beiden Funktionen die Frage von unterschiedlichen Perspektiven beantworten. In diesem Fall schafft `class()` Klarheit:


```
## [1] "ordered" "factor"
```


Wirklich verwirrend wird es, wenn `factors` in numeric umgewandelt werden sollen.


```
## [1] null eins zwei drei
## Levels: null < eins < zwei < drei < vier
## [1] 1 2 3 4
```

Das die Übersetzung der auf Deutsch ausgeschriebenen Nummern in nummerische Zahlen nicht funktionieren würde, war ja klar. Weniger klar ist es jedoch, wenn die `factors` bereits aus nummerischen Zahlen bestehen.


```
## [1] 4 3 2 1
```

In diesem Fall müssen die `factors` erstmals in `character` umgewandelt werden.


```
## [1] 3 2 1 0
```




#### Zeit/Datum

Um in R mit Datum/Zeit Datentypen umzugehen, müssen sie als `POSIXct` eingelesen werden (es gibt alternativ noch `POSIXlt`, aber diese ignorieren wir mal). Anders als Beispielsweise bei Excel, sollten in R Datum und Uhrzeit immer in **einer Spalte** gespeichert werden.


```
## [1] "2017-10-01 13:45:10 CEST"
```

Wenn das die Zeichenkette in dem obigen Format (Jahr-Monat-Tag Stunde:Minute:Sekunde) daher kommt, braucht `as.POSIXct`keine weiteren Informationen. Sollte das Format von dem aber Abweichen, muss man der Funktion das genaue Schema jedoch mitteilen. Der Syntax dafür kann via `?strptime` nachgeschlagen werden.


```
## [1] "2017-10-01 13:45:00 CEST"
```

Beachtet, dass in den den obigen Beispiel R automatisch eine Zeitzone angenommen hat (`CEST`). R geht davon aus, dass die Zeitzone der **System Timezone** (`Sys.timezone()`) entspricht.


```
## [1] "10"
## [1] "Okt"
## [1] "Oktober"
```



### Data Frames und Conveniance Variabeln

Eine `data.frame` ist die gängigste Art, Tabellarische Daten zu speichern. 


```
## 'data.frame':	5 obs. of  3 variables:
##  $ Stadt    : chr  "Zürich" "Genf" "Basel" "Bern" ...
##  $ Einwohner: num  396027 194565 175131 140634 135629
##  $ Ankunft  : chr  "1.1.2017 10:00" "1.1.2017 14:00" "1.1.2017 13:00" "1.1.2017 18:00" ...
```

In der obigen `data.frame` wurde die Spalte `Einwohner` als Fliesskommazahl abgespeichert. Dies ist zwar nicht tragisch, aber da wir wissen das es sich hier sicher um Ganzzahlen handelt, können wir das korrigieren. Wichtiger ist aber, dass wir die Ankunftszeit (Spalte`Ankunft`) von  einem `Factor` in ein Zeitformat (`POSIXct`) umwandeln. 



```
## [1] 396027 194565 175131 140634 135629
## [1] "2017-01-01 10:00:00 CET" "2017-01-01 14:00:00 CET" "2017-01-01 13:00:00 CET" "2017-01-01 18:00:00 CET"
## [5] "2017-01-01 21:00:00 CET"
```


Diese Rohdaten können nun helfen, um Hilfsvariablen (**convenience variables**) zu erstellen. Z.B. können wir die Städte einteilen in gross, mittel und klein. 





Oder aber, die Ankunftszeit kann von der Spalte `Ankunft`abgeleitet werden. Dazu brauchen wir aber das Package `lubridate`










