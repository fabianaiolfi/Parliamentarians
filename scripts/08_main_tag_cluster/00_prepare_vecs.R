
# Load All Businesses -------------------------------------------------------------------

load(file = here("data", "all_businesses.RData"))

# Import Embeddings -------------------------------------------------------------------

# Load previously saved embeddings
load(here("data", "all_vecs_230703.Rda"))

# Embeddings from 05_chatgpt_tagging
chatgpt_tags <- read_delim(here("scripts", "05_chatgpt_tagging", "vec_files", "chatgpt_tags.txt"), delim = " ", col_names = FALSE)
chatgpt_tags$X301 <- NULL


# Clean Embeddings -------------------------------------------------------------------

# Remove ".txt" from the file_name column
for (i in seq_along(all_vecs)) {
  all_vecs[[i]]$file_name <- gsub("\\.txt$", "", all_vecs[[i]]$file_name)
}

# NAs in the text should have a embedding value of 0
# Replace NAs with 0
all_vecs <- lapply(all_vecs, function(df) {
  df[is.na(df)] <- 0
  return(df)
})



# Create weighted sum of all features -------------------------------------------------------------------

# Get DF names
all_vecs_df_names <- c()

for (i in seq_along(all_vecs)) {
  current_df <- all_vecs[[i]]
  all_vecs_df_names <- append(all_vecs_df_names, current_df$file_name[1])
}

all_vecs_df_names <- as.data.frame(all_vecs_df_names)
all_vecs_df_names <- all_vecs_df_names %>% rowid_to_column("index")

# Remove first two colums of each dataframe
# Iterate over each dataframe in the list
for (i in seq_along(all_vecs)) {
  # Get the current dataframe
  current_df <- all_vecs[[i]]
  
  # Remove the first column in the current dataframe
  current_df <- subset(current_df, select = -1)
  
  # Update the current dataframe in all_vecs with the modified dataframe
  all_vecs[[i]] <- current_df
}

# Sum up weighted embeddings
combined_vecs <- all_vecs[[1]]*0.1 + # BusinessTypeName
  #all_vecs[[3]]*0.1 + # chatgpt_summaries_lemma
  all_vecs[[4]]*0.8 + # chatgpt_summaries
  all_vecs[[5]]*0.1 + # Description
  all_vecs[[6]]*0.1 + # FirstCouncil1Name
  all_vecs[[8]] + # InitialSituation_lemma
  #all_vecs[[10]]*0.1 + # main_tag
  all_vecs[[11]]*0.1 + # Proceedings_lemma
  all_vecs[[13]]*0.1 + # ReasonText_lemma
  all_vecs[[15]]*0.1 + # ResponsibleDepartmentName
  all_vecs[[16]]*0.1 + # SubmissionCouncilName
  all_vecs[[17]]*0.1 + # SubmittedBy
  all_vecs[[18]]*0.1 + # SubmittedText_lemma
  all_vecs[[20]]*0.1 + # TagNames
  all_vecs[[21]]*0.8 + # Title
  chatgpt_tags
