
# Setup ---------------------------------------------------------------------

library(fastText)
library(udpipe)
library(ggplot2)
library(factoextra)


# Preprocessing ---------------------------------------------------------------------

business_legislative_period_51$InitialSituation_clean <- paste(business_legislative_period_51$Title,
                                                               business_legislative_period_51$InitialSituation_clean) # add info from title!


ft_corpus <- business_legislative_period_51 %>%
  select(InitialSituation_clean)


# Lemmatisation

# download german ud model
#ud_model <- udpipe_download_model("german")
#ud_model <- udpipe_load_model(ud_model)
ud_model <- udpipe_load_model("german-gsd-ud-2.5-191206.udpipe")

#Text2Lemmatize <- test_corpus$InitialSituation_clean[1]

ft_corpus_lemma <- udpipe_annotate(ud_model, ft_corpus$InitialSituation_clean)
ft_corpus_lemma <- as.data.frame(ft_corpus_lemma)

ft_corpus_lemma <- ft_corpus_lemma %>% 
  select(doc_id, lemma) %>% 
  drop_na()

ft_corpus_lemma <- ft_corpus_lemma %>% 
  group_by(doc_id) %>%
  summarize(text = paste(lemma, collapse = " "))

ft_corpus_lemma$doc_id <- gsub('doc', '', ft_corpus_lemma$doc_id)
ft_corpus_lemma$doc_id <- as.numeric(ft_corpus_lemma$doc_id)
ft_corpus_lemma <- ft_corpus_lemma %>% 
  arrange(doc_id)

ft_corpus_lemma$text <- tolower(ft_corpus_lemma$text)

tokens_business <- tokens(ft_corpus_lemma$text)
tokens_business <- tokens(tokens_business, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
custom_stopwords <- scan(here("scripts", "sandbox", "custom_stopwords.txt"), character(), sep = "\n")
tokens_business <- tokens_remove(tokens_business, pattern = c(stopwords("de"), custom_stopwords))

tokens_business <- data.frame(text = sapply(tokens_business, paste, collapse = " "))

write.table(tokens_business, sep=",", "ft_corpus.txt",  col.names = F, row.names = F) # ft_corpus


# fastText word embeddings ---------------------------------------------------------------------

list_params = list(command = 'print-sentence-vectors',
                   model = '/Users/aiolf1/Desktop/cc.de.300.bin')

res = fasttext_interface(list_params,
                         path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/ft_corpus.txt',
                         path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/SENTENCE_VECs.txt')



# work with embeddings

sentence_vecs <- scan(here("SENTENCE_VECs.txt"), character(), sep = "\n")
sentence_vecs <- as.data.frame(sentence_vecs)

sentence_vecs <- stringr::str_split_fixed(sentence_vecs$sentence_vecs, " ", 300)
sentence_vecs <- as.data.frame(sentence_vecs)
sentence_vecs <- mutate_all(sentence_vecs, function(x) as.numeric(as.character(x)))


# Visualise embeddings ---------------------------------------------------------------------

# Step 1: Standardize the data
standardized_data <- scale(df2)

# Step 2: Perform PCA
pca_result <- prcomp(standardized_data, scale. = TRUE)#, rank. = 2)

# Step 3: Extract the principal components
principal_components <- pca_result$x

# Step 4: Select the desired number of components (2 in this case)
reduced_data <- principal_components[, 1:2]

reduced_data_df <- as.data.frame(reduced_data)
#reduced_data_df <- reduced_data_df[-1, ]

ggplot(reduced_data_df, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.8, size = 2) +
  #geom_jitter(width = 0.05, height = 0.05, alpha = 0.75, size = 2) +
  theme_minimal()








# Perform k-means clustering ---------------------------------------------------------------------

k <- 30  # Number of clusters
result <- kmeans(sentence_vecs, centers = k)

# Get the cluster assignments
cluster_assignments <- result$cluster

# Add cluster assignments back to the dataframe
sentence_vecs$cluster <- cluster_assignments

sentence_vecs <- sentence_vecs %>%
  mutate(doc_id = 1:nrow(sentence_vecs)) %>% 
  select(doc_id, cluster)

topic_check <- business_legislative_period_51 %>%
  select(TagNames, Title) %>% 
  mutate(doc_id = 1:nrow(sentence_vecs)) %>% 
  left_join(sentence_vecs, by = "doc_id")

table(topic_check$cluster)
hist(topic_check$cluster, breaks = k)



# chatgpt on elbow method ------------------------------------------------------------------


# Perform k-means clustering for different values of k and calculate WCSS
wcss <- c()
for (k in 1:20) {
  kmeans_model <- kmeans(sentence_vecs, centers = k)#, nstart = 25)
  wcss[k] <- kmeans_model$tot.withinss
}

# Create a line plot of WCSS against the number of clusters
plot_data <- data.frame(k = 1:20, WCSS = wcss)
ggplot(data = plot_data, aes(x = k, y = WCSS)) +
  geom_line() +
  geom_point() +
  labs(x = "Number of Clusters (k)", y = "Within-Cluster Sum of Squares (WCSS)")

# Use the fviz_nbclust() function from the factoextra package to visualize the elbow point
#elbow_plot <- fviz_nbclust(sentence_vecs, kmeans, method = "wss", k.max = 20)

# Print the elbow plot
#print(elbow_plot)



load("data/chatgpt_output_20230419_204609.RData")
chatgpt_summaries <- chatgpt_output[[1]][["chatgpt_content"]]
chatgpt_summaries <- chatgpt_summaries[1:147]
chatgpt_summaries <- as.data.frame(chatgpt_summaries)
chatgpt_summaries$doc_id <- 1:nrow(chatgpt_summaries)

topic_check <- topic_check %>% 
  left_join(chatgpt_summaries, by = "doc_id")




# fasttext classification of chatgpt summaries ------------------------------------------------------------------

ft_gptsummaries_lemma <- udpipe_annotate(ud_model, chatgpt_summaries$chatgpt_summaries)
ft_gptsummaries_lemma <- as.data.frame(ft_gptsummaries_lemma)

ft_gptsummaries_lemma <- ft_gptsummaries_lemma %>% 
  select(doc_id, lemma) %>% 
  drop_na()

ft_gptsummaries_lemma <- ft_gptsummaries_lemma %>% 
  group_by(doc_id) %>%
  summarize(text = paste(lemma, collapse = " "))

ft_gptsummaries_lemma$doc_id <- gsub('doc', '', ft_gptsummaries_lemma$doc_id)
ft_gptsummaries_lemma$doc_id <- as.numeric(ft_gptsummaries_lemma$doc_id)
ft_gptsummaries_lemma <- ft_gptsummaries_lemma %>% 
  arrange(doc_id)

ft_gptsummaries_lemma$text <- tolower(ft_gptsummaries_lemma$text)

tokens_gptsummaries <- tokens(ft_gptsummaries_lemma$text)
tokens_gptsummaries <- tokens(tokens_gptsummaries, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
custom_stopwords <- scan(here("scripts", "sandbox", "custom_stopwords.txt"), character(), sep = "\n")
tokens_gptsummaries <- tokens_remove(tokens_gptsummaries, pattern = c(stopwords("de"), custom_stopwords))

tokens_gptsummaries <- data.frame(text = sapply(tokens_gptsummaries, paste, collapse = " "))

write.table(tokens_gptsummaries, sep=",", "tokens_gptsummaries.txt",  col.names = F, row.names = F)


# fastText word embeddings ---------------------------------------------------------------------

list_params = list(command = 'print-sentence-vectors',
                   model = '/Users/aiolf1/Desktop/cc.de.300.bin')

res = fasttext_interface(list_params,
                         path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/tokens_gptsummaries.txt',
                         path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/summaries_vecs.txt')



# work with embeddings
summaries_vecs <- scan(here("summaries_vecs.txt"), character(), sep = "\n")
summaries_vecs <- as.data.frame(summaries_vecs)

summaries_vecs <- stringr::str_split_fixed(summaries_vecs$summaries_vecs, " ", 300)
summaries_vecs <- as.data.frame(summaries_vecs)
summaries_vecs <- mutate_all(summaries_vecs, function(x) as.numeric(as.character(x)))


# elbow
wcss <- c()
for (k in 1:140) {
  kmeans_model <- kmeans(summaries_vecs, centers = k)#, nstart = 25)
  wcss[k] <- kmeans_model$tot.withinss
}

# Create a line plot of WCSS against the number of clusters
plot_data <- data.frame(k = 1:140, WCSS = wcss)
ggplot(data = plot_data, aes(x = k, y = WCSS)) +
  geom_line() +
  geom_point() +
  labs(x = "Number of Clusters (k)", y = "Within-Cluster Sum of Squares (WCSS)")


k <- 30  # Number of clusters
result <- kmeans(summaries_vecs, centers = k)

# Get the cluster assignments
cluster_assignments <- result$cluster

# Add cluster assignments back to the dataframe
summaries_vecs$cluster <- cluster_assignments

summaries_vecs <- summaries_vecs %>%
  mutate(doc_id = 1:nrow(summaries_vecs)) %>% 
  select(doc_id, cluster)

topic_check <- business_legislative_period_51 %>%
  select(TagNames, Title) %>% 
  mutate(doc_id = 1:nrow(summaries_vecs)) %>% 
  left_join(summaries_vecs, by = "doc_id") %>% 
  left_join(chatgpt_summaries, by = "doc_id")


hist(topic_check$cluster, breaks = k)



# Specify model type and computational engine -----------------------------

kmeans_model <- k_means() %>%
  set_engine("stats") %>% # use the {stats} package as the engine
  set_mode("partition") %>% # {tidyclust} offers the partition mode
  set_args(num_clusters = 30) # specify the number of clusters



# Step 1: Standardize the data
standardized_data <- scale(summaries_vecs)

# Step 2: Perform PCA
pca_result <- prcomp(standardized_data, scale. = TRUE)#, rank. = 2)

# Step 3: Extract the principal components
principal_components <- pca_result$x

# Step 4: Select the desired number of components (2 in this case)
reduced_data <- principal_components[, 1:2]

reduced_data_df <- as.data.frame(reduced_data)
#reduced_data_df$tags <- business_legislative_period_51$TagNames
reduced_data_df$tags <- NULL

kmeans_fit <- kmeans_model %>%
  fit(~., data = reduced_data_df) # Passes all the features for fitting


# Predict -----------------------------------------------------------------

kmeans_pred <- predict(kmeans_fit, new_data = reduced_data_df)
predictions <- reduced_data_df %>%
  bind_cols(., kmeans_pred) # attach cluster assignments

predictions %>%
  ggplot(mapping = aes(x = PC1, y = PC2, colour = .pred_cluster)) +
  geom_point()















