
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
