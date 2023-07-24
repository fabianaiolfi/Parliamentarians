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

# Create Sample ---------------------------------------------------------------

# Always sample the same business items
sample_sbn <- c("22.028", "22.030", "20.063", "20.064", "22.033")

# Create sample dataframe
sample_business <- business_legislative_period_51 %>% 
  filter(BusinessShortNumber %in% sample_sbn)


# Clean Data ---------------------------------------------------------------
# Remove bold tags
sample_business$InitialSituation_clean <- delete_bold_tags(sample_business$InitialSituation)

# Remove all HTML tags
sample_business$InitialSituation_clean <- strip_html(sample_business$InitialSituation_clean)

# Remove double whitespaces (Source: ChatGPT)
sample_business$InitialSituation_clean <- gsub(" {2,}", " ", sample_business$InitialSituation_clean)


# Create ChatGPT Queries ---------------------------------------------------------------
# Sent on 20230411_232430
query_3_pts <- "Zusammenfassung in 3 nummerierten Stichpunkten, jeweils maximal 10 Wörter, mit Verweis auf die wichtigsten Akteure in jedem Stichpunkt: "
query_1_sent <- "Erstelle eine Zusammenfassung, maximal 1 Satz, maximal 15 Wörter, in einfacher Sprache: "
query_central_stmnt <- "Welche zentrale Aussage soll ein:e Wähler:in von diesem Text mitnehmen? Verwende  einfache Sprache, maximal 15 Wörter und maximal 1 Satz.\n"
query_3_keywords <- "Welche drei Schlagwörter passen zu diesem Text?\n"
# Sent on 20230418
query_smartspider <- "Du hast 8 Kategorien:\n1. Offene Aussenpolitik\n2. Liberale Wirtschaftspolitik\n3. Restriktive Finanzpolitik\n4. Law & Order\n5. Restriktive Migrationspolitik\n6. Ausgebauter Umweltschutz\n7. Ausgebauter Sozialstaat\n8. Liberale Gesellschaft\nBasierend auf den Text unten gibst du für jede Kategorie einen Wert zwischen 0 und 100. 100 steht für eine starke Zustimmung für die Kategorie, 0 steht für keine Zustimmung. Gebe 'NA' an, wenn eine Kategorie nicht passt. Bitte nur die 8 Punkte zurückgeben.\n"
query_smartspider_precise <- "Du hast 8 Kategorien:\n1. Offene Aussenpolitik\n2. Liberale Wirtschaftspolitik\n3. Restriktive Finanzpolitik\n4. Law & Order\n5. Restriktive Migrationspolitik\n6. Ausgebauter Umweltschutz\n7. Ausgebauter Sozialstaat\n8. Liberale Gesellschaft\nBasierend auf den Text unten gibst du für jede Kategorie einen Wert zwischen 0 und 100. 100 steht für eine starke Zustimmung für die Kategorie, 0 steht für keine Zustimmung. Gebe 'NA' an, wenn eine Kategorie nicht passt. Gib immer an, welcher Wert zu welcher Kategorie gehört. Gib keine weiteren Informationen.\n"

# Save for Shiny app
save(query_3_pts, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "query_3_pts.RData"))
save(query_1_sent, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "query_1_sent.RData"))
save(query_central_stmnt, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "query_central_stmnt.RData"))
save(query_3_keywords, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "query_3_keywords.RData"))
save(query_smartspider, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "query_smartspider.RData"))
save(query_smartspider_precise, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "query_smartspider_precise.RData"))

sample_business <- sample_business %>% 
  mutate(chatgpt_query_3_pts = paste(query_3_pts, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_1_sent = paste(query_1_sent, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_central_stmnt = paste(query_central_stmnt, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_3_keywords = paste(query_3_keywords, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_smartspider = paste(query_smartspider, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_smartspider_precise = paste(query_smartspider_precise, InitialSituation_clean, sep = " "))

save(sample_business, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "sample_business.RData")) # save for Shiny app


query_list <- c("chatgpt_query_3_pts", "chatgpt_query_1_sent", "chatgpt_query_central_stmnt", "chatgpt_query_3_keywords", "chatgpt_query_smartspider", "chatgpt_query_smartspider_precise")


# Wide to Long Table ---------------------------------------------------------------
sample_business_long <- sample_business %>% 
  select(BusinessShortNumber, all_of(query_list)) %>% 
  gather(key = "query_type", value = "query", query_list) %>% 
  mutate(id = paste(BusinessShortNumber, query_type, sep = "-"), .keep = c("unused"))

# Wrapper requires `prompt_role_var` to be a column in the dataframe
sample_business_long$role <- "user"

# Only include smartspider query
sample_business_long <- sample_business_long %>% 
  filter(str_detect(id, "smartspider_precise"))
