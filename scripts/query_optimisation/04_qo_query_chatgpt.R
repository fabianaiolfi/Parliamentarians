# Get Summaries from ChatGPT

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
# 
# save(chatgpt_output, file = paste0("data/chatgpt_output_", formatted_timestamp, ".RData"))
