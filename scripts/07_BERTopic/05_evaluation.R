
# Evaluation: Automatic Document Intrusion Detection ----------------------


# Setup DF with Intruders ----------------------

set.seed(42)

# Set all items of business not to be intruding documents
top_topics_long$intruder <- FALSE

add_intruder <- function(data) {
  # Define the range and the numbers to exclude
  topic_range <- 0:(topics_count-1)
  exclude <- data$topic_value[1]

  # Pick a random number from the range excluding the specified numbers
  random_topic <- sample(setdiff(topic_range, exclude), 1)

  # Select a random row with that topic
  intruder_row <- top_topics_long %>% dplyr::filter(topic_value == random_topic) %>% head(n = 1)

  # Mark it as an intruder
  intruder_row$intruder <- TRUE
  # Hide it, i.e., place it in the foreign group
  intruder_row$topic_value <- exclude
  
  return(intruder_row)
}

intruders <- top_topics_long %>%
  group_by(topic_value) %>%
  do(add_intruder(.))

# Combine the original dataframe with the "intruders"
df_with_intruders <- rbind(top_topics_long, intruders)

# Shuffle rows randomly
df_with_intruders <- df_with_intruders %>% sample_frac(1)


# Setup ChatGPT Query ----------------------

chatgpt_intruder_query <- df_with_intruders %>% 
  select(BusinessShortNumber, Title, chatgpt_summaries, topic_value, intruder) %>% 
  group_by(topic_value) %>%
  mutate(topic_index = row_number()) %>%
  ungroup() %>% 
  drop_na(topic_value) %>% 
  left_join(chatgpt_topics, by = c("topic_value" = "Topic"))

summary(chatgpt_intruder_query)
1911-629
