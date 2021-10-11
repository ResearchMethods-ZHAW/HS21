
weather <- read_table("order_52252_data.txt")


stn <- unique(weather$stn)
stn <- stn[stn != "stn"]

weather <- filter(weather, time < 2002010100, stn %in% stn[1:5])

write_csv(weather, "weather.csv")
