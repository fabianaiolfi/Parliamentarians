
# Sergio Sample  ---------------------------------------------------------------------
# Create sample for Sergio: Parliamentarians currently in Basel Stadt

# set.seed(42)
# 
# sergio_list <- c("von Falkenstein", "Wyss", "Atici", "Arslan", "Christ") # Patricia von Falkenstein, Sarah Wyss, Mustafa Atici, Sibel Arslan und Katja Christ
# 
# sergio_sample <- prompt_vote_statement_sorge %>%
#   dplyr::filter(CantonName == "Basel-Stadt") %>%
#   dplyr::filter(LastName %in% sergio_list) %>%
#   select(prompt, FirstName, LastName, CantonName, sorge_long) %>%
#   mutate(role = "user") %>%
#   mutate(id = row_number())

# # Mini sample for testing API and ChatGPT output
# sergio_sample <- sample_n(sergio_sample, size = 3)


# Working Sample ---------------------------------------------------------------------
# Create sample for working example and keeping API costs low

# set.seed(12)
# 
# PersonNumber_list <- unique(prompt_vote_statement_sorge$PersonNumber)
# PersonNumber_list_sample <- sample(PersonNumber_list, 5)
# 
# prompt_vote_statement_sorge_sample <- prompt_vote_statement_sorge %>%
#   dplyr::filter(PersonNumber %in% PersonNumber_list_sample) %>%
#   mutate(role = "user") %>%
#   mutate(id = row_number())

# Mini sample for testing API and ChatGPT output
# prompt_vote_statement_sorge_sample <- sample_n(prompt_vote_statement_sorge_sample, size = 3)

# Super mini sample
# prompt_vote_statement_sorge_sample <- prompt_vote_statement_sorge_sample[63, ]



# Parliamentarians from Nationalrat ---------------------------------------

load(here("data", "member_council.RData"))

national_councillors <- member_council %>% 
  dplyr::filter(Active == T) %>% 
  dplyr::filter(CouncilName == "Nationalrat")

national_councillors_PersonNumber <- national_councillors$PersonNumber

prompt_vote_statement_sorge_sample <- prompt_vote_statement_sorge %>%
  dplyr::filter(PersonNumber %in% national_councillors_PersonNumber) %>%
  mutate(role = "user") %>%
  mutate(id = row_number())

# Mini sample for testing API and ChatGPT output
# set.seed(12)
# prompt_vote_statement_sorge_sample <- sample_n(prompt_vote_statement_sorge_sample, size = 3)

# remove first 716 rows as they have been done in first batch
# prompt_vote_statement_sorge_sample <- prompt_vote_statement_sorge_sample[-(1:716), ]
