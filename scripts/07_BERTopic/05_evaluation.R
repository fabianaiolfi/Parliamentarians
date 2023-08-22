
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

#rm(chatgpt_intruder_query)
chatgpt_intruder_query <- df_with_intruders %>% 
  select(BusinessShortNumber, Title, chatgpt_summaries, topic_value, intruder) %>% 
  # Add index for each group
  group_by(topic_value) %>%
  mutate(in_topic_index = row_number()) %>%
  ungroup() %>% 
  # Prepare strings for query
  mutate(in_topic_index = paste("Dokument", in_topic_index, sep = " ")) %>% 
  mutate(Title = paste("Titel:", Title, sep = " ")) %>% 
  mutate(chatgpt_summaries = paste("Text:", chatgpt_summaries, sep = " ")) %>% 
  mutate(query_docs = paste(in_topic_index, Title, chatgpt_summaries, sep = "\n")) %>% 
  drop_na(topic_value) %>% 
  # Add topic names to each group
  left_join(chatgpt_topics, by = c("topic_value" = "Topic")) %>% 
  select(-Representation)

intruder_doc_number <- chatgpt_intruder_query %>% 
  dplyr::filter(intruder == T) %>% 
  mutate(doc_number = in_topic_index) %>% 
  select(topic_value, in_topic_index) %>% 
  rename(intruder_doc = in_topic_index)

chatgpt_intruder_query <- chatgpt_intruder_query %>%
  group_by(topic_value) %>%
  summarise(query = paste(query_docs, collapse = "\n\n")) %>%
  ungroup() %>% 
  left_join(intruder_doc_number, by = "topic_value") %>% 
  left_join(chatgpt_topics, by = c("topic_value" = "Topic")) %>% 
  select(-Representation) %>% 
  mutate(prompt = paste("Welches Dokument passt nicht in diese Gruppe? Das Thema der Gruppe ist '", chatgpt_topic_title, "'. Gib nur die Dokumentennummer zurück und nichts anderes:\n\n", sep = "")) %>% 
  mutate(query = paste0(prompt, query)) %>% 
  select(topic_value, query, intruder_doc)

# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
chatgpt_intruder_query$role <- "user"


# Test ChatGPT Query with Sample ---------------------------------------------------------------

# set.seed(42)
# test_sample <- sample(0:topics_count-1, 5, replace = F)
# chatgpt_intruder_query <- chatgpt_intruder_query %>% dplyr::filter(topic_value %in% test_sample)


# Query ChatGPT ---------------------------------------------------------------

# # Connect to ChatGPT
# gpt3_authenticate("ChatGPT_API_Key.txt")
# 
# # Get and format the current timestamp to prevent overwriting files when saving RData locally
# timestamp <- Sys.time()
# formatted_timestamp <- format(timestamp, "%Y%m%d_%H%M%S")
# 
# # Create empty DF to fill up with ChatGPT output
# chatgpt_output_intruder_all <- data.frame(topic_value = numeric(0), chatgpt_intruder_guess = numeric(0))
# 
# # ChatGPT API Query in sleep loop to prevent reaching tokens-per-minute limit of 10'000
# for(i in 1:nrow(chatgpt_intruder_query)) {
#   chatgpt_output_intruder <- chatgpt(prompt_role_var = chatgpt_intruder_query$role[i],
#                                      prompt_content_var = chatgpt_intruder_query$query[i],
#                                      id_var = chatgpt_intruder_query$topic_value[i],
#                                      param_max_tokens = 100,
#                                      param_n = 1,
#                                      param_temperature = 0,
#                                      param_model = "gpt-4")
#   # Convert to DF
#   chatgpt_output_intruder <- do.call(
#     rbind,
#     Map(data.frame,
#         topic_value = chatgpt_output_intruder[[1]][["id"]],
#         chatgpt_intruder_guess = chatgpt_output_intruder[[1]][["chatgpt_content"]]))
#   
#   # Add to main output DF
#   chatgpt_output_intruder_all <- rbind(chatgpt_output_intruder_all, chatgpt_output_intruder)
#   
#   # Print counter
#   print(i)
#   
#   # Pause
#   Sys.sleep(20)
# }
# 
# file_name <- paste0("chatgpt_output_intruder_", formatted_timestamp, ".RData")
# save(chatgpt_output_intruder_all, file = here("data", file_name))


# Clean ChatGPT Output ---------------------------------------------------------------

# Load ChatGPT Data
load(here("data", "chatgpt_output_intruder_20230822_151009.RData"))

# Merge and clean
chatgpt_intruder_query <- chatgpt_intruder_query %>% 
  left_join(chatgpt_output_intruder_all, by = "topic_value") %>% 
  select(-role)


# Calculate Evaluation ---------------------------------------------------------------

# Accuracy: Number of correct guesses over the total number of guesses.
# Precision: Of the documents that were predicted as 'intruders', how many were actually 'intruders'?
# Recall (Sensitivity): Of all the actual 'intruder' documents, how many were correctly predicted by the model? (Correctly identified Topic n docs / Total actual Topic n docs)

chatgpt_intruder_query <- chatgpt_intruder_query %>% 
  mutate(chatgpt_intruder_guess = gsub("Dokument", "", chatgpt_intruder_guess)) %>% 
  mutate(chatgpt_intruder_guess = as.numeric(chatgpt_intruder_guess)) %>% 
  mutate(intruder_doc = gsub("Dokument", "", intruder_doc)) %>% 
  mutate(intruder_doc = as.numeric(intruder_doc))

# Create the confusion matrix using table()
confusion_matrix <- table(chatgpt_intruder_query$intruder_doc, chatgpt_intruder_query$chatgpt_intruder_guess)

# Create an empty 4x4 matrix
true_topics <- sort(unique(chatgpt_intruder_query$intruder_doc))
full_matrix <- matrix(0, nrow = length(true_topics), ncol = length(true_topics), dimnames = list(true_topics, true_topics))

# Populate the full matrix with values from confusion_matrix
for (i in rownames(confusion_matrix)) {
  for (j in colnames(confusion_matrix)) {
    full_matrix[i, j] <- confusion_matrix[i, j]
  }
}

# Using the full_matrix from the previous code
confusion_result <- confusionMatrix(as.table(full_matrix))

# Extracting metrics
accuracy <- confusion_result$overall['Accuracy']

precision <- confusion_result$byClass[,'Pos Pred Value']
precision_mean <- mean(precision, na.rm = TRUE)

recall <- confusion_result$byClass[,'Sensitivity']
recall_mean <- mean(recall, na.rm = TRUE)

f1_score <- 2 * (precision_mean * recall_mean) / (precision_mean + recall_mean)

print(paste("Accuracy: ", round(accuracy, 3)))
print(paste("Precision (Mean over all Topics): ", round(precision_mean, 3)))
print(paste("Recall (Mean over all Topics): ", round(recall_mean, 3)))
print(paste("F1 Score (Mean over all Topics): ", round(f1_score, 3)))
