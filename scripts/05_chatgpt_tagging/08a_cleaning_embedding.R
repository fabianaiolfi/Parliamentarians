
# Cleaning (post processing) for embedding

# load(here("data", "all_businesses_and_tags_230703.RData"))
# ud_model <- udpipe_load_model(here("models", "german-gsd-ud-2.5-191206.udpipe"))
custom_stopwords <- scan(here("data", "custom_stopwords.txt"), character(), sep = "\n")
tag_stopwords <- scan(here("data", "tag_stopwords.txt"), character(), sep = "\n")


# Clean Text ------------------------------------------------------

# Remove \n
all_businesses$chatgpt_tags_clean <- gsub('\n', ' ', all_businesses$chatgpt_tags)

# Lemmatise
# https://cran.r-project.org/web/packages/udpipe/vignettes/udpipe-annotation.html
# lemma_df <- all_businesses %>% select(BusinessShortNumber, chatgpt_tags_clean)
# 
# temp_vector <- lemma_df$chatgpt_tags_clean
# temp_vector <- udpipe_annotate(ud_model, temp_vector)
# temp_df <- as.data.frame(temp_vector)
# temp_df <- temp_df %>% select(doc_id, lemma)# %>% drop_na()
# 
# temp_df <- temp_df %>% group_by(doc_id) %>% summarize(temp_df = paste(lemma, collapse = " "))
# 
# temp_df$doc_id <- gsub('doc', '', temp_df$doc_id)
# temp_df$doc_id <- as.numeric(temp_df$doc_id)
# temp_df <- temp_df %>% arrange(doc_id)
# 
# lemma_df$chatgpt_tags_clean <- temp_df$temp_df
# 
# # Merge with main DF
# all_businesses$chatgpt_tags_clean <- NULL
# all_businesses <- all_businesses %>% left_join(lemma_df, by = "BusinessShortNumber")
# rm(temp_df)

# Remove numbers, punctuation and stopwords
temp_df <- tokens(all_businesses$chatgpt_tags_clean, remove_punct = F, remove_numbers = F, remove_symbol = F)

# Create quanteda dictionary for multi-word stopwords (e.g. "Parlamentarische Initiative")
sw_dict <- dictionary(list(tag_sw = tag_stopwords))
temp_df <- tokens_remove(temp_df, pattern = c(stopwords("de"), phrase(sw_dict))) # custom_stopwords

temp_df <- data.frame(temp_df = sapply(temp_df, paste, collapse = " "))
all_businesses <- cbind(all_businesses, temp_df)
all_businesses$chatgpt_tags_clean <- all_businesses$temp_df
all_businesses$temp_df <- NULL
rm(temp_df)

# Lowercasing
# all_businesses$chatgpt_tags_clean <- tolower(all_businesses$chatgpt_tags_clean)

# Deal with rows with empty strings
# Some rows don't have any tags. Replace empty strings with the string NA. May have to deal with this later
all_businesses$chatgpt_tags_clean <- gsub('^$', 'NA', all_businesses$chatgpt_tags_clean)

#save(all_businesses, file = here("data", "all_businesses_and_clean_tags_230703.RData"))

# # Short Evaluation ----------------------------------------------------
# # Adjust stopword choice based on this
# 
# # # Combine all the text into a single character vector
# all_tags <- paste(all_businesses$chatgpt_tags_clean, collapse = " ")
# 
# # Split the combined text into individual words
# all_tags <- gsub('\n', ' ', all_tags) # remove \n
# words <- unlist(strsplit(all_tags, "\\d+\\s\\.\\s"))
# words <- gsub('\\s$', '', words) # remove trailing whitespace
# 
# # Count the occurrences of each word
# word_counts <- table(words)
# word_counts <- as.data.frame(word_counts)
# word_counts %>% arrange(-Freq) %>% select(words) %>% head(n = 100) %>% print(row.names = FALSE)


# Prepare for Fasttext ----------------------------------------------------

# Remove all newline characters
all_businesses <- all_businesses %>% mutate_at(vars(chatgpt_tags_clean), ~ gsub("\n", " ", .))

# Add </s> at end of strings
# all_businesses <- all_businesses %>% mutate_at(vars(chatgpt_tags_clean), ~ paste0(., "</s>"))

# all_businesses$chatgpt_tags_clean[1]
