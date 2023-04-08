# Get Summaries from ChatGPT


# Calculate API Costs -----------------------------------------------------

# https://openai.com/pricing
# gpt-3.5-turbo:	$0.002 / 1K tokens
token_sum <- round(sum(business_legislative_period_51$chatgpt_prompt_n_tokens))
round(token_sum / 1000 * 0.002, 2) # Call will cost about $0.30