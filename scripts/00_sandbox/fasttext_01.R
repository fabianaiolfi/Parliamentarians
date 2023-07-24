
# Setup ---------------------------------------------------------------------

library(fastText)



# Preprocessing ---------------------------------------------------------------------

# business_legislative_period_51$InitialSituation_clean <- paste(business_legislative_period_51$Title,
#                                                                business_legislative_period_51$InitialSituation_clean) # add info from title!
# 

test_corpus <- business_legislative_period_51 %>%
  select(InitialSituation_clean) %>% 
  mutate(InitialSituation_clean = tolower(InitialSituation_clean))

tokens_business <- tokens(test_corpus$InitialSituation_clean)
tokens_business <- tokens(tokens_business, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
custom_stopwords <- scan(here("scripts", "sandbox", "custom_stopwords.txt"), character(), sep = "\n")
tokens_business <- tokens_remove(tokens_business, pattern = c(stopwords("de"), custom_stopwords))

tokens_business <- data.frame(text = sapply(tokens_business, paste, collapse = " "))

# Lemmatisation
library("spacyr")
spacy_initialize(model = "de_core_news_sm", condaenv = "/Users/aiolf1/opt/miniconda3/envs/spacy_condaenv")
## Found 'spacy_condaenv'. spacyr will use this environment
## successfully initialized (spaCy Version: 2.2.3, language model: en_core_web_sm)
## (python options: type = "condaenv", value = "spacy_condaenv")

library(udpipe)

# download german ud model
ud_model <- udpipe_download_model("german")
ud_model <- udpipe_load_model(ud_model)

Text2Lemmatize <- test_corpus$InitialSituation_clean[1]

x <- udpipe_annotate(ud_model, Text2Lemmatize)
x <- as.data.frame(x)
x[, c("token", "lemma", "upos")]



#write.csv(test_corpus, "test_corpus.txt", row.names = F)
write.table(tokens_business, sep=",", "test_corpus.txt",  col.names = F, row.names = F)


# 
# test_corpus <- tm_map(test_corpus, content_transformer(tolower))
# 
# 
# rm(test_corpus)
# test_corpus <- tokens(test_corpus$InitialSituation_clean, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
# 
# 
# 
# 
# tokens_business <- tokens(business_legislative_period_51$InitialSituation_clean)
# tokens_business <- tokens(tokens_business, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
# custom_stopwords <- scan(here("scripts", "sandbox", "custom_stopwords.txt"), character(), sep = "\n")
# tokens_business <- tokens_remove(tokens_business, pattern = c(stopwords("de"), custom_stopwords))



# fastText word embeddings ---------------------------------------------------------------------

list_params = list(command = 'print-sentence-vectors',
                   model = '/Users/aiolf1/Desktop/cc.de.300.bin')

res = fasttext_interface(list_params,
                         path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/test_corpus.txt',
                         path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/SENTENCE_VECs.txt')



# work with embeddings

sentence_vecs <- scan(here("SENTENCE_VECs.txt"), character(), sep = "\n")

sentence_vecs <- as.data.frame(sentence_vecs)

df <- sentence_vecs
df <- stringr::str_split_fixed(df$sentence_vecs, " ", 300)
df <- as.data.frame(df)
df2 <- mutate_all(df, function(x) as.numeric(as.character(x)))



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










