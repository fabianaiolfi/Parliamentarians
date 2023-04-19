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
business_legislative_period_51$InitialSituation_clean <- delete_bold_tags(business_legislative_period_51$InitialSituation)

# Remove all HTML tags
business_legislative_period_51$InitialSituation_clean <- strip_html(business_legislative_period_51$InitialSituation_clean)

# Remove double whitespaces (Source: ChatGPT)
business_legislative_period_51$InitialSituation_clean <- gsub(" {2,}", " ", business_legislative_period_51$InitialSituation_clean)


# Create ChatGPT Query String ---------------------------------------------------------------

# Setup query as string
query_central_stmnt <- "Welche zentrale Aussage soll ein:e Wähler:in von diesem Text mitnehmen? Verwende einfache Sprache, maximal 15 Wörter und maximal 1 Satz.\n"
query_smartspider_precise <- "Du hast 8 Kategorien:\n1. Offene Aussenpolitik\n2. Liberale Wirtschaftspolitik\n3. Restriktive Finanzpolitik\n4. Law & Order\n5. Restriktive Migrationspolitik\n6. Ausgebauter Umweltschutz\n7. Ausgebauter Sozialstaat\n8. Liberale Gesellschaft\nBasierend auf den Text unten gibst du für jede Kategorie einen Wert zwischen 0 und 100. 100 steht für eine starke Zustimmung für die Kategorie, 0 steht für keine Zustimmung. Gebe 'NA' an, wenn eine Kategorie nicht passt. Gib immer an, welcher Wert zu welcher Kategorie gehört. Gib keine weiteren Informationen.\n"

# Merge ChatGPT query string with description text
business_legislative_period_51 <- business_legislative_period_51 %>% 
  mutate(chatgpt_query_central_stmnt = paste(query_central_stmnt, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_smartspider_precise = paste(query_smartspider_precise, InitialSituation_clean, sep = " ")) 

# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
business_legislative_period_51$role <- "user"