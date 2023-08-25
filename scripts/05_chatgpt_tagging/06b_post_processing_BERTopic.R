# Post process ChatGPT Output


# Load ChatGPT Data -------------------------------------------------------
load(here("data", "chatgpt_output_df_20230825_133800.RData"))


# Split business short number and query type -------------------------------------------------------

chatgpt_output_df <- chatgpt_output_df %>% 
  separate_wider_delim(id, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type")) %>% 
  select(-query_type)


# Merge with original dataframe -------------------------------------------------------

all_businesses <- all_businesses %>% 
  left_join(chatgpt_output_df, by = "BusinessShortNumber")
