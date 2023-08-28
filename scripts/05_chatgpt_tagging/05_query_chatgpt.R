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
chatgpt_output_df <- data.frame(id = character(0), chatgpt_tags = character(0))

# ChatGPT API Query in sleep loop to prevent reaching tokens-per-minute limit of 10'000
for(i in 1:nrow(all_businesses_long)) {
  chatgpt_output_tags <- chatgpt(prompt_role_var = all_businesses_long$role[i],
                                    prompt_content_var = all_businesses_long$query[i],
                                    id_var = all_businesses_long$id[i],
                                    param_max_tokens = 100,
                                    param_n = 1,
                                    param_temperature = 0,
                                    param_model = "gpt-4")
  # Convert to DF
  chatgpt_output_tags <- do.call(
    rbind,
    Map(data.frame,
        id = chatgpt_output_tags[[1]][["id"]],
        chatgpt_tags = chatgpt_output_tags[[1]][["chatgpt_content"]]))
  
  # Add to main output DF
  chatgpt_output_df <- rbind(chatgpt_output_df, chatgpt_output_tags)
  
  # Print counter
  print(i)
  
  # Pause
  Sys.sleep(15)
}


# Add Manual Output -----------------------------------------------------
# One item of business failed to produce an output due to an error on ChatGPT's side

# Create a new row as a data frame
new_row <- data.frame(id = "09.437-chatgpt_query_tags",
                      chatgpt_tags = "1. Fraktionsfinanzierung\n2. Gesetzliche Grundlagen\n3. Beitragserhöhung\n4. Mehrkosten\n5. Verantwortlichkeiten\n6. Bundesrat-Stellungnahme\n7. Zweckbindung der Gelder\n8. Finanzpolitische Abwägungen\n9. Parlamentsbetrieb\n10. Verwaltungsdelegation\n")

# Add the new row to the original data frame
chatgpt_output_df <- rbind(chatgpt_output_df, new_row)


# Save to File -----------------------------------------------------

file_name <- paste0("chatgpt_output_df_", formatted_timestamp, ".RData")
save(chatgpt_output_df, file = here("data", file_name))
