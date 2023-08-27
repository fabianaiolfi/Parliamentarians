

# Get Dataframes ----------------------------------------------------------

# Initialize an empty data frame to store the information
info_df <- tibble(
  file_name = character(),
  object_name = character(),
  column_names = character(),
  num_rows = integer(),
  num_cols = integer()
)

# List all .RData and .Rda files in the folder
files <- list.files(path = "data", pattern = "\\.RData$|\\.Rda$", full.names = TRUE)

# Loop through each file to extract information
for (file in files) {
  
  # Get objects in the environment before loading the file
  before_loading <- ls()
  
  # Load the file
  load(file)
  
  # Get objects in the environment after loading the file
  after_loading <- ls()
  
  # Identify newly loaded objects
  new_objects <- setdiff(after_loading, before_loading)
  
  # Loop through each newly loaded object to get details
  for (obj_name in new_objects) {
    
    obj <- get(obj_name)
    
    if (is.data.frame(obj) || is.matrix(obj)) {
      file_name <- basename(file)
      column_names <- paste(colnames(obj), collapse = " | ")
      num_rows <- nrow(obj)
      num_cols <- ncol(obj)
      
      # Add this info to the info_df data frame
      info_df <- add_row(info_df, file_name = file_name, object_name = obj_name,
                         column_names = column_names, num_rows = num_rows,
                         num_cols = num_cols)
    }
  }
  
  # Remove the newly loaded objects from the environment
  rm(list = new_objects)
}

all_files <- tibble(file_name = files)
all_files <- all_files %>% mutate(file_name = gsub("data/", "", file_name))
all_files <- all_files %>% left_join(info_df, by = "file_name")

# Save as .CSV
write.csv(all_files, here("data", "data_documentation.csv"), row.names = F)


# Manually Get List Objects ----------------------------------------------------------
load("data/sample_chatgpt_query.RData")


# Manual Work
load("data/chatgpt_output_df_20230827_095111.RData")
colnames(chatgpt_output_df)



