
# Cleaning (post processing) for BERTopic ------------------------------------------------------

custom_stopwords <- scan(here("data", "custom_stopwords.txt"), character(), sep = "\n")
tag_stopwords <- scan(here("data", "tag_stopwords_v230828.txt"), character(), sep = "\n")


# Clean Text ------------------------------------------------------

# Remove \n
all_businesses$chatgpt_tags_clean <- gsub('\n', ' ', all_businesses$chatgpt_tags)

# Replace numbers with |
all_businesses$chatgpt_tags_clean <- gsub('\\d+\\.', '|', all_businesses$chatgpt_tags_clean)

# Remove numbers, punctuation and stopwords
temp_df <- tokens(all_businesses$chatgpt_tags_clean, remove_punct = T, remove_numbers = F, remove_symbol = F)

# Create quanteda dictionary for multi-word stopwords (e.g. "Parlamentarische Initiative")
sw_dict <- dictionary(list(tag_sw = tag_stopwords))
temp_df <- tokens_remove(temp_df, pattern = c(stopwords("de"), phrase(sw_dict))) # custom_stopwords

temp_df <- data.frame(temp_df = sapply(temp_df, paste, collapse = " "))
all_businesses <- cbind(all_businesses, temp_df)
all_businesses$chatgpt_tags_clean <- all_businesses$temp_df
all_businesses$temp_df <- NULL
rm(temp_df)

# Deal with multiple pipes
all_businesses$chatgpt_tags_clean <- gsub('\\|\\s\\|', '||', all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub('\\|\\s\\|', '||', all_businesses$chatgpt_tags_clean) # Do It Twice
all_businesses$chatgpt_tags_clean <- gsub('\\|\\|+', '|', all_businesses$chatgpt_tags_clean)

# Remove first |
all_businesses$chatgpt_tags_clean <- gsub('^\\|\\s', '', all_businesses$chatgpt_tags_clean)
