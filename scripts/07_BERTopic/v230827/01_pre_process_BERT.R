
# Pre-process items of business for BERTopic ---------------------------------------------------------------


# Load Businesses ---------------------------------------------------------------

#load(here("data", "all_businesses_summaries_clean_tags.RData"))


# Add Main Tag ---------------------------------------------------------------

all_businesses <- all_businesses %>%
  mutate(main_tag = TagNames) %>% # Save main tag
  mutate(main_tag = gsub("\\|.*", "", main_tag)) %>%
  separate_rows(main_tag, sep = "\\|") %>% # Transform column to have one tag per row
  mutate(TagNames = gsub("\\|", " ", TagNames))

# Clean Data ---------------------------------------------------------------

# Remove any rows containing NAs in relevant columns
# all_businesses <- all_businesses %>% drop_na(InitialSituation_clean,
#                                              main_tag,
#                                              chatgpt_tags_clean,
#                                              chatgpt_summary)
# 
# all_businesses <- all_businesses %>% dplyr::filter(chatgpt_tags_clean != "NA")


# Export Data ---------------------------------------------------------------

# Create export TSV and change order of columns for BERTopic
all_businesses_export <- all_businesses %>% 
  select(BusinessShortNumber,
         Title,
         chatgpt_summary,
         main_tag,
         #chatgpt_tags_clean,
         InitialSituation_clean,
         ResponsibleDepartmentName,
         TagNames)

# Fake DF for testing
#all_businesses_export <- all_businesses_export %>% uncount(20)
#all_businesses_export <- all_businesses_export %>% mutate(across(everything(), sample))
#all_businesses_export$BusinessShortNumber <- 1:nrow(all_businesses_export)

# Keep TagNames in seperate column for semi-supervised modelling
all_businesses_export <- all_businesses_export %>% unite("all", -BusinessShortNumber, -TagNames, sep = " ", remove = T, na.rm = T)

write.table(all_businesses_export,
            sep = "\t",
            here("scripts", "07_BERTopic", "data", "all_businesses.tsv"),
            row.names = F, col.names = T, quote = F)


# Clean Up Environment ---------------------------------------------------------------

rm(list=setdiff(ls(), "all_businesses"))
