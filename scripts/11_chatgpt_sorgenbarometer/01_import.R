
# Import ------------------------------------------------------------------

# From "10_web_data"
source(here("scripts", "10_web_data", "01_load_data.R"))
source(here("scripts", "10_web_data", "02_preprocessing.R"))

# All businesses with ChatGPT tags
load(here("scripts", "05_chatgpt_tagging", "chatgpt_tagging_output", "all_businesses_eval.RData"))
