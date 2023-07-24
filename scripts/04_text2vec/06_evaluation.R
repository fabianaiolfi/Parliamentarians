
# Evaluation ---------------------------------------------------------------------
# How good are the clusters within the tag groups?

# Which tag groups exist?
all_tags <- unique(df$main_tag)

# Plot tag occurences
tag_plot <- df %>%
  group_by(main_tag) %>%
  mutate(main_tag_count = n()) %>% 
  ungroup() %>% 
  distinct(main_tag, main_tag_count)

# Plot occurences
ggplot(tag_plot) +
  geom_col(aes(x = reorder(main_tag, main_tag_count), y = main_tag_count)) + #, stat = "count"
  coord_flip() +
  xlab("") +
  theme_minimal()

# Examine individual tags
eval_tags <- df %>% 
  dplyr::filter(main_tag == "Verkehr</s>") %>% 
  select(-chatgpt_query_central_stmnt, -InitialSituation_lemma, -ReasonText_lemma, -Proceedings_lemma, -SubmittedText_lemma, -chatgpt_summaries_lemma) %>% 
  group_by(cluster) %>%
  mutate(cluster_count = n())

ggplot(eval_tags) +
  geom_bar(aes(x = reorder(as.factor(cluster), -cluster_count)), stat = "count") + 
  coord_flip() +
  xlab("") +
  theme_minimal()

eval_tags %>% 
  dplyr::filter(cluster == 1) %>% 
  select(Title, InitialSituation_clean, TagNames, chatgpt_summaries) %>% 
  View()

