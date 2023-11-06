
# Output for Web App -------------------------------------------------------


## Parliamentarian Name Dropdown ----------------------------

names <- output_merged %>% 
  select(PersonNumber, FirstName, LastName, CantonName) %>% 
  distinct(PersonNumber, .keep_all = T)

# Add party name to each parliamentarian
load(here("data", "member_council.RData"))
names <- names %>% left_join(select(member_council, PersonNumber, PartyAbbreviation), by = "PersonNumber")

# Convert dataframe to list with PersonNumber as names
lst <- split(names[-1], factor(names$PersonNumber, levels = unique(names$PersonNumber)))
named_lst <- setNames(lst, unique(names$PersonNumber))

# Convert list to JSON
json_output <- toJSON(named_lst, pretty = TRUE, auto_unbox = TRUE)

# Output
write(json_output, here("scripts", "11_chatgpt_sorgenbarometer", "names.json"))


## Worry Statement ----------------------------

worry_statement <- output_merged %>% 
  select(PersonNumber, sorge, chatgpt_output)

# Pivot dataframe to wide format
worry_statement <- worry_statement %>% 
  spread(key = sorge, value = chatgpt_output)

# Convert dataframe to list with PersonNumber as names
lst <- setNames(split(worry_statement[-1], worry_statement$PersonNumber), worry_statement$PersonNumber)

# Convert list to JSON
json_output <- toJSON(lst, pretty = TRUE, auto_unbox = TRUE)

# Output
write(json_output, here("scripts", "11_chatgpt_sorgenbarometer", "worry_statement.json"))


## Sorgen and BSNs ----------------------------
# Create a JSON that lists every BSN for each Sorge

sorgen_bsn <- all_businesses_sorgen_merge %>%
  pivot_longer(cols = -BusinessShortNumber, names_to = "topic", values_to = "value") %>%
  dplyr::filter(value) %>%
  group_by(topic) %>%
  summarise(BusinessShortNumber = paste(BusinessShortNumber, collapse = ", "))

# Convert dataframe to named list
named_list <- setNames(as.list(sorgen_bsn$BusinessShortNumber), sorgen_bsn$topic)

# Convert named list to JSON
json_output <- toJSON(named_list, pretty = TRUE)

# Output
write(json_output, here("scripts", "11_chatgpt_sorgenbarometer", "sorgen_bsn.json"))


## Parliamentarians and BSNs ----------------------------
# Which items of business did parliamentarians vote for?

person_bsn_vote <- voting_all_periods_edit %>% 
  select(PersonNumber, DecisionText, BusinessShortNumber)

nested_data <- person_bsn_vote %>%
  group_by(PersonNumber, DecisionText) %>%
  summarise(BusinessShortNumbers = list(BusinessShortNumber)) %>%
  nest(data = c(DecisionText, BusinessShortNumbers)) %>%
  mutate(data = map(data, ~setNames(.x$BusinessShortNumbers, .x$DecisionText))) %>%
  deframe()

# Convert to JSON
json_output <- toJSON(nested_data, pretty = TRUE)

# Output
write(json_output, here("scripts", "11_chatgpt_sorgenbarometer", "person_bsn_vote.json"))


## BSNs, summaries and vote statements ----------------------------
# DF/JSON with summary and vote statement of each item of business

bsn_summary_statement <- all_businesses_web %>%
  select(BusinessShortNumber, Title, chatgpt_summary, vote_statement, # Some confusion about chatgpt_summary and chatgpt_summaries; chatgpt_summary is GPT4 from chatgpt_output_df_20230827_100317.RData
         #associated_word_1, associated_word_2, associated_word_3,
         #context_1, context_2, context_3
         ) %>% 
  rename(summary = chatgpt_summary)

json_data <- toJSON(setNames(lapply(seq_len(nrow(bsn_summary_statement)), function(i) {
  bsn_summary_statement[i, c("Title", "summary", "vote_statement"#,
                             #"associated_word_1", "associated_word_2", "associated_word_3",
                             #"context_1", "context_2", "context_3"
                             )]
}), bsn_summary_statement$BusinessShortNumber), pretty = TRUE)


# Output
write(json_data, here("scripts", "11_chatgpt_sorgenbarometer", "bsn_summary_statement.json"))


## BSN Initial Situation split by sentence ----------------------------
# Used to retrieve context

# You may need to unnest the 'sents' column if it's a list of lists
bsn_sents <- bsn_sents %>%
  mutate(sents = map(sents, ~ as.character(.x)))

# Now, convert the dataframe to a named list
named_list <- setNames(bsn_sents$sents, bsn_sents$BusinessShortNumber)

# Convert the named list to JSON
json_data <- toJSON(named_list, pretty = TRUE, auto_unbox = TRUE)

# If you want to write the JSON to a file
write(json_data, here("scripts", "11_chatgpt_sorgenbarometer", "bsn_sents.json"))


## Topic and associated words ----------------------------
# Used to retrieve context

# Unnest the 'sents' column if it's a list of lists
associated_words <- associated_words %>%
  mutate(words_list = map(words_list, ~ as.character(.x)))

# Now, convert the dataframe to a named list
named_list <- setNames(associated_words$words_list, associated_words$sorge)

# Convert the named list to JSON
json_data <- toJSON(named_list, pretty = TRUE, auto_unbox = TRUE)

# If you want to write the JSON to a file
write(json_data, here("scripts", "11_chatgpt_sorgenbarometer", "topics_associated_words.json"))
