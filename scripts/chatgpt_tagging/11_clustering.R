
# Prepare DF ---------------------------------------------------------------------

chatgpt_tag_embeddings_scaled <- scale(chatgpt_tag_embeddings)
chatgpt_tag_embeddings_scaled <- as.data.frame(chatgpt_tag_embeddings_scaled)


# Hierarchical clustering ---------------------------------------------------------------------
# https://www.statology.org/hierarchical-clustering-in-r/

# Find the Linkage Method to Use
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# function to compute agglomerative coefficient
ac <- function(x) {
  agnes(chatgpt_tag_embeddings_scaled, method = x)$ac
}

# calculate agglomerative coefficient for each clustering linkage method
sapply(m, ac)


# Determine the Optimal Number of Clusters

# calculate gap statistic for each number of clusters (up to 10 clusters)
gap_stat <- clusGap(chatgpt_tag_embeddings_scaled, FUN = hcut, nstart = 25, K.max = 400, B = 50)
#save(gap_stat, file = here("data", "gap_stat_k_400_b_50")) # nstart = 25, K.max = 400, B = 50

#produce plot of clusters vs. gap statistic
fviz_gap_stat(gap_stat)


# Compute distance matrix
d <- dist(chatgpt_tag_embeddings_scaled[,c(1:300)], method = "euclidean")
d <- as.dist(d)

# Perform hierarchical clustering using Ward's method
final_clust <- hclust(d, method = "ward.D2")

# Cut the dendrogram into k clusters
groups <- cutree(final_clust, k = 160)

# Append cluster labels to df
all_businesses <- cbind(all_businesses, cluster = groups)


# Evaluation

load(here("data", "all_businesses_and_tags_230703.RData"))
all_businesses_tags <- all_businesses %>% select(BusinessShortNumber, chatgpt_tags)

load(here("data", "all_businesses_and_summaries.RData"))
all_businesses_summaries <- all_businesses %>% select(BusinessShortNumber, chatgpt_summaries)

all_businesses_eval <- all_businesses
all_businesses_eval <- cbind(all_businesses_eval, cluster = groups)

all_businesses_eval <- all_businesses_eval %>% 
  left_join(all_businesses_tags, by = "BusinessShortNumber")

ggplot(all_businesses_eval, aes(x = cluster)) +
  geom_bar(stat = "count")

all_businesses_eval %>% dplyr::filter(cluster == floor(runif(1, min = 1, max = 161))) %>% 
  select(cluster, TagNames, Title, InitialSituation_clean, chatgpt_summaries, chatgpt_tags) %>% 
  View()
# Disappointing results




