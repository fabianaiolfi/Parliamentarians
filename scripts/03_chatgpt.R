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


# Query ChatGPT -----------------------------------------------------

# Get and format the current timestamp
timestamp <- Sys.time()
formatted_timestamp <- format(timestamp, "%Y%m%d_%H%M%S")

# Query
# chatgpt_output <- chatgpt(prompt_role_var = sample_business_long$role,
#                           prompt_content_var = sample_business_long$query,
#                           id_var = sample_business_long$id,
#                           param_max_tokens = 100,
#                           param_n = 1,
#                           param_temperature = 0)

#save(chatgpt_output, file = paste0("data/chatgpt_output_", formatted_timestamp, ".RData"))