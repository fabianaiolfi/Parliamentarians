
# Post process ChatGPT Output


# Load ChatGPT Data -------------------------------------------------------
#load(here("data", "chatgpt_output_df_20230827_100317.RData"))


# Split business short number and query type, clean data -------------------------------------------------------

chatgpt_output_df <- chatgpt_output_df %>%
  separate_wider_delim(id, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type")) %>% 
  select(-query_type) %>% 
  mutate(split_text = str_split(chatgpt_summary, "(?=\\n2\\.)", n = 2)) %>%
  select(-chatgpt_summary) %>% 
  unnest_wider(split_text, names_sep = "_") %>%
  rename(chatgpt_summary = split_text_1, chatgpt_vote_yes = split_text_2) %>% 
  mutate(chatgpt_summary = gsub("1. ", "", chatgpt_summary)) %>% 
  mutate(chatgpt_vote_yes = gsub("\\n2. ", "", chatgpt_vote_yes)) %>% 
  mutate(chatgpt_vote_yes = gsub("'", "", chatgpt_vote_yes))


# Merge with original dataframe -------------------------------------------------------

all_businesses <- all_businesses %>% 
  left_join(chatgpt_output_df, by = "BusinessShortNumber")
