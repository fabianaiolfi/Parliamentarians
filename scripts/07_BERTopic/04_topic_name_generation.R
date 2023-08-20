
# BERTopic Name Generation with ChatGPT ---------------------------------------------------------------

chatgpt_topics <- topics %>%
  select(Topic, Representation) %>% 
  mutate(Representation = gsub("\\[|\\]|'", "", Representation))

query <- "Generiere einen kurzen, allgemein gehaltenen Titel für diese Gruppe von Begriffen:\n"

# Create new column with query and terms
chatgpt_topics <- chatgpt_topics %>% mutate(chatgpt_query = paste(query, Representation, sep = ""))

# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
chatgpt_topics$role <- "user"
