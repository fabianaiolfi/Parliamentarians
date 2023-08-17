
# Import and Prepare CSV ---------------------------------------------------------------

# Plain Vanilla
BERTopic_df <- read.csv(here("scripts", "07_BERTopic", "doc_level_info.csv"))
BERTopic_df$BusinessShortNumber <- all_businesses$BusinessShortNumber

# Semi-Supervised
BERTopic_df_ss <- read.csv(here("scripts", "07_BERTopic", "doc_level_info_ss.csv"))
BERTopic_df_ss$BusinessShortNumber <- all_businesses$BusinessShortNumber

# Semi-Supervised Probabilities
rm(BERTopic_df_ss_probs)
BERTopic_df_ss_probs <- read.csv(here("scripts", "07_BERTopic", "ss_probs_data",  "probs.csv"), header = F)

# Guided
BERTopic_df_guided <- read.csv(here("scripts", "07_BERTopic", "doc_level_info_guided.csv"))
BERTopic_df_guided$BusinessShortNumber <- all_businesses$BusinessShortNumber


# Merge ---------------------------------------------------------------

# Plain Vanilla
all_businesses <- all_businesses %>% 
  left_join(BERTopic_df, by = "BusinessShortNumber")

# Semi-Supervised
all_businesses <- all_businesses %>% 
  left_join(BERTopic_df_ss, by = "BusinessShortNumber")

# Guided
all_businesses <- all_businesses %>% 
  left_join(BERTopic_df_guided, by = "BusinessShortNumber")


# Inspect ---------------------------------------------------------------

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
BERTopic_df_ss_probs$sd <- apply(BERTopic_df_ss_probs[, paste0("V", 1:140)], 1, sd)

hist(BERTopic_df_ss_probs$max, breaks = 100)
hist(BERTopic_df_ss_probs$min, breaks = 100)
hist(BERTopic_df_ss_probs$sd, breaks = 100)


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









