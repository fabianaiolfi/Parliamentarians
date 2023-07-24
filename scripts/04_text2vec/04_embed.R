

# Setup -------------------------------------------------------------------

list_params <- list(command = 'print-sentence-vectors',
                    model = here("models", "cc.de.300.bin")) # https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.de.300.bin.gz


# Create Embeddings -------------------------------------------------------------------

# Uncomment to create embeddings
for (col in df_colnames) {
  res <- fasttext_interface(list_params,
                            path_input = here("scripts", "text2vec", "fasttext", "input_files", paste0(col, ".txt")),
                            path_output = here("scripts", "text2vec", "fasttext", "vec_files", paste0(col, ".txt")))
}


# Import Embeddings -------------------------------------------------------------------

read_embeddings <- function(file_path) {
  file_name <- basename(file_path)
  embeddings <- read_delim(file_path, delim = " ", col_names = FALSE)
  embeddings <- embeddings %>% mutate(file_name = file_name, .before = X1)  # Add file_name column at the first position
  embeddings$X301 <- NULL
  return(embeddings)
}

file_directory <- here("scripts", "text2vec", "fasttext", "vec_files")
file_paths <- list.files(file_directory, pattern = "\\.txt$", full.names = TRUE)

all_vecs <- lapply(file_paths, read_embeddings)

# Save imported embeddings
save(all_vecs, file = here("data", "all_vecs_230703.Rda"))

# Load previously saved embeddings
load(here("data", "all_vecs_230703.Rda"))


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
  
  # Remove the first 2 columns in the current dataframe
  current_df <- subset(current_df, select = -1)
  
  # Update the current dataframe in all_vecs with the modified dataframe
  all_vecs[[i]] <- current_df
}

# > all_vecs_df_names
# index           all_vecs_df_names
# 1      1            BusinessTypeName
# 2      2 chatgpt_query_central_stmnt
# 3      3     chatgpt_summaries_lemma
# 4      4           chatgpt_summaries
# 5      5                 Description
# 6      6           FirstCouncil1Name
# 7      7      InitialSituation_clean
# 8      8      InitialSituation_lemma
# 9      9            InitialSituation
# 10    10                    main_tag
# 11    11           Proceedings_lemma
# 12    12                 Proceedings
# 13    13            ReasonText_lemma
# 14    14                  ReasonText
# 15    15   ResponsibleDepartmentName
# 16    16       SubmissionCouncilName
# 17    17                 SubmittedBy
# 18    18         SubmittedText_lemma
# 19    19               SubmittedText
# 20    20                    TagNames
# 21    21                       Title

# Sum up weighted embeddings
combined_vecs <- all_vecs[[1]]*0.1 + # BusinessTypeName
  all_vecs[[3]] + # chatgpt_summaries_lemma
  #all_vecs[[4]]*0.6 + # chatgpt_summaries
  all_vecs[[5]]*0.5 + # Description
  all_vecs[[6]]*0.1 + # FirstCouncil1Name
  all_vecs[[8]] + # InitialSituation_lemma
  #all_vecs[[10]] + # main_tag
  all_vecs[[11]]*0.5 + # Proceedings_lemma
  all_vecs[[13]]*0.2 + # ReasonText_lemma
  all_vecs[[15]]*0.4 + # ResponsibleDepartmentName
  all_vecs[[16]]*0.1 + # SubmissionCouncilName
  all_vecs[[17]]*0.1 + # SubmittedBy
  all_vecs[[18]]*0.1 + # SubmittedText_lemma
  all_vecs[[20]] + # TagNames
  all_vecs[[21]]*0.7 # Title
