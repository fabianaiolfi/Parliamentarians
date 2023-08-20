
# Topic Name Generation ---------------------------------------------------------------

topic_names <- df_long %>% 
  dplyr::filter(topic_num == "topic_1") %>% 
  dplyr::filter(prob_1 == 1)