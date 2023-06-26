

# Setup -------------------------------------------------------------------

list_params <- list(command = 'print-sentence-vectors',
                    model = here("models", "cc.de.300.bin")) # https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.de.300.bin.gz

# Uncomment to create embeddings
# for (col in df_colnames) {
#   res <- fasttext_interface(list_params,
#                             path_input = here("scripts", "text2vec", "fasttext", "input_files", paste0(col, ".txt")),
#                             path_output = here("scripts", "text2vec", "fasttext", "vec_files", paste0(col, ".txt")))
# }


### delete later
# for (col in df_colnames) {
#   assign(paste0(col, "_vecs"), scan(here("scripts", "text2vec", "fasttext", "vec_files", paste0(col, ".txt")), character(), sep = "\n"))
# }
#   #sf_chatgpt_summaries_vecs <- scan(here("soziale_fragen", "vecs", "chatgpt_summaries.txt"), character(), sep = "\n")
# 
# df_colnames_vecs <- paste0(df_colnames, "_vecs")
# 
# Description_vecs <- as.data.frame(Description_vecs)
# 
# for (i in df_colnames_vecs) {
#   assign(i, as.data.frame(get(i)))
# }
# 
# TagNames_vecs$`get(i)`
# 
# for (j in df_colnames_vecs) {
#   assign(j, stringr::str_split_fixed(get(j), " ", 300))
# }
# 
# 
#   
#   #df_vec <- )
#   
#   #df_vec <- as.data.frame(df_vec)
#   #df_vec <- mutate_all(df_vec, function(x) as.numeric(as.character(x)))
# 
# 
# Proceedings_lemma_vecs$`get(i)`
# 
# test <- as.data.frame(BusinessTypeName_vecs)
#   
# 
# test_list <- list(chatgpt_summaries, df)
# 
# 
# 
# sf_Title_vecs <- cbind(soziale_fragen$Title, sf_Title_vecs)
# #sf_Title_vecs[!!rowSums(is.na(sf_Title_vecs)),] <- NA
# 
# # remove first column
# sf_BusinessTypeName_vecs[1] <- NULL

read_embeddings <- function(file_path) {
  file_name <- basename(file_path)
  embeddings <- read_delim(file_path, delim = " ", col_names = FALSE)
  embeddings <- embeddings %>% mutate(file_name = file_name, .before = X1)  # Add file_name column at the first position
  embeddings$X301 <- NULL
  return(embeddings)
}

file_directory <- here("scripts", "text2vec", "fasttext", "vec_files")
file_paths <- list.files(file_directory, pattern = "\\.txt$", full.names = TRUE)

#all_vecs <- lapply(file_paths, read_embeddings)
#save(all_vecs, file = here("data", "all_vecs.Rda"))
rm(all_vecs)
load(here("data", "all_vecs.Rda"))

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


# Created weighted sum of all features
combined_df <- sf_BusinessTypeName_vecs*0.1 +
  sf_Description_vecs*0.5 + # *0.8 +
  sf_FirstCouncil1Name_vecs*0.1 +
  sf_InitialSituation_vecs +
  sf_Proceedings_vecs*0.5 +
  sf_ReasonText_vecs*0.5 + #*0.8 +
  sf_ResponsibleDepartmentName_vecs*0.7 + #*0.8 +
  sf_SubmissionCouncilName_vecs*0.1 +
  sf_SubmittedBy_vecs*0.2 + #*0.8 +
  sf_SubmittedText_vecs*0.5 + #*0.8 +
  sf_TagNames_vecs +
  sf_Title_vecs +
  sf_chatgpt_summaries_vecs # *2





# archive
# Vectorise Description
# soziale_fragen_description <- soziale_fragen %>% select(Description)
# write.table(soziale_fragen_description, sep=",", "soziale_fragen_description.txt", col.names = F, row.names = F)