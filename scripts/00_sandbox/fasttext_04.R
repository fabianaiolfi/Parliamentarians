
# Setup ---------------------------------------------------------------------

library(fastText)
library(udpipe)
library(ggplot2)
library(factoextra)
ud_model <- udpipe_load_model(here("models", "german-gsd-ud-2.5-191206.udpipe"))
custom_stopwords <- scan(here("scripts", "sandbox", "custom_stopwords.txt"), character(), sep = "\n")

list_params = list(command = 'print-sentence-vectors',
                   model = '/Users/aiolf1/Documents/GitHub/Parliamentarians/models/cc.de.300.bin')

# New approach: 
# Generate vector representation for Tags, Title, Text and ChatGPT summary
# Add vectors together

# Setup DF

load("data/chatgpt_output_20230419_204609.RData")
chatgpt_summaries <- chatgpt_output[[1]][["chatgpt_content"]]
chatgpt_summaries <- chatgpt_summaries[1:147]
chatgpt_summaries <- as.data.frame(chatgpt_summaries)
chatgpt_summaries$doc_id <- 1:nrow(chatgpt_summaries)

df <- business_legislative_period_51 %>% 
  select(BusinessShortNumber, Title, TagNames, InitialSituation_clean) %>% 
  mutate(doc_id = 1:nrow(business_legislative_period_51)) %>% 
  left_join(chatgpt_summaries, by = "doc_id")

# Vectors of Titles
titles <- df %>% select(Title)

titles <- udpipe_annotate(ud_model, titles$Title)
titles <- as.data.frame(titles)

titles <- titles %>% 
  select(doc_id, lemma) %>% 
  drop_na()

titles <- titles %>% 
  group_by(doc_id) %>%
  summarize(text = paste(lemma, collapse = " "))

titles$doc_id <- gsub('doc', '', titles$doc_id)
titles$doc_id <- as.numeric(titles$doc_id)
titles <- titles %>% 
  arrange(doc_id)

titles$text <- tolower(titles$text)

titles <- tokens(titles$text)
titles <- tokens(titles, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
titles <- tokens_remove(titles, pattern = c(stopwords("de"), custom_stopwords))

titles <- data.frame(text = sapply(titles, paste, collapse = " "))

write.table(titles, sep=",", "titles.txt",  col.names = F, row.names = F)

res_titles = fasttext_interface(list_params,
                         path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/titles.txt',
                         path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/title_vecs.txt')




# Vectors of Tags
tags <- df %>% select(TagNames)

tags$TagNames <- tolower(tags$TagNames)

tags <- tokens(tags$TagNames)
tags <- tokens(tags, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)

tags <- data.frame(TagNames = sapply(tags, paste, collapse = " "))

write.table(tags, sep=",", "tags.txt",  col.names = F, row.names = F)

res_tags = fasttext_interface(list_params,
                                path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/tags.txt',
                                path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/tags_vecs.txt')


# Vectors of Text
text <- df %>% select(InitialSituation_clean)

text <- udpipe_annotate(ud_model, text$InitialSituation_clean)
text <- as.data.frame(text)

text <- text %>% 
  select(doc_id, lemma) %>% 
  drop_na()

text <- text %>% 
  group_by(doc_id) %>%
  summarize(text = paste(lemma, collapse = " "))

text$doc_id <- gsub('doc', '', text$doc_id)
text$doc_id <- as.numeric(text$doc_id)
text <- text %>% 
  arrange(doc_id)

text$text <- tolower(text$text)

text <- tokens(text$text)
text <- tokens(text, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
text <- tokens_remove(text, pattern = c(stopwords("de"), custom_stopwords))

text <- data.frame(text = sapply(text, paste, collapse = " "))

write.table(text, sep=",", "text.txt",  col.names = F, row.names = F)

res_texts = fasttext_interface(list_params,
                              path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/text.txt',
                              path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/text_vecs.txt')

# Vectors of Summaries
summaries <- df %>% select(chatgpt_summaries)

summaries <- udpipe_annotate(ud_model, summaries$chatgpt_summaries)
summaries <- as.data.frame(summaries)

summaries <- summaries %>% 
  select(doc_id, lemma) %>% 
  drop_na()

summaries <- summaries %>% 
  group_by(doc_id) %>%
  summarize(summaries = paste(lemma, collapse = " "))

summaries$doc_id <- gsub('doc', '', summaries$doc_id)
summaries$doc_id <- as.numeric(summaries$doc_id)
summaries <- summaries %>% 
  arrange(doc_id)

summaries$summaries <- tolower(summaries$summaries)

summaries <- tokens(summaries$summaries)
summaries <- tokens(summaries, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
summaries <- tokens_remove(summaries, pattern = c(stopwords("de"), custom_stopwords))

summaries <- data.frame(summaries = sapply(summaries, paste, collapse = " "))

write.table(summaries, sep=",", "summaries.txt",  col.names = F, row.names = F)

res_summaries = fasttext_interface(list_params,
                               path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/summaries.txt',
                               path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/summaries_vecs.txt')


# Import Vectors and add them together
summaries_vecs <- scan(here("summaries_vecs.txt"), character(), sep = "\n")
summaries_vecs <- as.data.frame(summaries_vecs)
summaries_vecs <- stringr::str_split_fixed(summaries_vecs$summaries_vecs, " ", 300)
summaries_vecs <- as.data.frame(summaries_vecs)
summaries_vecs <- mutate_all(summaries_vecs, function(x) as.numeric(as.character(x)))

tags_vecs <- scan(here("tags_vecs.txt"), character(), sep = "\n")
tags_vecs <- as.data.frame(tags_vecs)
tags_vecs <- stringr::str_split_fixed(tags_vecs$tags_vecs, " ", 300)
tags_vecs <- as.data.frame(tags_vecs)
tags_vecs <- mutate_all(tags_vecs, function(x) as.numeric(as.character(x)))

text_vecs <- scan(here("text_vecs.txt"), character(), sep = "\n")
text_vecs <- as.data.frame(text_vecs)
text_vecs <- stringr::str_split_fixed(text_vecs$text_vecs, " ", 300)
text_vecs <- as.data.frame(text_vecs)
text_vecs <- mutate_all(text_vecs, function(x) as.numeric(as.character(x)))

title_vecs <- scan(here("title_vecs.txt"), character(), sep = "\n")
title_vecs <- as.data.frame(title_vecs)
title_vecs <- stringr::str_split_fixed(title_vecs$title_vecs, " ", 300)
title_vecs <- as.data.frame(title_vecs)
title_vecs <- mutate_all(title_vecs, function(x) as.numeric(as.character(x)))

combined_df <- summaries_vecs + tags_vecs + text_vecs + title_vecs


# Perform k-means clustering ---------------------------------------------------------------------

k <- 15  # Number of clusters
result <- kmeans(combined_df, centers = k)

# Get the cluster assignments
cluster_assignments <- result$cluster

# Add cluster assignments back to the dataframe
combined_df$cluster <- cluster_assignments

combined_df <- combined_df %>%
  mutate(doc_id = 1:nrow(combined_df)) %>% 
  select(doc_id, cluster)

topic_check <- business_legislative_period_51 %>%
  select(TagNames, Title) %>% 
  mutate(doc_id = 1:nrow(combined_df)) %>% 
  left_join(combined_df, by = "doc_id")

topic_check <- topic_check %>% 
  left_join(chatgpt_summaries, by = "doc_id")




