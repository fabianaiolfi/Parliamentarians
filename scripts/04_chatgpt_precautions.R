# Some precautions to take before sending the request to the ChatGPT API

# Truncate Long Query ---------------------------------------------------------------
# The model gpt-3.5-turbo-0301 sets 4096 as the maximum number of tokens for one query (https://platform.openai.com/docs/guides/chat/introduction)

# Calculate number of tokens per query
# https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them
# English: 1 token ~ 4 characters

# Own calculations based on https://platform.openai.com/tokenizer
# German: 1 token ~ 2.6 characters
business_legislative_period_51$chatgpt_query_n_tokens <- nchar(business_legislative_period_51$chatgpt_query_smartspider_precise) / 2.6
max(business_legislative_period_51$chatgpt_query_n_tokens) # The longest query has 1843 tokens, leaving 2253 tokens for a response


# Calculate API Costs -----------------------------------------------------

# https://openai.com/pricing
# gpt-3.5-turbo:	$0.002 / 1K tokens

# Sum of queries and returning tokens
token_sum <- round(sum(business_legislative_period_51$chatgpt_query_n_tokens)) + (nrow(business_legislative_period_51) * 100)
round(token_sum / 1000 * 0.002, 2) # Queries will cost about $0.33 in total


