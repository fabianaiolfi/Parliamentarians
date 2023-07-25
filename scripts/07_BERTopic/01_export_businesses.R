
# Load Businesses ---------------------------------------------------------------

load(here("data", "all_businesses_and_tags_230703.RData"))
all_businesses_and_tags_230703 <- all_businesses
rm(all_businesses)

load(here("data", "all_businesses_and_clean_tags_230703.RData"))
all_businesses_and_clean_tags_230703 <- all_businesses
rm(all_businesses)

load(here("data", "all_businesses_and_summaries.RData"))
all_businesses_and_summaries <- all_businesses
rm(all_businesses)


# Merge Data ---------------------------------------------------------------

all_businesses_and_tags_230703 <- all_businesses_and_tags_230703 %>% select(BusinessShortNumber,
                                                                            Title,
                                                                            InitialSituation_clean,
                                                                            ResponsibleDepartmentName,
                                                                            TagNames)

all_businesses_and_tags_230703 <- all_businesses_and_tags_230703 %>%
  mutate(main_tag = TagNames) %>% # Save main tag
  mutate(main_tag = gsub("\\|.*", "", main_tag)) %>%
  separate_rows(main_tag, sep = "\\|") %>% # Transform column to have one tag per row
  mutate(TagNames = gsub("\\|", " ", TagNames))

all_businesses_and_clean_tags_230703 <- all_businesses_and_clean_tags_230703 %>% select(BusinessShortNumber, chatgpt_tags_clean)

all_businesses_and_summaries <- all_businesses_and_summaries %>% select(BusinessShortNumber, chatgpt_summaries)

all_businesses <- all_businesses_and_tags_230703 %>% 
  left_join(all_businesses_and_clean_tags_230703, by = "BusinessShortNumber") %>% 
  left_join(all_businesses_and_summaries, by = "BusinessShortNumber")


# Clean Data ---------------------------------------------------------------

all_businesses$chatgpt_tags_clean <- gsub("\\b\\d\\b", "", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("\\.\\s", "", all_businesses$chatgpt_tags_clean)



# Export Data ---------------------------------------------------------------

all_businesses_export <- all_businesses
all_businesses_export$BusinessShortNumber <- NULL
all_businesses_export <- all_businesses_export %>% unite(all, sep = " ", remove = T, na.rm = T)

write.table(all_businesses_export,
            sep = "\t",
            here("scripts", "07_BERTopic", "all_businesses.tsv"),
            row.names = F, col.names = F, quote = F)
