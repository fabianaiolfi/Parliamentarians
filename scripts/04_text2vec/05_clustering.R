

# Prepare DF ---------------------------------------------------------------------

combined_vecs_scaled <- scale(combined_vecs)
combined_vecs_scaled <- as.data.frame(combined_vecs_scaled)
combined_vecs_scaled$BusinessShortNumber <- df$BusinessShortNumber

df_main_tag <- df %>%
  distinct(BusinessShortNumber, .keep_all = T) %>% 
  select(BusinessShortNumber, main_tag)

combined_vecs_scaled <- combined_vecs_scaled %>%
  distinct(BusinessShortNumber, .keep_all = T) %>% 
  left_join(df_main_tag, by = "BusinessShortNumber")


# Hierarchical clustering ---------------------------------------------------------------------
# https://www.statology.org/hierarchical-clustering-in-r/

main_tags <- combined_vecs_scaled %>% 
  select(main_tag) %>% distinct(main_tag)
main_tags <- as.vector(main_tags$main_tag)

df_clustered <- as.data.frame(NULL)

for (i in main_tags) {
  temp_df <- combined_vecs_scaled %>% dplyr::filter(combined_vecs_scaled$main_tag == i)

  if (nrow(temp_df) < 9) {
    # Deal with dataframes/tags with few bills
    temp_df$cluster <- 0
    df_clustered <- rbind(df_clustered, temp_df)
  } else {
    # Compute distance matrix
    d <- dist(temp_df[,c(1:300)], method = "euclidean")
    d <- as.dist(d)

    # Perform hierarchical clustering using Ward's method
    final_clust <- hclust(d, method = "ward.D2")
    #final_clust <- hclust(d, method = "complete")

    # Cut the dendrogram into k clusters
    groups <- cutree(final_clust, k = 9)

    # Append cluster labels to df
    temp_df <- cbind(temp_df, cluster = groups)
    df_clustered <- rbind(df_clustered, temp_df)
  }
}


# Merge with original df ---------------------------------------------------------------------

df_clustered <- df_clustered %>% select(BusinessShortNumber, cluster)
df <- df %>% distinct(BusinessShortNumber, .keep_all = T)
df <- df %>% left_join(df_clustered, by = "BusinessShortNumber")
