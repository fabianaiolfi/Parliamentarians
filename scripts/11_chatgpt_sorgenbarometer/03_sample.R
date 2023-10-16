
# Subset  ---------------------------------------------------------------------
# Create a subset of all prompt_vote_statement_sorge

# prompt_subset <- prompt_vote_statement_sorge %>% 
#   dplyr::filter(bullet_count >= 4 & bullet_count <= 8) # Keeps 22 Sorgen and 530 Parliamentarians


# Sample  ---------------------------------------------------------------------
# Create sample for testing purposes

set.seed(42)

sergio_list <- c("von Falkenstein", "Wyss", "Atici", "Arslan", "Christ") # Patricia von Falkenstein, Sarah Wyss, Mustafa Atici, Sibel Arslan und Katja Christ

sergio_sample <- prompt_vote_statement_sorge %>% 
  dplyr::filter(CantonName == "Basel-Stadt") %>% 
  dplyr::filter(LastName %in% sergio_list) %>% 
  select(prompt, FirstName, LastName, CantonName, sorge_long) %>% 
  mutate(role = "user") %>% 
  mutate(id = row_number())

# Mini sample
#sergio_sample <- sample_n(sergio_sample, size = 3)
