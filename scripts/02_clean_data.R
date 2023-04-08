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



# Create ChatGPT Prompt ---------------------------------------------------------------
summary_prompt <- "Zusammenfassung in 3 nummerierten Stichpunkten, jeweils maximal 10 Wörter, mit Verweis auf die wichtigsten Akteure in jedem Stichpunkt: "

business_legislative_period_51 <- business_legislative_period_51 %>% 
  mutate(chatgpt_prompt = paste(summary_prompt, InitialSituation_clean, sep = " "))


# Truncate Long Prompts ---------------------------------------------------------------
# The model gpt-3.5-turbo-0301 sets 4096 as the maximum number of tokens (https://platform.openai.com/docs/guides/chat/introduction)

# Calculate number of tokens per prompt
# https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them
# English: 1 token ~ 4 characters

# Own calculations based on https://platform.openai.com/tokenizer
# German: 1 token ~ 2.6 characters
business_legislative_period_51$chatgpt_prompt_n_tokens <- nchar(business_legislative_period_51$chatgpt_prompt) / 2.6
all(business_legislative_period_51$InitialSituation_clean_n_tokens < 4096) # Returns TRUE: No prompts exceed the maximum number of tokens






