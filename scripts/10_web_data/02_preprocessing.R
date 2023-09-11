
# Preprocess data for web ------------------------------

# Create vote statement

all_businesses_web <- all_businesses_web %>% 
  mutate(vote_statement = gsub("\\[Politiker X\\] stimmt für ", "", chatgpt_vote_yes)) %>% 
  select(-chatgpt_vote_yes)


# Adjust Ja / Nein / Enthaltung

voting_all_periods_edit <- voting_all_periods %>% 
  mutate(DecisionText = case_when(DecisionText == "Ja" ~ "Stimmte für ",
                                  DecisionText == "Nein" ~ "Stimmte gegen ",
                                  DecisionText == "Hat nicht teilgenommen" ~ "Keine Teilnahme in Bezug auf ",
                                  DecisionText == "Enthaltung" ~ "Enthielt sich in Bezug auf ",
                                  DecisionText == "Entschuldigt gemäss Art. 57 Abs. 4" ~ "Keine Teilnahme in Bezug auf ",
                                  DecisionText == "Demissioniert" ~ "Keine Teilnahme in Bezug auf ",
                                  DecisionText == "Die Präsidentin/der Präsident stimmt nicht" ~ "Keine Teilnahme in Bezug auf "))


# Process DF for vue.js JSON ------------------------------

voting_all_periods_vue <- voting_all_periods_edit %>% 
  select(-DecisionText) %>% 
  group_by(PersonNumber, FirstName, LastName, CantonName) %>%
  summarise(BusinessShortNumbers = list(BusinessShortNumber)) %>% 
  mutate(full_name = paste0(FirstName, " ", LastName, " (", CantonName, ")")) %>% 
  ungroup() %>% 
  select(full_name, BusinessShortNumbers) %>% 
  mutate(full_name = tolower(full_name)) %>% 
  rename(key = full_name,
         value = BusinessShortNumbers)

# First, rename and select the relevant columns to match the desired output
all_businesses_vue <- all_businesses_web %>% 
  rename(Summary = chatgpt_summary, 
         Statement = vote_statement) %>% 
  mutate(BusinessShortNumber_card = BusinessShortNumber) %>% 
  select(BusinessShortNumber, BusinessShortNumber_card, Title, Summary, Statement)

# Next, group by BusinessShortNumber and create a list column containing the relevant rows
all_businesses_vue <- all_businesses_vue %>%
  group_by(BusinessShortNumber) %>%
  summarise(data = list(as.data.frame(cur_data())))

# Create name list for Select Dropdown with Search Field
names_search_select <- voting_all_periods_edit %>% 
  distinct(PersonNumber, .keep_all = T) %>% 
  select(FirstName, LastName, CantonName) %>% 
  mutate(full_name_label = paste0(FirstName, " ", LastName, " (", CantonName, ")")) %>% 
  mutate(full_name_value = tolower(full_name_label)) %>% 
  select(full_name_value, full_name_label) %>% 
  rename(value = full_name_value,
         label = full_name_label)


# Create JSON for vote statement
vote_statement_vue <- voting_all_periods_edit %>% 
  select(-PersonNumber) %>%
  mutate(full_name = paste0(FirstName, " ", LastName, " (", CantonName, ")")) %>% 
  mutate(full_name = tolower(full_name)) %>%
  select(full_name, DecisionText, BusinessShortNumber)

vote_statement_vue <- vote_statement_vue %>% 
  left_join(select(all_businesses_web, BusinessShortNumber, vote_statement, Title, chatgpt_summary, chatgpt_topic), by = "BusinessShortNumber") %>% 
  mutate(vote_statement = paste0(DecisionText, vote_statement)) %>% 
  select(-DecisionText)


# BusinessShortNumber URLs ------------------------------

bsn_url <- all_businesses %>%
  select(ID, BusinessShortNumber) %>% 
  mutate(url = paste0('https://www.parlament.ch/de/ratsbetrieb/suche-curia-vista/geschaeft?AffairId=', ID)) %>% 
  select(-ID)
