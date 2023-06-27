

# Setup -------------------------------------------------------------------

list_params <- list(command = 'print-sentence-vectors',
                    model = here("models", "cc.de.300.bin")) # https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.de.300.bin.gz


# Create Embeddings -------------------------------------------------------------------

# Uncomment to create embeddings
# for (col in df_colnames) {
#   res <- fasttext_interface(list_params,
#                             path_input = here("scripts", "text2vec", "fasttext", "input_files", paste0(col, ".txt")),
#                             path_output = here("scripts", "text2vec", "fasttext", "vec_files", paste0(col, ".txt")))
# }


# Import Embeddings -------------------------------------------------------------------

# read_embeddings <- function(file_path) {
#   file_name <- basename(file_path)
#   embeddings <- read_delim(file_path, delim = " ", col_names = FALSE)
#   embeddings <- embeddings %>% mutate(file_name = file_name, .before = X1)  # Add file_name column at the first position
#   embeddings$X301 <- NULL
#   return(embeddings)
# }
# 
# file_directory <- here("scripts", "text2vec", "fasttext", "vec_files")
# file_paths <- list.files(file_directory, pattern = "\\.txt$", full.names = TRUE)
# 
# all_vecs <- lapply(file_paths, read_embeddings)

# Save imported embeddings
#save(all_vecs, file = here("data", "all_vecs.Rda"))

# Load previously saved embeddings
load(here("data", "all_vecs.Rda"))


# Clean Embeddings -------------------------------------------------------------------
# NAs in the text should have a embedding value of 0

# Remove ".txt" from the file_name column
for (i in seq_along(all_vecs)) {
  all_vecs[[i]]$file_name <- gsub("\\.txt$", "", all_vecs[[i]]$file_name)
}

# Add text from DF to each data to check for NAs
# Then replace NAs wieghts with 0
# Iterate over each dataframe in the list
for (i in seq_along(all_vecs)) {
  # Get the current dataframe
  current_df <- all_vecs[[i]]
  # Get the corresponding file name from the "file_name" column
  file_name <- current_df$file_name[1]  # Assuming the file name is consistent within each dataframe
  current_df <- cbind(df[[file_name]], current_df)
  current_df <- current_df %>% rename(na_check = `df[[file_name]]`)
  current_df <- current_df %>% mutate_at(vars(-na_check, -file_name),
                                         ~ if_else(na_check == "NA</s>", 0, .))
  all_vecs[[i]] <- current_df
}


# Create weighted sum of all features -------------------------------------------------------------------

# Get DF names
all_vecs_df_names <- c()

for (i in seq_along(all_vecs)) {
  current_df <- all_vecs[[i]]
  all_vecs_df_names <- append(all_vecs_df_names, current_df$file_name[1])
}

all_vecs_df_names <- as.data.frame(all_vecs_df_names)
all_vecs_df_names <- all_vecs_df_names %>% rowid_to_column("index")
all_vecs_df_names

# Remove first two colums of each dataframe
# Iterate over each dataframe in the list
for (i in seq_along(all_vecs)) {
  # Get the current dataframe
  current_df <- all_vecs[[i]]
  
  # Remove the first 2 columns in the current dataframe
  current_df <- subset(current_df, select = -(1:2))
  
  # Update the current dataframe in all_vecs with the modified dataframe
  all_vecs[[i]] <- current_df
}

# Sum up weighted embeddings
combined_vecs <- all_vecs[[1]]*0.1 + # BusinessTypeName
  #all_vecs[[2]] + # chatgpt_summaries_lemma
  all_vecs[[3]]*0.8 + # chatgpt_summaries_lemma
  all_vecs[[4]]*0.5 + # Description
  all_vecs[[5]]*0.1 + # FirstCouncil1Name
  all_vecs[[6]] + # InitialSituation_lemma
  #all_vecs[[8]] + # main_tag
  all_vecs[[9]]*0.5 + # Proceedings_lemma
  all_vecs[[11]]*0.5 + # ReasonText_lemma
  all_vecs[[13]]*0.4 + # ResponsibleDepartmentName
  all_vecs[[14]]*0.1 + # SubmissionCouncilName
  all_vecs[[15]]*0.1 + # SubmittedBy
  all_vecs[[16]]*0.2 + # SubmittedText_lemma
  all_vecs[[18]] + # TagNames
  all_vecs[[19]]*0.8 # Title
