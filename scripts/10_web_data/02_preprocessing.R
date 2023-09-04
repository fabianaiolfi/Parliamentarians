
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
