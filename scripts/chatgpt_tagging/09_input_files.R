
# Embedding: Create input files

all_businesses$chatgpt_tags_clean <- gsub("\\d+\\s\\.\\s", "| ", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("^\\|", "", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("^\\s", "", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("^\\|+\\s", "", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("\\|+\\s\\|", "| ", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("\\d+\\s\\.", "", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("\\s+\\|\\s*\\|\\s+", "", all_businesses$chatgpt_tags_clean)
all_businesses$chatgpt_tags_clean <- gsub("^\\|", "", all_businesses$chatgpt_tags_clean)

write.table(
  all_businesses$chatgpt_tags_clean,
  sep = ",",
  here("scripts", "chatgpt_tagging", "input_files", "chatgpt_tags.txt"),
  col.names = F, row.names = F, quote = F
)
