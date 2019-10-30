
library(tidyverse)
library(ggfortify)


medley <- read_delim("14_Statistik2/data/medley.csv", ",")
medley$ZINC <- factor(medley$ZINC, levels=c("BACK", "LOW", "MED","HIGH"), ordered=T)

medley_sry <- medley %>%
  group_by(ZINC) %>%
  summarise(
    mean = mean(DIVERSITY),
    var = var(DIVERSITY),
    sd = sd(DIVERSITY)
  )


medley.aov <- aov(DIVERSITY~ZINC, medley)
autoplot(medley.aov)


library(multcomp)
library(stringr)
smry <- summary(glht(medley.aov, linfct=mcp(ZINC='Tukey')))

smry
# Um die Gruppen automatisch zu generieren kann man die Funtion multcompView::multcompLetters()
# benutzen. Leider habe ich keine elegante Weise gefunden den Ouput aus glht() in multcompLetters()
# einzulesen. Hier deshalb eine etwas klobige Lösung:
library(multcompView)

pvals <- smry$test[["pvalues"]]                         # p-Werte in Variabel speichern
gr.names <- names(smry$test[["tstat"]])                 # der Vektor hat keine Namen, braucht aber welche
gr.names <- str_replace_all(gr.names, fixed(" "), "")   # Leerschläge entfernen (damit hat multcompLetters Mühe)
names(pvals) <- gr.names                                # bereinigte Namen den p-Werten zuweisen

lets <- multcompLetters(pvals)                          # Gruppen generieren
lets <- as.data.frame(lets$Letters)                     # Output als dataframe abspeichern
lets <- rownames_to_column(lets)                        # Rownames als Spalte abspeichern (für "join")
colnames(lets) <- c("ZINC","Group")                     # Spaltenamen der neuen df anpassen

medley_sry <- left_join(medley_sry,lets)                # Gruppennamen der summary zuweisen


ggplot(medley_sry, aes(ZINC,mean)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin = mean-sd, ymax = mean+sd),width = 0.2) +
  geom_label(aes(label = Group)) +                      # so werden Gruppennamen dargestellt
  labs(x = "Zinc concentration",y = "Mean diatom diversity")
