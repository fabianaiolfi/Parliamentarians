
# BERTopic Topic Title Generation with ChatGPT ---------------------------------------------------------------


# Prepare Dataset ---------------------------------------------------------------

query <- "Hier ist eine Liste von Dokumententiteln und eine dazugehörige Zusammenfassung. Diese Dokumente gehören zu einer Gruppe. Wie lautet der Name der Gruppe? Gib nur einen möglichen Namen zurück, nichts anderes. Der Name soll kurz sein.\n\n"
 
all_businesses <- all_businesses %>% 
  left_join(select(doc_info, BusinessShortNumber, Topic), by = "BusinessShortNumber")

topics_by_title_summary <- all_businesses %>% 
  dplyr::filter(Topic != -1) %>% 
  select(Topic, Title, chatgpt_summary) %>% 
  mutate(titel_and_summary = paste("Titel: ", Title, "\n", "Zusammenfassung: ", chatgpt_summary, sep = "")) %>% 
  group_by(Topic) %>%
  summarise(titel_and_summary = paste(titel_and_summary, collapse = "\n\n"))


# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
topics_by_title_summary$role <- "user"

# Create new column with query and terms
topics_by_title_summary <- topics_by_title_summary %>% mutate(chatgpt_query = paste(query, titel_and_summary, sep = ""))


# Test ChatGPT Query with Sample ---------------------------------------------------------------

# set.seed(42)
# test_sample <- sample(0:topics_count-1, 5, replace = F)
# topics_by_title_summary <- topics_by_title_summary %>% dplyr::filter(Topic %in% test_sample)


# Query ChatGPT ---------------------------------------------------------------

# Connect to ChatGPT 
# gpt3_authenticate("ChatGPT_API_Key.txt")
# 
# # Get and format the current timestamp to prevent overwriting files when saving RData locally
# timestamp <- Sys.time()
# formatted_timestamp <- format(timestamp, "%Y%m%d_%H%M%S")
# 
# # Create empty DF to fill up with ChatGPT output
# chatgpt_output_df <- data.frame(id = character(0), chatgpt_topics = character(0))
# 
# # ChatGPT API Query in sleep loop to prevent reaching tokens-per-minute limit of 10'000
# for(i in 1:nrow(topics_by_title_summary)) {
#   chatgpt_output_topics <- chatgpt(prompt_role_var = topics_by_title_summary$role[i],
#                                     prompt_content_var = topics_by_title_summary$chatgpt_query[i],
#                                     id_var = topics_by_title_summary$Topic[i],
#                                     param_max_tokens = 100,
#                                     param_n = 1,
#                                     param_temperature = 0,
#                                     param_model = "gpt-4")
#   # Convert to DF
#   chatgpt_output_topics <- do.call(
#     rbind,
#     Map(data.frame,
#         Topic = chatgpt_output_topics[[1]][["id"]],
#         chatgpt_topic = chatgpt_output_topics[[1]][["chatgpt_content"]]))
#   
#   # Add to main output DF
#   chatgpt_output_df <- rbind(chatgpt_output_df, chatgpt_output_topics)
#   
#   # Print counter
#   print(i)
#   
#   # Pause
#   Sys.sleep(12)
# }
# 
# file_name <- paste0("chatgpt_output_df_", formatted_timestamp, ".RData")
# save(chatgpt_output_df, file = here("data", file_name))


# Clean ChatGPT Output ---------------------------------------------------------------

# Load ChatGPT Data
load(here("data", "chatgpt_output_df_20230827_173715.RData"))

# # Convert to DF
# chatgpt_output_topics <- do.call(
#   rbind,
#   Map(data.frame,
#       Topic = chatgpt_output_topics[[1]][["id"]],
#       chatgpt_topic = chatgpt_output_topics[[1]][["chatgpt_content"]]))
# 
# # # Merge and clean
# chatgpt_topics <- chatgpt_output_topics %>%
#   #left_join(chatgpt_output_topics, by = "Topic") %>%
#   select(Topic, chatgpt_topic) %>% # Representation
#   mutate(chatgpt_topic = gsub('"', '', chatgpt_topic))


# Housekeeping ---------------------------------------------------------------

# Prepare for 05_evaluation.R
#chatgpt_topics <- chatgpt_output_df
#rm(chatgpt_output_df)
#rm(chatgpt_output_topics)
