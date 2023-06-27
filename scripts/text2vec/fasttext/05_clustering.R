

# Prepare DF ---------------------------------------------------------------------

combined_vecs_scaled <- scale(combined_vecs)
combined_vecs_scaled <- as.data.frame(combined_vecs_scaled)
combined_vecs_scaled$BusinessShortNumber <- df$BusinessShortNumber
combined_vecs_scaled$main_tag <- df$main_tag

# Split dataframe by main tag
combined_vecs_scaled_split <- split(combined_vecs_scaled, combined_vecs_scaled$main_tag)
df_main_tag_split <- split(df, df$main_tag)


# Hierarchical clustering ---------------------------------------------------------------------
# https://www.statology.org/hierarchical-clustering-in-r/

for (i in seq_along(combined_vecs_scaled_split)) {
  if (nrow(combined_vecs_scaled_split[[i]]) < 9) {
    # Deal with dataframes/tags with few bills
    combined_vecs_scaled_split[[i]]$cluster <- 0
  } else {
    # Compute distance matrix
    d <- dist(combined_vecs_scaled_split[[i]][,c(1:300)], method = "euclidean")
    d <- as.dist(d)
    
    # Perform hierarchical clustering using Ward's method
    final_clust <- hclust(d, method = "ward.D2")
    #final_clust <- hclust(d, method = "complete")
    
    # Cut the dendrogram into k clusters
    groups <- cutree(final_clust, k = 9)
    
    # Append cluster labels to original data
    combined_vecs_scaled_split[[i]] <- cbind(combined_vecs_scaled_split[[i]], cluster = groups)
    combined_vecs_scaled_split[[i]] <- combined_vecs_scaled_split[[i]] %>% distinct(BusinessShortNumber, .keep_all = T)
  }
}


# Merge dataframes ---------------------------------------------------------------------

df_clustered <- as.data.frame(NULL)

# for (i in seq_along(combined_vecs_scaled_split)) {
  temp_df <- df_main_tag_split[[8]]
  temp_df <- temp_df %>% distinct(BusinessShortNumber, .keep_all = T)
  
  # Append cluster labels to original dataframe
  temp_df <- cbind(temp_df, cluster = combined_vecs_scaled_split[[8]]$cluster)
  temp_df <- temp_df %>% distinct(BusinessShortNumber, .keep_all = T) # Repeat this?
  
  df_clustered <- rbind(df_clustered, temp_df)
# }




combined_vecs_scaled_split[[3]]$cluster

inspect_df <- df_main_tag_split[[20]]
inspect_df <- inspect_df %>% distinct(BusinessShortNumber, .keep_all = T)

# Append cluster labels to original data
inspect_df <- cbind(inspect_df, cluster = combined_vecs_scaled_split[[20]]$cluster)





