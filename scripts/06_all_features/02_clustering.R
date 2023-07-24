
# Prepare DF ---------------------------------------------------------------------

combined_vecs_scaled <- scale(combined_vecs)
combined_vecs_scaled <- as.data.frame(combined_vecs_scaled)


# Hierarchical clustering ---------------------------------------------------------------------
# https://www.statology.org/hierarchical-clustering-in-r/

# Compute distance matrix
d <- dist(combined_vecs_scaled[,c(1:300)], method = "euclidean")
d <- as.dist(d)

# Perform hierarchical clustering using Ward's method
final_clust <- hclust(d, method = "ward.D2")

# Cut the dendrogram into k clusters
groups <- cutree(final_clust, k = 225)

# Append cluster labels to df
all_businesses <- cbind(all_businesses, cluster = groups)
all_businesses_cluster <- all_businesses


# Evaluation

load(here("data", "all_businesses_and_tags_230703.RData"))
all_businesses_tags <- all_businesses %>% select(BusinessShortNumber, chatgpt_tags)

load(here("data", "all_businesses_and_summaries.RData"))
all_businesses_summaries <- all_businesses %>% select(BusinessShortNumber, chatgpt_summaries)

load(here("data", "all_businesses_and_clean_tags_230703.RData"))
all_businesses_clean_tags <- all_businesses %>% select(BusinessShortNumber, chatgpt_tags_clean)

all_businesses_eval <- all_businesses_cluster

all_businesses_eval <- all_businesses_eval %>% 
  left_join(all_businesses_tags, by = "BusinessShortNumber") %>%
  left_join(all_businesses_clean_tags, by = "BusinessShortNumber") %>%
  left_join(all_businesses_summaries, by = "BusinessShortNumber")

# ggplot(all_businesses_eval, aes(x = cluster)) +
#   geom_bar(stat = "count")
# 
# length(unique(all_businesses_eval$cluster))

all_businesses_eval %>% 
  dplyr::filter(cluster == floor(runif(1, min = 1, max = 226))) %>%
  select(BusinessShortNumber, cluster, TagNames, Title, InitialSituation, chatgpt_summaries, chatgpt_tags, chatgpt_tags_clean) %>%
  View()
