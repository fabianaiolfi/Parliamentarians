
# Preprocess data for web ------------------------------

# Create vote statement

all_businesses_web <- all_businesses_web %>% 
  mutate(vote_statement = gsub("\\[Politiker X\\] stimmt für ", "", chatgpt_vote_yes)) %>% 
  select(-chatgpt_vote_yes)


# Adjust Ja / Nein / Enthaltung

voting_all_periods_edit <- voting_all_periods %>% 
  mutate(DecisionText = case_when(DecisionText == "Ja" ~ "Stimmte für ",
                                  DecisionText == "Nein" ~ "Stimmte gegen ",
                                  DecisionText == "Hat nicht teilgenommen" ~ "Nahm nicht teil an ",
                                  DecisionText == "Enthaltung" ~ "Enthielt sich zu ",
                                  DecisionText == "Entschuldigt gemäss Art. 57 Abs. 4" ~ "Nahm nicht teil an ",
                                  DecisionText == "Demissioniert" ~ "Nahm nicht teil an ",
                                  DecisionText == "Die Präsidentin/der Präsident stimmt nicht" ~ "Nahm nicht teil an "))


# Process DF for vue.js ------------------------------

voting_all_periods_vue <- voting_all_periods_edit %>% 
  select(-DecisionText) %>% 
  group_by(PersonNumber, FirstName, LastName, CantonName) %>%
  summarise(BusinessShortNumbers = list(BusinessShortNumber)) %>% 
  mutate(full_name = paste0(FirstName, " ", LastName, " (", CantonName, ")")) %>% 
  ungroup() %>% 
  select(full_name, BusinessShortNumbers) %>% 
  rename(key = full_name,
         value = BusinessShortNumbers)

# First, rename and select the relevant columns to match the desired output
all_businesses_vue <- all_businesses_web %>% 
  rename(#Title = chatgpt_topic, 
         Summary = chatgpt_summary, 
         Statement = vote_statement) %>% 
  select(BusinessShortNumber, Summary, Statement)

# Next, group by BusinessShortNumber and create a list column containing the relevant rows
all_businesses_vue <- all_businesses_vue %>%
  group_by(BusinessShortNumber) %>%
  summarise(data = list(as.data.frame(cur_data())))
