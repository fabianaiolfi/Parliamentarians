# Post process ChatGPT Output
load(here("data", "chatgpt_output_20230411_232430.RData"))

# Convert ChatGPT output to dataframe (Source: https://stackoverflow.com/a/28630369 )
chatgpt_output_df <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_output[[1]][["id"]],
      content = chatgpt_output[[1]][["chatgpt_content"]]))

# Split business short number and query type
chatgpt_output_df <- chatgpt_output_df %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))


# Separate numbered bullet points and spread them over separate columns (Source: ChatGPT)
# chatgpt_output <- chatgpt_output %>%
#   separate(content,
#            into = c("Point_1", "Point_2", "Point_3"),
#            sep = "\\s+(?=(1|2|3)\\.\\s)",
#            remove = TRUE, convert = TRUE, extra = "merge", fill = "right")

# Merge ChatGPT output dataframe together with Business dataframe
# sample_business <- sample_business %>% 
#   left_join(chatgpt_output, by = "BusinessShortNumber")