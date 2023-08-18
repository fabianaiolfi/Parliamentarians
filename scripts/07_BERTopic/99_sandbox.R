

all_businesses <- tibble::rowid_to_column(all_businesses, "python_ID")
all_businesses$python_ID <- all_businesses$python_ID - 1

summary(all_businesses$Topic)
hist(all_businesses$Topic, breaks = 144)



# Semi supervised probabilities

# Add index
BERTopic_df_ss_probs <- tibble::rowid_to_column(BERTopic_df_ss_probs, "index")

# this is rubbish
# max_values <- BERTopic_df_ss_probs %>%
#   group_by(index) %>%
#   summarize(max_probability = max(V1:V140))
# 
# hist(max_values$max_probability, breaks = 1000)

# BERTopic_df_ss_probs <- BERTopic_df_ss_probs %>%
#   rowwise() %>%
#   mutate(
#     min_val = min(c_across(V1:V140), na.rm = TRUE),
#     max_val = max(c_across(V1:V140), na.rm = TRUE)
#   ) %>%
#   ungroup()

# probs <- as.data.frame(0)
# probs$max <- 0
# BERTopic_df_ss_probs$max <- apply(BERTopic_df_ss_probs, 1, max, na.rm=TRUE)
# probs <- BERTopic_df_ss_probs$max

BERTopic_df_ss_probs$max <- do.call(pmax, BERTopic_df_ss_probs[, paste0("V", 1:140)])
BERTopic_df_ss_probs$min <- do.call(pmin, BERTopic_df_ss_probs[, paste0("V", 1:140)])

hist(BERTopic_df_ss_probs$max, breaks = 100)
hist(BERTopic_df_ss_probs$min, breaks = 100)

# inspect items with small SD
BERTopic_df_ss_probs$sd <- apply(BERTopic_df_ss_probs[, paste0("V", 1:140)], 1, sd)
hist(BERTopic_df_ss_probs$sd, breaks = 100)
summary(BERTopic_df_ss_probs$sd)

small_sd <- BERTopic_df_ss_probs %>% dplyr::filter(sd <= 0.002) # 0.0056372

# boxplots
df_long <- small_sd %>%
  pivot_longer(cols = starts_with("V"), names_to = "variable", values_to = "probability")

ggplot(df_long, aes(x = factor(index), y = probability)) +
  geom_boxplot(outlier.shape = NA) +  # Removing outlier points 
  geom_jitter(width = 0.01, alpha = 0.25, color = "red") +  # Adding data points with a slight jitter
  #ylim(0, 0.012) +
  labs(title = "Boxplot of Probabilities for Each Index",
       x = "Index",
       y = "Probability") +
  theme_minimal()


# look at items with prob of 1
mos_def <- BERTopic_df_ss_probs %>% dplyr::filter(max == 1)
mos_def$max_col <- apply(mos_def[, paste0("V", 1:140)], 1, function(x) {
  names(which.max(x))
})
mos_def <- mos_def %>% select(index, max_col)
mos_def$max_col <- gsub("V", "", mos_def$max_col)
mos_def$max_col <- as.numeric(mos_def$max_col)

all_businesses_mos_def <- all_businesses %>% select(BusinessShortNumber,
                                                    Title,
                                                    InitialSituation_clean,
                                                    chatgpt_summaries,
                                                    Topic)
all_businesses_mos_def <- tibble::rowid_to_column(all_businesses_mos_def, "index")

all_businesses_mos_def <- all_businesses_mos_def %>% 
  left_join(mos_def, by = "index")


# boxplots
df_long <- BERTopic_df_ss_probs %>%
  pivot_longer(cols = starts_with("V"), names_to = "variable", values_to = "probability")

ggplot(df_long, aes(x = factor(index), y = probability)) +
  geom_boxplot(outlier.shape = NA) +  # Removing outlier points
  #geom_jitter(width = 0.2, alpha = 0.5, color = "red") +  # Adding data points with a slight jitter
  labs(title = "Boxplot of Probabilities for Each Index",
       x = "Index",
       y = "Probability") +
  theme_minimal()



# calculate difference between n highest probabilities

BERTopic_df_ss_probs$diff_max_5 <- apply(BERTopic_df_ss_probs[, paste0("V", 1:140)], 1, function(row) {
  sorted_values <- sort(row, decreasing = TRUE)
  return(sorted_values[1] - sorted_values[5])
})

#BERTopic_df_ss_probs %>% select(index, diff_max_3rd) %>% View()
hist(BERTopic_df_ss_probs$diff_max_5)
summary(BERTopic_df_ss_probs$diff_max_5)
boxplot(BERTopic_df_ss_probs$diff_max_5)

ss_probs_5 <- BERTopic_df_ss_probs %>% dplyr::filter(diff_max_5 <= 0.0397235)

ss_probs_5$max_col <- apply(ss_probs_5[, paste0("V", 1:140)], 1, function(x) {
  #names(which.max(x))
  colnames(ss_probs_5)[which.max(x)]
})

ss_probs_5$top_5_topics <- apply(ss_probs_5[, paste0("V", 1:140)], 1, function(row) {
  sorted_indices <- order(row, decreasing = TRUE)[1:5]
  return(paste(colnames(ss_probs_5)[sorted_indices], collapse = ","))
})

ss_probs_5 <- ss_probs_5 %>% select(index, max_col, diff_max_5, top_5_topics)


# Heatmap
# Sample data
set.seed(123)
df <- as.data.frame(matrix(runif(588*140), ncol=140))

# Convert row names to a column
df$Document = rownames(df)

# Taking a subset: Top 10 topics and 50 documents
#subset_df <- df[1:50, c(1:10, ncol(df))]
#subset_df$Document <- as.numeric(subset_df$Document)
subset_df <- BERTopic_df_ss_probs#[1:300, c(1:140, ncol(BERTopic_df_ss_probs))]
subset_df <- tibble::rowid_to_column(subset_df, "Document")

# Convert to long format for ggplot
#long_df <- melt(subset_df, id.vars = "Document", variable.name = "Topic", value.name = "Probability")
long_df <- melt(subset_df, id.vars = "Document", variable.name = "Topic", value.name = "Probability")

ggplot(long_df, aes(y=Topic, x=Document)) + 
  geom_tile(aes(fill=Probability), color="white") + 
  #scale_fill_gradient(low="white", high="blue") + 
  scale_fill_gradient2(low="white", mid = "red", high="blue", midpoint = 0.5) + 
  theme_minimal() + 
  labs(y="Topics", x="Documents", title="Heatmap of Document-Topic Probabilities")


