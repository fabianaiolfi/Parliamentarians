
library(here)
library(tm)
library(topicmodels)
library(tidytext)
library(tidyverse)
library(seededlda)
library("stringr")
library(recipes)

business_legislative_period_51$InitialSituation_clean <- paste(business_legislative_period_51$Title,
                                                               business_legislative_period_51$InitialSituation_clean) # add info from title!

corpus <- Corpus(VectorSource(business_legislative_period_51$InitialSituation_clean))

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("german"))

custom_stopwords <- scan(here("scripts", "sandbox", "custom_stopwords.txt"), character(), sep = "\n")
corpus <- tm_map(corpus, removeWords, custom_stopwords)

dtm <- DocumentTermMatrix(corpus)
#doc_names <- colnames(as.matrix(dtm)) # chatgpt preserve document id?


#dtm_matrix <- as.matrix(dtm)         # Convert DTM to a matrix
#dtm_dataframe <- as.data.frame(dtm)  # Convert DTM to a dataframe

# https://www.tidytextmining.com/topicmodeling.html
# set a seed so that the output of the model is predictable
business_lda <- LDA(dtm, k = 27, control = list(seed = 1234))


business_topics <- tidy(business_lda, matrix = "beta")
#business_topics

business_top_terms <- business_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

business_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()


business_documents <- tidy(business_lda, matrix = "gamma")
business_documents$ID <- business_legislative_period_51$ID

business_documents <- business_documents %>% 
  group_by(document) %>% 
  top_n(1, gamma)

hist(business_documents$topic, breaks = 27)



############## quanteda

# comparing LDA topics with Tags in data
# https://tutorials.quanteda.io/machine-learning/topicmodel/

tokens_business <- tokens(business_legislative_period_51$InitialSituation_clean)
tokens_business <- tokens(tokens_business, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
tokens_business <- tokens_remove(tokens_business, pattern = c(stopwords("de"), custom_stopwords))

dfmat_business <- dfm(tokens_business) %>% 
  dfm_trim(min_termfreq = 0.9, termfreq_type = "quantile",
           max_docfreq = 0.1, docfreq_type = "prop")

tmod_lda <- textmodel_lda(dfmat_business, k = 10) # k=27; 105; 9
#terms(tmod_lda, 10)

lda_topics <- topics(tmod_lda)

business_legislative_period_51$topic <- lda_topics

topic_check <- business_legislative_period_51 %>% select(TagNames, topic)

topic_check_reduced <- topic_check %>% 
  group_by(TagNames, topic) %>% 
  distinct(TagNames, topic)

# 105 unique TagNames
# k = 27: 147 -> 128
# k = 15: 147 -> 126
# k = 10: 147 -> 124
# k = 5: 147 -> 119


################## using the tags

business_legislative_period_51$tag_count <- str_count(business_legislative_period_51$TagNames, "\\|") + 1

# No obvious relationship between number of tags and topics
#hist(business_legislative_period_51$tag_count, breaks = 6)
# ggplot(business_legislative_period_51, aes(tag_count, topic)) +
#   geom_jitter() +
#   theme_minimal()

# how many different tags?
business_tags <- business_legislative_period_51$TagNames
business_tags <- unlist(strsplit(business_tags, "|", fixed = TRUE))
business_tags <- unique(business_tags) # 27 unique tags


# take order of tags into account

# Example weight vector
weight_vector <- c(5, 4, 3, 2, 1)
#weight_vector <- c(16, 8, 4, 2, 1)
#weight_vector <- c(5, 3, 2, 1, 1)
#weight_vector <- c(1, 1, 1, 1, 1)

# Create a data frame to represent the document tags
document_tags <- data.frame(matrix(0, nrow = 147, ncol = 27))

# Assign column names to the data frame
colnames(document_tags) <- business_tags #paste0("tag", 1:27)

# Iterate through each document
for (i in 1:nrow(document_tags)) {
  # Parse the tags for the current document
  tags <- strsplit(business_legislative_period_51$TagNames[i], "\\|")[[1]]
  
  # Iterate through each tag
  for (tag in tags) {
    # Get the index of the tag
    tag_index <- match(tag, colnames(document_tags))
    
    # Update the matrix with the tag weight
    document_tags[i, tag_index] <- weight_vector[which(tags == tag)]
  }
}


# 
# df <- business_legislative_period_51 %>% 
#   select(BusinessShortNumber, TagNames, topic)
# 
# df_new <- df %>%
#   separate_rows(TagNames, sep = "\\|") %>%
#   mutate(Value = 1) %>%
#   pivot_wider(names_from = TagNames, values_from = Value, values_fill = 0)
# 
# test <- document_tags %>%
#   step_pca()#, threshold = 0.8)
# 
# 
# test <- df_new %>% 
#   select(-c(BusinessShortNumber, topic))


# Step 1: Standardize the data
standardized_data <- scale(document_tags)

# Step 2: Perform PCA
pca_result <- prcomp(standardized_data, scale. = TRUE)#, rank. = 2)

# Step 3: Extract the principal components
principal_components <- pca_result$x

# Step 4: Select the desired number of components (2 in this case)
reduced_data <- principal_components[, 1:2]

# Print the reduced data
#print(reduced_data)
#plot(reduced_data)

reduced_data_df <- as.data.frame(reduced_data)
reduced_data_df$topic <- business_legislative_period_51$topic

ggplot(reduced_data_df, aes(x = PC1, y = PC2, color = topic)) +
  #geom_point(alpha = 0.5, size = 4) +
  geom_jitter(width = 0.05, height = 0.05, alpha = 0.75, size = 2) +
  theme_minimal()

ggplot(reduced_data_df, aes(x = PC1, y = topic)) +
  geom_jitter(width = 0.2, height = 0.2, alpha = 0.75) +
  theme_minimal()

table(business_legislative_period_51$topic)

