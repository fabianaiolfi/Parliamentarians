
# Topic Consolidation -----------------------------------------------------
# Place similar topics together


# Load ChatGPT Generated Topic Names -----------------------------------------------------

load(here("data", "chatgpt_output_df_20230828_140010.RData"))


# Get Top 1-3 Topics per Business -----------------------------------------------------

# Retrieve BusinessShortNumber and top topic
bsn_topic_1 <- top_topics %>% select(BusinessShortNumber, topic_1)

# Merge top topic with 2nd and 3rd topic
bsn_topic <- top_topics_long %>%
  select(BusinessShortNumber, topic_value) %>% 
  left_join(bsn_topic_1, by = "BusinessShortNumber") %>% 
  mutate(topic_value = if_else(is.na(topic_value), topic_1, topic_value)) %>% 
  select(-topic_1) %>% 
  distinct(BusinessShortNumber, topic_value) # Remove redudant rows


# Consolidate Topics -----------------------------------------------------

# Identical Topics

