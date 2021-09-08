#.################################################################################################
# Einfluss von COID19 auf die Besucherzahlen im WPZ ####
# Modul Research Methods, HS21. Adrian Hochreutener ####
#.################################################################################################

#.################################################################################################
# METADATA UND DEFINITIONEN ####
#.################################################################################################

# Datenherkunft ####
# Saemtliche verwendeten Zaehdaten sind Eigentum des Wildnispark Zuerich und duerfen nur im Rahmen 
# des Moduls verwendet werden. Sie sind vertraulich zu behandeln.
# Die Meteodaten sind Eigentum von MeteoSchweiz.

# Verwendete Meteodaten
# Lufttemperatur 2 m UEber Boden; Tagmaximum (6 UTC bis 18 UTC), tre200jx [°C ]
# Niederschlag; Halbtagessumme 6 UTC - 18 UTC, rre150j0 [mm]
# Sonnenscheindauer; Tagessumme, sre000d0 [min]

# Ordnerstruktur ####
# Im Ordner in dem das R-Projekt abgelegt ist muessen folgende Unterordner bestehen:
# - data (Rohdaten hier ablegen)
# - results
# - results_compare
# - scripts

# Benoetigte Bibliotheken ####
library(tidyverse) # Data wrangling und piping
library(lubridate) # Arbeiten mit Datumsformaten
library(data.table)# schnelles Dateneinlesen
library(suncalc)   # zum berechnen der Sonnenscheindauer
library(GGally)    # plotten von mehreren Plots gleichzeitig
library(PerformanceAnalytics) # Plotte Korrelationsmatrix
library(MuMIn)     # Multi-Model Inference
library(AICcmodavg)# Modellaverageing
library(fitdistrplus)# Prueft die Verteilung in Daten
library(lme4)      # Multivariate Modelle
library(blmeco)    # Bayesian data analysis using linear models
library(sjPlot)    # Plotten von Modellergebnissen (tab_model)
library(lattice)   # einfaches plotten von Zusammenhängen zwischen Variablen

# Start und Ende ####
# Untersuchungszeitraum, ich waehle hier das Jahr 2019 bis und mit Sommer 2021
depo_start <- as.Date("2019-01-01")
depo_end <- as.Date("2021-7-27")

# Ebenfalls muessen die erste und letzte Kalenderwoche der Untersuchungsfrist definiert werden
# Diese werden bei Wochenweisen Analysen ebenfalls ausgeklammert da sie i.d.R. unvollstaendig sind
KW_start <- week(depo_start)
KW_end <- week(depo_end)

# Start und Ende Lockdown
# definieren, wichtig fuer die spaeteren Auswertungen
lock_1_start_2020 <- as.Date("2020-03-16")
lock_1_end_2020 <- as.Date("2020-05-11")

lock_2_start_2021 <- as.Date("2020-12-22")
lock_2_end_2021 <- as.Date("2021-03-01")

#.################################################################################################
# 1. DATENIMPORT #####
#.################################################################################################

# Beim Daten einlesen koennen sogleich die Datentypen und erste Bereinigungen vorgenommen werden

# 1.1 Zaehldaten ####
# Die Zaehldaten des Wildnispark Sihlwald wurden vorgaengig bereinigt. z.B. wurden Stundenwerte 
# entfernt, an denen am Zaehler Wartungsarbeiten stattgefunden haben.

# lese die Daten mithilfe der Bibliothek data.table ein (alternative zu read_csv und dergleichen). 
# Je nach Bedarf muss der Speicherort sowie der Dateiname angepasst werden
depo <- fread("./_fallstudien/_R_analysis/data/211_sihlwaldstrasse_2017_2021.csv")

# Hinweis zu den Daten:
# In hourly analysis format, the data at 11:00 am corresponds to the counts saved between 
# 11:00 am and 12:00 am.

# Anpassen der Datentypen und erstes Sichten
str(depo)

depo <- depo %>%
  mutate(Datum_Uhrzeit = as.character(DatumUhrzeit)) %>%
  separate(Datum_Uhrzeit, into = c("Datum", "Zeit"), sep = " ")%>%
  mutate(Datum = as.Date(Datum, format = "%d.%m.%Y")) %>% 
  # Schneide das df auf den gewuenschten Zeitraum zu
  filter(Datum >= depo_start, Datum <=  depo_end) # das Komma hat die gleiche Funktion wie ein &

# In dieser Auswertung werden nur Velos betrachtet!
depo <- depo[,-c(1,4,5), drop=FALSE] # mit diesem Befehl lassen wir Spalten "fallen", 
                                     # aendern aber nichts an der Form des data.frames

# Berechnen des Totals, da dieses in den Daten nicht vorhanden ist
depo <- depo%>%
  mutate(Total = Fuss_IN + Fuss_OUT)

# Entferne die NA's in dem df.
depo <- na.omit(depo)

# 1.2 Meteodaten ####
# Einlesen
meteo <- fread("./_fallstudien/_R_analysis/data/order_97149_data.txt")
# Datentypen setzen
# Das Datum wird als Integer erkannt. Zuerst muss es in Text umgewaldelt werden aus dem dann
# das eigentliche Datum herausgelesen werden kann
meteo <- transform(meteo, time = as.Date(as.character(time), "%Y%m%d"))
# Die eigentlichen Messwerte sind alle nummerisch
meteo <- meteo%>%
  mutate(tre200jx = as.numeric(tre200jx))%>%
  mutate(rre150j0 = as.numeric(rre150j0))%>%
  mutate(sremaxdv = as.numeric(sremaxdv)) %>% 
  filter(time >= depo_start, time <=  depo_end) # schneide dann auf Untersuchungsdauer

# Was ist eigentlich Niederschlag:
# https://www.meteoschweiz.admin.ch/home/wetter/wetterbegriffe/niederschlag.html

# Filtere Werte mit NA
meteo <- meteo %>%
  filter(!is.na(stn)) %>%
  filter(!is.na(time))%>%
  filter(!is.na(tre200jx))%>%
  filter(!is.na(rre150j0))%>%
  filter(!is.na(sremaxdv))
# Pruefe ob alles funktioniert hat
str(meteo)
sum(is.na(meteo)) # zeigt die Anzahl NA's im data.frame an

#.################################################################################################
# 2. VORBEREITUNG DER DATEN #####
#.################################################################################################

# 2.1 Convinience Variablen ####
# fuege dem Dataframe (df) die Wochentage hinzu
depo <- depo %>% 
  mutate(Wochentag = weekdays(Datum)) %>% 
  # R sortiert die Levels aplhabetisch. Da das in unserem Fall aber sehr unpraktisch ist,
  # muessen die Levels manuell manuell bestimmt werden
  mutate(Wochentag = base::factor(Wochentag, 
                            levels = c("Montag", "Dienstag", "Mittwoch", 
                                       "Donnerstag", "Freitag", "Samstag", "Sonntag"))) %>% 
  # Werktag oder Wochenende hinzufuegen
  mutate(Wochenende = if_else(Wochentag == "Montag" | Wochentag == "Dienstag" | 
                           Wochentag == "Mittwoch" | Wochentag == "Donnerstag" | 
                           Wochentag == "Freitag", "Werktag", "Wochenende"))%>%
  #Kalenderwoche hinzufuegen
  mutate(KW= week(Datum))%>%
  # monat und Jahr
  mutate(Monat = month(Datum)) %>% 
  mutate(Jahr = year(Datum)) %>% 
  # vor oder danach?
  mutate(COVID = if_else(Datum >= lock_1_start_2020, "covid", "normal"))

#Lockdown Fruehling 20
# Hinweis: ich mache das nachgelagert, da ich die Erfahrung hatte, dass zu viele 
# Operationen in einem Schritt auch schon mal durcheinander erzeugen koennen.
# Hinweis II: Wir packen die beiden Lockdowns in eine Spalte --> long ist schoener als wide
depo <- depo %>% 
mutate(Lockdown = if_else(Datum >= lock_1_start_2020 & Datum <= lock_1_end_2020,
                          "Lockdown_1",
                          if_else(Datum >= lock_2_start_2021 & Datum <= lock_2_end_2021,
                                  "Lockdown_2", "0"))) 
# hat das gepklappt?!
unique(depo$Lockdown)

# aendere die Datentypen
depo <- depo %>% 
  mutate(Wochenende = as.factor(Wochenende)) %>% 
  mutate(KW = factor(KW)) %>% 
  mutate(Lockdown = as.factor(Lockdown)) %>% 
  # mit factor() koennen die levels direkt einfach selbst definiert werden.
  # wichtig: speizfizieren, dass aus R base, ansonsten kommt es zu einem 
  # mix-up mit anderen packages
  mutate(COVID = base::factor(COVID, levels = c("normal", "covid")))
str(depo)
  
# Fuer einige Auswertungen muss auf die Stunden als nummerischer Wert zurueckgegriffen werden
depo$Stunde <- as.numeric(format(as.POSIXct(depo$Zeit,format="%H:%M"),"%H"))

# Die Daten wurden kalibriert. Wir runden sie fuer unserer Analysen auf Ganzzahlen
depo$Total <- round(depo$Total, digits = 0)
depo$Fuss_IN <- round(depo$Fuss_IN, digits = 0)
depo$Fuss_OUT <- round(depo$Fuss_OUT, digits = 0)

# 2.2 Pruefen auf Ausreisser ####
# Grundsaetzlich ist es schwierig Ausreisser in einem df zu finden. Gerade die Extremwerte 
# koennen entweder falsche Werte, oder aber die wichtigsten Werte im ganzen df sein.
# Ausreisser koennen in einem ersten Schritt optisch relativ einfach gefunden werden.
# Dazu werden die Zaehlmengen auf der y-Achse und die einzelne Datenpunkte auf der x-Achse
# geplottet. Wenn einzelne Werte nun die umliegenden bei weiten ueberragen, sollten diese
# genauer angeschaut werden. Sind sie an einem Wochenende? Ist die Tageszeit realisitsch?
# Wie mit Ausreissern umgegangen wird, muss von Fall zu Fall individuell entschieden werden.

# Verteilung mittels Histogram pruefen
hist(depo$Total[!depo$Total==0] , breaks = 100) 
# hier schliesse ich die Nuller aus der Visualisierung aus

# Verteilung mittels Scatterplot pruefen
plot(x=depo$Datum, y=depo$Total)
# Dem Scatterplot kann nun eine horizontale Linie hinzugefuegt werden, die bei 95 % der
# Werte liegt. Berchnet wird die Linie mittels dem 95 % Quartil
qts <- quantile(depo$Total,probs=c(0,.95))
abline(h=qts[2], col="red")

# Werte ueber 95 % auflisten
# Nun koennen diese optisch identifizierten Werte aufgelistet werden. Jeder einzele Wert
# sollte nun auf die Plausibilitaet geprueft werden. Dies sowohl bei Total als auch in
# den einzelnen Richtungen (IN, OUT)
(
  Ausreisser <- depo %>%
    filter(Total > qts[2])%>% 
    arrange(desc(Total))
)

# Werte ausschliessen; Aufgrund manueller Inspektion
# Die Werte, welche als Ausreisser identifiziert wurden, werden nun aufgrund der Zeilennummer 
# ausgeschlossen. Das muss individuell angepasst werden.
# depo <- depo[-c(Zeilennummer),] # ersetze "Zeilennummer" mit Zahlen, Kommagetrennt

# Da der WPZ die Daten aber bereits bereinigte, koennen wir uns diesen Schritt eigentlich sparen... ;)

# pruefe das df
str(depo)
head(depo)

# 2.3 Aggregierung der Stundendaten zu ganzen Tagen ####
# Zur Berechnung von Kennwerten ist es hilfreich, wenn neben den Stundendaten auch auf Ganztagesdaten
# zurueckgegriffen werden kann
# hier werden also pro Nutzergruppe und Richtung die Stundenwerte pro Tag aufsummiert
Day <- depo %>% 
  group_by(Datum, Wochentag, Wochenende, KW, Monat, Jahr, Lockdown, COVID) %>% 
  summarise(Total = sum(Fuss_IN + Fuss_OUT), 
            Fuss_IN = sum(Fuss_IN),
            Fuss_OUT = sum(Fuss_OUT)) 
# Wenn man die Convinience Variablen als grouping variable einspeisst, dann werden sie in 
# das neue df uebernommen und muessen nicht nochmals hinzugefuegt werden

# pruefe das df
head(Day)

# 2.4 Explorative Darstellung Meteodaten ####
# ausschliesslich zur optischen validierung, kein wichtiges Resultat!
# Temperaturmaximum
ggplot(data=meteo, mapping=aes(x=time, y=tre200jx))+
  geom_point()+
  geom_smooth(col="red")
# Niederschlagsumme
ggplot(data=meteo, mapping=aes(x=time, y=rre150j0))+
  geom_point()+
  geom_smooth(col="blue")
# Sonnenminuten
ggplot(data=meteo, mapping=aes(x=time, y=sremaxdv))+
  geom_point()+
  geom_smooth(col="yellow")

# Pruefe das df
head(meteo)
str(meteo)

#.################################################################################################
# 3. DESKRIPTIVE ANALYSE UND VISUALISIERUNG #####
#.################################################################################################

# Die deskriptiven Vergleiche sollen den Zeitraum des Lockdown 1 und 2 betrachten
lock <- depo %>% 
  filter(Lockdown == "Lockdown_1" | # da wir den Zeitraum bereits definiert haben,
           Lockdown == "Lockdown_2")# muessen wir nicht mehr ueber das Datum gehen

lock_day <- Day %>% 
  filter(Lockdown == "Lockdown_1" |
           Lockdown == "Lockdown_2")

# 3.1 Besuchszahlen nach Phase ####
total_lock_day <- lock_day %>% 
  group_by(Lockdown) %>% 
  summarise(Total = sum(Total),
            IN = sum(Fuss_IN),
            OUT = sum(Fuss_OUT))

# mean besser Vergleichbar, da Zeitreihen unterschiedlich lange
mean_lock_day <- lock_day %>% 
  group_by(Lockdown) %>% 
  summarise(Total = mean(Total),
            IN = mean(Fuss_IN),
            OUT = mean(Fuss_OUT))
# berechne prozentuale Richtungsverteilung
mean_lock_day <- mean_lock_day %>% 
  mutate(Proz_IN = round(100/Total*IN, 1)) %>% # berechnen und auf eine Nachkommastelle runden
  mutate(Proz_OUT = round(100/Total*OUT,1))

# behalte rel. Spalten
mean_lock_day <- mean_lock_day[,-c(2:4), drop=FALSE]

# transformiere fuer Plotting
mean_lock_day <- reshape2::melt(mean_lock_day, 
                                 measure.vars = c("Proz_IN","Proz_OUT"),
                                 value.name = "Durchschnitt",variable.name = "Gruppe")

# Visualisierung
ggplot(data = mean_lock_day, mapping = aes(x = Gruppe, y = Durchschnitt, fill = Lockdown))+
  geom_col(position = "dodge", width = 0.8)+
  scale_fill_manual(values = c("orangered", "royalblue"))+
  scale_x_discrete(labels = c("IN", "OUT"))+
  labs(y = "Durchschnitt [%]", x= "Bewegungsrichtung")+
  theme_classic(base_size = 15)+
  theme(legend.title = element_blank(),
        legend.position = "bottom")

ggsave("Bewegungsrichtung_Lockdown.jpg", width=10, height=10, units="cm", dpi=1000, 
       path = "_fallstudien/_R_analysis/results/")  
