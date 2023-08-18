
# Load Businesses ---------------------------------------------------------------

load(here("data", "all_businesses_and_tags_230703.RData"))
all_businesses_and_tags_230703 <- all_businesses
rm(all_businesses)

load(here("data", "all_businesses_and_clean_tags_230703.RData"))
all_businesses_and_clean_tags_230703 <- all_businesses
rm(all_businesses)

load(here("data", "all_businesses_and_summaries.RData"))
all_businesses_and_summaries <- all_businesses
rm(all_businesses)


# Load Topic Probabilities ---------------------------------------------------------------

topic_probs <- read.csv(here("scripts", "07_BERTopic", "ss_probs_data", "probs.csv"), header = F)
