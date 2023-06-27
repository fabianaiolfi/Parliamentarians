# Some precautions to take before sending the request to the ChatGPT API

# Truncate Long Query ---------------------------------------------------------------
# The model gpt-3.5-turbo-0301 sets 4096 as the maximum number of tokens for one query (https://platform.openai.com/docs/guides/chat/introduction)

# Calculate number of tokens per query
# https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them
# English: 1 token ~ 4 characters

# Own calculations based on https://platform.openai.com/tokenizer
# German: 1 token ~ 2.6 characters
all_businesses$chatgpt_query_n_tokens <- nchar(all_businesses$chatgpt_query_central_stmnt) / 2.6
max(all_businesses$chatgpt_query_n_tokens, na.rm = T) # The longest query has 5190 tokens. Leaving as is for the time being, this bill will simply not have a summary.
#all_businesses <- all_businesses %>% dplyr::filter(chatgpt_query_n_tokens < 4000)

# Calculate API Costs -----------------------------------------------------

# https://openai.com/pricing
# gpt-3.5-turbo: ~ $0.0015 / 1K tokens

# Sum of queries and returning tokens
chatgpt_summaries$chatgpt_query_n_tokens <- nchar(chatgpt_summaries$chatgpt_summaries) / 2.6
token_sum <- round(sum(all_businesses$chatgpt_query_n_tokens)) + (sum(chatgpt_summaries$chatgpt_query_n_tokens, na.rm = T))
round(token_sum / 1000 * 0.002, 2) # Queries will cost about $1.47 in total
