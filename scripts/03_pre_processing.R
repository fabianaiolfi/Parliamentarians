# Prepare Data for ChatGPT API


# Functions ---------------------------------------------------------------

# Remove HTML tags (Source: https://stackoverflow.com/a/17227415)
strip_html <- function(htmlString) {
  return(gsub("<.*?>", " ", htmlString))
}

# Remove text in bold tags because these are already summaries (Source: ChatGPT)
delete_bold_tags <- function(input_string) {
  # Define the pattern to match text inside <b> tags
  pattern <- "<b>[^<>]*</b>"
  # Replace the pattern with an empty string
  result_string <- gsub(pattern, "", input_string, perl = TRUE)
  return(result_string)
}


# Clean Data ---------------------------------------------------------------
# Remove bold tags
#all_businesses$InitialSituation_clean <- delete_bold_tags(all_businesses$InitialSituation)

# Remove all HTML tags
all_businesses$InitialSituation_clean <- strip_html(all_businesses$InitialSituation)

# Remove double whitespaces (Source: ChatGPT)
all_businesses$InitialSituation_clean <- gsub(" {2,}", " ", all_businesses$InitialSituation_clean)


# Create ChatGPT Query String ---------------------------------------------------------------
# Setup query as string
query_central_stmnt <- "Welche zentrale Aussage soll ein:e Wähler:in von diesem Text mitnehmen? Verwende einfache Sprache, maximal 15 Wörter und maximal 1 Satz.\n"
#query_smartspider_precise <- "Du hast 8 Kategorien:\n1. Offene Aussenpolitik\n2. Liberale Wirtschaftspolitik\n3. Restriktive Finanzpolitik\n4. Law & Order\n5. Restriktive Migrationspolitik\n6. Ausgebauter Umweltschutz\n7. Ausgebauter Sozialstaat\n8. Liberale Gesellschaft\nBasierend auf den Text unten gibst du für jede Kategorie einen Wert zwischen 0 und 100. 100 steht für eine starke Zustimmung für die Kategorie, 0 steht für keine Zustimmung. Gebe 'NA' an, wenn eine Kategorie nicht passt. Gib immer an, welcher Wert zu welcher Kategorie gehört. Gib keine weiteren Informationen.\n"

# Merge ChatGPT query string with description text
all_businesses <- all_businesses %>% 
  mutate(chatgpt_query_central_stmnt = paste(query_central_stmnt, InitialSituation_clean, sep = " "))# %>% 
  #mutate(chatgpt_query_smartspider_precise = paste(query_smartspider_precise, InitialSituation_clean, sep = " "))


# Wide to Long Table ---------------------------------------------------------------
all_businesses_long <- all_businesses %>% 
  select(BusinessShortNumber, chatgpt_query_central_stmnt) %>% #, chatgpt_query_smartspider_precise) %>% 
  gather(key = "query_type", value = "query", chatgpt_query_central_stmnt) %>% #, chatgpt_query_smartspider_precise) %>% 
  mutate(id = paste(BusinessShortNumber, query_type, sep = "-"), .keep = c("unused"))

# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
all_businesses_long$role <- "user"
