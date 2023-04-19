# ChatGPT API Queries


# Connect to ChatGPT -----------------------------------------------------
gpt3_authenticate("ChatGPT_API_Key.txt")

# Check if API is working. Should return "test successful".
# gpt3_test_completion()


# Query ChatGPT -----------------------------------------------------

# Get and format the current timestamp to prevent overwriting files when saving RData locally
timestamp <- Sys.time()
formatted_timestamp <- format(timestamp, "%Y%m%d_%H%M%S")

# Query
chatgpt_output <- chatgpt(prompt_role_var = business_legislative_period_51_long$role,
                          prompt_content_var = business_legislative_period_51_long$query,
                          id_var = business_legislative_period_51_long$id,
                          param_max_tokens = 100,
                          param_n = 1,
                          param_temperature = 0)
 
file_name <- paste0("chatgpt_output_", formatted_timestamp, ".RData")
save(chatgpt_output, file = here("data", file_name))
