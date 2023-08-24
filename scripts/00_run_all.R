
# Clear enivronment ------------------------------------------

rm(list=ls())


# Load parl data ------------------------------------------

# source(here("scripts", "01_get_parl_data.R"))
source(here("scripts", "02_load_parl_data.R"))
rm(list = setdiff(ls(), c("all_businesses")))


# 02 ChatGPT Summarisation ------------------------------------------

source(here("scripts", "02_chatgpt_summarisation", "03_pre_processing.R"))
# source(here("scripts", "02_chatgpt_summarisation", "04_chatgpt_precautions.R"))
# source(here("scripts", "02_chatgpt_summarisation", "05_query_chatgpt.R"))
source(here("scripts", "02_chatgpt_summarisation", "06_post_processing.R"))
rm(list = setdiff(ls(), c("all_businesses")))


# 05 ChatGPT Tagging ------------------------------------------

source(here("scripts", "05_chatgpt_tagging", "03_pre_processing.R"))
source(here("scripts", "05_chatgpt_tagging", "05_query_chatgpt.R"))
source(here("scripts", "05_chatgpt_tagging", "06_post_processing.R"))
# source(here("scripts", "05_chatgpt_tagging", "07_evaluation.R"))
# source(here("scripts", "05_chatgpt_tagging", "08_cleaning.R"))
# source(here("scripts", "05_chatgpt_tagging", "09_input_files.R"))
# source(here("scripts", "05_chatgpt_tagging", "10_embed.R"))
# source(here("scripts", "05_chatgpt_tagging", "11_clustering.R"))
source(here("scripts", "05_chatgpt_tagging", "12_output.R"))


# 07 BERTopic ------------------------------------------

source(here("scripts", "07_BERTopic", "01_pre_process_BERT.R"))
# 02_BERTopic.ipynb
source(here("scripts", "07_BERTopic", "03_post_process_BERT.R"))
source(here("scripts", "07_BERTopic", "04_topic_name_generation.R"))
source(here("scripts", "07_BERTopic", "05_evaluation.R"))




