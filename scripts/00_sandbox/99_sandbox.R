library(ggplot2)
library(factoextra)
library(factoextra)
library(cluster)


ud_model <- udpipe_load_model(here("models", "german-gsd-ud-2.5-191206.udpipe"))
custom_stopwords <- scan(here("scripts", "sandbox", "custom_stopwords.txt"), character(), sep = "\n")


# Sandbox -----------------------------------------------------------------

df <- business_legislative_period_51 %>% 
  select(BusinessShortNumber, TagNames, Title, InitialSituation)

# Transform dataframe to have one tag per row
df_new <- df %>%
  separate_rows(TagNames, sep = "\\|") %>% 
  group_by(TagNames) %>%
  mutate(count_name_occurr = n()) %>% 
  ungroup()



soziale_fragen <- df_new %>% 
  dplyr::filter(TagNames == "Soziale Fragen") %>%
  select(BusinessShortNumber, TagNames) %>%
  rename(main_tag = TagNames) %>% 
  left_join(business_legislative_period_51, by = "BusinessShortNumber") %>% 
  select(-c(ID, Language, BusinessType, BusinessTypeAbbreviation, DraftText, DocumentationText, MotionText, FederalCouncilResponseText, FederalCouncilProposal, FederalCouncilProposalDate, FederalCouncilProposalText, BusinessStatus, BusinessStatusText, BusinessStatusDate, ResponsibleDepartment, ResponsibleDepartmentAbbreviation, IsLeadingDepartment, Tags, Category, Modified, SubmissionDate, SubmissionCouncil, SubmissionCouncilAbbreviation, SubmissionSession, SubmissionLegislativePeriod, FirstCouncil1, FirstCouncil1Abbreviation, FirstCouncil2, FirstCouncil2Name, FirstCouncil2Abbreviation))


# Remove all HTML tags
soziale_fragen$InitialSituation <- strip_html(soziale_fragen$InitialSituation)
soziale_fragen$Proceedings <- strip_html(soziale_fragen$Proceedings)
soziale_fragen$SubmittedText <- strip_html(soziale_fragen$SubmittedText)
soziale_fragen$ReasonText <- strip_html(soziale_fragen$ReasonText)

# Remove double whitespaces (Source: ChatGPT)
soziale_fragen$InitialSituation <- gsub(" {2,}", " ", soziale_fragen$InitialSituation)
soziale_fragen$Proceedings <- gsub(" {2,}", " ", soziale_fragen$Proceedings)
soziale_fragen$SubmittedText <- gsub(" {2,}", " ", soziale_fragen$SubmittedText)
soziale_fragen$ReasonText <- gsub(" {2,}", " ", soziale_fragen$ReasonText)


load("data/chatgpt_output_20230419_204609.RData")
chatgpt_summaries <- chatgpt_output[[1]][["chatgpt_content"]]
chatgpt_summaries <- chatgpt_summaries[1:147]
chatgpt_summaries <- as.data.frame(chatgpt_summaries)

temp <- business_legislative_period_51 %>% 
  select(BusinessShortNumber)

chatgpt_summaries <- cbind(chatgpt_summaries, temp)
  
soziale_fragen <- soziale_fragen %>% 
  left_join(chatgpt_summaries, by = "BusinessShortNumber")

# Prepare longer texts

# InitialSituation
# Proceedings
# SubmittedText
# ReasonText

text <- soziale_fragen %>% select(chatgpt_summaries)
text <- udpipe_annotate(ud_model, text$chatgpt_summaries)
text <- as.data.frame(text)
text <- text %>% select(doc_id, lemma) %>% drop_na()

text <- text %>% group_by(doc_id) %>% summarize(text = paste(lemma, collapse = " "))

text$doc_id <- gsub('doc', '', text$doc_id)
text$doc_id <- as.numeric(text$doc_id)
text <- text %>% arrange(doc_id)

text$text <- tolower(text$text)

text <- tokens(text$text)
text <- tokens(text, remove_punct = TRUE, remove_numbers = TRUE, remove_symbol = TRUE)
text <- tokens_remove(text, pattern = c(stopwords("de"), custom_stopwords))

text <- data.frame(text = sapply(text, paste, collapse = " "))
text <- text %>% mutate(text = replace(text, text == "na", NA))
soziale_fragen$chatgpt_summaries <- text$text

soziale_fragen_edit <- soziale_fragen %>% mutate_at(vars(-BusinessShortNumber), ~ paste0(., "</s>")) # add </s> at end of strings
soziale_fragen_edit$TagNames <- gsub("\\|", " ", soziale_fragen_edit$TagNames)

write.table(soziale_fragen_edit$chatgpt_summaries, sep=",", "soziale_fragen/chatgpt_summaries.txt", col.names = F, row.names = F, quote = F)


# Vectorise Description
# soziale_fragen_description <- soziale_fragen %>% select(Description)
# write.table(soziale_fragen_description, sep=",", "soziale_fragen_description.txt", col.names = F, row.names = F)

list_params <- list(command = 'print-sentence-vectors',
                   model = '/Users/aiolf1/Documents/GitHub/Parliamentarians/models/cc.de.300.bin')

res <- fasttext_interface(list_params,
                         path_input = '/Users/aiolf1/Documents/GitHub/Parliamentarians/soziale_fragen/chatgpt_summaries.txt',
                         path_output = '/Users/aiolf1/Documents/GitHub/Parliamentarians/soziale_fragen/vecs/chatgpt_summaries.txt')


sf_chatgpt_summaries_vecs <- scan(here("soziale_fragen", "vecs", "chatgpt_summaries.txt"), character(), sep = "\n")
sf_chatgpt_summaries_vecs <- as.data.frame(sf_chatgpt_summaries_vecs)
sf_chatgpt_summaries_vecs <- stringr::str_split_fixed(sf_chatgpt_summaries_vecs$sf_chatgpt_summaries_vecs, " ", 300)
sf_chatgpt_summaries_vecs <- as.data.frame(sf_chatgpt_summaries_vecs)
sf_chatgpt_summaries_vecs <- mutate_all(sf_chatgpt_summaries_vecs, function(x) as.numeric(as.character(x)))

sf_Title_vecs <- cbind(soziale_fragen$Title, sf_Title_vecs)
#sf_Title_vecs[!!rowSums(is.na(sf_Title_vecs)),] <- NA

# remove first column
sf_BusinessTypeName_vecs[1] <- NULL

# convert NA to 0
sf_SubmittedText_vecs[!!rowSums(is.na(sf_SubmittedText_vecs)),] <- 0

combined_df <- sf_BusinessTypeName_vecs*0.1 +
  sf_Description_vecs*0.5 + # *0.8 +
  sf_FirstCouncil1Name_vecs*0.1 +
  sf_InitialSituation_vecs +
  sf_Proceedings_vecs*0.5 +
  sf_ReasonText_vecs*0.5 + #*0.8 +
  sf_ResponsibleDepartmentName_vecs*0.7 + #*0.8 +
  sf_SubmissionCouncilName_vecs*0.1 +
  sf_SubmittedBy_vecs*0.2 + #*0.8 +
  sf_SubmittedText_vecs*0.5 + #*0.8 +
  sf_TagNames_vecs +
  sf_Title_vecs +
  sf_chatgpt_summaries_vecs # *2

# elbow ---------------------------------------------------------------------


# Perform k-means clustering for different values of k and calculate WCSS
# wcss <- c()
# for (k in 1:16) {
#   kmeans_model <- kmeans(combined_df, centers = k)#, nstart = 25)
#   wcss[k] <- kmeans_model$tot.withinss
# }
# 
# # Create a line plot of WCSS against the number of clusters
# plot_data <- data.frame(k = 1:16, WCSS = wcss)
# ggplot(data = plot_data, aes(x = k, y = WCSS)) +
#   geom_line() +
#   geom_point() +
#   labs(x = "Number of Clusters (k)", y = "Within-Cluster Sum of Squares (WCSS)")


# Perform k-means clustering ---------------------------------------------------------------------

# k <- 9  # Number of clusters
# result <- kmeans(combined_df, centers = k)
# 
# # Get the cluster assignments
# cluster_assignments <- result$cluster
# 
# # Add cluster assignments back to the dataframe
# combined_df$cluster <- cluster_assignments
# 
# combined_df <- combined_df %>%
#   mutate(doc_id = 1:nrow(combined_df)) %>% 
#   select(doc_id, cluster)
# 
# topic_check <- soziale_fragen %>%
#   select(TagNames, Title) %>% 
#   mutate(doc_id = 1:nrow(combined_df)) %>% 
#   left_join(combined_df, by = "doc_id")

# topic_check <- topic_check %>% 
#   left_join(chatgpt_summaries, by = "doc_id")



# hierarchical clustering ---------------------------------------------------------------------
# https://www.statology.org/hierarchical-clustering-in-r/

df_hierarchical <- scale(combined_df)
#df_hierarchical <- as.data.frame(df_hierarchical)

#define linkage methods
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

#function to compute agglomerative coefficient
ac <- function(x) {
  agnes(df_hierarchical, method = x)$ac
}

#calculate agglomerative coefficient for each clustering linkage method
sapply(m, ac)

#perform hierarchical clustering using Ward's minimum variance
clust <- agnes(df_hierarchical, method = "ward")

#produce dendrogram
pltree(clust, cex = 0.6, hang = -1, main = "Dendrogram") 


#calculate gap statistic for each number of clusters (up to 10 clusters)
gap_stat <- clusGap(df_hierarchical, FUN = hcut, nstart = 25, K.max = 15, B = 50)

#produce plot of clusters vs. gap statistic
fviz_gap_stat(gap_stat)


#compute distance matrix
d <- dist(df_hierarchical, method = "euclidean")
d <- as.dist(d)

#perform hierarchical clustering using Ward's method
final_clust <- hclust(d, method = "ward.D2")

#cut the dendrogram into 4 clusters
groups <- cutree(final_clust, k = 9)

#append cluster labels to original data
final_data <- cbind(soziale_fragen, cluster = groups)
final_data <- final_data %>% 
  left_join(chatgpt_summaries, by = "BusinessShortNumber") %>% 
  select(-c(main_tag, BusinessTypeName, SubmissionCouncilName, FirstCouncil1Name, chatgpt_summaries.x))



# dbscan ---------------------------------------------------------------------


# Loading package
library(fpc)


# Fitting DBScan clustering Model
# to training dataset
set.seed(220) # Setting seed
Dbscan_cl <- dbscan(sf_TagNames_vecs, eps = 0.45, MinPts = 5, scale = T, method = "hybrid", showplot = 1)
Dbscan_cl

# https://rpubs.com/datalowe/dbscan-simple-example
dbscan_res <- dbscan(combined_df, eps = 1, MinPts = 0.01)
plot(sf_TagNames_vecs[,1:2], col=dbscan_res$cluster+1, main="DBSCAN")
dbscan_res$cluster

# Checking cluster
Dbscan_cl$cluster

# Table
table(Dbscan_cl$cluster)

# Plotting Cluster
plot(Dbscan_cl, iris_1, main = "DBScan")
plot(Dbscan_cl, iris_1, main = "Petal Width vs Sepal Length")

# not enough samples, results are terrible


# GMM ---------------------------------------------------------------------
#https://cran.r-project.org/web/packages/ClusterR/vignettes/the_clusterR_package.html

library(ClusterR)

x <- GMM(
  combined_df,
  gaussian_comps = 1,
  dist_mode = "eucl_dist",
  seed_mode = "random_subset",
  km_iter = 10,
  em_iter = 5,
  verbose = FALSE,
  var_floor = 1e-10,
  seed = 1,
  full_covariance_matrices = FALSE
)
# chatgpt

# Install and load the required package
library(mclust)

# Assuming you have your data stored in a matrix 'data' with 300 vectors per text

# Fit the GMM model
gmm_model <- Mclust(combined_df,
                    modelNames = "EII")

# Extract the cluster assignments
gmm_cluster_assignments <- gmm_model$classification

# Get the parameters of the Gaussian mixture components
gmm_component_means <- gmm_model$parameters$mean
gmm_component_covs <- gmm_model$parameters$cov

# Number of clusters
gmm_num_clusters <- length(unique(gmm_cluster_assignments))

# do not understand

############ merged all businesses
all_businesses_nas <- all_businesses %>% 
  dplyr::filter(is.na(InitialSituation) == T)


# samples
all_businesses$InitialSituation_clean[5]
all_businesses$query_central_stmnt[5]




###########################


unique(all_businesses$main_tag)
unique(all_businesses_web$chatgpt_topic)


load(here("scripts", "05_chatgpt_tagging", "chatgpt_tagging_output", "all_businesses_eval.RData"))


unique(all_businesses$main_topic)



################################


df <- data.frame(tags = c("Internationale Währungshilfe | Rechtsgrundlage", 
                          "Rechtsgrundlage | Währungszusammenarbeit", 
                          "apple | banana", 
                          "date | egg"))

vector1 <- c("apple", "banana", "cherry", "Internationale Währungshilfe")
vector2 <- c("date", "egg", "Rechtsgrundlage")
vector3 <- c("fig", "grape", "honey", "Währungszusammenarbeit")

# Function to check if any of the terms from a vector are substrings of a tag string
is_in_vector <- function(tags_str, vec) {
  any(sapply(vec, function(v) str_detect(tags_str, fixed(v))))
}

df <- df %>%
  rowwise() %>%
  mutate(
    vector1_flag = if_else(is_in_vector(tags, vector1), "vector1", ""),
    vector2_flag = if_else(is_in_vector(tags, vector2), "vector2", ""),
    vector3_flag = if_else(is_in_vector(tags, vector3), "vector3", ""),
    vector_name = paste(vector1_flag, vector2_flag, vector3_flag, sep = "|")
  ) %>%
  mutate(vector_name = if_else(vector_name == "||", NA_character_, vector_name))

# Optionally, you can remove the flag columns if you want
df <- df %>% select(-vector1_flag, -vector2_flag, -vector3_flag)

print(df)


all_businesses_ahv <- all_businesses_sorgen %>% 
  dplyr::filter(ahv == T) %>% 
  select(BusinessShortNumber)

all_businesses_ahv <- all_businesses_ahv %>% 
  left_join(all_businesses_web, by = "BusinessShortNumber")

my_table <- as.data.frame(table(voting_all_periods$PersonNumber))

pfister <- voting_all_periods %>% 
  dplyr::filter(PersonNumber == 1109) %>% 
  select(BusinessShortNumber, DecisionText)

pfister_ahv <- all_businesses_ahv %>% 
  left_join(pfister, by = "BusinessShortNumber")

pfister_ahv %>% select(DecisionText)

schwander <- voting_all_periods %>% 
  dplyr::filter(PersonNumber == 1159) %>% 
  select(BusinessShortNumber, DecisionText)

schwander_ahv <- all_businesses_ahv %>% 
  left_join(schwander, by = "BusinessShortNumber")

schwander_ahv %>% select(DecisionText)



voting_all_periods

# Filter rows where all columns (except ID) are FALSE
df <- all_businesses_sorgen %>%
  select(1, 7:33)

df <- df %>% 
  rowwise() %>%
  mutate(any_sorgen = any(c_across(-BusinessShortNumber), na.rm=TRUE))

df <- df %>% 
  dplyr::filter(any_sorgen == F) %>% 
  select(BusinessShortNumber) %>% 
  left_join(all_businesses_web, by = "BusinessShortNumber") %>% 
  left_join(select(all_businesses_eval, BusinessShortNumber, chatgpt_tags_clean), by = "BusinessShortNumber")

# 238 items of business without any Sorgen

# create new df with a single tag per row - 2222 obs
tag_df <- df %>%
  # Separate tags into individual rows
  tidyr::separate_rows(chatgpt_tags_clean, sep = " \\| ") %>%
  # Remove any residual "</s>" strings
  mutate(chatgpt_tags_clean = gsub("</s>", "", chatgpt_tags_clean)) %>%
  # Count the occurrences of each tag
  group_by(chatgpt_tags_clean) %>%
  summarize(count = n())




### chatgpt costs
length(unique(voting_all_periods$PersonNumber))

# 580 tokens

(534*20*580) / 1000 * 0.03 # $180 for set summaries





load(here("data", "chatgpt_output_df_20230827_100317.RData"))







