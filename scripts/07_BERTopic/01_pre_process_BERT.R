
# Pre-process items of business for BERTopic ---------------------------------------------------------------


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

all_businesses_and_clean_tags_230703 <- all_businesses_and_clean_tags_230703 %>% select(BusinessShortNumber,
                                                                                        chatgpt_tags_clean)

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

# Add index
all_businesses <- tibble::rowid_to_column(all_businesses, "index")


# Export Data ---------------------------------------------------------------

# Create export TSV and change order of columns for BERTopic
all_businesses_export <- all_businesses %>% 
  select(index,
         BusinessShortNumber,
         Title,
         chatgpt_summaries,
         main_tag,
         chatgpt_tags_clean,
         InitialSituation_clean,
         ResponsibleDepartmentName,
         TagNames)

#all_businesses_export$BusinessShortNumber <- NULL
all_businesses_export$index <- NULL

# Keep TagNames in seperate column for semi-supervised modelling
all_businesses_export <- all_businesses_export %>% unite("all", -BusinessShortNumber, -TagNames, sep = " ", remove = T, na.rm = T)

write.table(all_businesses_export,
            sep = "\t",
            here("scripts", "07_BERTopic", "data", "all_businesses.tsv"),
            row.names = F, col.names = T, quote = F)


# Clean Up Environment ---------------------------------------------------------------

rm(list=setdiff(ls(), "all_businesses"))
