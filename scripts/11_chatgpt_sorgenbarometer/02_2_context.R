
# Context -----------------------------------------------------------------
# For each Worry and Items of Business, add a string that contains the Worry's topic in the business description


# ## Which topic appears the most in the desciprtion? ------------------------------------------
# 
# ### 1. Which Worries does an item of business have? -----------------------
# 
# df <- all_businesses_sorgen %>% 
#   select(-Title, -TagNames, -chatgpt_summaries, -chatgpt_tags_clean)
#   
# # Function to concatenate the column names where value is TRUE
# get_true_cols <- function(row) {
#   true_cols <- names(row)[row == TRUE]
#   paste(true_cols, collapse = ", ")
# }
#   
# # Apply the function to each row and create a new column
# df$true_columns <- apply(df[-c(1,2)], 1, get_true_cols)
# 
# df <- df %>% 
#   select(BusinessShortNumber, InitialSituation_clean, true_columns) %>% 
#   dplyr::filter(true_columns != "")
# 
# 
# ### 2. Which topics are associated with those Worries? ----------------------
# 
# # Function to get corresponding words
# get_words <- function(true_cols) {
#   keywords <- unlist(strsplit(true_cols, ",\\s*"))  # Split by comma and optional space
#   words <- unlist(lapply(keywords, function(k) get(k)))  # Fetch words using get()
#   paste(words, collapse = ", ")  # Combine words into a string
# }
# 
# # Apply the function to the true_columns and create a new column
# df$associated_words <- sapply(df$true_columns, get_words)
# 
# 
# ### 3. Which three topics appear most frequent in the description? -----------------------
# 
# df <- df %>% select(-true_columns)
# 
# # Function to find the top 3 most frequent associated words
# find_most_frequent_words <- function(row) {
#   # Split associated_words by comma and remove leading/trailing whitespaces
#   words <- trimws(unlist(strsplit(row[3], ",\\s*")))
#   # Count occurrences of each word in InitialSituation_clean
#   word_counts <- sapply(words, function(word) {
#     sum(gregexpr(word, row[2], ignore.case = TRUE)[[1]] >= 0)
#   })
#   # Find indices of top 3 word counts
#   top_indices <- order(word_counts, decreasing = TRUE)[1:min(3, length(word_counts))]
#   # Extract top 3 words
#   most_frequent_words <- paste(words[top_indices], collapse = ", ")
#   return(most_frequent_words)
# }
# 
# # Apply the function to each row and create a new column
# df$top_3_frequent_words <- apply(df, 1, find_most_frequent_words)
# 
# # Split the top_3_frequent_words column into multiple columns
# split_columns <- str_split_fixed(df$top_3_frequent_words, ",\\s*", 3)
# 
# # Add the new columns to the data frame
# df <- cbind(df, as.data.frame(split_columns))
# 
# # Housekeeping
# df <- df %>%
#   select(-top_3_frequent_words, -associated_words) %>% 
#   rename(associated_word_1 = V1,
#          associated_word_2 = V2,
#          associated_word_3 = V3)
# 
# 
# ### 4. Extract string around where the worry appears -------------------------------
# 
# # Replace periods after 1 or 2-digit numbers
# df <- df %>% 
#   mutate(InitialSituation_clean_edit = gsub("\\b(\\d{1,2})\\.", "\\1", InitialSituation_clean))
# 
# # Function to extract the sentence around a word
# get_context <- function(text, word) {
#   if (is.na(text) || is.na(word)) {
#     return(NA)
#   }
#   
#   # Tokenize the text into sentences
#   sentences <- stri_split_boundaries(text, type = "sentence")[[1]]
#   
#   # Find the first sentence containing the word as a substring
#   matching_sentence <- grep(paste0(word), sentences, ignore.case = TRUE, value = TRUE)
#   
#   if (length(matching_sentence) == 0) {
#     return(NA)
#   }
#   
#   return(matching_sentence[1])
# }
# 
# # Apply the function for each associated word
# for (i in 1:3) {
#   word_col <- paste0("associated_word_", i)
#   context_col <- paste0("context_", i)
#   df[, context_col] <- mapply(get_context, df$InitialSituation_clean_edit, df[, word_col])
# }
# 
# # Housekeeping and remove duplicate context sentences
# df <- df %>% 
#   select(-c(InitialSituation_clean, InitialSituation_clean_edit)) %>% 
#   mutate(
#     context_2 = ifelse(context_2 == context_1, NA, context_2),
#     context_3 = ifelse(context_3 == context_1 | context_3 == context_2, NA, context_3)
#   )
# 
# 
# ### 5. Merge with all_businesses_web -------------------------------
# 
# all_businesses_web <- all_businesses_web %>% 
#   left_join(df, by = "BusinessShortNumber")



# New Approach -------------------------------------
# Dynamically extract sentence from entire description based on topic in dropdown
# Problem with counting most frequent occurence was that some items of business appeared without an apparent link to topic

# 1. Split description by sentences over columns

df <- all_businesses_eval %>% 
  select(BusinessShortNumber, InitialSituation_clean)

# Replace periods after 1 or 2-digit numbers
df <- df %>%
  mutate(InitialSituation_clean = gsub("\\b(\\d{1,2})\\.", "\\1", InitialSituation_clean))

# Tokenize sentences and make a new row for each
df_sentences <- df %>%
  drop_na(InitialSituation_clean) %>% 
  mutate(sentences = map(InitialSituation_clean, ~stri_split_boundaries(.x, type = "sentence"))) %>%
  unnest(sentences) %>%
  group_by(BusinessShortNumber) %>%
  mutate(sentence_id = row_number()) %>%
  ungroup()

# Spread the sentences into separate columns
df <- df_sentences %>%
  pivot_wider(names_from = sentence_id,
              values_from = sentences,
              names_prefix = "sentence_") %>% 
  select(-InitialSituation_clean) %>% 
  rename(sents = sentence_1)

head(df$sents)


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























