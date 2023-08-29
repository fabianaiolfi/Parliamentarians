library(tidyverse)

# Post process ChatGPT Output

# Load ChatGPT Data -------------------------------------------------------
load("/Users/aiolf1/Documents/GitHub/Parliamentarians/data/chatgpt_output_df_20230827_100317.RData")



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


# Export Data ---------------------------------------------------------------

# Create export TSV and change order of columns for BERTopic
all_vote_yes_export <- chatgpt_output_df %>% 
  select(-chatgpt_summary)

# Keep TagNames in seperate column for semi-supervised modelling
# all_vote_yes_export <- all_vote_yes_export %>% unite("all", -BusinessShortNumber, sep = " ", remove = T, na.rm = T)

write.table(all_vote_yes_export,
            sep = "\t",
            "/Users/aiolf1/Documents/GitHub/Parliamentarians/scripts/09_vote_yes/export.tsv",
            row.names = F, col.names = T, quote = F)
