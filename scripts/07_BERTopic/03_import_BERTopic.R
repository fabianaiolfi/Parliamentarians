
# Import and Prepare CSV ---------------------------------------------------------------

# Plain Vanilla
BERTopic_df <- read.csv(here("scripts", "07_BERTopic", "doc_level_info.csv"))
BERTopic_df$BusinessShortNumber <- all_businesses$BusinessShortNumber

# Semi-Supervised
BERTopic_df_ss <- read.csv(here("scripts", "07_BERTopic", "doc_level_info_ss.csv"))
BERTopic_df_ss$BusinessShortNumber <- all_businesses$BusinessShortNumber

# Guided
BERTopic_df_guided <- read.csv(here("scripts", "07_BERTopic", "doc_level_info_guided.csv"))
BERTopic_df_guided$BusinessShortNumber <- all_businesses$BusinessShortNumber


# Merge ---------------------------------------------------------------

# Plain Vanilla
all_businesses <- all_businesses %>% 
  left_join(BERTopic_df, by = "BusinessShortNumber")

# Semi-Supervised
all_businesses <- all_businesses %>% 
  left_join(BERTopic_df_ss, by = "BusinessShortNumber")

# Guided
all_businesses <- all_businesses %>% 
  left_join(BERTopic_df_guided, by = "BusinessShortNumber")


# Inspect ---------------------------------------------------------------
summary(all_businesses$Topic)
hist(all_businesses$Topic, breaks = 144)


