# ChatGPT API Queries


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


# Convert Output to dataframe -----------------------------------------------------
# Support: https://stackoverflow.com/a/28630369

# chatgpt_output <- do.call(
#   rbind,
#   Map(data.frame,
#       BusinessShortNumber = sample_chatgpt_query[[1]][["id"]],
#       content = sample_chatgpt_query[[1]][["chatgpt_content"]]))

# # Separate numbered bullet points and spread them over separate columns (Source: ChatGPT)
# chatgpt_output <- chatgpt_output %>%
#   separate(content,
#            into = c("Point_1", "Point_2", "Point_3"),
#            sep = "\\s+(?=(1|2|3)\\.\\s)",
#            remove = TRUE, convert = TRUE, extra = "merge", fill = "right")
# 
# # Merge ChatGPT output dataframe together with Business dataframe
# business_legislative_period_51 <- business_legislative_period_51 %>% 
#   left_join(chatgpt_output, by = "BusinessShortNumber")