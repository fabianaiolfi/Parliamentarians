
# Output for Web App -------------------------------------------------------


## Parliamentarian Name Dropdown ----------------------------

names <- output_merged %>% 
  select(PersonNumber, FirstName, LastName, CantonName) %>% 
  distinct(PersonNumber, .keep_all = T)

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
  select(BusinessShortNumber, chatgpt_summary, vote_statement) %>% 
  rename(summary = chatgpt_summary)

json_data <- toJSON(setNames(lapply(seq_len(nrow(bsn_summary_statement)), function(i) {
  bsn_summary_statement[i, c("summary", "vote_statement")]
}), bsn_summary_statement$BusinessShortNumber), pretty = TRUE)


# Output
write(json_data, here("scripts", "11_chatgpt_sorgenbarometer", "bsn_summary_statement.json"))
