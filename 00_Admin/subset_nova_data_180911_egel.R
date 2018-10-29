# Create Subset for Research Methods

# required packages
pack <- c("dplyr", "lubridate", "readr", "stringr", "readxl", "here")
lapply(pack, function(x){do.call("library", list(x))})


# load data: see script 041load data from till data (see new dataset)
df <- read_delim("13_Statistik1/data/novanimal_data_181029_egel.csv", delim = ";", col_types = cols(transaction_id = col_character(), ccrs = col_character())) %>% # attention some parsing failures in transaction_id because the zeros at the end
    select(transaction_id, cycle, date, trans_date, week, year, meal_name, article_description, label_content, condit, card_num, gender, member, age, price_article, total_amount, pay_description, shop_description, tot_ubp, buffet_animal_comp) %>%
    rename(buffet_animal = buffet_animal_comp)

# take only data from the first cycle
df_ <- filter(df, cycle == 1)

# exclude cases with age == 117
df_ <- filter(df_, !(age == 117))


# change some variables
# change names of meal line
df_[grep("Local Favorite", df_$article_description), ]$article_description <- "Local F"
df_[grep("Favorite", df_$article_description), ]$article_description <- "F"
df_[grep("Local Kitchen", df_$article_description), ]$article_description <- "Local K"
df_[grep("Kitchen", df_$article_description), ]$article_description <- "K"
df_[grep("Local World", df_$article_description), ]$article_description <- "Local W"
df_[grep("World", df_$article_description), ]$article_description <- "W"

df_[grep("Hot and Cold", df_$article_description), ]$article_description <- "Buffet"
df_[grep("Hot and Cold", df_$label_content), ]$label_content <- "Buffet"

# change names of place
df_[grep("Grüental", df_$shop_description), ]$shop_description <- "GR"
df_[grep("Vista", df_$shop_description), ]$shop_description <- "VS"


# set seed
set.seed(17)

# group data according to condit, label_content and week and take a fraction of it
df_t <- df_ %>% 
    group_by(condit, label_content, week, gender, member) %>%
    sample_frac(.1) %>% # extract 10% of original data with the more or less same occurencies (in condit and label_content) as the original dataset 
    select(-cycle) # exclude cycle

#save dataset
write_delim(df_t, "13_Statistik1/data/novanimal2.csv", delim = ";")


