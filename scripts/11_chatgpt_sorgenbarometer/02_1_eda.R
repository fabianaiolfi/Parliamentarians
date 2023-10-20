
# EDA ---------------------------------------------------------------------

# Count occurrences of each sorge
sorge_counts <- vote_statement %>%
  group_by(sorge) %>%
  tally(sort = TRUE)

ggplot(sorge_counts, aes(x = reorder(sorge, n), y = n)) +
  geom_bar(stat = "identity") +
  coord_flip() + 
  labs(x = "Sorge", y = "Number of Occurrences", title = "Occurrences of Sorge") +
  theme_minimal()

# Check prompt lengths
prompt_vote_statement_sorge <- prompt_vote_statement_sorge %>% 
  mutate(len = nchar(prompt)) %>% 
  mutate(bullet_count = str_count(prompt, "- "))

summary(prompt_vote_statement_sorge$len)

ggplot(prompt_vote_statement_sorge, aes(x = bullet_count)) +
  geom_histogram(binwidth = 1) +
  theme_minimal()

# Which items of business have no Sorge? (n=214)
no_sorge <- all_businesses_sorgen_merge %>%
  rowwise() %>%
  dplyr::filter(all(c_across(-BusinessShortNumber) == FALSE)) %>%
  ungroup() %>% 
  select(BusinessShortNumber) %>% 
  left_join(all_businesses_eval, by = "BusinessShortNumber")

# also check rows with NA in topics (n=4)
no_chatgpt_tags <- all_businesses_eval %>% 
  dplyr::filter(is.na(chatgpt_tags) == T)
