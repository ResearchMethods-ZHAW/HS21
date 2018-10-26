--- 
title: "Research Methods"
date: "2018-10-26"
site: bookdown::bookdown_site
#output: bookdown::gitbook
documentclass: book
bibliography: [00_Admin/book.bib, 00_Admin/packages.bib]
biblio-style: apalike
link-citations: yes
description: "Begleitmaterial zum Modul 'Research Methods' "
---

# Einleitung


Das Modul „Research Methods“ vermittelt vertiefte Methodenkompetenzen für praxisorientiertes und angewandtes wissenschaftliches Arbeiten im Fachbereich „Umwelt und Natürliche Ressourcen“ auf MSc-Niveau. Die Studierenden erarbeiten sich vertiefte Methodenkompetenzen für die analytische Betrachtung der Zusammenhänge im Gesamtsystem „Umwelt und Natürliche Ressourcen“. Die Studierenden erlernen die methodischen Kompetenzen, auf denen die nachfolgenden Module im MSc Programm UNR aufbauen. Das Modul vermittelt einerseits allgemeine, fächerübergreifende methodische Kompetenzen (z.B. Wissenschaftstheorie, computer-gestützte Datenverar-beitung und Statistik).

Auf dieser Plattform (RStudio Connect) werden die Unterlagen für die R-Übungsteile bereitgestellt. Es werden sukzessive sowohl Demo-Files, Aufgabenstellungen und Lösungen veröffentlicht.















<!--chapter:end:index.Rmd-->

# Statistik 1 (29.1.2018)

In Statistik 1 lernen die Studierenden, was (Inferenz-) Statistik im Kern leistet und warum sie für wissenschaftliche Erkenntnis (in den meisten Disziplinen) unentbehrlich ist. Nach einer Wiederholung der Rolle von Hypothesen wird erläutert, wie Hypothesentests in der frequentist-Statistik umgesetzt werden, einschliesslich p-Werten und Signifikanz-Levels. Die praktische Statistik beginnt mit den beiden einfachsten Fällen, dem Chi-Quadrat-Test für die Assoziation zwischen zwei kategorialen Variablen und dem t-Test auf Unterschiede in Mittelwerten zwischen zwei Gruppen. Dann geht es um die Voraussetzungen parametrischer (und nicht-parametrischer) Tests und Optionen, wenn diese verletzt sind. Abschliessend gibt es einen ersten Einstieg in die Varianzanalyse (ANOVA).


<!-- TODO: -->
<!-- Referenzen passt noch nicht -->
<!-- hierarchien noch kontrollieren und mit anderen blöcke abgleichen -->
<!-- Beschreibung forschungsprojekte: tabelle besser als csv -->


<!--chapter:end:13_Statistik1/Abstract.Rmd-->


# knitr::opts_knit$set(root.dir = "13_Statistik1") 

Placeholder


## Demo: Stastische Tests
### Assoziationstests
#### Tests mit einer *breiten* (wide) Tabelle
#### Tests mit einer *langen* (long) Tabelle
### Randomisierung
#### F-Test
#### Levene Test
#### Visuelle Inspektion / Transformation
#### ANOVA mit "Blumen"-Daten
## Optional für Demo
#### ANOVA mit Gewässerdaten
##### Step 1
##### Step 2
##### Step 3
##### Step 4
### Libraries

<!--chapter:end:13_Statistik1/Demo_Tests.Rmd-->



## Beschreibung Forschungsprojekt NOVANIMAL (NFP69)
### Weitere Erläuterungen zum Datensatz

<!--chapter:end:13_Statistik1/Intro_Daten_egel.Rmd-->

## Übung A (NatWis)

###	Aufgabe 1

Datenerhebung für einen Assoziationstest zweier kategorialer Variablen, Dateneingabe und Durchführung von Chi-Quadrat- sowie Fishers exaktem Test


###	Aufgabe 2

Überlegen Sie eine Hypothese, die mit einem t-Test geprüft werden kann, erheben Sie dazu die Daten, geben Sie diese ein, visualisieren Sie diese, testen auf evtl. Verletzungen der Modellannahmen, führen dann den geeigneten t-Test sowie eine nicht-parametrische Alternative durch und fassen die Ergebnisse in einem Satz zusammen


###	Aufgabe 3: ANOVA

Führt mit dem Datensatz [competition.csv](13_Statistik1/data/competition.csv) einen einfaktoriellen ANOVA selbst durch (Aufbereitung der Daten, visuelle Inspektion der Modellvoraussetzung, Berechnung des Modells, Darstellung und Interpretation der Ergebnisse)





<!--chapter:end:13_Statistik1/Uebung_A.Rmd-->



## Übung A: Lösung
###  Musterlösung Aufgabe 3

<!--chapter:end:13_Statistik1/Uebung_A_loesung.Rmd-->

## Übung B (SozOek)


###	Aufgabe 1:

Unterscheidet sich die novanimal-Stichprobe von der gesamten Population bezüglich Geschlecht und Hochschulzugehörigkeit? 


* Es wird angenommen, dass 15 Prozent aller Mitarbeitenden mit CampusCard weiblich sind. 16 Prozent der Population (N = 2138) sind Mitarbeiter und 37 Prozent Studenten.
* Definiert die Null- ($H_0$) und Alternativhypothese ($H_1$)
* Führt einen $\chi^2$-Test und anschliessend einen exakten Fishers-Test mit dem Datensatz novanimal.csv durch
* Fasst die Ergebnisse in einem Satz zusammen


###	Aufgabe 2: t-Test

Werden in den Basis- und Interventionswochen unterschiedlich viele Gerichte verkauft?

* Definiert die Null- ($H_0$) und Alternativhypothese ($H_1$)
* Führt einen t-Test mit dem Datensatz novanimal.csv durch
* Welche Form von t-Test müssen Sie anwenden? einseitig/zweiseitig? gepaart/ungepaart?
* Überprüft die Voraussetzungen für einen t-Test (verwendet dafür das classic_theme())
* Fasst die Ergebnisse in einem Satz zusammen







<!--chapter:end:13_Statistik1/Uebung_B.Rmd-->


# Gruppiere und fasse die Variablen nach Geschlecht und Hochschulzugehörigkeit zusammen 

Placeholder


## Übung B: Lösung
###  Musterlösung Aufgabe 1
## Lade Datei
## definiere theme für die Plots
###  Musterlösung Aufgabe 2
###  Referenzen

<!--chapter:end:13_Statistik1/Uebung_B_loesung.Rmd-->

