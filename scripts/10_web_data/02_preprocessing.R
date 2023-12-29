
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

# Add main topic
voting_all_periods_edit <- voting_all_periods_edit %>% 
  left_join(select(all_businesses, BusinessShortNumber, main_topic), by = "BusinessShortNumber")

# Add vote tally to all_businesses_web
vote_tally <- voting_all_periods_edit %>% 
  group_by(BusinessShortNumber) %>% 
  count(DecisionText) %>% 
  mutate(DecisionText = case_when(DecisionText == "Keine Teilnahme in Bezug auf " ~ "no_participation",
                                  DecisionText == "Stimmte für " ~ "yes",
                                  DecisionText == "Stimmte gegen " ~ "no",
                                  DecisionText == "Enthielt sich in Bezug auf " ~ "abstention")) %>% 
  pivot_wider(
    names_from = DecisionText,    # Use DecisionText values as new column names
    values_from = n,             # Fill the new columns with corresponding 'n' values
    values_fill = list(n = 0)    # Fill missing values with 0
  ) %>% 
  mutate(vote_result = case_when(yes > no ~ "yes",
                                 no > yes ~ "no",
                                 T ~ NA)) %>% 
  left_join(select(all_businesses, BusinessShortNumber, BusinessTypeName), by = "BusinessShortNumber") %>% 
  mutate(vote_result_text = case_when(vote_result == "yes" & BusinessTypeName == "Parlamentarische Initiative" | BusinessTypeName == "Standesinitiative" ~ "Die Initiative wurde angenommen",
                                      vote_result == "no" & BusinessTypeName == "Parlamentarische Initiative" | BusinessTypeName == "Standesinitiative" ~ "Die Initiative wurde abgelehnt",
                                      vote_result == "yes" & BusinessTypeName == "Geschäft des Bundesrates" ~ "Das Geschäft wurde angenommen",
                                      vote_result == "no" & BusinessTypeName == "Geschäft des Bundesrates" ~ "Das Geschäft wurde abgelehnt"))

# Add date, ID and submitting person; Generate URL from ID
all_businesses_web <- all_businesses_web %>% 
  left_join(select(all_businesses, BusinessShortNumber, BusinessStatusDate, SubmittedBy, ID), by = "BusinessShortNumber") %>% 
  mutate(business_url = paste0("https://www.parlament.ch/de/ratsbetrieb/suche-curia-vista/geschaeft?AffairId=", ID))

all_businesses_web <- all_businesses_web %>% 
  left_join(vote_tally, by = "BusinessShortNumber")


# Process DF for vue.js JSON ------------------------------

voting_all_periods_vue <- voting_all_periods_edit %>% 
  select(-DecisionText) %>% 
  group_by(PersonNumber, FirstName, LastName, CantonName) %>%
  summarise(BusinessShortNumbers = list(BusinessShortNumber)) %>% 
  mutate(full_name = paste0(FirstName, " ", LastName, " (", CantonName, ")")) %>% 
  ungroup() %>% 
  select(PersonNumber, full_name, BusinessShortNumbers) %>% 
  mutate(full_name = tolower(full_name)) %>% 
  rename(key = full_name,
         value = BusinessShortNumbers)

# First, rename and select the relevant columns to match the desired output
all_businesses_vue <- all_businesses_web %>% 
  rename(Summary = chatgpt_summary, 
         Statement = vote_statement) %>% 
  mutate(BusinessShortNumber_card = BusinessShortNumber) %>% 
  select(BusinessShortNumber, BusinessShortNumber_card, Title, Summary, Statement, main_topic)

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
  mutate(full_name = paste0(FirstName, " ", LastName, " (", CantonName, ")")) %>% 
  mutate(full_name = tolower(full_name)) %>%
  select(PersonNumber, full_name, DecisionText, BusinessShortNumber, main_topic)

vote_statement_vue <- vote_statement_vue %>% 
  left_join(select(all_businesses_web, BusinessShortNumber, vote_statement, Title, chatgpt_summary, chatgpt_topic), by = "BusinessShortNumber") %>% 
  mutate(vote_statement = paste0(DecisionText, vote_statement)) %>% 
  select(-DecisionText)


# BusinessShortNumber URLs ------------------------------

# bsn_url <- all_businesses %>%
#   select(ID, BusinessShortNumber) %>% 
#   mutate(url = paste0('https://www.parlament.ch/de/ratsbetrieb/suche-curia-vista/geschaeft?AffairId=', ID)) %>% 
#   select(-ID)


# Person Number Index ------------------------------

person_number_index <- voting_all_periods %>% 
  select(PersonNumber, FirstName, LastName, CantonName) %>% 
  distinct(PersonNumber, .keep_all = T)
