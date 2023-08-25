# Post process ChatGPT Output


# Load ChatGPT Data -------------------------------------------------------
load(here("data", "chatgpt_output_20230703_213415.RData"))
chatgpt_output_20230419_204609 <- chatgpt_output


# Convert ChatGPT output to dataframe -------------------------------------------------------
# Source: https://stackoverflow.com/a/28630369
chatgpt_output_df <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_output[[1]][["id"]],
      content = chatgpt_output[[1]][["chatgpt_content"]]))

# Split business short number and query type
chatgpt_output_df <- chatgpt_output_df %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))


# Clean ChatGPT output dataframe -------------------------------------------------------
# Convert dataframe
chatgpt_output_df <- chatgpt_output_df %>% 
  pivot_wider(names_from = query_type, values_from = content)


# Merge with original dataframe -------------------------------------------------------

all_businesses <- all_businesses %>% 
  left_join(chatgpt_output_df, by = "BusinessShortNumber") %>% 
  # Depending which file is loaded
  # rename(chatgpt_tags = chatgpt_query_tags) %>% 
  rename(chatgpt_tags = query_central_stmnt)
