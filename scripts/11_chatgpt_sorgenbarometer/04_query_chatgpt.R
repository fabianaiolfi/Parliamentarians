# ChatGPT API Queries


# Connect to ChatGPT -----------------------------------------------------
gpt3_authenticate("ChatGPT_API_Key.txt")

# Check if API is working. Should return "test successful".
# gpt3_test_completion()


# Query ChatGPT -----------------------------------------------------

# Get and format the current timestamp to prevent overwriting files when saving RData locally
timestamp <- Sys.time()
formatted_timestamp <- format(timestamp, "%Y%m%d_%H%M%S")

# Create empty DF to fill up with ChatGPT output
chatgpt_output_df <- data.frame(id = character(0), chatgpt_output = character(0))

# ChatGPT API Query in sleep loop to prevent reaching tokens-per-minute limit of 10'000
for(i in 1:nrow(sergio_sample)) {
  chatgpt_output_summary <- chatgpt(prompt_role_var = sergio_sample$role[i],
                                    prompt_content_var = sergio_sample$prompt[i],
                                    id_var = sergio_sample$id[i],
                                    param_max_tokens = 120,
                                    param_n = 1,
                                    param_temperature = 0,
                                    param_model = "gpt-4")
  # Convert to DF
  chatgpt_output_summary <- do.call(
    rbind,
    Map(data.frame,
        id = chatgpt_output_summary[[1]][["id"]],
        chatgpt_output = chatgpt_output_summary[[1]][["chatgpt_content"]]))

  # Add to main output DF
  chatgpt_output_df <- rbind(chatgpt_output_df, chatgpt_output_summary)

  # Print counter
  print(i)

  # Pause
  Sys.sleep(8)
}
 
file_name <- paste0("chatgpt_output_df_", formatted_timestamp, ".RData")
save(chatgpt_output_df, file = here("data", file_name))
