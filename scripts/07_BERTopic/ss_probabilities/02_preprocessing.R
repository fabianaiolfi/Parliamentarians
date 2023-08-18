
# Merge Business Data ---------------------------------------------------------------

all_businesses_and_tags_230703 <- all_businesses_and_tags_230703 %>% select(BusinessShortNumber,
                                                                            Title,
                                                                            InitialSituation_clean,
                                                                            ResponsibleDepartmentName,
                                                                            TagNames)

all_businesses_and_tags_230703 <- all_businesses_and_tags_230703 %>%
  mutate(main_tag = TagNames) %>% # Save main tag
  mutate(main_tag = gsub("\\|.*", "", main_tag)) %>%
  separate_rows(main_tag, sep = "\\|") %>% # Transform column to have one tag per row
  mutate(TagNames = gsub("\\|", " ", TagNames))

all_businesses_and_clean_tags_230703 <- all_businesses_and_clean_tags_230703 %>% select(BusinessShortNumber, chatgpt_tags_clean)

all_businesses_and_summaries <- all_businesses_and_summaries %>% select(BusinessShortNumber, chatgpt_summaries)

all_businesses <- all_businesses_and_tags_230703 %>% 
  left_join(all_businesses_and_clean_tags_230703, by = "BusinessShortNumber") %>% 
  left_join(all_businesses_and_summaries, by = "BusinessShortNumber")


# Clean Business Data ---------------------------------------------------------------

all_businesses$chatgpt_tags_clean <- gsub("\\b\\d\\b", "", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("\\.\\s", "", all_businesses$chatgpt_tags_clean)

# Remove any rows containing NAs in relevant columns
all_businesses <- all_businesses %>% drop_na(InitialSituation_clean,
                                             main_tag,
                                             chatgpt_tags_clean,
                                             chatgpt_summaries)

all_businesses <- all_businesses %>% dplyr::filter(chatgpt_tags_clean != "NA")

# Add index
all_businesses <- tibble::rowid_to_column(all_businesses, "index")

rm(all_businesses_and_clean_tags_230703, all_businesses_and_summaries, all_businesses_and_tags_230703)


# Prepare Topic Probability Data ---------------------------------------------------------------

# Add index
topic_probs <- tibble::rowid_to_column(topic_probs, "index")

# Calculate difference between 5 highest probabilities
topic_probs$diff_max_5 <- apply(topic_probs[, paste0("V", 1:140)], 1, function(row) {
  sorted_values <- sort(row, decreasing = TRUE)
  return(sorted_values[1] - sorted_values[5])
})

# Get highest probability
topic_probs$max_prob <- do.call(pmax, topic_probs[, paste0("V", 1:140)])

# Get column with highest probability
topic_probs$max_col <- apply(topic_probs[, paste0("V", 1:140)], 1, function(x) {
  names(x)[which.max(x)]
})

# Get columns with top 5 probabilities
topic_probs$top_5_topics <- apply(topic_probs[, paste0("V", 1:140)], 1, function(row) {
  sorted_indices <- order(row, decreasing = TRUE)[1:5]
  return(paste(names(row)[sorted_indices], collapse = ","))
})

topic_probs <- topic_probs %>% select(index, max_col, max_prob, top_5_topics, diff_max_5)

#topic_probs_max_5 <- topic_probs %>% dplyr::filter(diff_max_5 <= summary(topic_probs$diff_max_5)[2]) # Only values in 1st quartile
