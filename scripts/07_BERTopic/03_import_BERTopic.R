
# Import and Prepare CSV ---------------------------------------------------------------

BERTopic_df <- read.csv(here("scripts", "07_BERTopic", "doc_level_info.csv"))
BERTopic_df$BusinessShortNumber <- all_businesses$BusinessShortNumber


# Merge ---------------------------------------------------------------

all_businesses <- all_businesses %>% 
  left_join(BERTopic_df, by = "BusinessShortNumber")
