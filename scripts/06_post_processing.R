# Post process ChatGPT Output


# Load ChatGPT Data -------------------------------------------------------
load(here("data", "chatgpt_output_20230419_165256.RData"))
chatgpt_output_20230419_165256 <- chatgpt_output
rm(chatgpt_output)


# Convert ChatGPT output to dataframe -------------------------------------------------------
# Source: https://stackoverflow.com/a/28630369
chatgpt_output_df <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_output_20230419_165256[[1]][["id"]],
      content = chatgpt_output_20230419_165256[[1]][["chatgpt_content"]]))

# Split business short number and query type
chatgpt_output_df <- chatgpt_output_df %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))


# Clean ChatGPT output dataframe -------------------------------------------------------
# Convert dataframe
chatgpt_output_df <- chatgpt_output_df %>% 
  pivot_wider(names_from = query_type, values_from = content)

chatgpt_output_df <- chatgpt_output_df %>% 
  separate(query_smartspider_precise,
           into = c("Offene Aussenpolitik",
                    "Liberale Wirtschaftspolitik",
                    "Restriktive Finanzpolitik",
                    "Law & Order",
                    "Restriktive Migrationspolitik",
                    "Ausgebauter Umweltschutz",
                    "Ausgebauter Sozialstaat",
                    "Liberale Gesellschaft"),
           sep = "\n")

# Custom function to replace entire string with NA if it contains "NA" (ChatGPT)
replace_NA <- function(x) {
  if (is.character(x)) {
    x[grepl("NA", x)] <- NA
  }
  return(x)
}

value_pattern <- "\\b\\d{2}\\b"

chatgpt_output_df <- chatgpt_output_df %>%
  mutate_at(vars("Offene Aussenpolitik":"Liberale Gesellschaft"), replace_NA) %>%
  mutate_at(vars("Offene Aussenpolitik":"Liberale Gesellschaft"), list(~str_extract(., value_pattern))) %>% 
  mutate_at(vars("Offene Aussenpolitik":"Liberale Gesellschaft"), as.integer)
