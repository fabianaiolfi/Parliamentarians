# Some precautions to take before sending the request to the ChatGPT API

# Truncate Long Query ---------------------------------------------------------------
# The model gpt-4 sets 8,192 as the maximum number of tokens for one query (https://platform.openai.com/docs/guides/chat/introduction)

# Calculate number of tokens per query
# https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them
# English: 1 token ~ 4 characters

# Own calculations based on https://platform.openai.com/tokenizer
# German: 1 token ~ 2.6 characters
all_businesses$chatgpt_query_n_tokens <- nchar(all_businesses$chatgpt_query_central_stmnt) / 2.6
max(all_businesses$chatgpt_query_n_tokens, na.rm = T) # The longest query has 5190 tokens. All good.


# Calculate API Costs -----------------------------------------------------

# https://openai.com/pricing
# gpt-3.5-turbo: ~ $0.0015 / 1K tokens
# gpt-4: ~ $0.04 / 1K tokens

# Sum of queries and returning tokens
# Run 06_post_processing.R to get objects
all_businesses$chatgpt_answer_n_tokens <- nchar(all_businesses$chatgpt_summaries) / 2.6
token_sum <- round(sum(all_businesses$chatgpt_answer_n_tokens, na.rm = T)) + (sum(all_businesses$chatgpt_query_n_tokens, na.rm = T))
round(token_sum / 1000 * 0.04, 2) # Queries will cost about $30 in total


# Summary Length Check -----------------------------------------------------
len_check <- all_businesses_long %>% mutate(length = nchar(query) / 2.6)
summary(len_check$length)
# How long should Sys.sleep() be?
60/(10000/2000) # 15 sec
(15*672)/60/60 # 3h for summaries
(7*180)/60 # 21min for topic name generation
98/3

sum(len_check$length)
787256.9 / 1000 * 0.03 # ~32$ for summaries
750296.9 / 1000 * 0.03 # ~22$ for tags
60510.77 / 1000 * 0.035 # ~2.1$
91968.08 / 1000 * 0.035 # ~3.2$

cat(all_businesses_long$query[584])


# gpt-3.5 vs gpt-4 -----------------------------------------------------
# Is gpt-4 really that much better than gpt-3.5?
set.seed(42)
summary_sample <- all_businesses_long %>% slice_sample(n = 5)

# Request lengths (https://platform.openai.com/account/rate-limits)
req_lengths <- summary_sample %>% 
  mutate(length = nchar(query) / 2.6)
sum(req_lengths$length) # Shouldn't be a problem for summary_sample
mean(req_lengths$length) # ~ 2-3h for gpt-4

# Connect to ChatGPT
gpt3_authenticate("ChatGPT_API_Key.txt")

# Query ChatGPT
# Get and format the current timestamp to prevent overwriting files when saving RData locally
timestamp <- Sys.time()
formatted_timestamp <- format(timestamp, "%Y%m%d_%H%M%S")

# Query
# chatgpt_3_5_output <- chatgpt(prompt_role_var = summary_sample$role,
chatgpt_4_output <- chatgpt(prompt_role_var = summary_sample$role,
                          prompt_content_var = summary_sample$query,
                          id_var = summary_sample$id,
                          param_max_tokens = 100,
                          param_n = 1,
                          param_temperature = 0,
                          # param_model = "gpt-3.5-turbo")
                          param_model = "gpt-4")

#file_name <- paste0("chatgpt_output_3_5_", formatted_timestamp, ".RData")
#save(chatgpt_3_5_output, file = here("data", file_name))
file_name <- paste0("chatgpt_output_4_", formatted_timestamp, ".RData")
save(chatgpt_4_output, file = here("data", file_name))

# Convert ChatGPT-3.5 output to dataframe
chatgpt_3_5_output <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_3_5_output[[1]][["id"]],
      content = chatgpt_3_5_output[[1]][["chatgpt_content"]]))
# Split business short number and query type
chatgpt_3_5_output <- chatgpt_3_5_output %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))

# Convert ChatGPT-4 output to dataframe
chatgpt_4_output <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_4_output[[1]][["id"]],
      content = chatgpt_4_output[[1]][["chatgpt_content"]]))
# Split business short number and query type
chatgpt_4_output <- chatgpt_4_output %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))

