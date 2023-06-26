
# Define Functions ---------------------------------------------------------------

# Remove HTML tags (Source: https://stackoverflow.com/a/17227415)
strip_html <- function(htmlString) {
  return(gsub("<.*?>", " ", htmlString))
}


# Wrangle Dataframes ------------------------------------------------------

# Setup Dataframe, one tags per line
df <- business_legislative_period_51 %>% 
  select(-c(ID, Language, BusinessType, BusinessTypeAbbreviation, DraftText, DocumentationText, MotionText, FederalCouncilResponseText, FederalCouncilProposal, FederalCouncilProposalDate, FederalCouncilProposalText, BusinessStatus, BusinessStatusText, BusinessStatusDate, ResponsibleDepartment, ResponsibleDepartmentAbbreviation, IsLeadingDepartment, Tags, Category, Modified, SubmissionDate, SubmissionCouncil, SubmissionCouncilAbbreviation, SubmissionSession, SubmissionLegislativePeriod, FirstCouncil1, FirstCouncil1Abbreviation, FirstCouncil2, FirstCouncil2Name, FirstCouncil2Abbreviation)) %>% 
  mutate(main_tag = TagNames) %>% # Save main tag
  mutate(main_tag = gsub("\\|.*", "", main_tag)) %>%
  separate_rows(main_tag, sep = "\\|") %>% # Transform column to have one tag per row
  mutate(TagNames = gsub("\\|", " ", TagNames))


# Only keep ChatGPT summaries
chatgpt_summaries <- chatgpt_output[[1]][["chatgpt_content"]]
chatgpt_summaries <- chatgpt_summaries[1:147]
chatgpt_summaries <- as.data.frame(chatgpt_summaries)
temp_df <- business_legislative_period_51 %>% select(BusinessShortNumber)
chatgpt_summaries <- cbind(chatgpt_summaries, temp_df)
df <- df %>% left_join(chatgpt_summaries, by = "BusinessShortNumber")
rm(temp_df)



# Clean Text ------------------------------------------------------

# Clean up text heavy columns
text_cols <- c("InitialSituation", "Proceedings", "SubmittedText", "ReasonText", "chatgpt_summaries")
df <- df %>% mutate(across(text_cols, ~strip_html(.))) # Remove all HTML tags
df <- df %>% mutate(across(text_cols, ~gsub(" {2,}", " ", (.)))) # Remove double whitespaces

# Uncomment to Lemmatise Text
# lemma_df <- df %>% select(BusinessShortNumber, text_cols)
# 
# counter = length(text_cols)
# for (col in text_cols) {
#   temp_vector <- lemma_df[[col]] # %>% select({{ col }})
#   temp_vector <- udpipe_annotate(ud_model, temp_vector)
#   temp_df <- as.data.frame(temp_vector)
#   temp_df <- temp_df %>% select(doc_id, lemma) %>% drop_na()
# 
#   temp_df <- temp_df %>% group_by(doc_id) %>% summarize(temp_df = paste(lemma, collapse = " "))
# 
#   temp_df$doc_id <- gsub('doc', '', temp_df$doc_id)
#   temp_df$doc_id <- as.numeric(temp_df$doc_id)
#   temp_df <- temp_df %>% arrange(doc_id)
# 
#   lemma_df[[col]] <- temp_df$temp_df
#   print(counter)
#   counter <- counter -1
#   }
# save(lemma_df, file = here("data", "text2vec_fasttext_lemma_df.Rda"))
load(here("data", "text2vec_fasttext_lemma_df.Rda"))

# Further Preprocessing
for (col in text_cols) {
  lemma_df[[col]] <- tolower(lemma_df[[col]]) # Lowercasing
  # Tokenisation
  text <- tokens(lemma_df[[col]])
  text <- tokens(text, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
  text <- tokens_remove(text, pattern = c(stopwords("de"), custom_stopwords))
  # Merge back with lemma_df
  text <- data.frame(text = sapply(text, paste, collapse = " "))
  lemma_df[[col]] <- text$text
}

# Replace "na" strings with NA
lemma_df <- lemma_df %>% mutate(across(everything(), ~replace(., . == "na", NA)))

# Rename lemma columns for merge with main DF
new_colnames <- colnames(lemma_df)
new_colnames[-1] <- paste0(new_colnames[-1], "_lemma")
colnames(lemma_df) <- new_colnames

# Merge with main DF
df <- df %>% left_join(lemma_df, by = "BusinessShortNumber")


# Prepare for Fasttext ----------------------------------------------------

# Remove all newline characters
df <- df %>% mutate_at(vars(-BusinessShortNumber), ~ gsub("\n", "", .))

# Add </s> at end of strings
df <- df %>% mutate_at(vars(-BusinessShortNumber), ~ paste0(., "</s>"))
