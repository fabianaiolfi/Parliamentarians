
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
load(here("data", "chatgpt_output_df_20231231_091842.RData"))
chatgpt_output_df_20231231_091842 <- chatgpt_output_df

load(here("data", "chatgpt_output_df_20231231_110101.RData"))
chatgpt_output_df_20231231_110101 <- chatgpt_output_df

rm(chatgpt_output_df)

chatgpt_output_df <- bind_rows(chatgpt_output_df_20231231_091842, chatgpt_output_df_20231231_110101)

# Merge with original dataframe
output_merged <- prompt_vote_statement_sorge_sample %>%
  left_join(chatgpt_output_df, by = "id")
