
# Add Context -----------------------------------------------------------------

# For each Worry and Items of Business, display a string that contains the Worry's topic in the business description
# Dynamically extract sentence from entire description based on topic in dropdown
# Problem with counting most frequent occurence was that some items of business appeared without an apparent link to topic

# 1. Split description by sentences over columns
bsn_sents <- all_businesses_eval %>% 
  select(BusinessShortNumber, InitialSituation_clean)

# Replace periods after 1 or 2-digit numbers
bsn_sents <- bsn_sents %>%
  mutate(InitialSituation_clean = gsub("\\b(\\d{1,2})\\.", "\\1", InitialSituation_clean))

# Tokenize sentences and make a new row for each
bsn_sents_sentences <- bsn_sents %>%
  drop_na(InitialSituation_clean) %>% 
  mutate(sentences = map(InitialSituation_clean, ~stri_split_boundaries(.x, type = "sentence"))) %>%
  unnest(sentences) %>%
  group_by(BusinessShortNumber) %>%
  mutate(sentence_id = row_number()) %>%
  ungroup()

# Spread the sentences into separate columns
bsn_sents <- bsn_sents_sentences %>%
  pivot_wider(names_from = sentence_id,
              values_from = sentences,
              names_prefix = "sentence_") %>% 
  select(-InitialSituation_clean) %>% 
  rename(sents = sentence_1)

# Create DF with associated words
associated_words <- vote_statement %>% 
  distinct(sorge)

# Function to safely retrieve an object by name
get_words_safe <- function(word) {
  if (exists(word)) {
    return(get(word))
  }
  return(NULL)
}

# Adding the lists to the dataframe
associated_words <- associated_words %>%
  rowwise() %>%
  mutate(words_list = list(get_words_safe(sorge))) %>%
  ungroup()
