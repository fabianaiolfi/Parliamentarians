
# Prepare DF
combined_vecs_scaled <- scale(combined_vecs)
combined_vecs_scaled <- as.data.frame(combined_vecs_scaled)
combined_vecs_scaled$BusinessShortNumber <- df$BusinessShortNumber
combined_vecs_scaled$main_tag <- df$main_tag

# Split dataframe by main tag
combined_vecs_scaled_split <- split(combined_vecs_scaled, combined_vecs_scaled$main_tag)
df_main_tag_split <- split(df, df$main_tag)


# hierarchical clustering ---------------------------------------------------------------------
# https://www.statology.org/hierarchical-clustering-in-r/

#df_hierarchical <- scale(combined_vecs)
#df_hierarchical <- as.data.frame(lapply(combined_vecs[, -which(names(combined_vecs) == "BusinessShortNumber")], scale))


#define linkage methods
# m <- c( "average", "single", "complete", "ward")
# names(m) <- c( "average", "single", "complete", "ward")
# 
# #function to compute agglomerative coefficient
# ac <- function(x) {
#   #for (i in seq_along(combined_vecs_scaled_split)) {
#   agnes(combined_vecs_scaled_split[[2]], method = x)$ac
#   #}
# }
# 
# combined_vecs_scaled_split[[1]]

#calculate agglomerative coefficient for each clustering linkage method
#sapply(m, ac)

#perform hierarchical clustering using Ward's minimum variance
clust <- agnes(combined_vecs_scaled_split[[3]], method = "ward")

#produce dendrogram
#pltree(clust, cex = 0.6, hang = -1, main = "Dendrogram") 

#calculate gap statistic for each number of clusters (up to 10 clusters)
#gap_stat <- clusGap(df_hierarchical, FUN = hcut, nstart = 25, K.max = 15, B = 50)

#produce plot of clusters vs. gap statistic
#fviz_gap_stat(gap_stat)


#compute distance matrix
d <- dist(combined_vecs_scaled_split[[3]], method = "euclidean")
d <- as.dist(d)

#perform hierarchical clustering using Ward's method
final_clust <- hclust(d, method = "ward.D2")

#cut the dendrogram into k clusters
groups <- cutree(final_clust, k = 5)

#europapolitik <- combined_vecs_scaled_split[[3]]
europapolitik_df <- df_main_tag_split[[3]]

#append cluster labels to original data
#final_data <- cbind(europapolitik, cluster = groups)
europapolitik_df <- cbind(europapolitik_df, cluster = groups)
europapolitik_df <- europapolitik_df %>% distinct(BusinessShortNumber, .keep_all = T)

#final_data <- final_data %>% 
  #left_join(europapolitik_df, by = "BusinessShortNumber")# %>% 
  #select(-c(main_tag, BusinessTypeName, SubmissionCouncilName, FirstCouncil1Name, chatgpt_summaries.x))






