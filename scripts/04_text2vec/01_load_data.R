# Load Locally Stored Parliamentary Data ---------------------------------------------------------------
# Only run this script if data has already been downloaded via 01_get_parl_data.R

load(here("data", "all_businesses_and_summaries.RData"))
#load(here("data", "chatgpt_output_20230419_204609.RData"))

ud_model <- udpipe_load_model(here("models", "german-gsd-ud-2.5-191206.udpipe"))
custom_stopwords <- scan(here("data", "custom_stopwords.txt"), character(), sep = "\n")
