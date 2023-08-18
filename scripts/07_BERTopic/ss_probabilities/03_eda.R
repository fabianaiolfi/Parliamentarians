
# Exploratory Data Analysis -----------------------------------------------

topic_probs_max <- topic_probs %>% dplyr::filter(max_prob == 1)


# Merge all businesses and topic probs ---------------------------------------------------------------

topic_probs_max <- topic_probs_max %>%
  left_join(all_businesses, by = "index")


length(unique(topic_probs_max$max_col))
