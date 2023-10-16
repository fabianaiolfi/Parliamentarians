
# Post process ChatGPT Output -------------------------------------------------------


# Load ChatGPT Data -------------------------------------------------------
load(here("data", "chatgpt_output_df_20231016_213823.RData"))


# Merge with original dataframe -------------------------------------------------------

output_merged <- sergio_sample %>% 
  left_join(chatgpt_output_df, by = "id")
