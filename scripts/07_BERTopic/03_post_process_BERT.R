
# Prepare Topic Probability Data ---------------------------------------------------------------

# Load Topics
topics <- read.csv(here("scripts", "07_BERTopic", "BERT_data", "v230820", "topic_info.csv"), header = T)

# Remove outlier topic (Topic: "-1")
topics <- topics %>% dplyr::filter(Topic != -1)

# Get number of topics
topics_count <- nrow(topics)

# Load Topic Probabilities
topic_probs <- read.csv(here("scripts", "07_BERTopic", "BERT_data", "v230820", "probs.csv"), header = F)

# Add index
topic_probs <- tibble::rowid_to_column(topic_probs, "index")


# Get Topic with highest Probilities ---------------------------------------------------------------

# Calculate difference between 3 highest probabilities
topic_probs$diff_max_3 <- apply(topic_probs[, paste0("V", 1:topics_count)], 1, function(row) {
  sorted_values <- sort(row, decreasing = TRUE)
  return(sorted_values[1] - sorted_values[3])
})

# Get 1st probability (max)
topic_probs$prob_1 <- do.call(pmax, topic_probs[, paste0("V", 1:topics_count)])

# Get 2nd highest probability
topic_probs$prob_2 <- apply(topic_probs[, paste0("V", 1:topics_count)], 1, function(x) x[order(x, decreasing = TRUE)[2]])

# Get 3rd highest probability
topic_probs$prob_3 <- apply(topic_probs[, paste0("V", 1:topics_count)], 1, function(x) x[order(x, decreasing = TRUE)[3]])

# Get column name with highest probability
topic_probs$max_col <- apply(topic_probs[, paste0("V", 1:topics_count)], 1, function(x) {
  names(x)[which.max(x)]
})

# Get column names with top 3 probabilities
topic_probs$top_3_topics <- apply(topic_probs[, paste0("V", 1:topics_count)], 1, function(row) {
  sorted_indices <- order(row, decreasing = TRUE)[1:3]
  return(paste(names(row)[sorted_indices], collapse = ","))
})

topic_probs <- topic_probs %>% select(index, max_col, top_3_topics, prob_1, prob_2, prob_3, diff_max_3)


# Multiple topics per Business Item ---------------------------------------------------------------

top_topics <- topic_probs %>%
  select(index, top_3_topics, prob_1, prob_2, prob_3) %>% 
  separate(top_3_topics, into = c("topic_1", "topic_2", "topic_3"), sep = ",") %>%
  mutate_at(vars(topic_1:topic_3), ~as.integer(sub("V", "", .))) %>% 
  # Re-align topic numbers with topic number generated in BERTopic (topic nr 1 -> topic nr 0)
  mutate(topic_1 = topic_1 - 1) %>% mutate(topic_2 = topic_2 - 1) %>% mutate(topic_3 = topic_3 - 1) %>% 
  mutate(topic_2 = case_when(prob_2 < 0.001 ~ NA,
                             prob_2 >= 0.001 ~ topic_2)) %>% 
  mutate(topic_3 = case_when(is.na(topic_2) == TRUE ~ NA,
                             is.na(topic_2) == FALSE ~ topic_3)) %>% 
  mutate(prob_2 = case_when(prob_2 < 0.001 ~ NA,
                             prob_2 >= 0.001 ~ prob_2)) %>% 
  mutate(prob_3 = case_when(is.na(prob_2) == TRUE ~ NA,
                             is.na(prob_2) == FALSE ~ prob_3))

top_topics <- top_topics %>%
  left_join(all_businesses, by = "index")

top_topics_long <- top_topics %>%
  pivot_longer(cols = starts_with("topic"),
               names_to = "topic_num",
               values_to = "topic_value")
