# Post process ChatGPT Output
load(here("data", "chatgpt_output_20230411_232430.RData"))
chatgpt_output_20230411_232430 <- chatgpt_output

load(here("data", "chatgpt_output_20230418_170140.RData"))
chatgpt_output_20230418_170140 <- chatgpt_output

load(here("data", "chatgpt_output_20230418_210755.RData"))
chatgpt_output_20230418_210755 <- chatgpt_output

rm(chatgpt_output)

# Convert ChatGPT output to dataframe (Source: https://stackoverflow.com/a/28630369 )
chatgpt_output_df_20230411_232430 <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_output_20230411_232430[[1]][["id"]],
      content = chatgpt_output_20230411_232430[[1]][["chatgpt_content"]]))

chatgpt_output_df_20230418_170140 <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_output_20230418_170140[[1]][["id"]],
      content = chatgpt_output_20230418_170140[[1]][["chatgpt_content"]]))

chatgpt_output_df_20230418_210755 <- do.call(
  rbind,
  Map(data.frame,
      BusinessShortNumber = chatgpt_output_20230418_210755[[1]][["id"]],
      content = chatgpt_output_20230418_210755[[1]][["chatgpt_content"]]))

# Split business short number and query type
chatgpt_output_df_20230411_232430 <- chatgpt_output_df_20230411_232430 %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))

chatgpt_output_df_20230418_170140 <- chatgpt_output_df_20230418_170140 %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))

chatgpt_output_df_20230418_210755 <- chatgpt_output_df_20230418_210755 %>% 
  separate_wider_delim(BusinessShortNumber, delim = "-chatgpt_", names = c("BusinessShortNumber", "query_type"))

chatgpt_output_df <- rbind(chatgpt_output_df_20230411_232430,
                           chatgpt_output_df_20230418_170140,
                           chatgpt_output_df_20230418_210755)
save(chatgpt_output_df, file = here("scripts", "query_optimisation", "qo_shiny_app", "data", "chatgpt_output_df.RData")) # save for Shiny app