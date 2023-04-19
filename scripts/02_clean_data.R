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



# Create ChatGPT Query ---------------------------------------------------------------
summary_query <- "Zusammenfassung in 3 nummerierten Stichpunkten, jeweils maximal 10 Wörter, mit Verweis auf die wichtigsten Akteure in jedem Stichpunkt: "

business_legislative_period_51 <- business_legislative_period_51 %>% 
  mutate(chatgpt_query = paste(summary_query, InitialSituation_clean, sep = " "))

# Wrapper requires `prompt_role_var` to be a column in the dataframe
business_legislative_period_51$role <- "user"