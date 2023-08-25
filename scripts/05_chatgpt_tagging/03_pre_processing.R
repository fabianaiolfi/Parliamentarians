
# Prepare Data for ChatGPT API

# Create ChatGPT Query String ---------------------------------------------------------------

# Setup query as string
query_tags <- "Hier ist ein Dokument mit einem Titel. Gib dem Dokument 5 bis 10 Kategorien. Jede Kategorie muss 1 bis 3 Wörter umfassen. Gib nur die Kategorien zurück:\n"

# Merge ChatGPT query string with description text
all_businesses <- all_businesses %>% 
  mutate(chatgpt_query_tags = paste(query_tags, "Titel:", Title, "\nInhalt:", InitialSituation_clean, sep = "\n"))


# Wide to Long Table ---------------------------------------------------------------
all_businesses_long <- all_businesses %>% 
  select(BusinessShortNumber, chatgpt_query_tags) %>%
  gather(key = "query_type", value = "query", chatgpt_query_tags) %>%
  mutate(id = paste(BusinessShortNumber, query_type, sep = "-"), .keep = c("unused"))

# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
all_businesses_long$role <- "user"
