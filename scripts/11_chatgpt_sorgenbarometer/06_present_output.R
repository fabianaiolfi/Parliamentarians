
# Present Output -------------------------------------------------------

output_nice <- output_merged %>% 
  select(FirstName, LastName, sorge_long, chatgpt_output) %>% 
  mutate(name = paste(FirstName, LastName)) %>% 
  select(-FirstName, -LastName)

output_nice_person <- output_nice %>% 
  dplyr::filter(name == "Patricia von Falkenstein") %>% 
  select(-name) %>% 
  mutate(output = paste0("## ", sorge_long, "\n", chatgpt_output, "\n\n"))

cat(output_nice_person$output) # Then copied into Google Doc: https://docs.google.com/document/d/1T1qXafCihzTut5pNjvP_oS0CMu0ZZvobUImOuCcbnSc/edit?usp=sharing
