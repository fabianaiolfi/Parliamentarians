
# Pre-process items of business for BERTopic ---------------------------------------------------------------


# Add Main Tag ---------------------------------------------------------------

all_businesses <- all_businesses %>%
  mutate(main_tag = TagNames) %>% # Save main tag
  mutate(main_tag = gsub("\\|.*", "", main_tag)) %>%
  separate_rows(main_tag, sep = "\\|") %>% # Transform column to have one tag per row
  mutate(TagNames = gsub("\\|", " ", TagNames))


# Export Data ---------------------------------------------------------------

# Create export TSV and change order of columns for BERTopic
all_businesses_export <- all_businesses %>% 
  select(BusinessShortNumber,
         Title,
         chatgpt_summary,
         main_tag,
         chatgpt_tags_clean,
         InitialSituation_clean,
         ResponsibleDepartmentName,
         TagNames)

# Keep TagNames in seperate column for semi-supervised modelling
all_businesses_export <- all_businesses_export %>% unite("all", -BusinessShortNumber, -TagNames, sep = " ", remove = T, na.rm = T)

write.table(all_businesses_export,
            sep = "\t",
            here("scripts", "07_BERTopic", "data", "all_businesses.tsv"),
            row.names = F, col.names = T, quote = F)
