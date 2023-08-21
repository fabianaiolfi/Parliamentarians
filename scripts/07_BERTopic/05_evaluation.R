
# Evaluation: Automatic Document Intrusion Detection ----------------------

# temp_df <- top_topics_long %>% 
#   select(Title, chatgpt_summaries, topic_value) %>% 
#   dplyr::filter(topic_value == 0)
# rm(temp_df)

# # Function to get an intruder document for a given topic
# get_intruder <- function(data) {
#   intruder_topic <- sample(setdiff(unique(top_topics_long$topic_value), data$topic_value[1]), 1)
#   intruder_doc <- sample(top_topics_long$BusinessShortNumber[top_topics_long$topic_value == intruder_topic], 1)
#   return(data.frame(document = intruder_doc, topic_value = data$topic_value[1]))
# }
# 
# # Get intruders for each topic group
# intruders <- top_topics_long %>%
#   group_by(topic_value) %>%
#   do(get_intruder(.))
# 
# # Combine original dataframe with intruders
# df_with_intruders <- rbind(top_topics_long, intruders)

# rm(get_intruder)
# rm(playground_df)


# playground_df <- top_topics_long
# playground_df <- playground_df %>% mutate(intruder = F)
# 
# # Sample function to add an intruder for each group
# add_intruder <- function(data) {
#   # Select a random row that doesn't match the current topic
#   intruder_row <- playground_df %>%
#     dplyr::filter(topic_value != data$topic_value[1]) %>%
#     sample_n(1)
#   # Mark it as an intruder
#   intruder_row$intruder <- TRUE
#   return(intruder_row)
# }
# 
# # Apply the function to each group
# intruders <- playground_df %>%
#   distinct(BusinessShortNumber, .keep_all = T) %>% 
#   group_by(topic_value) %>%
#   do(add_intruder(.))
# 
# # Combine the original dataframe with the "intruders"
# #rm(df_with_intruders)
# df_with_intruders <- rbind(playground_df, intruders)


playground_df <- top_topics_long
playground_df <- playground_df %>% mutate(intruder = FALSE)

# add_intruder <- function(data) {
#   # Identify topics which are not the current topic
#   other_topics <- setdiff(unique(playground_df$topic_value), unique(data$topic_value))
#   
#   # This loop ensures that a valid intruder is always found
#   for (i in 1:length(other_topics)) {
#     # Select a random topic from other topics
#     random_topic <- sample(other_topics, 1)
#     
#     # Select a random row with that topic
#     intruder_row <- playground_df %>%
#       dplyr::filter(topic_value == random_topic)
#     
#     # If we have found a valid intruder row, break the loop
#     if (nrow(intruder_row) > 0) {
#       intruder_row <- sample_n(intruder_row, 1)
#       break
#     }
#     
#     # If not, remove this topic from our list and try again
#     other_topics <- setdiff(other_topics, random_topic)
#   }
#   
#   # Mark it as an intruder
#   intruder_row$intruder <- TRUE
#   
#   return(intruder_row)
# }

add_intruder <- function(data) {
  # Define the range and the numbers to exclude
  topic_range <- 0:(topics_count-1)
  exclude <- data$topic_value[1]

  # Pick a random number from the range excluding the specified numbers
  random_topic <- sample(setdiff(topic_range, exclude), 1)

  # Select a random row with that topic
  intruder_row <- playground_df %>% dplyr::filter(topic_value == random_topic) %>% head(n = 1)

  # Mark it as an intruder
  intruder_row$intruder <- TRUE
  # Hide it, i.e., place it in the foreign group
  intruder_row$topic_value <- exclude
  
  return(intruder_row)
}

intruders <- playground_df %>%
  group_by(topic_value) %>%
  do(add_intruder(.))

rm(df_with_intruders)
df_with_intruders <- rbind(playground_df, intruders)

table(df_with_intruders$intruder)














