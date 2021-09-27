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
library(ggpubr)    # to arrange multiple plots in one graph
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

# Start und Ende Lockdown
# definieren, wichtig fuer die spaeteren Auswertungen
lock_1_start_2020 <- as.Date("2020-03-16")
lock_1_end_2020 <- as.Date("2020-05-11")

lock_2_start_2021 <- as.Date("2020-12-22")
lock_2_end_2021 <- as.Date("2021-03-01")

# Ebenfalls muessen die erste und letzte Kalenderwoche der Untersuchungsfrist definiert werden
# Diese werden bei Wochenweisen Analysen ebenfalls ausgeklammert da sie i.d.R. unvollstaendig sind
KW_start <- week(depo_start)
KW_end <- week(depo_end)

# Erster und letzter Tag der Ferien
# je nach Untersuchungsdauer muessen hier weitere oder andere Ferienzeiten ergaenzt werden
# (https://www.schulferien.org/schweiz/ferien/2020/)
Fruehlingsferien_2019_start <- as.Date("2019-04-13")
Fruehlingsferien_2019_ende <- as.Date("2019-04-28")
Sommerferien_2019_start <- as.Date("2019-07-6")
Sommerferien_2019_ende <- as.Date("2019-08-18")
Herbstferien_2019_start <- as.Date("2019-10-05")
Herbstferien_2019_ende <- as.Date("2019-10-20")
Winterferien_2019_start <- as.Date("2019-12-21")
Winterferien_2019_ende <- as.Date("2020-01-02")

Fruehlingsferien_2020_start <- as.Date("2020-04-11")
Fruehlingsferien_2020_ende <- as.Date("2020-04-26")
Sommerferien_2020_start <- as.Date("2020-07-11")
Sommerferien_2020_ende <- as.Date("2020-08-16")
Herbstferien_2020_start <- as.Date("2020-10-03")
Herbstferien_2020_ende <- as.Date("2020-10-18")
Winterferien_2020_start <- as.Date("2020-12-19")
Winterferien_2020_ende <- as.Date("2021-01-03")

Fruehlingsferien_2021_start <- as.Date("2021-04-24")
Fruehlingsferien_2021_ende <- as.Date("2021-05-09")
Sommerferien_2021_start <- as.Date("2021-07-17")

#.################################################################################################
# 1. DATENIMPORT #####
#.################################################################################################

# Beim Daten einlesen koennen sogleich die Datentypen und erste Bereinigungen vorgenommen werden

# 1.1 Zaehldaten ####
# Die Zaehldaten des Wildnispark wurden vorgaengig bereinigt. z.B. wurden Stundenwerte 
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
  mutate(Jahr = year(Datum))

#Lockdown 
# Hinweis: ich mache das nachgelagert, da ich die Erfahrung hatte, dass zu viele 
# Operationen in einem Schritt auch schon mal durcheinander erzeugen koennen.
# Hinweis II: Wir packen alle Phasen (normal, die beiden Lockdowns und Covid aber ohne Lockdown)
# in eine Spalte --> long ist schoener als wide
depo <- depo %>%
mutate(Phase = if_else(Datum >= lock_1_start_2020 & Datum <= lock_1_end_2020,
                          "Lockdown_1",
                       if_else(Datum >= lock_2_start_2021 & Datum <= lock_2_end_2021,
                               "Lockdown_2",
                               if_else(Datum < lock_1_start_2020,
                                  "Normal", "Covid"))))

# hat das gepklappt?!
unique(depo$Phase)

# aendere die Datentypen
depo <- depo %>% 
  mutate(Wochenende = as.factor(Wochenende)) %>% 
  mutate(KW = factor(KW)) %>% 
  # mit factor() koennen die levels direkt einfach selbst definiert werden.
  # wichtig: speizfizieren, dass aus R base, ansonsten kommt es zu einem 
  # mix-up mit anderen packages
  mutate(Phase = base::factor(Phase, levels = c("Normal", "Lockdown_1", "Lockdown_2", "Covid")))

str(depo)
  
# Fuer einige Auswertungen muss auf die Stunden als nummerischer Wert zurueckgegriffen werden
depo$Stunde <- as.numeric(format(as.POSIXct(depo$Zeit,format="%H:%M"),"%H"))

# Die Daten wurden kalibriert. Wir runden sie fuer unserer Analysen auf Ganzzahlen
depo$Total <- round(depo$Total, digits = 0)
depo$Fuss_IN <- round(depo$Fuss_IN, digits = 0)
depo$Fuss_OUT <- round(depo$Fuss_OUT, digits = 0)

# 2.2 Pruefen auf Ausreisser (OPTIONAL) ####
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
depo_d <- depo %>% 
  group_by(Datum, Wochentag, Wochenende, KW, Monat, Jahr, Phase) %>% 
  summarise(Total = sum(Fuss_IN + Fuss_OUT), 
            Fuss_IN = sum(Fuss_IN),
            Fuss_OUT = sum(Fuss_OUT)) 
# Wenn man die Convinience Variablen als grouping variable einspeisst, dann werden sie in 
# das neue df uebernommen und muessen nicht nochmals hinzugefuegt werden

# pruefe das df
head(depo_d)

# Gruppiere die Werte nach Monat
depo_m <- depo %>% 
  group_by(Jahr, Monat) %>% 
  summarise(Total = sum(Total)) 
# sortiere das df aufsteigend (nur das es sicher stimmt)
depo_m <- as.data.frame(depo_m)
depo_m[
  with(depo_m, order(Jahr, Monat)),]
# mache dann aus Jahr und Monat faktoren
depo_m <- depo_m %>% 
  mutate(Jahr = as.factor(Jahr)) %>% 
  mutate(Monat = as.factor(Monat)) %>% 
  mutate(Ym = paste(Jahr, Monat)) %>% # und mache eine neue Spalte, in der Jahr und
  mutate(Ym= factor(Ym, levels=unique(Ym))) # Monat in zusammen sind

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

# 3.1 Verlauf der Besuchszahlen / m ####
# Monatliche Summen am Standort

# wann beginnt die Datenreihe schon wieder?
first(depo_m$Ym)
# und wann ist die fertig?
last(depo_m$Ym)

# Plotte
ggplot(depo_m, mapping = aes(Ym, Total, group = 1))+ # group 1 braucht R, dass aus den Einzelpunkten ein Zusammenhang hergestellt wird
  #zeichne Lockdown 1
  geom_rect(mapping = aes(xmin="2020 3", xmax="2020 5",
                          ymin =0, ymax=max(Total+(Total/100*10))),
            fill = "lightskyblue", alpha = 0.4, colour = NA)+
  #zeichne Lockdown 2
    geom_rect(mapping = aes(xmin="2020 12", xmax="2021 3", 
                          ymin =0, ymax=max(Total+(Total/100*10))), 
            fill = "lightskyblue", alpha = 0.4, colour = NA)+
  geom_line(alpha = 0.6, size = 1.5)+
  scale_x_discrete(breaks = c("2019 1", "2019 7","2019 1","2020 1","2020 7","2021 1","2021 7"),
                   labels = c("2019 1", "2019 7","2019 1","2020 1","2020 7","2021 1","2021 7"))+
  labs(title= "", y="Fuss pro Monat", x = "Jahr")+
  theme_linedraw(base_size = 15)+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

ggsave("Entwicklung_Zaehlstelle.png", width=20, height=10, units="cm", dpi=1000, 
       path = "_fallstudien/_R_analysis/results/") 

# 3.2 Wochengang ####

# mean / d / phase
mean_phase_wd <- depo_d %>% 
  group_by(Wochentag, Phase) %>% 
  summarise(Total = mean(Total))

write.csv(mean_phase_wd, "_fallstudien/_R_analysis/results/mean_phase_wd.csv")

#plot
ggplot(data = depo_d)+
  geom_boxplot(mapping = aes(x= Wochentag, y = Total, fill = Phase))+
  labs(title="", y= "Anzahl pro Tag")+
  scale_fill_manual(values = c("royalblue", "red4", "orangered", "gold2"))+
  theme_classic(base_size = 15)+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        legend.title = element_blank())

ggsave("Wochengang_Lockdown.png", width=15, height=15, units="cm", dpi=1000, 
       path = "_fallstudien/_R_analysis/results/")

# Statistik: Unterschied WE und WO während Lockdown 1
t.test(depo_d$Total [depo_d$Phase == "Lockdown_1" & depo_d$Wochenende=="Werktag"], 
       depo_d$Total [depo_d$Phase == "Lockdown_1" & depo_d$Wochenende=="Wochenende"])


# 3.3 Tagesgang ####
# Bei diesen Berechnungen wird jeweils der Mittelwert pro Stunde berechnet. 
# wiederum nutzen wir dafuer "pipes"
Mean_h <- depo %>% 
  group_by(Wochentag, Stunde, Phase) %>% 
  summarise(Total = mean(Total)) 

# transformiere fuer Plotting
Mean_h_long<- reshape2::melt(Mean_h,measure.vars = c("Total"),
                             value.name = "Durchschnitt",variable.name = "Gruppe")

# Plotte den Tagesgang, unterteilt nach Wochentagen

# Normal
tag_norm <- ggplot(subset(Mean_h_long, Phase %in% c("Normal")), 
                     mapping=aes(x = Stunde, y = Durchschnitt, colour = Wochentag, linetype = Wochentag))+
  geom_line(size = 2)+
  scale_colour_viridis_d()+
  scale_linetype_manual(values = c(rep("solid", 5),  "twodash", "twodash"))+
  scale_x_continuous(breaks = c(seq(0, 23, by = 2)), labels = c(seq(0, 23, by = 2)))+
  labs(x="Uhrzeit [h]", y= "∅ Fussganger_Innen / h", title = "")+
  lims(y = c(0,25))+
  theme_linedraw(base_size = 15)+
  theme(legend.position = "right")

# Lockdown 1

tag_lock_1 <- ggplot(subset(Mean_h_long, Phase %in% c("Lockdown_1")), 
                     mapping=aes(x = Stunde, y = Durchschnitt, colour = Wochentag, linetype = Wochentag))+
  geom_line(size = 2)+
  scale_colour_viridis_d()+
  scale_linetype_manual(values = c(rep("solid", 5), "twodash", "twodash"))+
  scale_x_continuous(breaks = c(seq(0, 23, by = 2)), labels = c(seq(0, 23, by = 2)))+
  labs(x="Uhrzeit [h]", y= "∅ Fussganger_Innen / h", title = "")+
  lims(y = c(0,25))+
  theme_linedraw(base_size = 15)+
  theme(legend.position = "right")

# Lockdown 2
tag_lock_2 <- ggplot(subset(Mean_h_long, Phase %in% c("Lockdown_2")), 
                     mapping=aes(x = Stunde, y = Durchschnitt, colour = Wochentag, linetype = Wochentag))+
  geom_line(size = 2)+
  scale_colour_viridis_d()+
  scale_linetype_manual(values = c(rep("solid", 5), "twodash", "twodash"))+
  scale_x_continuous(breaks = c(seq(0, 23, by = 2)), labels = c(seq(0, 23, by = 2)))+
  labs(x="Uhrzeit [h]", y= "∅ Fussganger_Innen / h", title = "")+
  lims(y = c(0,25))+
  theme_linedraw(base_size = 15)+
  theme(legend.position = "right")

# Covid
tag_covid <- ggplot(subset(Mean_h_long, Phase %in% c("Covid")), 
                     mapping=aes(x = Stunde, y = Durchschnitt, colour = Wochentag, linetype = Wochentag))+
  geom_line(size = 2)+
  scale_colour_viridis_d()+
  scale_linetype_manual(values = c(rep("solid", 5), "twodash", "twodash"))+
  scale_x_continuous(breaks = c(seq(0, 23, by = 2)), labels = c(seq(0, 23, by = 2)))+
  labs(x="Uhrzeit [h]", y= "∅ Fussganger_Innen / h", title = "")+
  lims(y = c(0,25))+
  theme_linedraw(base_size = 15)+
  theme(legend.position = "right")

# Arrange und Export Tagesgang
ggarrange(tag_lock_1+            # plot 1 aufrufen
            rremove("x.text")+   # plot 1 braucht es nicht alle Achsenbeschriftungen
            rremove("x.title"),            
          tag_lock_2+            # plot 2 aufrufen
            rremove("y.text")+   # bei plot 2 brauchen wir keine Achsenbeschriftung
            rremove("y.title")+
            rremove("x.text")+
            rremove("x.title"),
          tag_norm,
          tag_covid+
            rremove("y.text")+   
            rremove("y.title"),
          ncol = 2, nrow = 2,    # definieren, wie die plots angeordnet werden
          heights = c(0.9, 1),  # beide plots sind wegen der fehlenden Beschriftung nicht gleich hoch
          widths = c(1,0.9),    
          labels = c("a) Lockdown 1", "b) Lockdown 2", "c) Normal", "d) Covid"),
          label.x = 0.1,        # wo stehen die Plottitel
          label.y = 0.99,
          common.legend = TRUE, legend = "bottom") # wir brauchen nur eine Legende, unten

ggsave("Tagesgang.png", width=25, height=25, units="cm", dpi=1000,
       path = "_fallstudien/_R_analysis/results/")

# 3.4 Kennzahlen ####
total_phase <- depo_d %>% 
  # gruppiere nach Phasen inkl. Normal. Diese Levels haben wir bereits definiert
  group_by(Phase) %>% 
  summarise(Total = sum(Total),
            IN = sum(Fuss_IN),
            OUT = sum(Fuss_OUT))

write.csv(total_phase, "_fallstudien/_R_analysis/results/total_phase.csv")

# mean besser Vergleichbar, da Zeitreihen unterschiedlich lange
mean_phase_d <- depo_d %>% 
  group_by(Phase) %>% 
  summarise(Total = mean(Total),
            IN = mean(Fuss_IN),
            OUT = mean(Fuss_OUT))
# berechne prozentuale Richtungsverteilung
mean_phase_d <- mean_phase_d %>% 
  mutate(Proz_IN = round(100/Total*IN, 1)) %>% # berechnen und auf eine Nachkommastelle runden
  mutate(Proz_OUT = round(100/Total*OUT,1))

write.csv(mean_phase_d, "_fallstudien/_R_analysis/results/mean_phase_d.csv")

# selektiere absolute Zahlen
# behalte rel. Spalten (nur die relativen Prozentangaben)
mean_phase_d_abs <- mean_phase_d[,-c(2,5,6), drop=FALSE]
# transformiere fuer Plotting
mean_phase_d_abs <- reshape2::melt(mean_phase_d_abs, 
                                     measure.vars = c("IN","OUT"),
                                     value.name = "Durchschnitt",variable.name = "Gruppe")

# selektiere relative Zahlen
# behalte rel. Spalten (nur die relativen Prozentangaben)
mean_phase_d_proz <- mean_phase_d[,-c(2:4), drop=FALSE]
# transformiere fuer Plotting
mean_phase_d_proz <- reshape2::melt(mean_phase_d_proz, 
                                 measure.vars = c("Proz_IN","Proz_OUT"),
                                 value.name = "Durchschnitt",variable.name = "Gruppe")

# Visualisierung abs
abs <- ggplot(data = mean_phase_d_abs, mapping = aes(x = Gruppe, y = Durchschnitt, fill = Phase))+
  geom_col(position = "dodge", width = 0.8)+
  scale_fill_manual(values = c("royalblue", "red4", "orangered", "gold2"), name = "Phase")+
  scale_x_discrete(labels = c("IN", "OUT"))+
  labs(y = "Durchschnitt [mean]", x= "Bewegungsrichtung")+
  theme_classic(base_size = 15)+
  theme(legend.position = "bottom")

# Visualisierung %
proz <- ggplot(data = mean_phase_d_proz, mapping = aes(x = Gruppe, y = Durchschnitt, fill = Phase))+
  geom_col(position = "dodge", width = 0.8)+
  scale_fill_manual(values = c("royalblue", "red4", "orangered", "gold2"), name = "Phase")+
  scale_x_discrete(labels = c("IN", "OUT"))+
  labs(y = "Durchschnitt [%]", x= "Bewegungsrichtung")+
  theme_classic(base_size = 15)+
  theme(legend.position = "bottom")

# Arrange und Export Verteilung
ggarrange(abs,            # plot 1 aufrufen
          proz,            # plot 2 aufrufen
          ncol = 2, nrow = 1,    # definieren, wie die plots angeordnet werden
          heights = c(1),        # beide sind bleich hoch
          widths = c(1,0.95),    # plot 2 ist aufgrund der fehlenden y-achsenbesch. etwas schmaler
          labels = c("a) Absolute Verteilung", "b) Relative Verteilung"),
          label.x = 0,        # wo stehen die labels
          label.y = 1.0,
          common.legend = TRUE, legend = "bottom") # wir brauchen nur eine Legende, unten

ggsave("Verteilung.png", width=20, height=15, units="cm", dpi=1000,
       path = "_fallstudien/_R_analysis/results/")







