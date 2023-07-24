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

# Remove whitespace at beginning
all_businesses$InitialSituation_clean <- gsub("^\\s+", "", all_businesses$InitialSituation_clean)


# Create ChatGPT Query String ---------------------------------------------------------------
# Setup query as string
query_central_stmnt <- "Hier ist ein Dokument mit einem Titel. Gib dem Dokument 5 bis 10 Kategorien. Jede Kategorie muss 1 bis 3 Wörter umfassen. Gib nur die Kategorien zurück:\n"

# Merge ChatGPT query string with description text
all_businesses <- all_businesses %>% 
  mutate(chatgpt_query_central_stmnt = paste(query_central_stmnt, "Titel:", Title, "\nInhalt:", InitialSituation_clean, sep = "\n"))


# Wide to Long Table ---------------------------------------------------------------
all_businesses_long <- all_businesses %>% 
  select(BusinessShortNumber, chatgpt_query_central_stmnt) %>% #, chatgpt_query_smartspider_precise) %>% 
  gather(key = "query_type", value = "query", chatgpt_query_central_stmnt) %>% #, chatgpt_query_smartspider_precise) %>% 
  mutate(id = paste(BusinessShortNumber, query_type, sep = "-"), .keep = c("unused"))

# ChatGPT wrapper requires `prompt_role_var` to be its own column in the dataframe
all_businesses_long$role <- "user"

# Check
cat(all_businesses_long$query[670])
