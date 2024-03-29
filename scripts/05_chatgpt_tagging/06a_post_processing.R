# Post process ChatGPT Output


# Load ChatGPT Data -------------------------------------------------------
load(here("data", "chatgpt_output_20230703_213415.RData"))
chatgpt_output_20230419_204609 <- chatgpt_output


# Convert ChatGPT output to dataframe -------------------------------------------------------
# Source: https://stackoverflow.com/a/28630369
chatgpt_output_df <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_output[[1]][["id"]],
      content = chatgpt_output[[1]][["chatgpt_content"]]))

# Split business short number and query type
chatgpt_output_df <- chatgpt_output_df %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))


# Clean ChatGPT output dataframe -------------------------------------------------------
# Convert dataframe
chatgpt_output_df <- chatgpt_output_df %>% 
  pivot_wider(names_from = query_type, values_from = content)

# Custom function to replace entire string with NA if it contains "NA" (ChatGPT)
replace_NA <- function(x) {
  if (is.character(x)) {
    x[grepl("NA", x)] <- NA
  }
  return(x)
}

value_pattern <- "\\b\\d{2}\\b"


# Save files for Shiny App -------------------------------------------------------
# save(business_legislative_period_51, file = here("scripts", "shiny_app", "data", "business_legislative_period_51.RData"))
# save(chatgpt_output_df, file = here("scripts","shiny_app", "data", "chatgpt_output_df.RData"))
# save(member_council_legislative_period_51, file = here("scripts","shiny_app", "data", "member_council_legislative_period_51.RData"))
# save(voting_legislative_period_51, file = here("scripts","shiny_app", "data", "voting_legislative_period_51.RData"))


# Merge with original dataframe -------------------------------------------------------

all_businesses <- all_businesses %>% 
  left_join(chatgpt_output_df, by = "BusinessShortNumber") %>% 
  # Depending which file is loaded
  # rename(chatgpt_tags = chatgpt_query_tags) %>% 
  rename(chatgpt_tags = query_central_stmnt)
