
# BERTopic Topic Title Generation with ChatGPT ---------------------------------------------------------------


# Prepare Dataset ---------------------------------------------------------------

chatgpt_topics <- topics %>%
  select(Topic, Representation) %>% 
  mutate(Representation = gsub("\\[|\\]|'", "", Representation))

query_start <- "Ich habe folgende Begriffe: "
query_end <- ". Kannst du einen kurzen (max. 5 Wörter) und allgemein gehaltenen Titel basierend auf diesen Begriffen vorschlagen? Gib nur den Titel zurück, nichts anderes."

# Create new column with query and terms
chatgpt_topics <- chatgpt_topics %>% mutate(chatgpt_query = paste(query_start, Representation, query_end, sep = ""))

# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
chatgpt_topics$role <- "user"


# Test ChatGPT Query with Sample ---------------------------------------------------------------

# set.seed(42)
# test_sample <- sample(0:topics_count-1, 5, replace = F)
# chatgpt_topics <- chatgpt_topics %>% dplyr::filter(Topic %in% test_sample)


# Query ChatGPT ---------------------------------------------------------------

# Connect to ChatGPT 
gpt3_authenticate("ChatGPT_API_Key.txt")

# # Get and format the current timestamp to prevent overwriting files when saving RData locally
# timestamp <- Sys.time()
# formatted_timestamp <- format(timestamp, "%Y%m%d_%H%M%S")
# 
# # Query
# chatgpt_output_topics <- chatgpt(prompt_role_var = chatgpt_topics$role,
#                                  prompt_content_var = chatgpt_topics$chatgpt_query,
#                                  id_var = chatgpt_topics$Topic,
#                                  param_max_tokens = 100,
#                                  param_n = 1,
#                                  param_temperature = 0,
#                                  param_model = "gpt-4")
# 
# file_name <- paste0("chatgpt_output_topics_", formatted_timestamp, ".RData")
# save(chatgpt_output_topics, file = here("data", file_name))


# Clean ChatGPT Output ---------------------------------------------------------------

# Load ChatGPT Data
load(here("data", "chatgpt_output_topics_20230821_092124.RData"))

# Convert to DF
chatgpt_output_topics <- do.call(
  rbind,
  Map(data.frame,
      Topic = chatgpt_output_topics[[1]][["id"]],
      chatgpt_topic_title = chatgpt_output_topics[[1]][["chatgpt_content"]]))

# Merge and clean
chatgpt_topics <- chatgpt_topics %>% 
  left_join(chatgpt_output_topics, by = "Topic") %>% 
  select(Topic, chatgpt_topic_title, Representation) %>% 
  mutate(chatgpt_topic_title = gsub('"', '', chatgpt_topic_title))
