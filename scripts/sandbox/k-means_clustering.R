
# Load packages -----------------------------------------------------------

library(tidyverse)
library(tidymodels)
library(tidyclust)


# Specify model type and computational engine -----------------------------

kmeans_model <- k_means() %>%
  set_engine("stats") %>% # use the {stats} package as the engine
  set_mode("partition") %>% # {tidyclust} offers the partition mode
  set_args(num_clusters = 10) # specify the number of clusters


# Fit ---------------------------------------------------------------------

#dfmat_business <- as.data.frame(dfmat_business)
k_means_data <- convert(dfmat_business, to = "data.frame")
k_means_data$doc_id <- NULL

#reduced_data_df$topic <- NULL

# Step 1: Standardize the data
standardized_data <- scale(k_means_data)

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

# Visual ------------------------------------------------------------------

predictions %>%
  ggplot(mapping = aes(x = PC1, y = PC2, colour = .pred_cluster)) +
  geom_point() +
  xlim(-10, 10) +
  ylim(-10, 10)

table(predictions$.pred_cluster)


# check with original topics ------------------------------------------------------------------

topic_check <- business_legislative_period_51 %>% select(TagNames, topic)
topic_check$cluster <- predictions$.pred_cluster




# chatgpt on elbow method ------------------------------------------------------------------

library(ggplot2)
library(factoextra)

# Perform k-means clustering for different values of k and calculate WCSS
wcss <- c()
for (k in 1:20) {
  kmeans_model <- kmeans(reduced_data_df, centers = k, nstart = 25)
  wcss[k] <- kmeans_model$tot.withinss
}

# Create a line plot of WCSS against the number of clusters
plot_data <- data.frame(k = 1:20, WCSS = wcss)
ggplot(data = plot_data, aes(x = k, y = WCSS)) +
  geom_line() +
  geom_point() +
  labs(x = "Number of Clusters (k)", y = "Within-Cluster Sum of Squares (WCSS)")

# Use the fviz_nbclust() function from the factoextra package to visualize the elbow point
elbow_plot <- fviz_nbclust(reduced_data_df, kmeans, method = "wss", k.max = 20)

# Print the elbow plot
print(elbow_plot)
