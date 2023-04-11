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
query_3_pts <- "Zusammenfassung in 3 nummerierten Stichpunkten, jeweils maximal 10 Wörter, mit Verweis auf die wichtigsten Akteure in jedem Stichpunkt: "
query_1_sent <- "Erstelle eine Zusammenfassung, maximal 1 Satz, maximal 15 Wörter, in einfacher Sprache: "
query_central_stmnt <- "Welche zentrale Aussage soll ein:e Wähler:in von diesem Text mitnehmen? Verwende  einfache Sprache, maximal 15 Wörter und maximal 1 Satz.\n"
query_3_keywords <- "Welche drei Schlagwörter passen zu diesem Text?\n"

sample_business <- sample_business %>% 
  mutate(chatgpt_query_3_pts = paste(query_3_pts, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_1_sent = paste(query_1_sent, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_central_stmnt = paste(query_central_stmnt, InitialSituation_clean, sep = " ")) %>% 
  mutate(chatgpt_query_3_keywords = paste(query_3_keywords, InitialSituation_clean, sep = " "))

query_list <- c("chatgpt_query_3_pts", "chatgpt_query_1_sent", "chatgpt_query_central_stmnt", "chatgpt_query_3_keywords")


# Truncate Long Query ---------------------------------------------------------------
# The model gpt-3.5-turbo-0301 sets 4096 as the maximum number of tokens for one query (https://platform.openai.com/docs/guides/chat/introduction)

# Calculate number of tokens per query
# https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them
# English: 1 token ~ 4 characters

# Own calculations based on https://platform.openai.com/tokenizer
# German: 1 token ~ 2.6 characters
# sample_business$chatgpt_query_n_tokens <- nchar(sample_business$chatgpt_query_3_pts) / 2.6
# max(sample_business$chatgpt_query_n_tokens)


# Wide to Long Table ---------------------------------------------------------------
sample_business_long <- sample_business %>% 
  select(BusinessShortNumber, all_of(query_list)) %>% 
  gather(key = "query_type", value = "query", query_list) %>% 
  mutate(id = paste(BusinessShortNumber, query_type, sep = "-"), .keep = c("unused"))

# Wrapper requires `prompt_role_var` to be a column in the dataframe
sample_business_long$role <- "user"

# Tweak Council Member DF for Shiny App ---------------------------------------------------------------
#member_council_legislative_period_51 <- member_council_legislative_period_51 %>% 
  #mutate(full_name = paste(FirstName, LastName))
