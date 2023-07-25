
# Load Businesses ---------------------------------------------------------------

load(here("data", "all_businesses_and_tags_230703.RData"))


# Export Data ---------------------------------------------------------------

initial_situation <- all_businesses %>% select(InitialSituation_clean)
write.table(initial_situation,
            sep = "\t",
            here("scripts", "07_BERTopic", "initial_situation.csv"),
            row.names = F, col.names = F, quote = F)
