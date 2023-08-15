
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

# Remove any rows containing NAs in relevant columns
all_businesses <- all_businesses %>% drop_na(InitialSituation_clean,
                                             main_tag,
                                             chatgpt_tags_clean,
                                             chatgpt_summaries)

all_businesses <- all_businesses %>% dplyr::filter(chatgpt_tags_clean != "NA")


# Export Data ---------------------------------------------------------------

all_businesses_export <- all_businesses
all_businesses_export$BusinessShortNumber <- NULL

# Unite all columns for plain vanilla topic modelling
#all_businesses_export <- all_businesses_export %>% unite(all, sep = " ", remove = T, na.rm = T)

# Keep main_tag in seperate column for semi-supervised modelling
#all_businesses_export <- all_businesses_export %>% unite("all", -main_tag, sep = " ", remove = T, na.rm = T)

# Keep TagNames in seperate column for semi-supervised modelling
all_businesses_export <- all_businesses_export %>% unite("all", -TagNames, sep = " ", remove = T, na.rm = T)

write.table(all_businesses_export,
            sep = "\t",
            here("scripts", "07_BERTopic", "all_businesses_04.tsv"),
            row.names = F, col.names = T, quote = F)
