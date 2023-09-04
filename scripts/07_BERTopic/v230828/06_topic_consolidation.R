
# Topic Consolidation -----------------------------------------------------
# Place similar topics together


# Load ChatGPT Generated Topic Names -----------------------------------------------------

load(here("data", "chatgpt_output_df_20230828_140010.RData"))
generated_topics <- chatgpt_output_df
rm(chatgpt_output_df)

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

# Consolidate Identical Topics

# bsn_topic_consolidated <- bsn_topic %>% 
#   mutate(topic_value = case_when(topic_value == 129 ~ 100, # Bildungs- und Forschungsförderung
#                                  topic_value == 116 ~ 13, # COVID-19-Gesetzgebung
#                                  topic_value == 21 ~ 19, # Doppelbesteuerungsabkommen
#                                  topic_value == 23 ~ 19,
#                                  topic_value == 34 ~ 19,
#                                  topic_value == 58 ~ 19,
#                                  topic_value == 68 ~ 19,
#                                  topic_value == 69 ~ 19,
#                                  topic_value == 76 ~ 19,
#                                  topic_value == 143 ~ 19,
#                                  topic_value == 151 ~ 19,
#                                  topic_value == 161 ~ 19,
#                                  topic_value == 153 ~ 46, # Internationale Kriminalitätsbekämpfung
#                                  topic_value == 114 ~ 81, # Konkursrecht
#                                  topic_value == 135 ~ 117, # Krankenversicherungsgesetzgebung
#                                  topic_value == 113 ~ 92, # Militärreformen
#                                  topic_value == 77 ~ 67, # Schweizer Gesetzgebung
#                                  topic_value == 105 ~ 67, 
#                                  topic_value == 148 ~ 67,
#                                  topic_value == 85 ~ 49, # Schweizer Rechtssystem
#                                  topic_value == 82 ~ 24, # Sozialversicherungsreformen
#                                  topic_value == 138 ~ 16, # Steuerrecht
#                                  topic_value == 162 ~ 136, # Verkehrsgesetze
#                                  topic_value == 121 ~ 106, # Versicherungsrecht
#                                  TRUE ~ topic_value
#                                  )) %>% 
#   distinct(BusinessShortNumber, topic_value)

#length(unique(bsn_topic$topic_value))
#length(unique(bsn_topic_consolidated$topic_value))

#test <- all_businesses %>% left_join(bsn_topic_consolidated, by = "BusinessShortNumber") %>% dplyr::filter(topic_value == 14)
#test$chatgpt_vote_yes


# Merge and Export -----------------------------------------------------

all_businesses_web <- all_businesses %>% 
  left_join(bsn_topic_1, by = "BusinessShortNumber") %>% 
  left_join(generated_topics, by = c("topic_1" = "Topic")) %>% 
  select(BusinessShortNumber, chatgpt_summary, chatgpt_vote_yes, chatgpt_topic)

save(all_businesses_web, file = here("data", "all_businesses_web.RData"))
