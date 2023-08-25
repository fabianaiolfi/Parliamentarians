
# BERTopic Topic Title Generation with ChatGPT ---------------------------------------------------------------


# Prepare Dataset ---------------------------------------------------------------

query <- "Hier ist eine Liste von Dokumententiteln und eine dazugehörige Zusammenfassung. Diese Dokumente gehören zu einer Gruppe. Wie lautet der Name der Gruppe? Gib nur einen möglichen Namen zurück, nichts anderes. Der Name soll kurz und allgemein gehalten sein. Verwende keine spezifischen Begriffe."
 
all_businesses <- all_businesses %>% 
  left_join(select(doc_info, BusinessShortNumber, Topic), by = "BusinessShortNumber")

topics_by_title_summary <- all_businesses %>% 
  select(Topic, Title, chatgpt_summary) %>% 
  mutate(titel_and_summary = paste("Titel: ", Title, "\n", "Zusammenfassung: ", chatgpt_summary, sep = "")) %>% 
  group_by(Topic) %>%
  summarise(titel_and_summary = paste(titel_and_summary, collapse = "\n\n"))


# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
chatgpt_topics$role <- "user"

# Create new column with query and terms
chatgpt_topics <- chatgpt_topics %>% mutate(chatgpt_query = paste(query_start, Representation, query_end, sep = ""))


# Test ChatGPT Query with Sample ---------------------------------------------------------------

# set.seed(42)
# test_sample <- sample(0:topics_count-1, 5, replace = F)
# chatgpt_topics <- chatgpt_topics %>% dplyr::filter(Topic %in% test_sample)


# Query ChatGPT ---------------------------------------------------------------

# Connect to ChatGPT 
# gpt3_authenticate("ChatGPT_API_Key.txt")

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
load(here("data", "chatgpt_output_topics_20230821_102051.RData"))

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
