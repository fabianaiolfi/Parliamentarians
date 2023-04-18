# Get Summaries from ChatGPT


# Calculate API Costs -----------------------------------------------------

# https://openai.com/pricing
# gpt-3.5-turbo:	$0.002 / 1K tokens

# Sum of queries and returning tokens
token_sum <- round(sum(business_legislative_period_51$chatgpt_query_n_tokens)) + (nrow(business_legislative_period_51) * 100)
round(token_sum / 1000 * 0.002, 2) # Queries will cost about $0.33 in total


# Connect to ChatGPT -----------------------------------------------------
gpt3_authenticate("ChatGPT_API_Key.txt")

# Check if API is working. Should return "test successful".
# gpt3_test_completion()


# Query Sample Summary from ChatGPT -----------------------------------------------------

# Query ChatGPT
# chatgpt_query <- chatgpt(prompt_role_var = …$role,
#                                 prompt_content_var = …$chatgpt_query,
#                                 id_var = …$BusinessShortNumber,
#                                 param_max_tokens = 100,
#                                 param_n = 1,
#                                 param_temperature = 0)
# save(sample_chatgpt_query, file = "data/sample_chatgpt_query.RData")
load("data/sample_chatgpt_query.RData")

# Convert ChatGPT query to dataframe (Source: https://stackoverflow.com/a/28630369)
chatgpt_output <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = sample_chatgpt_query[[1]][["id"]],
      content = sample_chatgpt_query[[1]][["chatgpt_content"]]))

# Separate numbered bullet points and spread them over separate columns (Source: ChatGPT)
chatgpt_output <- chatgpt_output %>%
  separate(content,
           into = c("Point_1", "Point_2", "Point_3"),
           sep = "\\s+(?=(1|2|3)\\.\\s)",
           remove = TRUE, convert = TRUE, extra = "merge", fill = "right")

# Merge ChatGPT output dataframe together with Business dataframe
business_legislative_period_51 <- business_legislative_period_51 %>% 
  left_join(chatgpt_output, by = "BusinessShortNumber")