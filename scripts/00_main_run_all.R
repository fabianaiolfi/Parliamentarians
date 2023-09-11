
# Clear enivronment ------------------------------------------

rm(list=ls())


# Load parl data ------------------------------------------

# source(here("scripts", "01_get_parl_data.R"))
source(here("scripts", "02_load_parl_data.R"))
# source(here("scripts", "03_sample_all_businesses.R")) # Create sample for testing
rm(list = setdiff(ls(), c("all_businesses")))


# 02 ChatGPT Summarisation ------------------------------------------

source(here("scripts", "02_chatgpt_summarisation", "03_pre_processing.R"))
# source(here("scripts", "02_chatgpt_summarisation", "05_query_chatgpt.R"))
source(here("scripts", "02_chatgpt_summarisation", "06_post_processing.R"))
rm(list = setdiff(ls(), c("all_businesses")))


# 05 ChatGPT Tagging ------------------------------------------

source(here("scripts", "05_chatgpt_tagging", "03_pre_processing.R"))
# # source(here("scripts", "05_chatgpt_tagging", "05_query_chatgpt.R"))
source(here("scripts", "05_chatgpt_tagging", "06b_post_processing_BERTopic.R"))
# # source(here("scripts", "05_chatgpt_tagging", "07_evaluation.R"))
source(here("scripts", "05_chatgpt_tagging", "08b_cleaning_BERTopic.R"))
# # source(here("scripts", "05_chatgpt_tagging", "09_input_files.R"))
# # source(here("scripts", "05_chatgpt_tagging", "10_embed.R"))
# # source(here("scripts", "05_chatgpt_tagging", "11_clustering.R"))
# # source(here("scripts", "05_chatgpt_tagging", "12_output.R"))
rm(list = setdiff(ls(), c("all_businesses")))


# 07 BERTopic ------------------------------------------

# Pick pipeline
#version <- "v230820"
#version <- "v230827"
version <- "v230828"

source(here("scripts", "07_BERTopic", version, "01_pre_process_BERT.R"))
rm(list = setdiff(ls(), c("all_businesses", "version")))
# 02_BERTopic.ipynb
source(here("scripts", "07_BERTopic", version, "03_post_process_BERT.R"))
# source(here("scripts", "07_BERTopic", version, "04_topic_name_generation.R"))
#source(here("scripts", "07_BERTopic", version, "05_evaluation.R"))
source(here("scripts", "07_BERTopic", version, "06_topic_consolidation.R"))


# 10 Web Data ------------------------------------------

source(here("scripts", "10_web_data", "01_load_data.R"))
source(here("scripts", "10_web_data", "02_preprocessing.R"))
source(here("scripts", "10_web_data", "03_export.R"))

