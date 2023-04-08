# Get Summaries from ChatGPT


# Calculate API Costs -----------------------------------------------------

# https://openai.com/pricing
# gpt-3.5-turbo:	$0.002 / 1K tokens

# Sum of queries and returning tokens
token_sum <- round(sum(business_legislative_period_51$chatgpt_query_n_tokens)) + (nrow(business_legislative_period_51) * 100)
round(token_sum / 1000 * 0.002, 2) # Queries will cost about $0.33 in total


# Query Summary from ChatGPT -----------------------------------------------------
gpt3_authenticate("ChatGPT_API_Key.txt")

# Check if API is working. Should return "test successful".
gpt3_test_completion()






# save output to local file
# create backup of local data files!