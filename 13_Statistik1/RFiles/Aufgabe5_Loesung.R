# Daten müssen zuerst nach Kalenderwochen und Kondition zusammengefasst werden
df <- nova %>%
    group_by(condit, week) %>% # 
    summarise(tot_sold = n())

leveneTest(df$tot_sold, df$condit)

t.test(df[df$condit == "Basis", ]$tot_sold, df[df$condit == "Intervention", ]$tot_sold, var.equal = F, alternative = "less") # siehe gerichtete Hypothese

# boxplot

ggplot(df, aes(x = condit, y= tot_sold)) + 
    geom_boxplot(fill = "lightgrey") + 
    labs(x="Bedingungen", y="Anzahl verkaufte Gerichte")
