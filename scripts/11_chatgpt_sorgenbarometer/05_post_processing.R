
# Post process ChatGPT Output -------------------------------------------------------

# Sergio Sample
# Problem: Left join matching is broken because "Aussenwirtschaftspolitik Berichte" have been removed and further terms have been added to each "Sorge"

# # Load ChatGPT Data
# load(here("data", "chatgpt_output_df_20231016_213823.RData"))
# chatgpt_output_df_20231016_213823 <- chatgpt_output_df
# rm(chatgpt_output_df)
# 
# # Merge with original dataframe
# output_merged_sergio_sample <- sergio_sample %>%
#   left_join(chatgpt_output_df_20231016_213823, by = "id")

# Working Sample
load(here("data", "chatgpt_output_df_20231020_155001.RData"))
chatgpt_output_df_20231020_155001 <- chatgpt_output_df
rm(chatgpt_output_df)

# Merge with original dataframe
output_merged <- prompt_vote_statement_sorge_sample %>%
  left_join(chatgpt_output_df_20231020_155001, by = "id")
