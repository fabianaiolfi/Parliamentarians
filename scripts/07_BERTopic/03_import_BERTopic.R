
# Import and Prepare CSV ---------------------------------------------------------------

# Plain Vanilla
BERTopic_df <- read.csv(here("scripts", "07_BERTopic", "doc_level_info.csv"))
BERTopic_df$BusinessShortNumber <- all_businesses$BusinessShortNumber

# Semi-Supervised
BERTopic_df_ss <- read.csv(here("scripts", "07_BERTopic", "doc_level_info_ss.csv"))
BERTopic_df_ss$BusinessShortNumber <- all_businesses$BusinessShortNumber

# Semi-Supervised Probabilities
rm(BERTopic_df_ss_probs)
BERTopic_df_ss_probs <- read.csv(here("scripts", "07_BERTopic", "ss_probs_data",  "probs.csv"), header = F)

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

# Semi-Supervised Probabilities
# BERTopic_df_ss_probs <- tibble::rowid_to_column(BERTopic_df_ss_probs, "ID")
# ss_probs_merge <- BERTopic_df_ss_probs
# all_businesses <- tibble::rowid_to_column(all_businesses, "ID")
# 
# ss_probs_merge <- ss_probs_merge %>% select(ID, )
# all_businesses <- all_businesses %>% 
#   left_join(BERTopic_df_guided, by = "BusinessShortNumber")

# Inspect ---------------------------------------------------------------

all_businesses <- tibble::rowid_to_column(all_businesses, "index")
all_businesses %>% dplyr::filter(index %in% c(313, 388, 479, 545)) %>% View()







